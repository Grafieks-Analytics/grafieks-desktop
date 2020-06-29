#include "sheetds.h"

SheetDS::SheetDS(QObject *parent) : QObject(parent),
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
    this->google->setClientIdentifier("1075668792200-4mt2rbu1t7jjsi8hcb9d1p3b29982p98.apps.googleusercontent.com");
    this->google->setAccessTokenUrl(QUrl("https://oauth2.googleapis.com/token"));
    this->google->setClientIdentifierSharedKey("hXXkqrprnYZSNyCLedSraCaN");

    // In my case, I have hardcoded 5476
    // This is set in Redirect URI in Google Developers Console of the app
    // Same can be seen in the downloaded JSON file

    auto replyHandler = new QOAuthHttpServerReplyHandler(3000, this);
    this->google->setReplyHandler(replyHandler);

    connect(this->google, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        m_networkReply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(id,name,kind,modifiedTime,mimeType)&q=mimeType='application/vnd.google-apps.spreadsheet'"));

        connect(m_networkReply,&QNetworkReply::finished,this,&SheetDS::dataReadFinished);

    });
}

void SheetDS::fetchDatasources()
{
    this->google->grant();
}

void SheetDS::addDataSource(Sheet *Sheet)
{
    emit preItemAdded();
    m_Sheet.append(Sheet);
    emit postItemAdded();
}

void SheetDS::addDataSource(const QString &id, const QString &name, const QString &kind, const QString &modifiedTime, const QString &extension)
{
    Sheet *sheet = new Sheet(id,name,kind,modifiedTime,extension);
    addDataSource(sheet);
}

QList<Sheet *> SheetDS::dataItems()
{
    return m_Sheet;
}

void SheetDS::resetDatasource()
{
    emit preReset();
    m_Sheet.clear();
    emit postReset();
}

void SheetDS::dataReadFinished()
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

            QString SheetID = dataObj["id"].toString();
            QString SheetName = dataObj["name"].toString();
            QString SheetKind = dataObj["kind"].toString();
            QString SheetModiTime = dataObj["modifiedTime"].toString();
            QString SheetExtension = "file";
            QString SheetMimeType = dataObj["mimeType"].toString();
            QStringList extensionList;
            if(SheetName.contains(".")){
                extensionList = SheetName.split('.');
                SheetExtension = "." + extensionList.last();
            }else if(SheetMimeType == "application/vnd.google-apps.spreadsheet"){
                SheetExtension = ".gsheet";
            }


            this->addDataSource(SheetID,SheetName,SheetKind,SheetModiTime,SheetExtension);
        }

        m_dataBuffer->clear();
    }

}



