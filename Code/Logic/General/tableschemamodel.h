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
#include "../Connectors/duckcon.h"

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
    DuckCon *duckCon;

public:
    explicit TableSchemaModel(QObject *parent = nullptr);
    explicit TableSchemaModel(DuckCon *duckCon, QObject *parent = nullptr);
    Q_INVOKABLE void showSchema(QString query = "");
    Q_INVOKABLE void clearSchema();

signals:
    void tableSchemaObtained(QList<QStringList> allList, QList<QStringList> allCategorical, QList<QStringList> allNumerical, QList<QStringList> allDates, QList<QStringList> allOthers, QStringList queriedColumnNames);
    void tableSchemaCleared();

private:

    QList<QStringList> allList;
    QList<QStringList> allCategorical;
    QList<QStringList> allNumerical;
    QList<QStringList> allDates;
    QList<QStringList> allOthers;
    QStringList queriedColumnNames;
};

#endif // TABLESCHEMAMODEL_H
