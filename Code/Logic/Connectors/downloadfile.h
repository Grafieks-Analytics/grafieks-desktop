#ifndef DOWNLOADFILE_H
#define DOWNLOADFILE_H

#include <QObject>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class DownloadFile : public QObject
{
    Q_OBJECT
public:
    explicit DownloadFile(QUrl filePath, QObject *parent = nullptr);
    virtual ~DownloadFile();
    QByteArray downloadedData() const;

signals:
    void downloaded();


private slots:
    void fileDownloaded(QNetworkReply* pReply);

private:
    QNetworkAccessManager m_WebCtrl;
    QByteArray m_DownloadedData;

};

#endif // DOWNLOADFILE_H
