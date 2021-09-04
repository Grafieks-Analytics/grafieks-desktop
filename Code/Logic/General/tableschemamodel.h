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
#include "datatype.h"
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
    QuerySplitter querySplitter;

    int csvHeaderLength;
    QList<QByteArray> csvHeaderDataFinal;

public:
    explicit TableSchemaModel(QObject *parent = nullptr);
    Q_INVOKABLE void showSchema(QString query = ""); 
    Q_INVOKABLE void clearSchema();

signals:
    void tableSchemaObtained(QList<QStringList> allList, QList<QStringList> allCategorical, QList<QStringList> allNumerical, QList<QStringList> allDates, QList<QStringList> allOthers, QStringList queriedColumnNames);
    void extractSchemaObtained(QList<QStringList> allList, QList<QStringList> allCategorical, QList<QStringList> allNumerical, QList<QStringList> allDates, QList<QStringList> allOthers);
    void tableSchemaCleared();

public slots:
    void generateSchemaForExtract();

private:

    QList<QStringList> allList;
    QList<QStringList> allCategorical;
    QList<QStringList> allNumerical;
    QList<QStringList> allDates;
    QList<QStringList> allOthers;

    QList<QStringList> extractAllList;
    QList<QStringList> extractAllCategorical;
    QList<QStringList> extractAllNumerical;
    QList<QStringList> extractAllDates;
    QList<QStringList> extractAllOthers;

    QStringList queriedColumnNames;

    void setHeaders(const QByteArray line, QString delimiter);
    QMap<QString, QList<QStringList>> detectHeaderTypes(const QByteArray line, QString delimiter, QString tableName);
};

#endif // TABLESCHEMAMODEL_H
