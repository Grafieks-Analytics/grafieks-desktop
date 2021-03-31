#include "boxds.h"

/*!
 * \brief Constructor function to initialize connection with Box API
 * \details Initiates OAuth connection. Once OAuth token is obtained, it calls relevant methods to fetch the data from
 * the API
 * \param parent
 */

BoxDS::BoxDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
    emit showBusyIndicator(true);

    this->box = new QOAuth2AuthorizationCodeFlow(this);

    this->box->setScope("");

    connect(this->box, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, [=](QUrl url) {
        QUrlQuery query(url);
        QByteArray postData;

        query.addQueryItem("grant-type","authorization_code");

        postData = query.toString(QUrl::FullyEncoded).toUtf8();

        url.setQuery(query);
        QDesktopServices::openUrl(url);
    });


    this->box->setAuthorizationUrl(QUrl("https://account.box.com/api/oauth2/authorize"));
    this->box->setClientIdentifier(Secret::boxClient);
    this->box->setAccessTokenUrl(QUrl("https://api.box.com/oauth2/token"));
    this->box->setClientIdentifierSharedKey(Secret::boxSecret);

    auto replyHandler = new QOAuthHttpServerReplyHandler(Secret::boxPort, this);
    this->box->setReplyHandler(replyHandler);

    connect(this->box, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        // api link - https://developer.box.com/reference/get-folders-id-items/

        QNetworkRequest m_networkRequest;
        QUrl api("https://api.box.com/2.0/folders/0/items");
        QUrlQuery quer(api);

        quer.addQueryItem("fields","id,name,type,modified_at,description,size");
        api.setQuery(quer);
        m_networkRequest.setUrl(api);


        m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
        m_networkRequest.setRawHeader("Authorization", "Bearer " + this->box->token().toUtf8());
        token = this->box->token();

        m_networkReply = m_networkAccessManager->get(m_networkRequest);
        connect(m_networkReply,&QIODevice::readyRead,this,&BoxDS::dataReadyRead);
        connect(m_networkReply,&QNetworkReply::finished,this,&BoxDS::dataReadFinished);

    });
}

/*!
 * \brief Calls to authorize the user using Qt's OAuth class
 */

void BoxDS::fetchDatasources()
{
    this->box->grant();
}

/*!
 * \brief List contents of a folder
 * \param path (Folder path)
 */

void BoxDS::folderNav(QString path)
{
    emit showBusyIndicator(true);

    QNetworkRequest m_networkRequest;
    QUrl api("https://api.box.com/2.0/folders/" + path + "/items");
    QUrlQuery quer(api);

    quer.addQueryItem("fields","id,name,type,modified_at,description,size");
    api.setQuery(quer);
    m_networkRequest.setUrl(api);

    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
    m_networkRequest.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    token = this->box->token();

    m_networkReply = m_networkAccessManager->get(m_networkRequest);
    connect(m_networkReply,&QIODevice::readyRead,this,&BoxDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&BoxDS::dataReadFinished);

}

/*!
 * \brief Search the Box API
 * \details Documentation reference https://developer.box.com/reference/get-search/
 * \param path (File name)
 */

void BoxDS::searchQuer(QString path)
{
    emit showBusyIndicator(true);

    QNetworkRequest m_networkRequest;

    // api link - https://developer.box.com/reference/get-search/


    QUrl api("https://api.box.com/2.0/search");
    QUrlQuery quer(api);
    quer.addQueryItem("query",path);
    quer.addQueryItem("fields","id,name,type,modified_at,description,size");
    api.setQuery(quer);
    m_networkRequest.setUrl(api);

    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
    m_networkRequest.setRawHeader("Authorization", "Bearer " + this->box->token().toUtf8());
    token = this->box->token();

    m_networkReply = m_networkAccessManager->get(m_networkRequest);
    connect(m_networkReply,&QIODevice::readyRead,this,&BoxDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&BoxDS::dataReadFinished);
}

/*!
 * \brief Notify model after adding new record in QList<Box *>
 * \param box (Box *)
 */

void BoxDS::addDataSource(Box *box)
{
    emit preItemAdded();
    m_box.append(box);
    emit postItemAdded();
}

/*!
 * \brief Add new data to QList<Box *>
 * \param id (File id)
 * \param name (File name)
 * \param type (File type)
 * \param modifiedAt (Modified date)
 * \param extension (File extension)
 */

void BoxDS::addDataSource(const QString &id, const QString &name, const QString &type, const QString &modifiedAt, const QString &extension)
{
    Box *box = new Box(id,name,type,modifiedAt,extension);

    addDataSource(box);
}

