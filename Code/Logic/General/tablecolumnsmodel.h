#ifndef TABLECOLUMNSMODEL_H
#define TABLECOLUMNSMODEL_H

#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QObject>
#include <QDebug>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

#include "datatype.h"
#include "../Connectors/duckcon.h"

/*!
 * \class TableColumnsModel
 * \brief Lists column names and data types for a given sql table
 * \ingroup General
 */
class TableColumnsModel : public QObject
{
    Q_OBJECT
    DuckCon *duckCon;
    DataType dataType;

public:
    explicit TableColumnsModel(QObject *parent = nullptr);
    explicit TableColumnsModel(DuckCon *duckCon, QObject *parent = nullptr);

    Q_INVOKABLE void getColumnsForTable(QString tableName = "", QString moduleName = "");

signals:
    void columnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);


private:
    QList<QStringList> allColumns;
};

#endif // TABLECOLUMNSMODEL_H
