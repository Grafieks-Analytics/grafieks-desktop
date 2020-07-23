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


class PublishDatasourceModel : public QObject
{
    Q_OBJECT
public:
    explicit PublishDatasourceModel(QObject *parent = nullptr);
    Q_INVOKABLE void publishDatasource(QString dsName, QString description, QString uploadImage, QString sourceType,  int schedulerId, bool isFullExtract, QString extractColumnName);

private slots:
    void reading();
    void readComplete();

signals:
    void publishDSStatus(QVariantMap status);

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

};

#endif // PUBLISHDATASOURCEMODEL_H
