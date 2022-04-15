#include "githubds.h"

GithubDS::GithubDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray),
    totalData(0)
{
    emit showBusyIndicator(true);

    this->github = new QOAuth2AuthorizationCodeFlow(this);

    // More scopes https://docs.github.com/en/developers/apps/scopes-for-oauth-apps
    this->github->setScope("repo gist");

    connect(this->github, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, [=](QUrl url) {
        QUrlQuery query(url);
        QByteArray postData;

        postData = query.toString(QUrl::FullyEncoded).toUtf8();

        url.setQuery(query);
        QDesktopServices::openUrl(url);
    });

    // Details: https://docs.github.com/en/developers/apps/scopes-for-oauth-apps

    this->github->setAuthorizationUrl(QUrl("https://github.com/login/oauth/authorize"));
    this->github->setClientIdentifier(Secret::githubClient);
    this->github->setAccessTokenUrl(QUrl("https://github.com/login/oauth/access_token"));
    this->github->setClientIdentifierSharedKey(Secret::githubSecret);

    auto replyHandler = new QOAuthHttpServerReplyHandler(Secret::githubPort, this);
    this->github->setReplyHandler(replyHandler);

    connect(this->github, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        Statics::onlineStorageType = Constants::githubIntType;

        // api link - https://docs.github.com/en/rest/reference

        QNetworkRequest m_networkRequest;
        QUrl api("https://api.github.com/gists");
        QUrlQuery quer(api);

        m_networkRequest.setUrl(api);

        m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
        m_networkRequest.setRawHeader("Authorization", "Bearer " + this->github->token().toUtf8());

        m_networkReply = m_networkAccessManager->get(m_networkRequest);
        connect(m_networkReply,&QIODevice::readyRead,this,&GithubDS::dataReadyRead);
        connect(m_networkReply,&QNetworkReply::finished,this,&GithubDS::dataReadFinished);

    });
}

void GithubDS::fetchDatasources()
{
    this->github->grant();
}

void GithubDS::searchQuer(QString path)
{
    emit showBusyIndicator(true);
    this->resetDatasource();

    for(int i = 0; i < this->filesList.length(); i++){

        if(this->filesList.at(i).contains(path)){

            this->addDataSource(this->mainResultData.value(i).at(0),
                                this->mainResultData.value(i).at(1),
                                this->mainResultData.value(i).at(2),
                                this->mainResultData.value(i).at(3),
                                this->mainResultData.value(i).at(4),
                                this->mainResultData.value(i).at(5)
                                );
        }
    }
    emit showBusyIndicator(false);

}

void GithubDS::fetchFileData(QString gFileId, QString extension, QString url)
{
    emit showBusyIndicator(true);
    this->gFileId = gFileId;
    this->extension = extension;
    this->url = url;

    m_networkReply = this->github->get(QUrl(this->url));
    connect(m_networkReply,&QNetworkReply::finished,this,&GithubDS::fileDownloadFinished);
}

void GithubDS::addDataSource(Github *github)
{
    emit preItemAdded();
    m_github.append(github);
    emit postItemAdded();
}

void GithubDS::addDataSource(const QString &id, const QString &name, const QString &kind, const QString &modifiedTime, const QString &extension, const QString &url)
{
    Github *github = new Github(id, name, kind, modifiedTime, extension, url);
    addDataSource(github);
}

QList<Github *> GithubDS::dataItems()
{
    return m_github;
}

void GithubDS::resetDatasource()
{
    emit preReset();
    m_github.clear();
    emit postReset();
}

void GithubDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void GithubDS::dataReadFinished()
{
    m_dataBuffer->append(m_networkReply->readAll());
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{
        QStringList requiredExtensions;
        requiredExtensions << "text/csv" << "application/json";

        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);


        QJsonArray dataArray = resultJson.array();

        for(int i=0; i<dataArray.size(); i++){

            QJsonObject dataObj = dataArray.at(i).toObject();

            QStringList key =  dataObj.value("files").toObject().keys();
            QJsonObject fileData = dataObj.value("files").toObject().value(key[0]).toObject();

            QString GithubID = dataObj.value("id").toString();
            QString GithubName = fileData.value("filename").toString();
            QString GithubKind = fileData.value("language").toString();
            QString GithubLink = fileData.value("raw_url").toString();
            QString GithubModifiedTime = QDateTime::fromString(dataObj.value("updated_at").toString(), Qt::ISODate).toString("yyyy/MM/dd HH:mm ap");
            QString GithubExtension = "file";
            QString GithubMimeType = fileData.value("type").toString();
            QStringList extensionList;

            if(GithubName.contains(".")){
                extensionList = GithubName.split('.');
                GithubExtension = "." + extensionList.last();
            }

            if(requiredExtensions.indexOf(GithubMimeType) >= 0 || GithubExtension == "--"){

                // This data is required for search later
                // As there is no search API for Gists
                this->filesList << GithubName;
                QStringList tmpData;
                tmpData << GithubID << GithubName <<  GithubKind <<  GithubModifiedTime << GithubExtension << GithubLink;
                this->mainResultData.insert(totalData, tmpData);
                totalData++;

                this->addDataSource(GithubID, GithubName, GithubKind, GithubModifiedTime, GithubExtension, GithubLink);

            }
        }



        // Get user email
        m_networkReply = this->github->get(QUrl("https://api.github.com/user"));
        connect(m_networkReply,&QNetworkReply::finished,this,&GithubDS::userReadFinished);

    }
    m_dataBuffer->clear();
    emit showBusyIndicator(false);
}

void GithubDS::userReadFinished()
{

    m_dataBuffer->append(m_networkReply->readAll());
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();
        emit getGithubUsername(resultObj["email"].toString());
    }

    emit showBusyIndicator(false);
}

void GithubDS::fileDownloadFinished()
{
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{
        QString fileName = QDir::temp().tempPath() +"/" + this->gFileId +"." + this->extension;
        QFile file(fileName);
        file.open(QIODevice::WriteOnly);
        file.write(m_networkReply->readAll());
        file.close();

        if(this->extension.contains("xls")){
            emit fileDownloaded(fileName, "excel");

        } else if(this->extension.contains("csv")){
            emit fileDownloaded(fileName,"csv");

        } else if(this->extension.contains("json")){
            emit fileDownloaded(fileName, "json");
        }
    }

    emit showBusyIndicator(false);
}

