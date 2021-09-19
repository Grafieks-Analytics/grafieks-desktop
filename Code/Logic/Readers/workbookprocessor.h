#ifndef WORKBOOKPROCESSOR_H
#define WORKBOOKPROCESSOR_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QDataStream>
#include <QFile>
#include <QFileInfo>

#include "../General/generalparamsmodel.h"

#include "../../statics.h"
#include "../../constants.h"
#include "../../duckdb.hpp"

class WorkbookProcessor : public QObject
{
    Q_OBJECT
    QString filePath;
    GeneralParamsModel *generalParamsModel;

    QJsonObject dashboardParams;
    QJsonObject reportParams;
    QJsonObject tableColumnParams;
    bool receivedArgument;

public:
    explicit WorkbookProcessor(GeneralParamsModel *gpm = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArgumentsFromMenu(QString filePath);
    Q_INVOKABLE void setArgumentsByFile(QString filePath);
    Q_INVOKABLE bool receivedArgumentStatus();

    Q_INVOKABLE void processExtract();

    Q_INVOKABLE void saveWorkbooks(QString filePath);

public slots:
    void getReportParams(QJsonObject reportParams);
    void getDashboardParams(QJsonObject dashboardParams);
    void getTableColumns(QJsonObject tableColumns);


signals:
    void extractMissing();
    void processExtractFromWorkbook(QString filePath);

    void sendExtractReportParams(QJsonObject reportParams);
    void sendExtractDashboardParams(QJsonObject dashboardParams);
    void sendExtractTableColumns(QJsonObject tableColumns);

};

#endif // WORKBOOKPROCESSOR_H
