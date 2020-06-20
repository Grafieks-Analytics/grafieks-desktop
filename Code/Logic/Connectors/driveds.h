#ifndef DRIVEDS_H
#define DRIVEDS_H

#include <QObject>
#include <QOAuth2AuthorizationCodeFlow>
#include <QUrl>
#include <QUrlQuery>
#include <QOAuthHttpServerReplyHandler>
#include <QDesktopServices>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include "drive.h"

class DriveDS : public QObject
{
    Q_OBJECT
public:
    explicit DriveDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources();

    void addDataSource(Drive * drive);
    Q_INVOKABLE void addDataSource(const QString & id,const QString & name,const QString & kind,const QString & modifiedTime,const QString & extension);

    QList<Drive *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preReset();
    void postReset();

private slots:
    void resetDatasource();
//    void dataReadyRead();
    void dataReadFinished();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QOAuth2AuthorizationCodeFlow * google;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Drive*> m_drive;

};

#endif // DRIVEDS_H
