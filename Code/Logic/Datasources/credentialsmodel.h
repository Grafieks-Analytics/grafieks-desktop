#ifndef CREDENTIALSMODEL_H
#define CREDENTIALSMODEL_H

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QObject>
#include <QDebug>


#include "../../constants.h"

class CredentialsModel : public QObject
{
    Q_OBJECT

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QVariantMap credentials;

public:
    explicit CredentialsModel(QObject *parent = nullptr);
    Q_INVOKABLE void fetchLiveCredentials(QString dsName);

public slots:
    void dataReadyRead();
    void dataReadFinished();

signals:
    void openConnection(QString dbType);
    void signalCredentialsReceived(QVariantMap credentials);

};

#endif // CREDENTIALSMODEL_H