void BoxDS::fetchFileData(QString fileId, QString fileExtension)
{

    emit showBusyIndicator(true);
    qDebug() << fileId << fileExtension;

    this->boxFileId = fileId;
    this->boxExtension = fileExtension;

    QNetworkRequest m_networkRequest;
    m_networkReply = this->box->get(QUrl("https://api.box.com/2.0/files/"+ fileId +"/content"));

    QUrl api("https://api.box.com/2.0/files/"+ fileId +"/content");
    m_networkRequest.setUrl(api);
//    m_networkRequest.setAttribute(QNetworkRequest::FollowRedirectsAttribute, true);
//    m_networkRequest.setMaximumRedirectsAllowed(10);

    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
//    m_networkRequest.setRawHeader("Content-Type","application/json");
    m_networkRequest.setRawHeader("Authorization", "Bearer " + this->box->token().toUtf8());

    m_networkReply = m_networkAccessManager->get(m_networkRequest);
    connect(m_networkReply,&QNetworkReply::finished,this,&BoxDS::fileDownloadFinished);
}

/*!
 * \brief List the values in QList<Box *>
 * \return QList<Box *>
 */

QList<Box *> BoxDS::dataItems()
{
    return m_box;
}

/*!
 * \brief Clear all the values in QList<Box*> & notify model
 */

void BoxDS::resetDatasource()
{
    emit preReset();
    m_box.clear();
    emit postReset();
}

/*!
 * \brief Reads incoming data from the API & store to buffer
 */

void BoxDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

/*!
 * \brief Processes the data buffer
 * \details Process the data buffer and append new values to QList<Box*>
 */

void BoxDS::dataReadFinished()
{
    if(m_networkReply->error()){
        qDebug() <<"There was some error : "<< m_networkReply->errorString();
    }
    else{

        QStringList requiredExtensions;
        requiredExtensions << ".xls" << ".xlsx" << ".csv" << ".json" << ".ods";

        this->resetDatasource();
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonArray dataArray = resultObj["entries"].toArray();

        for(int i=0;i<dataArray.size();i++){

            QJsonObject dataObj = dataArray.at(i).toObject();

            QString BoxID = dataObj["id"].toString();
            QString BoxName = dataObj["name"].toString();
            QString BoxType = dataObj["type"].toString();
            QString BoxModifiedAt = QDateTime::fromString(dataObj["modified_at"].toString(), Qt::ISODate).toString("yyyy/MM/dd HH:mm ap");
            QString BoxExtension;
            QStringList extensionList;
            if(BoxType == "folder"){
                BoxModifiedAt = "--";
                BoxExtension = "--";
            }
            if(BoxType == "file"){
                extensionList = BoxName.split('.');
                BoxExtension = "." + extensionList.last();
            }

            if(requiredExtensions.indexOf(BoxExtension) >= 0 || BoxExtension == "--"){
                this->addDataSource(BoxID,BoxName,BoxType,BoxModifiedAt,BoxExtension);
            }
        }
        m_dataBuffer->clear();

        // Get user email
        m_networkReply = this->box->get(QUrl("https://api.box.com/2.0/users/me/"));
        connect(m_networkReply,&QNetworkReply::finished,this,&BoxDS::userReadFinished);

    }

    emit showBusyIndicator(false);
}

void BoxDS::userReadFinished()
{
    m_dataBuffer->append(m_networkReply->readAll());
    if(m_networkReply->error() ){
        qDebug() <<"There was some error : " << m_networkReply->errorString() ;

    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();
        emit getBoxUsername(resultObj["login"].toString());
    }

    emit showBusyIndicator(false);
}

void BoxDS::fileDownloadFinished()
{
    QByteArray bytes = m_networkReply->readAll();
    int statusCode = m_networkReply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();


    if(statusCode == 302)
    {
        QUrl newUrl = m_networkReply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
        qDebug() << "redirected  to " + newUrl.toString();
        QNetworkRequest newRequest(newUrl);

        m_networkReply = m_networkAccessManager->get(newRequest);
        connect(m_networkReply,&QNetworkReply::finished,this,&BoxDS::fileDownloadFinished);

        return ;
    }

    if(statusCode == 200)
    {
        QFile file("C:\\Users\\chill\\Desktop\\"+ this->boxFileId +"." + this->boxExtension);
        file.open(QIODevice::WriteOnly);
        file.write(bytes.data(), bytes.size());
        file.close();
    }

    emit showBusyIndicator(false);
}
