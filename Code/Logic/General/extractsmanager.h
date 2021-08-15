#ifndef EXTRACTSMANAGER_H
#define EXTRACTSMANAGER_H

#include <QObject>
#include <QDebug>
#include <QFile>

#include "../../duckdb.hpp"
#include "../Connectors/duckcon.h"

#include "../../statics.h"
#include "../../constants.h"

class ExtractsManager : public QObject
{
    Q_OBJECT
    QList<QByteArray> columnNames;
    QVector<int> columnIntTypes;
    QStringList columnStringTypes;
    QString tableName;


public:
    explicit ExtractsManager(QObject *parent = nullptr);

public slots:
    void createTable(QList<QByteArray> columnNames, QVector<int> columnIntTypes, QStringList columnStringTypes, QString tableName);
    void uploadCSVData(QFile *csvFile = nullptr, char delimiter = ',');
    void uploadQueryData(QSqlQuery *query = nullptr);

signals:

};

#endif // EXTRACTSMANAGER_H
