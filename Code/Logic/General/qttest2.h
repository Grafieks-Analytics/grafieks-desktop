#ifndef QTTEST2_H
#define QTTEST2_H

#include <QObject>
#include <QDebug>

#include <QFileInfo>
#include "../../duckdb.hpp"
#include "../../parquet-extension.hpp"

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

};

#endif // QTTEST2_H
