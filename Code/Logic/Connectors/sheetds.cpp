#include "sheetds.h"

//sheets api documentation - https://developers.google.com/drive/api/v3/reference/files

/*!
 * \brief Constructor function to initialize connection with Google Sheets API
 * \details Initiates OAuth connection. Once OAuth token is obtained, it calls relevant methods to fetch the data from
 * the API
 * \param parent
 */
SheetDS::SheetDS(QObject *parent) : QObject(parent),
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
    this->google->setClientIdentifier(Secret::sheetClient);
    this->google->setAccessTokenUrl(QUrl("https://oauth2.googleapis.com/token"));
    this->google->setClientIdentifierSharedKey(Secret::sheetSecret);

    // In my case, I have hardcoded 5476
    // This is set in Redirect URI in Google Developers Console of the app
    // Same can be seen in the downloaded JSON file

    auto replyHandler = new QOAuthHttpServerReplyHandler(Secret::sheetPort, this);
    this->google->setReplyHandler(replyHandler);

    connect(this->google, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        // Get Files list
        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=mimeType='application/vnd.google-apps.spreadsheet'"));
        connect(m_networkReply,&QNetworkReply::finished,this,&SheetDS::dataReadFinished);


    });
}

/*!
 * \brief Calls to authorize the user using Qt's OAuth class
 */
void SheetDS::fetchDatasources()
{
    this->google->grant();
}

/*!
 * \brief Search the Box API
 * \param path (File name)
 */
void SheetDS::searchQuer(QString path)
{
    emit showBusyIndicator(true);

    if(path == "")
        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=mimeType+contains+%27application%2Fvnd.google-apps.spreadsheet%27"));
    else
        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=name+contains+%27" + path +"%27+and+mimeType+contains+%27application%2Fvnd.google-apps.spreadsheet%27"));

    connect(m_networkReply,&QNetworkReply::finished,this,&SheetDS::dataReadFinished);
}

/*!
 * \brief Get back the home directory
 */
void SheetDS::homeBut()
{
    emit showBusyIndicator(true);

    m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=mimeType='application/vnd.google-apps.spreadsheet'"));
    connect(m_networkReply,&QNetworkReply::finished,this,&SheetDS::dataReadFinished);
}

void SheetDS::fetchFileData(QString gFileId)
{
    emit showBusyIndicator(true);
    this->gFileId = gFileId;

    QUrl sheetDownloadUrl("https://www.googleapis.com/drive/v3/files/" + gFileId +"/export?mimeType=application%2Fvnd.openxmlformats-officedocument.spreadsheetml.sheet&key="+Secret::sheetClient);
    m_networkReply = this->google->get(sheetDownloadUrl);

    connect(m_networkReply,&QNetworkReply::finished,this,&SheetDS::fileDownloadFinished);
}



/*!
 * \brief Notify model after adding new record in QList<Sheet *>
 * \param Sheet (Sheet *)
 */
void SheetDS::addDataSource(Sheet *Sheet)
{
    emit preItemAdded();
    m_Sheet.append(Sheet);
    emit postItemAdded();
}

/*!
 * \brief Add new data to QList<Sheet *>
 * \param id (File id)
 * \param name (File name)
 * \param kind (File type)
 * \param modifiedTime (Modified date)
 * \param extension ( File extension)
 */
void SheetDS::addDataSource(const QString &id, const QString &name, const QString &kind, const QString &modifiedTime, const QString &extension)
{
    Sheet *sheet = new Sheet(id,name,kind,modifiedTime,extension);
    addDataSource(sheet);
}

/*!
 * \brief List the values in QList<Sheet *>
 * \return QList<Sheet *>
 */
QList<Sheet *> SheetDS::dataItems()
{
    return m_Sheet;
}

/*!
 * \brief Clear all the values in QList<Sheet*> & notify model
 */
void SheetDS::resetDatasource()
{
    emit preReset();
    m_Sheet.clear();
    emit postReset();
}

void SheetDS::fileDownloadFinished()
{

    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{
        QString fileName = QDir::temp().tempPath() +"/" + this->gFileId +".xlsx";
        QFile file(fileName);
        file.open(QIODevice::WriteOnly);
        file.write(m_networkReply->readAll(), m_networkReply->size());
        file.close();
    }

    emit showBusyIndicator(false);
}

/*!
 * \brief Processes the data buffer
 * \details Process the data buffer and append new values to QList<Sheet*>
 */
void SheetDS::dataReadFinished()
{
    m_dataBuffer->append(m_networkReply->readAll());

    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{
        QStringList requiredExtensions;
        requiredExtensions << ".gsheet";

        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonArray dataArray = resultObj["files"].toArray();
        for(int i=0;i<dataArray.size();i++){

            QJsonObject dataObj = dataArray.at(i).toObject();

            QString SheetID = dataObj["id"].toString();
            QString SheetName = dataObj["name"].toString();
            QString SheetKind = dataObj["kind"].toString();
            QString SheetModiTime = QDateTime::fromString(dataObj["modifiedTime"].toString(), Qt::ISODate).toString("yyyy/MM/dd HH:mm ap");
            QString SheetExtension = "";
            QString SheetMimeType = dataObj["mimeType"].toString();

            QStringList extensionList;
            if(SheetMimeType == "application/vnd.google-apps.spreadsheet"){
                SheetExtension = ".gsheet";
            }

            if(SheetMimeType != "application/vnd.google-apps.folder" && requiredExtensions.indexOf(SheetExtension) >= 0){
                this->addDataSource(SheetID,SheetName,SheetKind,SheetModiTime,SheetExtension);
            }
        }

        m_dataBuffer->clear();

        // Get user email
        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/about/?fields=user"));
        connect(m_networkReply,&QNetworkReply::finished,this,&SheetDS::userReadFinished);

    }

    emit showBusyIndicator(false);

}

void SheetDS::userReadFinished()
{

    m_dataBuffer->append(m_networkReply->readAll());
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonObject user = resultObj.value("user").toObject();
        emit getSheetUsername(user["emailAddress"].toString());
    }

    emit showBusyIndicator(false);
}
