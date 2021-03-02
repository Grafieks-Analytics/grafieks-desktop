#ifndef DUCKDATAMODEL_H
#define DUCKDATAMODEL_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"

class DuckDataModel : public QObject
{
    Q_OBJECT
    QStringList colData;
public:
    explicit DuckDataModel(QObject *parent = nullptr);

    Q_INVOKABLE void columnData(QString col, QString index);

    duckdb::DuckDB db;
    duckdb::Connection con;

public slots:
    void receiveCsvFilterQuery(QString query);

signals:
    void csvColData(QStringList colData);

};

#endif // DUCKDATAMODEL_H
