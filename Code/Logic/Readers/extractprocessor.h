#ifndef EXTRACTPROCESSOR_H
#define EXTRACTPROCESSOR_H

#include <QObject>
#include <QDebug>

#include "../General/generalparamsmodel.h"
#include "../DataModeller/dsparamsmodel.h"

#include "../../statics.h"
#include "../../constants.h"
#include "../../duckdb.hpp"

class ExtractProcessor : public QObject
{
    Q_OBJECT
    QString filePath;
    QString testFilePath;
    bool receivedArgument;
    bool moveToDashboardScreen;

    GeneralParamsModel *generalParamsModel;
    DSParamsModel *dsParamsModel;


public:
    explicit ExtractProcessor(GeneralParamsModel *gpm = nullptr, DSParamsModel *dsp = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArgumentsFromMenu(QString filePath);
    Q_INVOKABLE void setArgumentsByFile(QString filePath);
    Q_INVOKABLE bool receivedArgumentStatus();

    Q_INVOKABLE void processExtract();

public slots:
    void setArgumentsFromWorkbook(QString filePath = "");

signals:

    void extractReaderProcessed();
    void generateReports(duckdb::Connection *con);

};

#endif // EXTRACTPROCESSOR_H
