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

/*!
 * \brief Fetches data records from Datasources API
 * \details Fetches data records for Datasources from Grafieks server API
 * \ingroup Datasources
 */

class DatasourceDS : public QObject
{
    Q_OBJECT
public:
    explicit DatasourceDS(QObject *parent = nullptr);

    Q_INVOKABLE void fetchDatsources(int page, bool fulllist, bool listview, QString keyword = "");
    Q_INVOKABLE void deleteDatasource(int datasourceId, int listIndex);

    void addDatasource(Datasource * datasource);

    Q_INVOKABLE void addDatasource(const int & id, const int & connectedWorkbooksCount, const int & profileId, const QString & connectionType, const QString & datasourceName, const QString & descriptions, const QString & sourceType, const QString & imageLink, const QString & downloadLink, const QString & createdDate, const QString & firstName, const QString & lastName);

    Q_INVOKABLE void removeDatasource(int index);
    QList<Datasource *> dataItems();

signals:
    void preItemAdded();
    void postItemAdded();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preReset();
    void postReset();

private slots:
    void resetDatasource();

    void dataReadyRead();
    void dataReadFinished();
    void dataDeleteFinished();


public slots:

private :
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QList<Datasource*> m_datasource;

};

#endif // DATASOURCEDS_H
