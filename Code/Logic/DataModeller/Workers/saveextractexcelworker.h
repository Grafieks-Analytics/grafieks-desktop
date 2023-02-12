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
#include "../../General/generalparamsmodel.h"

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
    QVariantMap changedColumnTypes;

public:
    explicit SaveExtractExcelWorker(QString query = "", QVariantMap changedColumnTypes = QVariantMap());

protected:
    void run() override;

private:
    void appendExtractData(duckdb::Appender *appender, QSqlQuery *query);


signals:
    void saveExtractComplete(QString errorMsg);

};

#endif // SAVEEXTRACTEXCELWORKER_H
