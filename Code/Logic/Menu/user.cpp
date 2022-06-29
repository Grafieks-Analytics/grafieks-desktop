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
    QString loginUrl = this->host + "/login";
    m_NetworkRequest.setUrl(loginUrl);

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");

    QJsonObject obj;
    obj.insert("username", this->username);
    obj.insert("password", this->password);
    obj.insert("source", Constants::source);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

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

    // We wont wait for the logout read status
    // Just clear the settings and we are good for a logout
    outputStatus.insert("code", 200);
    outputStatus.insert("msg", "Success");

    emit logoutStatus(outputStatus);

}


void User::setPassword(const QString &value)
{
    password = value;
}

void User::setUsername(const QString &value)
{
    username = value;
}

void User::siteLookup(const QString &value)
{
    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(Constants::defaultAPIEndpoint + "/sitelookup");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");

    QJsonObject obj;
    obj.insert("sitename", value);

    QSettings settings;
    settings.setValue("general/sitelookup", value);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply, &QIODevice::readyRead, this, &User::reading, Qt::UniqueConnection);
    connect(m_networkReply, &QNetworkReply::finished, this, &User::siteLookupReadComplete, Qt::UniqueConnection);
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
            settings.setValue("user/ftpUser", dataObj["ftpuser"].toString());
            settings.setValue("user/ftpPass", dataObj["ftppass"].toString());
            settings.setValue("user/ftpPort", dataObj["ftpport"].toString());
        }

    }
    emit loginStatus(outputStatus);
    m_tempStorage->clear();
}

void User::siteLookupReadComplete()
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

            this->host = resultObj["data"].toString();

            // Settings: set baseUrl
            // Settings: set hostname
            QSettings settings;
            settings.setValue("general/baseUrl", this->host);
            settings.setValue("general/ftpAddress", Constants::defaultFTPEndpoint);

            QUrl url(this->host);
            settings.setValue("general/hostname", url.host());
        }

        emit sitelookupStatus(outputStatus);
        m_tempStorage->clear();

    }
}


