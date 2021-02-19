#include "downloadfile.h"

DownloadFile::DownloadFile(QUrl filePath, QObject *parent)
{
    connect(&m_WebCtrl, SIGNAL (finished(QNetworkReply*)),this, SLOT (fileDownloaded(QNetworkReply*)));

    QNetworkRequest request(filePath);
    m_WebCtrl.get(request);
}

DownloadFile::~DownloadFile()
{

}

QByteArray DownloadFile::downloadedData() const
{
    return m_DownloadedData;
}

void DownloadFile::fileDownloaded(QNetworkReply *pReply)
{

    m_DownloadedData = pReply->readAll();
    //emit a signal
    pReply->deleteLater();
    emit downloaded();
}
