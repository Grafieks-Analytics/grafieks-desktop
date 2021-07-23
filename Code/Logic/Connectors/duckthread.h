#ifndef DUCKTHREAD_H
#define DUCKTHREAD_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include <QThread>

#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"
#include "../../Connectors/allconnectors.h"

class DuckThread : public QObject
{
    Q_OBJECT
    QStringList excelSheetsList;
    QString jsonPath;

    QStringList tables;
    QString fileType;
    bool errorStatus;

    duckdb::DuckDB *db;
    duckdb::Connection *con;

public:
    explicit DuckThread(duckdb::DuckDB *db = nullptr, duckdb::Connection *con = nullptr, QObject *parent = nullptr);

    void start();
    void processFile(QString fileType);

    void passExcelParams(QStringList excelSheetsList);
    void passJsonParams(QString jsonPath);

public slots:
    void processCsv();
    void processExcel();
    void processJson();

signals:
    void processingFinished(QString fileType, bool errorStatus, QStringList tables );

};

#endif // DUCKTHREAD_H
