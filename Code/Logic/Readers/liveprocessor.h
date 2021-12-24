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


public:
    explicit LiveProcessor(GeneralParamsModel *gpm = nullptr, DSParamsModel *dsp = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArgumentsFromMenu(QString filePath);
    Q_INVOKABLE void setArgumentsByFile(QString filePath);
    Q_INVOKABLE bool receivedArgumentStatus();

signals:
    void generateReports(duckdb::Connection *con);
    void liveReaderProcessed();

private:
    void processLive();

};

#endif // LIVEPROCESSOR_H
