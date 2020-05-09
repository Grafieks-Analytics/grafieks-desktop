#ifndef LISTDATASOURCES_H
#define LISTDATASOURCES_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QDebug>

class ListDatasources : public QObject
{
    Q_OBJECT
public:
    explicit ListDatasources(QObject *parent = nullptr);
    ListDatasources(const int & page, const bool & fulllist, const bool & listview, QObject *parent = nullptr);

private slots:
    void reading();
    void readComplete();

signals:
    void listDatasourceStatus(bool status);

private :
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

};

#endif // LISTDATASOURCES_H
