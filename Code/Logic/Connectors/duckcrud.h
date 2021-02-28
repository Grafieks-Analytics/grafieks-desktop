#ifndef DUCKCRUD_H
#define DUCKCRUD_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"

#include "Helpers/exceltocsv.h"
#include "Helpers/jsontocsv.h"

class DuckCRUD : public QObject
{
    Q_OBJECT
    ExcelToCsv excelToCsv;
    JsonToCsv jsonToCsv;

public:
    explicit DuckCRUD(QObject *parent = nullptr);

    Q_INVOKABLE void columnData(QString col, QString index);
    //    Q_INVOKABLE void insertData();
    //    Q_INVOKABLE QStringList readTableData();
    //    Q_INVOKABLE void updateData();
    //    Q_INVOKABLE void deleteData();

    //    // Process Bulk data
    //    Q_INVOKABLE void processCsv();
    //    Q_INVOKABLE void debugCSV();
    //    void query();

    duckdb::DuckDB db;
    duckdb::Connection con;

public slots:
    void createTable();
    void receiveCsvFilterQuery(QString query);

signals:

    void csvColData(QStringList colData);

    //    void dataUpdated();
    //    void csvReadComplete(uint time);


private:

    QStringList colData;
};

#endif // DUCKCRUD_H

