#ifndef LISTEXTRACTSCHEDULERSMODEL_H
#define LISTEXTRACTSCHEDULERSMODEL_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QObject>
#include <QDebug>

class ListExtractSchedulersModel : public QObject
{
    Q_OBJECT
public:
    explicit ListExtractSchedulersModel(QObject *parent = nullptr);
    Q_INVOKABLE void listExtractSchedulers();

private slots:
    void reading();
    void readComplete();

signals:
    void publishDSStatus(QList<QVariantMap> outputData);

private:
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;

    QVariantMap result;
    QList <QVariantMap> outputData;

};

#endif // LISTEXTRACTSCHEDULERSMODEL_H
