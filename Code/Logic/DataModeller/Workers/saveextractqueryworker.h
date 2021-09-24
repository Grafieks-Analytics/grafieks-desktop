#ifndef SAVEEXTRACTQUERYWORKER_H
#define SAVEEXTRACTQUERYWORKER_H

#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlQuery>
#include <QDate>
#include <QDateTime>
#include <QDebug>

#include "../../General/datatype.h"
#include "../../General/generalparamsmodel.h"

#include "../../../constants.h"
#include "../../../statics.h"
#include "../../../duckdb.hpp"

class SaveExtractQueryWorker : public QThread
{
    Q_OBJECT
    QString tmpSql;
    QStringList columnStringTypes;
    QVariantMap changedColumnTypes;

    GeneralParamsModel generalParamsModel;


public:
    explicit SaveExtractQueryWorker(QString tmpSql = "", QVariantMap changedColumnTypes = QVariantMap());

protected:
    void run() override;

signals:
    void saveExtractComplete(QString errorMsg);

};

#endif // SAVEEXTRACTQUERYWORKER_H
