#include "githubds.h"

GithubDS::GithubDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
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
    m_networkReply = this->github->get(QUrl("https://www.githubapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=name  +contains+%27" + path+ "%27"));
    connect(m_networkReply,&QNetworkReply::finished,this,&GithubDS::dataReadFinished);

}

void GithubDS::homeBut()
{
    m_networkReply = this->github->get(QUrl("https://www.githubapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)"));
    connect(m_networkReply, &QNetworkReply::finished, this, &GithubDS::dataReadFinished);
}

void GithubDS::addDataSource(Github *github)
{
    emit preItemAdded();
    m_github.append(github);
    emit postItemAdded();
}

void GithubDS::addDataSource(const QString &id, const QString &name, const QString &kind, const QString &modifiedTime, const QString &extension)
{
    Github *github = new Github(id,name,kind,modifiedTime,extension);
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
        requiredExtensions << ".xls" << ".xlsx" << ".csv" << ".json" << ".ods";

        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        qDebug() << resultJson;

        QJsonArray dataArray = resultObj["files"].toArray();

        for(int i=0; i<dataArray.size(); i++){

            QJsonObject dataObj = dataArray.at(i).toObject();

            QString GithubID = dataObj["id"].toString();
            QString GithubName = dataObj["name"].toString();
            QString GithubKind = dataObj["kind"].toString();
            QString GithubModiTime = dataObj["modifiedTime"].toString();
            QString GithubExtension = "file";
            QString GithubMimeType = dataObj["mimeType"].toString();
            QStringList extensionList;

            if(GithubName.contains(".")){
                extensionList = GithubName.split('.');
                GithubExtension = "." + extensionList.last();
            }else if(GithubMimeType == "application/vnd.github-apps.spreadsheet"){
                GithubExtension = ".gsheet";
            }

            if(requiredExtensions.indexOf(GithubExtension) >= 0 || GithubExtension == "--"){
                this->addDataSource(GithubID, GithubName, GithubKind, GithubModiTime, GithubExtension);
            }
        }

        m_dataBuffer->clear();

        // Get user email
        m_networkReply = this->github->get(QUrl("https://api.github.com/user"));
        connect(m_networkReply,&QNetworkReply::finished,this,&GithubDS::userReadFinished);

    }
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

        qDebug() << "USERG" <<resultJson;


    }
}

void GithubDS::saveFile()
{

    QByteArray arr = m_networkReply->readAll();
    qDebug() << arr << "SAVE FILE";

    QFile file("C:\\Users\\chill\\Desktop\\x.xlsx");
    file.open(QIODevice::WriteOnly);
    file.write(arr);
    file.close();
}
