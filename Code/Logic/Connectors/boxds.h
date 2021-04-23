#ifndef BOXDS_H
#define BOXDS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QOAuth2AuthorizationCodeFlow>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QUrl>
#include <QUrlQuery>
#include <QFile>
#include <QDesktopServices>
#include <QOAuthHttpServerReplyHandler>
#include <QtDebug>
#include <QDir>

#include "box.h"
#include "../../secrets.h"
#include "../../statics.h"
#include "../../constants.h"

/*!
 * \brief Fetches data records from Box API
 * \details This class lists all the methods which interact with the Box API documented in
 * <a href="https://developer.box.com/reference/">https://developer.box.com/reference/</a>
 * \ingroup ConnectorScreen
 */

class BoxDS : public QObject
{
    Q_OBJECT
public:
    explicit BoxDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources();
    Q_INVOKABLE void folderNav(QString path);
    Q_INVOKABLE void searchQuer(QString path);
    Q_INVOKABLE void fetchFileData(QString fileId, QString fileExtension);

    void addDataSource(Box *box);
    Q_INVOKABLE void addDataSource(const QString & id,const QString & name,const QString & type,const QString & modifiedAt,const QString & extension);

    QList<Box *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preReset();
    void postReset();
    void getBoxUsername(QString username);
    void showBusyIndicator(bool status);
    void fileDownloaded(QString filePath, QString fileType);

private slots:
    void dataReadyRead();
    void dataReadFinished();
    void dataSearchFinished();
    void userReadFinished();
    void fileDownloadFinished();

public slots:
    void resetDatasource();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Box*> m_box;
    QOAuth2AuthorizationCodeFlow * box;
    QString token;

    QString boxFileId;
    QString boxExtension;
};

#endif // BOXDS_H
