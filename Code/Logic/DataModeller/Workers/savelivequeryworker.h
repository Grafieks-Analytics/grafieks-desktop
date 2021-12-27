#ifndef SAVELIVEQUERYWORKER_H
#define SAVELIVEQUERYWORKER_H

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

    int colCount;

public:
    explicit SaveLiveQueryWorker(QString tmpSql = "", QVariantMap changedColumnTypes = QVariantMap(), bool ifSavePassword = false);
    explicit SaveLiveQueryWorker(QObject *parent);
    void saveDataTypes(QMap<int, QStringList> sqlChartHeader);

protected:
    void run() override;

signals:
    void saveLiveComplete(QString errorMsg);

};

#endif // SAVELIVEQUERYWORKER_H
