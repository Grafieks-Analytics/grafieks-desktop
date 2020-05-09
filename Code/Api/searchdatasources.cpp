#include "searchdatasources.h"

SearchDatasources::SearchDatasources(QObject *parent) : QObject(parent)
{

}

SearchDatasources::SearchDatasources(const QString &keyword, const int &page, const bool &fulllist, const bool &listview, QObject *parent):
    QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray)
{

    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QNetworkRequest m_networkRequest;
    m_networkRequest.setUrl(baseUrl+"/searchdatasource");

    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_networkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("keyworkd", keyword);
    obj.insert("page", page);
    obj.insert("fulllist", fulllist);
    obj.insert("listview", listview);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_networkRequest, strJson.toUtf8());

    connect(m_networkReply, &QIODevice::readyRead, this, &SearchDatasources::reading);
    connect(m_networkReply, &QNetworkReply::finished, this, &SearchDatasources::readComplete);
}



void SearchDatasources::reading()
{
    m_tempStorage->append(m_networkReply->readAll());
}



void SearchDatasources::readComplete()
{
    bool finalStatus = false;

    if(m_networkReply->error()){
        qDebug() << __FILE__ << __LINE__ << m_networkReply->errorString();

        // Set the output
        outputStatus.insert("code", m_networkReply->error());
        outputStatus.insert("msg", m_networkReply->errorString());

    } else{
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_tempStorage);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();

        // Set the output
        outputStatus.insert("code", statusObj["code"].toInt());
        outputStatus.insert("msg", statusObj["msg"].toString());

        // If successful, set the variables in settings
        if(statusObj["code"].toInt() == 200){

            // Process rest of the data
            // And send to model
            // QJsonObject dataObj = resultObj["data"].toObject();


            finalStatus = true;


        }
    }

    emit searchDatasourceStatus(finalStatus);
    m_tempStorage->clear();
}
