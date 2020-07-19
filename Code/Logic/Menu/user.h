#ifndef User_H
#define User_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QObject>
#include <QDebug>


class User : public QObject
{
    Q_OBJECT
public:
    explicit User(QObject *parent = nullptr);
    Q_INVOKABLE void login();
    Q_INVOKABLE void logout();

    Q_INVOKABLE void setHost(const QString &value);
    Q_INVOKABLE void setPassword(const QString &value);
    Q_INVOKABLE void setUsername(const QString &value);


private slots:
    void reading();
    void loginReadComplete();
    void logoutReadComplete();

signals:
    void loginStatus(QVariantMap status);
    void logoutStatus(QVariantMap status);

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

    QString username;
    QString password;
    QString host;

};

#endif // User_H
