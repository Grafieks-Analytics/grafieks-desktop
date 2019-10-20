#ifndef USER_H
#define USER_H

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QUrl>
#include <QUrlQuery>
#include <QSqlQuery>
#include <QSqlError>
#include <QObject>

class User : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString loginUsername READ loginUsername WRITE setLoginUsername NOTIFY loginUsernameChanged)
    Q_PROPERTY(QString loginPassword READ loginPassword WRITE setLoginPassword NOTIFY loginPasswordChanged)
    Q_PROPERTY(QUrl serverHost READ serverHost WRITE setServerHost NOTIFY serverHostChanged)

    Q_PROPERTY(QString firstName READ firstName WRITE setFirstName NOTIFY firstNameChanged)
    Q_PROPERTY(QString lastName READ lastName WRITE setLastName NOTIFY lastNameChanged)
    Q_PROPERTY(QString photoLink READ photoLink WRITE setPhotoLink NOTIFY photoLinkChanged)
    Q_PROPERTY(QString sessionHash READ sessionHash WRITE setSessionHash NOTIFY sessionHashChanged)
    Q_PROPERTY(int profileId READ profileId WRITE setProfileId NOTIFY profileIdChanged)


public:
    explicit User(QObject *parent = nullptr);

    QString loginUsername() const;
    QString loginPassword() const;
    QUrl serverHost() const;

    QString firstName() const;
    QString lastName() const;
    QString photoLink() const;
    QString sessionHash() const;
    int profileId() const;

    Q_INVOKABLE void checkLogin(bool showPublish);
    Q_INVOKABLE bool checkSession();
    void fetchCredentials();


signals:

    void loginUsernameChanged(QString loginUsername);
    void loginPasswordChanged(QString loginPassword);
    void serverHostChanged(QUrl serverHost);
    void firstNameChanged(QString firstName);
    void lastNameChanged(QString lastName);
    void photoLinkChanged(QString photoLink);
    void sessionHashChanged(QString sessionHash);
    void profileIdChanged(int profileId);

    void loginStatus(bool loginStatusVar, bool showPublish);

public slots:
    void setLoginUsername(QString loginUsername);
    void setLoginPassword(QString loginPassword);
    void setServerHost(QUrl serverHost);
    void setFirstName(QString firstName);
    void setLastName(QString lastName);
    void setPhotoLink(QString photoLink);
    void setSessionHash(QString sessionHash);
    void setProfileId(int profileId);

private slots:
    void reading();
    void readComplete();

private:

    QString m_loginUsername;
    QString m_loginPassword;
    QUrl m_serverHost;

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;

    QString m_firstName;
    QString m_lastName;
    QString m_photoLink;
    QString m_sessionHash;
    int m_profileId;
    bool showPublishMain;
};

#endif // USER_H
