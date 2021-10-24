#ifndef PUBLISHWORKBOOKMODEL_H
#define PUBLISHWORKBOOKMODEL_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QFile>
#include <QFileInfo>
#include <QObject>
#include <QDebug>

#include "../../statics.h"
#include "../../secrets.h"

class PublishWorkbookModel : public QObject
{
    Q_OBJECT
public:
    explicit PublishWorkbookModel(QObject *parent = nullptr);
    Q_INVOKABLE void publishDatasource(QString wbName, QString description, QString uploadImage, QString sourceType,  int schedulerId = 0, bool isFullExtract = false, QString extractColumnName = "");
    Q_INVOKABLE void workbookFile(QString workbookFilePath);

private slots:
    void reading();
    void readComplete();
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void uploadFinished();

signals:
    void publishWbStatus(QVariantMap status);
    void wbUploadPercentage(int percentage);
    void wbUploadFinished();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

    QString outputFileName;
    QString workbookFilePath;

    void uploadFile();

};

#endif // PUBLISHWORKBOOKMODEL_H
