#include "Headers/user.h"

User::User(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray),
    showPublishMain(false)
{
    fetchCredentials();
}

QString User::loginUsername() const
{
    return m_loginUsername;
}

QString User::loginPassword() const
{
    return m_loginPassword;
}

QUrl User::serverHost() const
{
    return m_serverHost;
}

void User::checkLogin(bool showPublish)
{
    showPublishMain = showPublish;
    QNetworkRequest mRequest;
    mRequest.setUrl(serverHost());

    mRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                       "application/x-www-form-urlencoded");

    QUrlQuery postData;
    postData.addQueryItem("username", loginUsername());
    postData.addQueryItem("password", loginPassword());


    m_networkReply = m_networkAccessManager->post(mRequest, postData.toString(QUrl::FullyEncoded).toUtf8());
    connect(m_networkReply, &QIODevice::readyRead, this, &User::reading);
    connect(m_networkReply, &QNetworkReply::finished, this, &User::readComplete);

}

bool User::checkSession()
{
    QSqlQuery query;
    query.exec("SELECT * FROM user WHERE id = 1");

    if(query.last()){
        return true;
    }
    else{
        return false;
    }
}




void User::fetchCredentials()
{
    QSqlQuery query;
    query.exec("SELECT * FROM user WHERE id = 1");

    if(query.last())
    {
        while(query.next()){
            setProfileId(query.value(1).toInt());
            setSessionHash(query.value(2).toString());
            setFirstName(query.value(3).toString());
            setLastName(query.value(4).toString());
            setPhotoLink(query.value(5).toString());
        }
    }
    else{
        qDebug()<< "User: fetchCredentials:" << "No credentials present";
    }
}

int User::profileId() const
{
    return m_profileId;
}

QString User::firstName() const
{
    return m_firstName;
}

QString User::lastName() const
{
    return m_lastName;
}

QString User::photoLink() const
{
    return m_photoLink;
}

QString User::sessionHash() const
{
    return m_sessionHash;
}


void User::setLoginUsername(QString loginUsername)
{
    if (m_loginUsername == loginUsername)
        return;

    m_loginUsername = loginUsername;
    emit loginUsernameChanged(m_loginUsername);
}

void User::setLoginPassword(QString loginPassword)
{
    if (m_loginPassword == loginPassword)
        return;

    m_loginPassword = loginPassword;
    emit loginPasswordChanged(m_loginPassword);
}

void User::setServerHost(QUrl serverHost)
{
    if (m_serverHost == serverHost)
        return;

    m_serverHost = serverHost;
    emit serverHostChanged(m_serverHost);
}

void User::setFirstName(QString firstName)
{
    if (m_firstName == firstName)
        return;

    m_firstName = firstName;
    emit firstNameChanged(m_firstName);
}

void User::setLastName(QString lastName)
{
    if (m_lastName == lastName)
        return;

    m_lastName = lastName;
    emit lastNameChanged(m_lastName);
}

void User::setPhotoLink(QString photoLink)
{
    if (m_photoLink == photoLink)
        return;

    m_photoLink = photoLink;
    emit photoLinkChanged(m_photoLink);
}


void User::setSessionHash(QString sessionHash)
{
    if (m_sessionHash == sessionHash)
        return;

    m_sessionHash = sessionHash;
    emit sessionHashChanged(m_sessionHash);
}

void User::setProfileId(int profileId)
{
    if (m_profileId == profileId)
        return;

    m_profileId = profileId;
    emit profileIdChanged(m_profileId);
}

void User::reading()
{

    m_tempStorage->append(m_networkReply->readAll());
}

void User::readComplete()
{
    QSqlQuery query;

    if(m_networkReply->error()){
        qWarning() << "User: readComplete:" << m_networkReply->errorString();
    }
    else{
        QJsonDocument doc = QJsonDocument::fromJson(* m_tempStorage);
        QJsonObject json = doc.object();

        if(json["code"].toInt() == 200){

            QJsonObject jObject = json["data"].toObject();

            if(query.exec("SELECT * FROM user WHERE id = 1")){

                if(query.last())
                {

                    query.prepare("UPDATE user set profile_id = ?, session_hash = ?, firstname = ?, lastname = ?, photo_link = ? WHERE id = 1");

                    query.addBindValue(jObject["profile_id"].toInt());
                    query.addBindValue(jObject["session_token"].toString());
                    query.addBindValue(jObject["firstname"].toString());
                    query.addBindValue(jObject["lastname"].toString());
                    query.addBindValue(jObject["photo_link"].toString());
                    query.exec();
                }
                else{

                    query.prepare("INSERT INTO user (profile_id, session_hash, firstname, lastname, photo_link) VALUES (:val1, :val2, :val3, :val4, :val5)");

                    query.bindValue(":val1", jObject["profile_id"].toInt());
                    query.bindValue(":val2", jObject["session_token"].toString());
                    query.bindValue(":val3", jObject["firstname"].toString());
                    query.bindValue(":val4", jObject["lastname"].toString());
                    query.bindValue(":val5", jObject["photo_link"].toString());
                    query.exec();
                }

                setProfileId(jObject["profile_id"].toInt());
                setSessionHash(jObject["session_hash"].toString());
                setFirstName(jObject["firstname"].toString());
                setLastName(jObject["lastname"].toString());
                setPhotoLink(jObject["photo_link"].toString());
            }

            qDebug() << showPublishMain;
            emit loginStatus(true, showPublishMain);

        }

        else{
            emit loginStatus(false, showPublishMain);
            qWarning() <<"User: readComplete:" <<"Bad login credentials";
        }
    }

    m_tempStorage->clear();
}
