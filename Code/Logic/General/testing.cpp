#include "testing.h"

Testing::Testing(QObject *parent) : QObject(parent)
{

    this->google = new QOAuth2AuthorizationCodeFlow(this);
    this->google->setScope("email");

    connect(this->google, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, &QDesktopServices::openUrl);

    this->google->setAuthorizationUrl(QUrl("https://accounts.google.com/o/oauth2/auth"));
    this->google->setClientIdentifier("452291785459-1ldhc2q2ahqfl7sv0mh1veuov740bj5f.apps.googleusercontent.com");
    this->google->setAccessTokenUrl(QUrl("https://oauth2.googleapis.com/token"));
    this->google->setClientIdentifierSharedKey("I09LKhYI21Svp-QWPe2nsJvb");

    auto replyHandler = new QOAuthHttpServerReplyHandler(5476, this);
    this->google->setReplyHandler(replyHandler);
    this->google->grant();

    qDebug() << "Access";

    connect(this->google, &QOAuth2AuthorizationCodeFlow::granted, [=](){
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        auto reply = this->google->get(QUrl("https://www.googleapis.com/plus/v1/people/me"));
        connect(reply, &QNetworkReply::finished, [reply](){
            qDebug() << "REQUEST FINISHED. Error? " << (reply->error() != QNetworkReply::NoError);
            qDebug() << reply->readAll();
        });
    });
}
