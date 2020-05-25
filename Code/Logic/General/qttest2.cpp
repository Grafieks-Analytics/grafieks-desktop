#include "qttest2.h"


QtTest2::QtTest2(QObject *parent) : QObject(parent),
    mNetManager(new QNetworkAccessManager(this)),
    mNetReply(nullptr),
    mDataBuffer(new QByteArray),
    mBuffer("")

{

}

void QtTest2::fetchPosts()
{
//    connect(mNetReply,&QIODevice::readyRead,this,&QtTest2::dataReadyRead);
    const QUrl API_ENDPOINT("https://api.dropboxapi.com/2/files/list_folder");
    QNetworkRequest request(QUrl("https://api.dropboxapi.com/2/files/list_folder"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", "Bearer u9UObpKvFnAAAAAAAAAAVUtFxxez0zkpmVysh6lbupRUR8XbW7TKomNdz0JAn9WE");
    QJsonObject json_body;
//    json_body.insert("limit",1000);
    json_body.insert("path","");
    json_body.insert("recursive",false);
    json_body.insert("include_media_info",false);
    json_body.insert("include_deleted",false);
    json_body.insert("include_has_explicit_shared_members",false);
    json_body.insert("include_mounted_folders",true);
    json_body.insert("include_non_downloadable_files",true);

    mNetReply = mNetManager->post(request,QJsonDocument(json_body).toJson());


    connect(mNetReply,&QIODevice::readyRead,this,&QtTest2::dataReadyRead);
    connect(mNetReply,&QNetworkReply::finished,this,&QtTest2::dataReadFinished);
}



void QtTest2::dataReadyRead()
{
    mDataBuffer->append( mNetReply->readAll());
}

void QtTest2::dataReadFinished()
{
    // Parse JSON Data
    if(mNetReply->error() ){
        qDebug() <<"There was some error : " << mNetReply->errorString() ;
    }else{
       qDebug() << "The header is :" << mNetReply->isFinished();
       QJsonDocument resultJson = QJsonDocument::fromJson(* mDataBuffer);
       QJsonObject resultObj = resultJson.object();

       qDebug() << resultObj;
    }

}
