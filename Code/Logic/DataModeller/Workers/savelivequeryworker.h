#ifndef SAVELIVEQUERYWORKER_H
#define SAVELIVEQUERYWORKER_H

#include <QObject>
#include <QThread>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <QSqlDatabase>
#include <QDateTime>
#include "../../../simplecrypt.h"


#include "../../General/generalparamsmodel.h"
#include "../../General/querysplitter.h"

#include "../../../constants.h"
#include "../../../statics.h"
#include "../../../duckdb.hpp"
#include "../../../secrets.h"
#include "../../../simplecrypt.h"

class SaveLiveQueryWorker : public QThread
{
    Q_OBJECT
    QString tmpSql;
    QStringList columnStringTypes;
    QVariantMap changedColumnTypes;
    bool ifSavePassword;
    QMap<int, QStringList> sqlChartHeader;

    QuerySplitter querySplitter;
    GeneralParamsModel generalParamsModel;

    SimpleCrypt simpleCrypt;

    int colCount;

public:
    explicit SaveLiveQueryWorker(QString tmpSql = "", QVariantMap changedColumnTypes = QVariantMap(), bool ifSavePassword = false);

protected:
    void run() override;

signals:
    void saveLiveComplete(QString errorMsg, QString selectParams, QString whereParams, QString joinParams, QString masterTable);

};

#endif // SAVELIVEQUERYWORKER_H
