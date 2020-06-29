#include "dropboxds.h"
#include <QJsonArray>
#include <QOAuth2AuthorizationCodeFlow>
#include <QFile>
#include <QJsonDocument>
#include <QDesktopServices>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QQmlContext>
#include <QOAuthHttpServerReplyHandler>
#include <QtDebug>

DropboxDS::DropboxDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
    this->dropbox = new QOAuth2AuthorizationCodeFlow(this);

    // Set Scope or Permissions required from dropbox
    // List can be obtained from https://developers.dropbox.com/identity/protocols/oauth2/scopes

    this->dropbox->setScope("");

    connect(this->dropbox, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, [=](QUrl url) {
        QUrlQuery query(url);
        QByteArray postData;

        query.addQueryItem("force_reapprove", "true"); // Param required to get data everytime
        query.addQueryItem("token_access_type", "offline"); // Needed for Refresh Token (as AccessToken expires shortly)
        query.addQueryItem("response_type", "code");


        postData = query.toString(QUrl::FullyEncoded).toUtf8();

        url.setQuery(query);
        QDesktopServices::openUrl(url);
    });
    // Here the parameters from dropbox JSON are filled up
    // Attached screenshot of JSON file and dropbox Console

    this->dropbox->setAuthorizationUrl(QUrl("https://www.dropbox.com/oauth2/authorize"));
    this->dropbox->setClientIdentifier("v1eumlddpbcttjt");
    this->dropbox->setAccessTokenUrl(QUrl("https://api.dropboxapi.com/oauth2/token"));
    this->dropbox->setClientIdentifierSharedKey("y91t2hwv0fdcbki");



    // In my case, I have hardcoded 5476
    // This is set in Redirect URI in dropbox Developers Console of the app
    // Same can be seen in the downloaded JSON file

    auto replyHandler = new QOAuthHttpServerReplyHandler(8080, this);
    this->dropbox->setReplyHandler(replyHandler);
//    connect(this->dropbox,&QOAuth2AuthorizationCodeFlow::granted,this,&DropboxDS::folderNav);

    connect(this->dropbox, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";
        const QUrl API_ENDPOINT("https://api.dropboxapi.com/2/files/list_folder");
        QJsonObject obj;
        obj.insert("limit", 100);
        obj.insert("path","");
        //    request.setRawHeader("Dropbox-API-Arg","{\"path\": \"id:XbzRXviwTQAAAAAAAAAAIQ\"}");
        obj.insert("recursive",false);
        obj.insert("include_media_info",false);
        obj.insert("include_deleted",false);
        obj.insert("include_has_explicit_shared_members",false);
        obj.insert("include_mounted_folders",true);
        obj.insert("include_non_downloadable_files",true);

        QJsonDocument doc(obj);
        QString strJson(doc.toJson(QJsonDocument::Compact));

        QNetworkRequest m_networkRequest;
        m_networkRequest.setUrl(QUrl("https://api.dropboxapi.com/2/files/list_folder"));

        m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
        m_networkRequest.setRawHeader("Authorization", "Bearer " + this->dropbox->token().toUtf8());
        token = this->dropbox->token();

        m_networkReply = m_networkAccessManager->post(m_networkRequest, strJson.toUtf8());
        connect(m_networkReply,&QIODevice::readyRead,this,&DropboxDS::dataReadyRead);
        connect(m_networkReply,&QNetworkReply::finished,this,&DropboxDS::dataReadFinished);

    });

}

void DropboxDS::fetchDatasources()
{
    this->dropbox->grant();

}

QString DropboxDS::goingBack(QString path,QString name)
{
    int len = name.length();
    //    QStringRef sub(&path);
    //    sub.chop(len);
    QString p = path;
    //    QStringList pa = path.split('');
    //    qDebug() <<"Listr is :" << pa;
    p.chop(len);
    if(p=="Dropbox" || p.length() == 1 || name == "Folder name")
        p="";

    qDebug()<<"This is p: "<<p;
    folderNav(p);

    return p;

}

void DropboxDS::folderNav(QString path)
{
    const QUrl API_ENDPOINT("https://api.dropboxapi.com/2/files/list_folder");
    QJsonObject obj;
    obj.insert("limit", 100);
    obj.insert("path",path);
    //    request.setRawHeader("Dropbox-API-Arg","{\"path\": \"id:XbzRXviwTQAAAAAAAAAAIQ\"}");
    obj.insert("recursive",false);
    obj.insert("include_media_info",false);
    obj.insert("include_deleted",false);
    obj.insert("include_has_explicit_shared_members",false);
    obj.insert("include_mounted_folders",true);
    obj.insert("include_non_downloadable_files",true);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    QNetworkRequest m_networkRequest;
    m_networkRequest.setUrl(QUrl("https://api.dropboxapi.com/2/files/list_folder"));

    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
    m_networkRequest.setRawHeader("Authorization", "Bearer " + token.toUtf8());

    m_networkReply = m_networkAccessManager->post(m_networkRequest, strJson.toUtf8());
    connect(m_networkReply,&QIODevice::readyRead,this,&DropboxDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&DropboxDS::dataReadFinished);
}

void DropboxDS::addDataSource(Dropbox *dropbox)
{
    emit preItemAdded();
    m_dropbox.append(dropbox);
    emit postItemAdded();
}

void DropboxDS::addDataSource(const QString & id, const QString & tag, const QString & name, const QString & pathLower, const QString & clientModified,const QString & extension)
{
    Dropbox *dropbox = new Dropbox(id,tag,name,pathLower,clientModified,extension);

    addDataSource(dropbox);
}

QList<Dropbox *> DropboxDS::dataItems()
{
    return m_dropbox;
}

void DropboxDS::resetDatasource()
{
    emit preReset();
    m_dropbox.clear();
    emit postReset();
}

void DropboxDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void DropboxDS::dataReadFinished()
{
    if(m_networkReply->error()){
        qDebug() <<"There was some error : "<< m_networkReply->errorString();
    }
    else{

        this->resetDatasource();

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonArray dataArray = resultObj["entries"].toArray();

        for(int i=0;i<dataArray.size();i++){

            QJsonObject dataObj = dataArray.at(i).toObject();

            QString DropboxID = dataObj["id"].toString();
            QString DropboxTag = dataObj[".tag"].toString();
            QString DropboxName = dataObj["name"].toString();
            QStringList extensionList;
            QString DropboxExtension;
            QString DropboxPathLower = dataObj["path_lower"].toString();
            QString DropboxClientModi;
            if(DropboxTag  == "file"){
                DropboxClientModi = dataObj["client_modified"].toString();
                extensionList = DropboxName.split('.');
                DropboxExtension = "." + extensionList.last();
            }
            else{
                DropboxClientModi = "--";
                DropboxExtension = "--";

            }
            this->addDataSource(DropboxID,DropboxTag,DropboxName,DropboxPathLower,DropboxClientModi,DropboxExtension);
        }

        m_dataBuffer->clear();
    }
}



