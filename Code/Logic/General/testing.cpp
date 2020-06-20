#include "testing.h"

Testing::Testing(QObject *parent) : QObject(parent)
{
    this->google = new QOAuth2AuthorizationCodeFlow(this);

    // Set Scope or Permissions required from Google
    // List can be obtained from https://developers.google.com/identity/protocols/oauth2/scopes

//    this->google->setScope("email https://www.googleapis.com/auth/drive.readonly");


    connect(this->google, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, [=](QUrl url) {
        QUrlQuery query(url);
        QByteArray postData;

        query.addQueryItem("force_reapprove", "true"); // Param required to get data everytime
        query.addQueryItem("disable_signup", "false"); // Needed for Refresh Token (as AccessToken expires shortly)
        query.addQueryItem("response_type", "code");
        query.addQueryItem("redirect_uri", "http://localhost:80/jq/");


        postData = query.toString(QUrl::FullyEncoded).toUtf8();

        url.setQuery(query);
        QDesktopServices::openUrl(url);
    });

    // Here the parameters from Google JSON are filled up
    // Attached screenshot of JSON file and Google Console

    this->google->setAuthorizationUrl(QUrl("https://www.dropbox.com/oauth2/authorize"));
    this->google->setClientIdentifier("63tucv4hmxxr4rf");
    this->google->setAccessTokenUrl(QUrl("https://api.dropboxapi.com/oauth2/token"));
    this->google->setClientIdentifierSharedKey("u29h3ibejo1vqav");


    // In my case, I have hardcoded 5476
    // This is set in Redirect URI in Google Developers Console of the app
    // Same can be seen in the downloaded JSON file

    auto replyHandler = new QOAuthHttpServerReplyHandler(80, this);
    this->google->setReplyHandler(replyHandler);


    connect(this->google, &QOAuth2AuthorizationCodeFlow::granted, [=](){
        qDebug() << __FUNCTION__ << __LINE__ << "Access Granted!";

        auto reply = this->google->get(QUrl("https://www.googleapis.com/drive/v3/files?fields=files(*)"));
        connect(reply, &QNetworkReply::finished, [reply](){
            qDebug() << "REQUEST FINISHED. Error? " << (reply->error() != QNetworkReply::NoError);
            qDebug() << reply->readAll();
        });
    });
}


// Call this function to prompt authentication
// and receive data from Google

void Testing::click()
{
    this->google->grant();
}
