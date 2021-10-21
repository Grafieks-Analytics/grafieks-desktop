#include "user.h"

User::User(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray)
{

}

void User::login()
{
    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(this->host);

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");

    QJsonObject obj;
    obj.insert("username", this->username);
    obj.insert("password", this->password);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    // Settings: set baseUrl
    // Settings: set hostname
    QSettings settings;
    settings.setValue("general/baseUrl", host);

    QUrl url(host);
    settings.setValue("general/hostname", url.host());

    connect(m_networkReply, &QIODevice::readyRead, this, &User::reading, Qt::UniqueConnection);
    connect(m_networkReply, &QNetworkReply::finished, this, &User::loginReadComplete, Qt::UniqueConnection);
}

void User::logout()
{

    // Fetch value from settings
    QSettings settings;
    QString baseUrl = settings.value("general/baseUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    // Remove user settings from data
    settings.remove("user");


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

    connect(m_networkReply, &QIODevice::readyRead, this, &User::reading);
    connect(m_networkReply, &QNetworkReply::finished, this, &User::logoutReadComplete);
}

void User::setHost(const QString &value)
{
    host = value;
}

void User::setPassword(const QString &value)
{
    password = value;
}

void User::setUsername(const QString &value)
{
    username = value;
}

void User::reading()
{
    m_tempStorage->append(m_networkReply->readAll());
}

void User::loginReadComplete()
{


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

            QJsonObject dataObj = resultObj["data"].toObject();

            QSettings settings;
            settings.setValue("user/profileId", dataObj["profileId"].toInt());
            settings.setValue("user/isAdmin", dataObj["isAdmin"].toBool());
            settings.setValue("user/firstname", dataObj["firstname"].toString());
            settings.setValue("user/lastname", dataObj["lastname"].toString());
            settings.setValue("user/photoLink", dataObj["photoLink"].toString());
            settings.setValue("user/sessionToken", dataObj["sessionToken"].toString());
            settings.setValue("user/sitename", dataObj["sitename"].toString());
        }

        emit loginStatus(outputStatus);
        m_tempStorage->clear();

    }
}

void User::logoutReadComplete()
{


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

            //            QSettings settings;
            //            settings.remove("user");
        }

        emit logoutStatus(outputStatus);
        m_tempStorage->clear();
    }

}
