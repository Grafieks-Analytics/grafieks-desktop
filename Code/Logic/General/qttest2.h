#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QByteArray>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>


class QtTest2 : public QObject
{
    Q_OBJECT
public:
    explicit QtTest2(QObject *parent = nullptr);

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

#endif // QTTEST2_H
