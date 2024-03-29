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

    emit showBusyIndicator(true);

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


        // Get files list
        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=(mimeType = 'application/vnd.ms-excel' or mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or mimeType = 'text/csv')&pageSize=1000"));
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
    emit showBusyIndicator(true);
    m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=name contains '"+ path +"' and (mimeType = 'application/vnd.ms-excel' or mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or mimeType = 'text/csv')"));
    connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::dataSearchFinished);
}

/*!
 * \brief Get back the home directory
 */
void DriveDS::homeBut()
{
    emit showBusyIndicator(true);

    m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=(mimeType = 'application/vnd.ms-excel' or mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or mimeType = 'text/csv')&pageSize=1000"));
    connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::dataReadFinished);
}


void DriveDS::fetchFileData(QString gFileId, QString fileName, QString extension)
{
    emit showBusyIndicator(true);
    this->gFileId = gFileId;
    this->extension = extension;
    this->newFileName = fileName;

    m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files/"+gFileId+"?alt=media"));
    connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::fileDownloadFinished);
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

        Statics::onlineStorageType = Constants::driveIntType;

        QStringList requiredExtensions;
        requiredExtensions << ".xls" << ".xlsx" << ".csv" << ".json";

        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonArray dataArray = resultObj["files"].toArray();
        for(int i=0;i<dataArray.size();i++){

            QJsonObject dataObj = dataArray.at(i).toObject();


            QString DriveID = dataObj["id"].toString();
            QString DriveName = dataObj["name"].toString();
            QString DriveKind = dataObj["kind"].toString();
            QString DriveModiTime = QDateTime::fromString(dataObj["modifiedTime"].toString(), Qt::ISODate).toString("yyyy/MM/dd HH:mm ap");
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



        // Get user email
        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/about/?fields=user"));
        connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::userReadFinished);

    }
    m_dataBuffer->clear();
    emit showBusyIndicator(false);

}

void DriveDS::dataSearchFinished()
{
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{
        QStringList requiredExtensions;
        requiredExtensions << ".xls" << ".xlsx" << ".csv" << ".json";

        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(m_networkReply->readAll().data());
        QJsonObject resultObj = resultJson.object();


        QJsonArray dataArray = resultObj["files"].toArray();
        for(int i=0;i<dataArray.size();i++){

            QJsonObject dataObj = dataArray.at(i).toObject();


            QString DriveID = dataObj["id"].toString();
            QString DriveName = dataObj["name"].toString();
            QString DriveKind = dataObj["kind"].toString();
            QString DriveModiTime = QDateTime::fromString(dataObj["modifiedTime"].toString(), Qt::ISODate).toString("yyyy/MM/dd HH:mm ap");
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

        // Get user email
        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/about/?fields=user"));
        connect(m_networkReply,&QNetworkReply::finished,this,&DriveDS::userReadFinished);

    }
    m_dataBuffer->clear();
    emit showBusyIndicator(false);

}

void DriveDS::userReadFinished()
{

    m_dataBuffer->append(m_networkReply->readAll());
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonObject user = resultObj.value("user").toObject();
        emit getDriveUsername(user["emailAddress"].toString());
    }

    emit showBusyIndicator(false);
}

void DriveDS::fileDownloadFinished()
{
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{

        QFileInfo f(this->newFileName);

        QString fileName = QDir::temp().tempPath() +"/" + this->newFileName;
        QFile file(fileName);
        file.open(QIODevice::WriteOnly);
        file.write(m_networkReply->readAll());
        file.close();

        if(this->extension.contains("xls") || this->extension.contains("xlsx")){
            emit fileDownloaded(fileName, "excel");

        } else if(this->extension.contains("csv")){
            emit fileDownloaded(fileName,"csv");

        } else if(this->extension.contains("json")){
            emit fileDownloaded(fileName, "json");
        }
    }

   // emit showBusyIndicator(false);
}



