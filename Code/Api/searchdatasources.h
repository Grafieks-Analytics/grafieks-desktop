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

signals:

};

#endif // SEARCHDATASOURCES_H
