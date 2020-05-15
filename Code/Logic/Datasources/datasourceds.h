#ifndef DATASOURCEDS_H
#define DATASOURCEDS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>

#include "datasource.h"

class DatasourceDS : public QObject
{
    Q_OBJECT
public:
    explicit DatasourceDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatsources( int page, bool fulllist, bool listview);
    void addDatasource(Datasource * datasource);

    Q_INVOKABLE void addDatasource(const int & id, const int & connectedWorkbooksCount, const int & profileId, const QString & connectionType, const QString & datasourceName, const QString & descriptions, const QString & sourceType, const QString & imageLink, const QString & downloadLink, const QString & createdDate, const QString & firstName, const QString & lastName);

    Q_INVOKABLE void removeDatasource(int index);
    QList<Datasource *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();

private slots:
    void dataReadyRead();
    void dataReadFinished();

public slots:
private :
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Datasource*> m_datasource;

};

#endif // DATASOURCEDS_H
