#ifndef SAVEEXTRACTFORWARDONLYWORKER_H
#define SAVEEXTRACTFORWARDONLYWORKER_H

#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QSqlField>
#include <QSqlError>
#include <QDebug>

#include "../../General/datatype.h"

#include "../../../statics.h"
#include "../../../constants.h"
#include "../../../duckdb.hpp"

class SaveExtractForwardOnlyWorker : public QThread
{
    Q_OBJECT
    DataType dataType;

    QString query;
    int internalColCount;
    QStringList columnStringTypes;

public:
    explicit SaveExtractForwardOnlyWorker(QString query = "");

protected:
    void run() override;

signals:
    void saveExtractComplete();

};

#endif // SAVEEXTRACTFORWARDONLYWORKER_H
