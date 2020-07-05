#ifndef TESTING_H
#define TESTING_H

#include <QObject>
#include <QOAuth2AuthorizationCodeFlow>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

#include <QUrl>
#include <QUrlQuery>
#include <QOAuthHttpServerReplyHandler>
#include <QDesktopServices>

class Testing : public QObject
{
    Q_OBJECT
public:
    explicit Testing(QObject *parent = nullptr);

private:

};

#endif // TESTING_H
