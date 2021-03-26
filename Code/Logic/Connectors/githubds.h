#ifndef GITHUBDS_H
#define GITHUBDS_H

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
#include <QtDebug>
#include <QFile>

#include "github.h"
#include "../../secrets.h"

/*!
 * \brief Fetches data records from Github API
 * \details This class lists all the methods which interact with the Box API documented in
 * <a href="https://docs.github.com/en/developers/apps/authorizing-oauth-apps">https://docs.github.com/en/developers/apps/authorizing-oauth-apps</a>
 * \ingroup ConnectorScreen
 */

class GithubDS : public QObject
{
    Q_OBJECT
public:
    explicit GithubDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatasources();
    Q_INVOKABLE void searchQuer(QString path);
    Q_INVOKABLE void homeBut();

    void addDataSource(Github * github);
    Q_INVOKABLE void addDataSource(const QString & id,const QString & name,const QString & kind,const QString & modifiedTime,const QString & extension);

    QList<Github *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preReset();
    void postReset();
    void getGithubUsername(QString username);

private slots:
    void resetDatasource();
    void dataReadyRead();
    void dataReadFinished();
    void userReadFinished();
    void saveFile();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QOAuth2AuthorizationCodeFlow * github;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Github *> m_github;

};

#endif // GITHUBDS_H
