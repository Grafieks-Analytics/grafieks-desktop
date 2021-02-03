#ifndef CSVCOLUMNLISTMODEL_H
#define CSVCOLUMNLISTMODEL_H

#include <QObject>
#include <QDebug>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"
#include "../../duckdb.hpp"

class CsvColumnListModel : public QObject
{
    Q_OBJECT
public:
    explicit CsvColumnListModel(QObject *parent = nullptr);
    Q_INVOKABLE void columnCsvData(QString colName, QString index);

public slots:
    void receiveCsvFilterQuery(QString query);

signals:
    void csvColData(QStringList colData);

private:
    duckdb::DuckDB db;
    duckdb::Connection con;
    QStringList columnData;


};

#endif // CSVCOLUMNLISTMODEL_H
