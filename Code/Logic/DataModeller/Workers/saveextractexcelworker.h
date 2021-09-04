#ifndef SAVEEXTRACTEXCELWORKER_H
#define SAVEEXTRACTEXCELWORKER_H

#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QSqlField>
#include <QRegularExpression>
#include <QFileInfo>
#include <QDebug>

#include "../../General/datatype.h"

#include "../../../duckdb.hpp"
#include "../../../statics.h"
#include "../../../constants.h"

class SaveExtractExcelWorker : public QThread
{
    Q_OBJECT
    DataType dataType;

    QString query;

    int internalRowCount;
    int internalColCount;
    QStringList columnStringTypes;

public:
    explicit SaveExtractExcelWorker(QString query = "");

protected:
    void run() override;

signals:
    void saveExtractComplete(duckdb::Connection *con);

};

#endif // SAVEEXTRACTEXCELWORKER_H
