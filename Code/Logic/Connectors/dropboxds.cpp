#include "dropboxds.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QQmlContext>
#include <QtDebug>


DropboxDS::DropboxDS(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

void DropboxDS::fetchDatasources(QString path)
{
    const QUrl API_ENDPOINT("https://api.dropboxapi.com/2/files/list_folder");
    QNetworkRequest request(API_ENDPOINT);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", "Bearer u9UObpKvFnAAAAAAAAAAVUtFxxez0zkpmVysh6lbupRUR8XbW7TKomNdz0JAn9WE");

    QJsonObject json_body;
    json_body.insert("path",path);
    //    request.setRawHeader("Dropbox-API-Arg","{\"path\": \"id:XbzRXviwTQAAAAAAAAAAIQ\"}");
    json_body.insert("recursive",false);
    json_body.insert("include_media_info",false);
    json_body.insert("include_deleted",false);
    json_body.insert("include_has_explicit_shared_members",false);
    json_body.insert("include_mounted_folders",true);
    json_body.insert("include_non_downloadable_files",true);
    //    QString a="";

    m_networkReply = m_networkAccessManager->post(request,QJsonDocument(json_body).toJson());
    //        mNetReply = mNetManager->post(request, a.toUtf8());


    connect(m_networkReply,&QIODevice::readyRead,this,&DropboxDS::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&DropboxDS::dataReadFinished);

}

void DropboxDS::addDataSource(Dropbox *dropbox)
{
    emit preItemAdded();
    m_dropbox.append(dropbox);
    emit postItemAdded();
}

void DropboxDS::addDataSource(const QString & id, const QString & tag, const QString & name, const QString & pathLower, const QString & clientModified,const QString & extension)
{
    Dropbox *dropbox = new Dropbox(id,tag,name,pathLower,clientModified,extension);

    addDataSource(dropbox);
}

QList<Dropbox *> DropboxDS::dataItems()
{
    return m_dropbox;
}

void DropboxDS::resetDatasource()
{
    emit preReset();
    m_dropbox.clear();
    emit postReset();
}

void DropboxDS::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void DropboxDS::dataReadFinished()
{
    if(m_networkReply->error()){
        qDebug() <<"There was some error : "<< m_networkReply->errorString();
    }
    else{

        this->resetDatasource();

        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();
        QJsonObject statusObj = resultObj["status"].toObject();



            QJsonArray dataArray = resultObj["entries"].toArray();

            for(int i=0;i<dataArray.size();i++){

                QJsonObject dataObj = dataArray.at(i).toObject();

                QString DropboxID = dataObj["id"].toString();
                QString DropboxTag = dataObj[".tag"].toString();
                QString DropboxName = dataObj["name"].toString();
                QStringList extensionList;
                QString DropboxExtension;
                QString DropboxPathLower = dataObj["path_lower"].toString();
                QString DropboxClientModi;
                if(DropboxTag  == "file"){
                    DropboxClientModi = dataObj["client_modified"].toString();
                    extensionList = DropboxName.split('.');
                    DropboxExtension = "." + extensionList.last();
                }
                else{
                    DropboxClientModi = "--";
                    DropboxExtension = "--";

                }
                this->addDataSource(DropboxID,DropboxTag,DropboxName,DropboxPathLower,DropboxClientModi,DropboxExtension);
            }

        m_dataBuffer->clear();
    }
}



