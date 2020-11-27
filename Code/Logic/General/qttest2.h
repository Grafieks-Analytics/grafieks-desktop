#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QDebug>
#include <QSqlDatabase>

#include "../../duckdb.hpp"



class QtTest2 : public QObject
{
    Q_OBJECT
public:
    explicit QtTest2(QObject *parent = nullptr);
    Q_INVOKABLE void x();


public slots:

signals:

private:
    duckdb::DuckDB db;
    duckdb::Connection con;
};

#endif // QTTEST2_H
