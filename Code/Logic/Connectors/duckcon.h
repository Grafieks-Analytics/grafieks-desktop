#ifndef DUCKCON_H
#define DUCKCON_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include <QThread>

#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"
#include "../../Connectors/allconnectors.h"


class DuckCon : public QObject
{
    Q_OBJECT
    ExcelCon excelToCsv;
    JsonCon jsonToCsv;
    QStringList tables;
    QThread thread;
    QThread thread2;

    QStringList excelSheetsList;
    QVariantMap response;
    bool directLogin;



public:
    explicit DuckCon(QObject *parent = nullptr);
//    ~DuckCon();

    duckdb::DuckDB db;
    duckdb::Connection con;

public slots:
    void createTable(QString dbName, bool directLogin, QVariantMap response);
    void dropTables();

    void convertedExcelPaths(QStringList paths);
//    void processData();

signals:
    void importError(QString errorString, QString fileType);
    void excelLoginStatus(QVariantMap response, bool directLogin);

};

#endif // DUCKCON_H
