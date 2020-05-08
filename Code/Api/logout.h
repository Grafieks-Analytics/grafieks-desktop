#ifndef LOGOUT_H
#define LOGOUT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QDebug>

class Logout : public QObject
{
    Q_OBJECT

public:
    explicit Logout(QObject *parent = nullptr);
    QVariantMap getOutputStatus() const;

private slots:
    void reading();
    void readComplete();


signals:

private :
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

};

#endif // LOGOUT_H
