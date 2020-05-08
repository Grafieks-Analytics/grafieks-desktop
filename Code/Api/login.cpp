#include "login.h"


Login::Login(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray)

{

}

Login::Login(const QString &host, const QString &username, const QString &password, QObject *parent):
    QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray)

{
    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(host);

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");

    QJsonObject obj;
    obj.insert("username", username);
    obj.insert("password", password);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    // Settings: set baseUrl
    QSettings settings;
    settings.setValue("general/baseUrl", host);

    connect(m_networkReply, &QIODevice::readyRead, this, &Login::reading);
    connect(m_networkReply, &QNetworkReply::finished, this, &Login::readComplete);
}

void Login::reading()
{
    m_tempStorage->append(m_networkReply->readAll());
}

void Login::readComplete()
{
    if(m_networkReply->error()){
        qDebug() << __FILE__ << __LINE__ << m_networkReply->errorString();

        // Set the output
        outputStatus.insert("code", m_networkReply->error());
        outputStatus.insert("msg", m_networkReply->errorString());
        emit loginStatus(false);

    } else{
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_tempStorage);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();

        // Set the output
        outputStatus.insert("code", statusObj["code"].toInt());
        outputStatus.insert("msg", statusObj["msg"].toString());

        qDebug() << __FILE__ << __LINE__ << statusObj;

        // If successful, set the variables in settings
        if(statusObj["code"].toInt() == 200){

            QJsonObject dataObj = resultObj["data"].toObject();

            QSettings settings;
            settings.setValue("user/profileId", dataObj["profileId"].toInt());
            settings.setValue("user/isAdmin", dataObj["isAdmin"].toBool());
            settings.setValue("user/firstname", dataObj["firstname"].toString());
            settings.setValue("user/lastname", dataObj["lastname"].toString());
            settings.setValue("user/photoLink", dataObj["photoLink"].toString());
            settings.setValue("user/sessionToken", dataObj["sessionToken"].toString());

            emit loginStatus(true);


        } else{
            emit loginStatus(false);
        }

        m_tempStorage->clear();

    }

}

QVariantMap Login::getOutputStatus() const
{
    return outputStatus;
}
