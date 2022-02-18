#ifndef SAVELIVEFORWARDONLYWORKER_H
#define SAVELIVEFORWARDONLYWORKER_H

#include <QObject>
#include <QThread>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <QSqlDatabase>
#include <QDateTime>

#include "../../General/generalparamsmodel.h"
#include "../../General/querysplitter.h"

#include "../../../constants.h"
#include "../../../statics.h"
#include "../../../duckdb.hpp"

class SaveLiveForwardOnlyWorker : public QThread
{
    Q_OBJECT
    bool ifSavePassword;
    QString tmpSql;
    QStringList columnStringTypes;
    QVariantMap changedColumnTypes;

    QuerySplitter querySplitter;

public:
    explicit SaveLiveForwardOnlyWorker(QString tmpSql = "", QVariantMap changedColumnTypes = QVariantMap(), bool ifSavePassword = false);

protected:
    void run() override;

signals:
    void saveLiveComplete(QString errorMsg, QString selectParams, QString whereParams, QString joinParams, QString masterTable);

};

#endif // SAVELIVEFORWARDONLYWORKER_H
