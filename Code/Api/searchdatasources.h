#ifndef SEARCHDATASOURCES_H
#define SEARCHDATASOURCES_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QDebug>

class SearchDatasources : public QObject
{
    Q_OBJECT
public:
    explicit SearchDatasources(QObject *parent = nullptr);
    SearchDatasources(const QString & keyword, const int & page, const bool & fulllist, const bool & listview, QObject *parent = nullptr);

private slots:
    void reading();
    void readComplete();

signals:
    void searchDatasourceStatus(bool status);

private :
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_tempStorage;
    QVariantMap outputStatus;

};

#endif // SEARCHDATASOURCES_H
