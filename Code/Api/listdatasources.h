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
    ListDatasources(const int & profileId, const int & page, const bool & fulllist, const bool & listview);

private slots:
    void reading();
    void readComplete();

signals:



private :
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;

};

#endif // LISTDATASOURCES_H
