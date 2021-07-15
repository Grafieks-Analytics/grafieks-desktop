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
    bool directLogin;
    QVariantMap response;
    bool errorStatus = false;


public:
    explicit DuckCon(QObject *parent = nullptr);
    //    ~DuckCon();

    duckdb::DuckDB db;
    duckdb::Connection con;

public slots:
    void createTable(QString dbName, bool directLogin, QVariantMap response);
    void dropTables();

    void convertedExcelPaths(QStringList paths);
    void processThis();
    void processThat();

signals:
    void importError(QString errorString, QString fileType);
    void test();
    void excelLoginStatus(QVariantMap status, bool directLogin);

};

#endif // DUCKCON_H

