#ifndef PUBLISHDATASOURCEMODEL_H
#define PUBLISHDATASOURCEMODEL_H

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


class PublishDatasourceModel : public QObject
{
    Q_OBJECT
public:
    explicit PublishDatasourceModel(QObject *parent = nullptr);
    Q_INVOKABLE void publishDatasource(QString dsName, QString description, QString uploadImage, QString sourceType,  int schedulerId = 0, bool isFullExtract = false, QString extractColumnName = "");

private slots:
    void reading();
    void readComplete();
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    void uploadFinished();

signals:
    void publishDSStatus(QVariantMap status);
    void dsUploadPercentage(int percentage);
    void dsUploadFinished();

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

    void uploadFile();
};

#endif // PUBLISHDATASOURCEMODEL_H
