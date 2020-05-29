#include "qttest2.h"

QtTest2::QtTest2(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_tempStorage(new QByteArray)
{
    const QUrl API_ENDPOINT("https://content.dropboxapi.com/2/files/download");
    QNetworkRequest request(API_ENDPOINT);

    request.setRawHeader("Authorization", "Bearer Nhs8WPsY-hYAAAAAAAAHvLP53pgtkGD_ZI3ZYNXF5LacVrX88iJnqV807cFLvw-E");
    request.setRawHeader("Dropbox-API-Arg","{\"path\": \"id:g8RmlbAknUAAAAAAAAACsw\"}");

    QString a="";

    m_networkReply = m_networkAccessManager->post(request, a.toUtf8());


    connect(m_networkReply, &QIODevice::readyRead, this, &QtTest2::reading, Qt::UniqueConnection);
    connect(m_networkReply, &QNetworkReply::finished, this, &QtTest2::readComplete, Qt::UniqueConnection);

}


void QtTest2::reading()
{

    m_tempStorage->append(m_networkReply->readAll());
}

void QtTest2::readComplete()
{


    if(m_networkReply->error()){
        qDebug() << __FILE__ << __LINE__ << m_networkReply->errorString() << m_networkReply->error();


    } else{
        QJsonDocument resultJson = QJsonDocument::fromJson(* m_tempStorage);
        QJsonObject resultObj = resultJson.object();

        qDebug() << resultJson << "corona";

        m_tempStorage->clear();

    }
}

