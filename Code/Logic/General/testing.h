#ifndef TESTING_H
#define TESTING_H

#include <QObject>
#include <QOAuth2AuthorizationCodeFlow>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QByteArray>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include <QFile>
#include <QDir>
#include <QUrl>
#include <QOAuthHttpServerReplyHandler>
#include <QDesktopServices>
#include <QEventLoop>
#include <QUrlQuery>

class Testing : public QObject
{
    Q_OBJECT
public:
    explicit Testing(QObject *parent = nullptr);
    Q_INVOKABLE void click();


private:
    QOAuth2AuthorizationCodeFlow * google;

private slots:

    void readme();


};

#endif // TESTING_H
