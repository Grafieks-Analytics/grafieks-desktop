#ifndef NEWTABLECOLUMNSMODEL_H
#define NEWTABLECOLUMNSMODEL_H

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

class NewTableColumnsModel : public QObject
{
    Q_OBJECT
    DuckCon *duckCon;
    DataType dataType;

public:
    explicit NewTableColumnsModel(QObject *parent = nullptr);
    explicit NewTableColumnsModel(DuckCon *duckCon, QObject *parent = nullptr);

    Q_INVOKABLE void getColumnsForTable(QString tableName = "", QString moduleName = "");

signals:
    void columnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);


private:
    QList<QStringList> allColumns;

};

#endif // NEWTABLECOLUMNSMODEL_H
