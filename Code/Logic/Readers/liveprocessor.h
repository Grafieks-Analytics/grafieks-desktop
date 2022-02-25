#ifndef LIVEPROCESSOR_H
#define LIVEPROCESSOR_H

#include <QObject>
#include <QDebug>

#include "../General/generalparamsmodel.h"
#include "../DataModeller/dsparamsmodel.h"

#include "../../statics.h"
#include "../../constants.h"
#include "../../duckdb.hpp"

class LiveProcessor : public QObject
{
    Q_OBJECT
    QString filePath;
    GeneralParamsModel *generalParamsModel;
    DSParamsModel *dsParamsModel;

    bool receivedArgument;
    bool moveToDashboardScreen;
    QMap<int, QStringList> sqlChartHeader;

    QString masterTable;
    QString whereParams;
    QString joinParams;
    QString selectParams;

    QString masterQuery;


public:
    explicit LiveProcessor(GeneralParamsModel *gpm = nullptr, DSParamsModel *dsp = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArgumentsFromMenu(QString filePath);
    Q_INVOKABLE void setArgumentsByFile(QString filePath);
    Q_INVOKABLE bool receivedArgumentStatus();
    Q_INVOKABLE void processLiveQueries();

public slots:
    void setArgumentsFromWorkbook(QString filePath = "");

signals:
    void generateLiveReports(QMap<int, QStringList> sqlHeaders);
    void liveReaderProcessed();
    void liveQueryParams(QString selectParams, QString whereParams, QString joinParams, QString masterTable);
    void generateLiveSchema(QString query);
    void openConnection(QString dbType);

private:
    void processLive();

};

#endif // LIVEPROCESSOR_H
