#ifndef TABLESCHEMAMODEL_H
#define TABLESCHEMAMODEL_H

#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QObject>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QSettings>

#include "datatype.h"
#include "queryjoiner.h"
#include "querysplitter.h"

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

#include "datatype.h"
#include "../../duckdb.hpp"

/*!
 * \class TableSchemaModel
 * \brief Generates schema of a given table(s) in a given query
 * \ingroup General
 */
class TableSchemaModel : public QObject
{
    Q_OBJECT
    DataType dataType;
    QueryJoiner qj;
    QuerySplitter querySplitter;

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QNetworkRequest m_NetworkRequest;

    QString baseUrl;
    QByteArray sessionToken;
    int profileId;

    QString reportWhereConditions;
    QString dashboardWhereConditions;
    QString joinConditions;

    int csvHeaderLength;
    QList<QByteArray> csvHeaderDataFinal;

public:
    explicit TableSchemaModel(QObject *parent = nullptr);
    Q_INVOKABLE void showSchema(QString query = ""); 
    Q_INVOKABLE void clearSchema();

signals:
    void tableSchemaObtained(QList<QVariantList> allList, QList<QVariantList> allCategorical, QList<QVariantList> allNumerical, QList<QVariantList> allDates, QList<QVariantList> allOthers, QStringList queriedColumnNames);
    void extractSchemaObtained(QList<QVariantList> allList, QList<QVariantList> allCategorical, QList<QVariantList> allNumerical, QList<QVariantList> allDates, QList<QVariantList> allOthers);
    void apiSchemaObtained(QList<QVariantList> allList, QList<QVariantList> allCategorical, QList<QVariantList> allNumerical, QList<QVariantList> allDates, QList<QVariantList> allOthers);
    void tableSchemaCleared();

    void sessionExpired();

public slots:
    void generateSchemaForExtract();
    void generateSchemaForLive(QString query);
    void generateSchemaForReader(duckdb::Connection *con);
    void generateSchemaForApi();

    void dataReadyRead();
    void dataReadFinished();


private:

    QList<QVariantList> allList;
    QList<QVariantList> allCategorical;
    QList<QVariantList> allNumerical;
    QList<QVariantList> allDates;
    QList<QVariantList> allOthers;

    QList<QVariantList> extractAllList;
    QList<QVariantList> extractAllCategorical;
    QList<QVariantList> extractAllNumerical;
    QList<QVariantList> extractAllDates;
    QList<QVariantList> extractAllOthers;

    QStringList queriedColumnNames;

    void setHeaders(const QByteArray line, QString delimiter);
    QMap<QString, QList<QVariantList> > detectHeaderTypes(const QByteArray line, QString delimiter, QString tableName);
    void extractSchema(duckdb::Connection *con);
    void fetchSettings();
};

#endif // TABLESCHEMAMODEL_H
