#ifndef UPDATEAPPLICATIONMODEL_H
#define UPDATEAPPLICATIONMODEL_H

#include <QObject>
#include <QDebug>
#include <QSettings>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QProcess>
#include <QDir>
#include <QApplication>

#include "../../constants.h"
#include "../../statics.h"

class UpdateApplicationModel : public QObject
{
    Q_OBJECT

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QNetworkRequest m_NetworkRequest;

public:
    explicit UpdateApplicationModel(QObject *parent = nullptr);

    Q_INVOKABLE void promptUpdater();

    void checkLatestApplication();
    void checkDsVersion(QString currentVersion);
    void checkWbVersion(QString currentVersion);

    void promptUpdate();

public slots:
    void dataReadyRead();
    void dataReadFinished();

signals:
    void updateAppVersion(QString currentAppVersion, QString latestAppVersion);

};

#endif // UPDATEAPPLICATIONMODEL_H
