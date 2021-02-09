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

    connect(m_networkReply,&QNetworkReply::finished,this,&GithubDS::dataReadFinished);

}

void GithubDS::addDataSource(Github *github)
{
    emit preItemAdded();
    m_drive.append(github);
    emit postItemAdded();
}

void GithubDS::addDataSource(const QString &id, const QString &name, const QString &kind, const QString &modifiedTime, const QString &extension)
{
    Github *drive = new Github(id,name,kind,modifiedTime,extension);
    addDataSource(drive);
}

QList<Github *> GithubDS::dataItems()
{
    return m_drive;
}

void GithubDS::resetDatasource()
{
    emit preReset();
    m_drive.clear();
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
        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonArray dataArray = resultObj["files"].toArray();

        qDebug() << resultJson;
        for(int i=0;i<dataArray.size();i++){

            QJsonObject dataObj = dataArray.at(i).toObject();

            QString DriveID = dataObj["id"].toString();
            QString DriveName = dataObj["name"].toString();
            QString DriveKind = dataObj["kind"].toString();
            QString DriveModiTime = dataObj["modifiedTime"].toString();
            QString DriveExtension = "file";
            QString DriveMimeType = dataObj["mimeType"].toString();
            QStringList extensionList;
            if(DriveName.contains(".")){
                extensionList = DriveName.split('.');
                DriveExtension = "." + extensionList.last();
            }else if(DriveMimeType == "application/vnd.github-apps.spreadsheet"){
                DriveExtension = ".gsheet";
            }


            this->addDataSource(DriveID,DriveName,DriveKind,DriveModiTime,DriveExtension);
        }

        m_dataBuffer->clear();
    }
}
