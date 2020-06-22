#include "driveds.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QQmlContext>
#include <QtDebug>


DriveDS::DriveDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
    this->google = new QOAuth2AuthorizationCodeFlow(this);

    // Set Scope or Permissions required from Google
    // List can be obtained from https://developers.google.com/identity/protocols/oauth2/scopes

    this->google->setScope("email https://www.googleapis.com/auth/drive");

    connect(this->google, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, [=](QUrl url) {
        QUrlQuery query(url);

        query.addQueryItem("prompt", "consent");      // Param required to get data everytime
        query.addQueryItem("access_type", "offline"); // Needed for Refresh Token (as AccessToken expires shortly)

        url.setQuery(query);
        QDesktopServices::openUrl(url);
    });

    // Here the parameters from Google JSON are filled up
    // Attached screenshot of JSON file and Google Console

    this->google->setAuthorizationUrl(QUrl("https://accounts.google.com/o/oauth2/auth"));
    this->google->setClientIdentifier("452291785459-1ldhc2q2ahqfl7sv0mh1veuov740bj5f.apps.googleusercontent.com");
    this->google->setAccessTokenUrl(QUrl("https://oauth2.googleapis.com/token"));
    this->google->setClientIdentifierSharedKey("I09LKhYI21Svp-QWPe2nsJvb");

    // In my case, I have hardcoded 5476
    // This is set in Redirect URI in Google Developers Console of the app
    // Same can be seen in the downloaded JSON file

    auto replyHandler = new QOAuthHttpServerReplyHandler(59376, this);
    this->google->setReplyHandler(replyHandler);

    connect(this->google, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)"));

        connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::dataReadFinished);

    });
}

void DriveDS::fetchDatasources()
{
    this->google->grant();
}

void DriveDS::addDataSource(Drive *drive)
{
    emit preItemAdded();
    m_drive.append(drive);
    emit postItemAdded();
}

void DriveDS::addDataSource(const QString &id, const QString &name, const QString &kind, const QString &modifiedTime, const QString &extension)
{
    Drive *drive = new Drive(id,name,kind,modifiedTime,extension);
    addDataSource(drive);
}

QList<Drive *> DriveDS::dataItems()
{
    return m_drive;
}

void DriveDS::resetDatasource()
{
    emit preReset();
    m_drive.clear();
    emit postReset();
}

void DriveDS::dataReadFinished()
{
    m_dataBuffer->append(m_networkReply->readAll());
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{
        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonArray dataArray = resultObj["files"].toArray();
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
            }else if(DriveMimeType == "application/vnd.google-apps.spreadsheet"){
                DriveExtension = ".gsheet";
            }


            this->addDataSource(DriveID,DriveName,DriveKind,DriveModiTime,DriveExtension);
        }

        m_dataBuffer->clear();
    }

}



