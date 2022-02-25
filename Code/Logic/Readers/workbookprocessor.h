#ifndef WORKBOOKPROCESSOR_H
#define WORKBOOKPROCESSOR_H

#include <QObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QDataStream>
#include <QFile>
#include <QByteArray>
#include <QDir>
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
    QJsonObject whereParams;
    bool receivedArgument;

public:
    explicit WorkbookProcessor(GeneralParamsModel *gpm = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArgumentsFromMenu(QString filePath);
    Q_INVOKABLE void setArgumentsByFile(QString filePath);
    Q_INVOKABLE bool receivedArgumentStatus();

    Q_INVOKABLE void processDS();
    Q_INVOKABLE void processAfterSelectingDS(QString dsPath);

    Q_INVOKABLE void saveWorkbooks(QString filePath);

public slots:
    void getReportParams(QJsonObject reportParams);
    void getDashboardParams(QJsonObject dashboardParams);
    void getTableColumns(QJsonObject tableColumns);
    void getWhereParams(QJsonObject whereParams);

private:
    void processRemaining(QJsonDocument doc);

signals:
    void extractMissing();
    void processExtractFromWorkbook(QString filePath);
    void processLiveFromWorkbook(QString filePath);

    void sendDSReportParams(QJsonObject reportParams);
    void sendDSDashboardParams(QJsonObject dashboardParams);
    void sendDSTableColumns(QJsonObject tableColumns);
    void sendDSWhereParams(QJsonObject whereParams);

    void workbookSaved();

};

#endif // WORKBOOKPROCESSOR_H
