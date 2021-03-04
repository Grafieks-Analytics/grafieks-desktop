#ifndef DUCKDATAMODEL_H
#define DUCKDATAMODEL_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"
#include "../Connectors/duckcon.h"

#include "../General/datatype.h"

class DuckDataModel : public QObject
{
    Q_OBJECT
    QStringList colData;
    DuckCon *duckCon;
    DataType dataType;

    QList<QStringList> allColumns;

public:
    explicit DuckDataModel(QObject *parent = nullptr);
    explicit DuckDataModel(DuckCon *duckCon, QObject *parent = nullptr);


    Q_INVOKABLE void columnData(QString col, QString index);
    Q_INVOKABLE QStringList getColumnList(QString tableName, QString moduleName);
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList getDbList();

public slots:
    void receiveCsvFilterQuery(QString query);

signals:
    void csvColData(QStringList colData);
    void columnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);


};

#endif // DUCKDATAMODEL_H
