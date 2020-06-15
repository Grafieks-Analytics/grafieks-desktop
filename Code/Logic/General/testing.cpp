#include "testing.h"

Testing::Testing(QObject *parent) : QObject(parent)
{
    this->google = new QOAuth2AuthorizationCodeFlow(this);
    this->google->setScope("email https://www.googleapis.com/auth/drive.readonly");

    connect(this->google, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, [=](QUrl url) {
        QUrlQuery query(url);

        // Forces the user to enter their credentials to authorize the correct
        query.addQueryItem("prompt", "consent");
        url.setQuery(query);
        QDesktopServices::openUrl(url);
    });

    this->google->setAuthorizationUrl(QUrl("https://accounts.google.com/o/oauth2/auth"));
    this->google->setClientIdentifier("CLIENT_ID");
    this->google->setAccessTokenUrl(QUrl("https://oauth2.googleapis.com/token"));
    this->google->setClientIdentifierSharedKey("SECRET_KEY");

    // In my case, I have hardcoded 8080 to test
    auto replyHandler = new QOAuthHttpServerReplyHandler(5476, this);
    this->google->setReplyHandler(replyHandler);


    connect(this->google, &QOAuth2AuthorizationCodeFlow::granted, [=](){
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        auto reply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files"));
        connect(reply, &QNetworkReply::finished, [reply](){
            qDebug() << "REQUEST FINISHED. Error? " << (reply->error() != QNetworkReply::NoError);
            qDebug() << reply->readAll();
        });
    });
}

void Testing::click()
{
    this->google->grant();
}


void Testing::readme()
{

}


