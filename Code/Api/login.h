#ifndef LOGIN_H
#define LOGIN_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QDebug>


class Login : public QObject
{
    Q_OBJECT

public:
    explicit Login(QObject *parent = nullptr);
    Login(const QString & host, const QString & username, const QString & password, QObject *parent = nullptr);
    QVariantMap getOutputStatus() const;

private slots:
    void reading();
    void readComplete();

signals:
    void loginStatus(bool status);

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

};

#endif // LOGIN_H
