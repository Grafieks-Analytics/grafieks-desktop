#ifndef DROPBOXDS_H
#define DROPBOXDS_H

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
#include <QByteArray>


#include "dropbox.h"
#include "../../secrets.h"


/*!
 * \brief Fetches data records from Dropbox API
 * \details This class lists all the methods which interact with the Box API documented in
 * <a href="https://www.dropbox.com/developers/documentation/http/documentation">https://www.dropbox.com/developers/documentation/http/documentation</a>
 * \ingroup ConnectorScreen
 */

class DropboxDS : public QObject
{
    Q_OBJECT
public:
    explicit DropboxDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources();
    Q_INVOKABLE QString goingBack(QString path,QString name);
    Q_INVOKABLE void folderNav(QString path);
    Q_INVOKABLE void searchQuer(QString path);
    Q_INVOKABLE void getUserName();
    Q_INVOKABLE void downloadFile(QString fileId);

    void addDataSource(Dropbox * dropbox);

    Q_INVOKABLE void addDataSource(const QString & id,const QString & tag,const QString & name,const QString & pathLower,const QString & clientModified,const QString & extension);

//    Q_INVOKABLE void removeDatasource(int index);
    QList<Dropbox *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preReset();
    void postReset();
    void getUsername(QString username);

private slots:
    void resetDatasource();
    void dataReadyRead();
    void dataReadFinished();
    void dataSearchedFinished();
//    void datadeleteFinished();
    void saveFile();

public slots:

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Dropbox*> m_dropbox;
    QOAuth2AuthorizationCodeFlow * dropbox;
    QString token;
    QString username;

    void addDatasourceHelper(QJsonDocument &doc);
};

#endif // DROPBOXDS_H
