#include "driveds.h"


/*!
 * \brief Constructor function to initialize connection with Google Drive API
 * \details Initiates OAuth connection. Once OAuth token is obtained, it calls relevant methods to fetch the data from
 * the API
 * \param parent
 */
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
    this->google->setClientIdentifier(Secret::driveClient);
    this->google->setAccessTokenUrl(QUrl("https://oauth2.googleapis.com/token"));
    this->google->setClientIdentifierSharedKey(Secret::driveSecret);

    // In my case, I have hardcoded 5476
    // This is set in Redirect URI in Google Developers Console of the app
    // Same can be seen in the downloaded JSON file

    auto replyHandler = new QOAuthHttpServerReplyHandler(Secret::drivePort, this);
    this->google->setReplyHandler(replyHandler);

    connect(this->google, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)"));

        connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::dataReadFinished);

    });
}


/*!
 * \brief Calls to authorize the user using Qt's OAuth class
 */
void DriveDS::fetchDatasources()
{
    this->google->grant();
}

/*!
 * \brief Search the Box API
 * \details Documentation reference https://developer.box.com/reference/get-search/
 * \param path (File name)
 */
void DriveDS::searchQuer(QString path)
{
    m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=name  +contains+%27" + path+ "%27"));

    connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::dataReadFinished);
}

/*!
 * \brief Get back the home directory
 */
void DriveDS::homeBut()
{
    m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)"));
    connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::dataReadFinished);
}

void DriveDS::getUserName()
{

}

void DriveDS::downloadFile(QString fileID)
{
    qDebug() << this->google->token() << "ACCESS TOKEM";
    m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files/1E5svQOzBkvgOw012Peuisa-JUP0fsPVp?alt=media"));

    connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::saveFile);

}

/*!
 * \brief Notify model after adding new record in QList<Drive *>
 * \param drive (Drive *)
 */
void DriveDS::addDataSource(Drive *drive)
{
    emit preItemAdded();
    m_drive.append(drive);
    emit postItemAdded();
}

/*!
 * \brief Add new data to QList<Drive *>
 * \param id (File id)
 * \param name (File name)
 * \param kind (File kind)
 * \param modifiedTime (Modified date)
 * \param extension (File extension)
 */
void DriveDS::addDataSource(const QString &id, const QString &name, const QString &kind, const QString &modifiedTime, const QString &extension)
{
    Drive *drive = new Drive(id,name,kind,modifiedTime,extension);
    addDataSource(drive);
}

void DriveDS::downloadFile(QString filePath)
{

}

/*!
 * \brief List the values in QList<Drive *>
 * \return QList<Drive *>
 */
QList<Drive *> DriveDS::dataItems()
{
    return m_drive;
}

/*!
 * \brief Clear all the values in QList<Drive*> & notify model
 */
void DriveDS::resetDatasource()
{
    emit preReset();
    m_drive.clear();
    emit postReset();
}

/*!
 * \brief Reads incoming data from the API & store to buffer
 */
void DriveDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}


/*!
 * \brief Processes the data buffer
 * \details Process the data buffer and append new values to QList<Drive*>
 */
void DriveDS::dataReadFinished()
{
    m_dataBuffer->append(m_networkReply->readAll());
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{
        QStringList requiredExtensions;
        requiredExtensions << ".xls" << ".xlsx" << ".csv" << ".json" << ".ods" << ".gsheet";

        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        qDebug() << "FILES" << resultObj;

        QJsonArray dataArray = resultObj["files"].toArray();
        for(int i=0;i<dataArray.size();i++){

            QJsonObject dataObj = dataArray.at(i).toObject();


            QString DriveID = dataObj["id"].toString();
            QString DriveName = dataObj["name"].toString();
            QString DriveKind = dataObj["kind"].toString();
            QString DriveModiTime = dataObj["modifiedTime"].toString();
            QString DriveExtension = "";
            QString DriveMimeType = dataObj["mimeType"].toString();
            QStringList extensionList;

            if(DriveName.contains(".")){
                extensionList = DriveName.split('.');
                DriveExtension = "." + extensionList.last();
            }else if(DriveMimeType == "application/vnd.google-apps.spreadsheet"){
                DriveExtension = ".gsheet";
            }

            if(DriveMimeType != "application/vnd.google-apps.folder" && requiredExtensions.indexOf(DriveExtension) >= 0){
                this->addDataSource(DriveID,DriveName,DriveKind,DriveModiTime,DriveExtension);
            }
        }

        m_dataBuffer->clear();
    }

}

void DriveDS::saveFile()
{
    QByteArray arr = m_networkReply->readAll();

    QFile file("C:\\Users\\chill\\Desktop\\x.xlsx");
    file.open(QIODevice::WriteOnly);
    file.write(arr);
    file.close();
}



