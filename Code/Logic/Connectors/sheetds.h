#ifndef SHEETDS_H
#define SHEETDS_H

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
#include "sheet.h"

class SheetDS : public QObject
{
    Q_OBJECT
public:
    explicit SheetDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources();

    void addDataSource(Sheet * Sheet);
    Q_INVOKABLE void addDataSource(const QString & id,const QString & name,const QString & kind,const QString & modifiedTime,const QString & extension);

    QList<Sheet *> dataItems();

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
    QList<Sheet*> m_Sheet;


};

#endif // SHEETDS_H
