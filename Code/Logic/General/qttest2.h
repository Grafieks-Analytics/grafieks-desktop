#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QDebug>
#include <QtWebChannel/QtWebChannel>
#include <QSettings>

#include <QFileInfo>
#include "../../duckdb.hpp"
#include "../../parquet-extension.hpp"


class QtTest2 : public QObject
{
    Q_OBJECT
public:
    explicit QtTest2(QObject *parent = nullptr);
    Q_INVOKABLE void x();

    // Test QSettings for Windows Registry and Mac property files
    // to fetch available ODBC drivers
    Q_INVOKABLE void osTest();


public slots:

signals:

private:

//    duckdb::DuckDB db;
//    duckdb::Connection con;

};

#endif // QTTEST2_H
