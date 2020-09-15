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


/*!
 * \class TableColumnsModel
 * \brief Lists column names and data types for a given sql table
 * \ingroup General
 */
class TableColumnsModel : public QObject
{
    Q_OBJECT
public:
    explicit TableColumnsModel(QObject *parent = nullptr);

    Q_INVOKABLE void getColumnsForTable(QString tableName = "");

signals:
    void columnListObtained(QList<QStringList> allColumns);


private:
    QList<QStringList> allColumns;
};

#endif // TABLECOLUMNSMODEL_H
