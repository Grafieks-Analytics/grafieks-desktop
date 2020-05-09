#include "logout.h"

Logout::Logout(QObject *parent) : QObject(parent),
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
    m_networkRequest.setUrl(baseUrl+"/logout");

    m_networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_networkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("profileId", profileId);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_networkRequest, strJson.toUtf8());

    connect(m_networkReply, &QIODevice::readyRead, this, &Logout::reading);
    connect(m_networkReply, &QNetworkReply::finished, this, &Logout::readComplete);
}




void Logout::reading()
{

    m_tempStorage->append(m_networkReply->readAll());
}

void Logout::readComplete()
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

        // If successful, remove the user variables in settings
        if(statusObj["code"].toInt() == 200){

            QSettings settings;
            settings.remove("user");
            finalStatus = false;
        }

        emit logoutStatus(finalStatus);
        m_tempStorage->clear();
    }
}

QVariantMap Logout::getOutputStatus() const
{
    return outputStatus;
}
