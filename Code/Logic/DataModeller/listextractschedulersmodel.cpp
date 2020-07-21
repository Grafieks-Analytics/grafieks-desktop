#include "listextractschedulersmodel.h"

ListExtractSchedulersModel::ListExtractSchedulersModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray)
{

}

void ListExtractSchedulersModel::listExtractSchedulers()
{
    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();


    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(baseUrl+"/desk_listschedulernames");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
     m_NetworkRequest.setRawHeader("Authorization", sessionToken);


    QJsonObject obj;
    obj.insert("profileID", profileId);
    obj.insert("Type", "data_extract");


    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());


    connect(m_networkReply, &QIODevice::readyRead, this, &ListExtractSchedulersModel::reading, Qt::UniqueConnection);
    connect(m_networkReply, &QNetworkReply::finished, this, &ListExtractSchedulersModel::readComplete, Qt::UniqueConnection);
}

void ListExtractSchedulersModel::reading()
{
    m_tempStorage->append(m_networkReply->readAll());
}

void ListExtractSchedulersModel::readComplete()
{
    if(m_networkReply->error()){
        qDebug() << __FILE__ << __LINE__ << m_networkReply->errorString();


    } else{
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_tempStorage);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["data"].toObject();

//        // Set the output
//        outputStatus.insert("code", statusObj["code"].toInt());
//        outputStatus.insert("msg", statusObj["msg"].toString());

        qDebug() << "uploaded" << statusObj;

//        emit publishDSStatus(outputData);
        m_tempStorage->clear();
    }
}
