#include "boxds.h"
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

// box api documentation - https://developer.box.com/reference/

BoxDS::BoxDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
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
    this->box->setClientIdentifier("xmv0g8l02pkfolfw0eofxsifmd2o0w6z");
    this->box->setAccessTokenUrl(QUrl("https://api.box.com/oauth2/token"));
    this->box->setClientIdentifierSharedKey("U0sHm7ESB7MgSoeD66OD2GSSQOSkno9s");

    auto replyHandler = new QOAuthHttpServerReplyHandler(5476, this);
    this->box->setReplyHandler(replyHandler);

    connect(this->box, &QOAuth2AuthorizationCodeFlow::granted, [=]() {
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

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

void BoxDS::fetchDatasources()
{
    this->box->grant();
}

//QString BoxDS::goingBack(QString path, QString name)
//{

//}

void BoxDS::folderNav(QString path)
{
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

void BoxDS::searchQuer(QString path)
{
    QNetworkRequest m_networkRequest;
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

void BoxDS::addDataSource(Box *box)
{
    emit preItemAdded();
    m_box.append(box);
    emit postItemAdded();
}

void BoxDS::addDataSource(const QString &id, const QString &name, const QString &type, const QString &modifiedAt, const QString &extension)
{
    Box *box = new Box(id,name,type,modifiedAt,extension);

    addDataSource(box);
}

QList<Box *> BoxDS::dataItems()
{
    return m_box;
}

void BoxDS::resetDatasource()
{
    emit preReset();
    m_box.clear();
    emit postReset();
}

void BoxDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void BoxDS::dataReadFinished()
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

            QString BoxID = dataObj["id"].toString();
            QString BoxName = dataObj["name"].toString();
            QString BoxType = dataObj["type"].toString();
            QString BoxModifiedAt = dataObj["modified_at"].toString();
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
            this->addDataSource(BoxID,BoxName,BoxType,BoxModifiedAt,BoxExtension);
        }
        m_dataBuffer->clear();
    }
}



