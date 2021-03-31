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
#include <QFile>
#include <QDir>

#include "sheet.h"
#include "../../secrets.h"

/*!
 * \brief Fetches data records from Google Sheet API
 * \details This class lists all the methods which interact with the Box API documented in
 * <a href="https://developers.google.com/drive/api/v3/reference/files">https://developers.google.com/drive/api/v3/reference/files</a>
 * \ingroup ConnectorScreen
 */


class SheetDS : public QObject
{
    Q_OBJECT
public:
    explicit SheetDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources();
    Q_INVOKABLE void searchQuer(QString path);
    Q_INVOKABLE void homeBut();
    Q_INVOKABLE void fetchFileData(QString gFileId);

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
    void getSheetUsername(QString username);
    void showBusyIndicator(bool status);

private slots:
    void resetDatasource();
    void fileDownloadFinished();
    void dataReadFinished();
    void userReadFinished();


private:
    QNetworkAccessManager * m_networkAccessManager;
    QOAuth2AuthorizationCodeFlow * google;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Sheet*> m_Sheet;

    QString username;
    QString gFileId;
};

#endif // SHEETDS_H
