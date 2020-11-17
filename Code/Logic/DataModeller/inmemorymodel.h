#ifndef INMEMORYMODEL_H
#define INMEMORYMODEL_H

#include <QObject>
#include <QElapsedTimer>
#include <QDebug>

#include "../../duckdb.hpp"

class InMemoryModel : public QObject
{
    Q_OBJECT
public:
    explicit InMemoryModel(QObject *parent = nullptr);

    void insertOne();
    void updateOne();
    void deleteOne();
    void fetchOne();

    void insertMany();
    void updateMany();
    void deleteMany();
    void fetchMany();

    void parseCsv();

signals:

private:
    duckdb::DuckDB db;
    duckdb::Connection con;
    int counter;

};

#endif // INMEMORYMODEL_H
