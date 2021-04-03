#ifndef DUCKCON_H
#define DUCKCON_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"
#include "../../Connectors/allconnectors.h"


class DuckCon : public QObject
{
    Q_OBJECT
    ExcelCon excelToCsv;
    JsonCon jsonToCsv;

public:
    explicit DuckCon(QObject *parent = nullptr);
//    ~DuckCon();

    duckdb::DuckDB db;
    duckdb::Connection con;

public slots:
    void createTable();

signals:
    void importError(QString errorString);

};

#endif // DUCKCON_H

