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
    QJsonObject joinAndWhereParams;
    bool receivedArgument;

public:
    explicit WorkbookProcessor(GeneralParamsModel *gpm = nullptr, QObject *parent = nullptr);

    Q_INVOKABLE void setArgumentsFromMenu(QString filePath);
    Q_INVOKABLE void setArgumentsByFile(QString filePath);
    Q_INVOKABLE bool receivedArgumentStatus();

    Q_INVOKABLE void processDS();
    Q_INVOKABLE void processAfterSelectingDS(QString dsPath);

    Q_INVOKABLE void saveWorkbooks(QString filePath);

    Q_INVOKABLE void processJsonAfterLoginCredentials();

public slots:
    void getReportParams(QJsonObject reportParams);
    void getDashboardParams(QJsonObject dashboardParams);
    void getTableColumns(QJsonObject tableColumns);
    void getJoinAndWhereParams(QJsonObject joinAndWhereParams);

private:
    void processRemaining(QJsonDocument doc);

signals:
    void dsMissing(QString dsType, QString dsName);
    void processExtractFromWorkbook(QString filePath);
    void processLiveFromWorkbook(QString filePath);

    void sendDSReportParams(QJsonObject reportParams);
    void sendDSDashboardParams(QJsonObject dashboardParams);
    void sendDSTableColumns(QJsonObject tableColumns);
    void sendDSJoinAndWhereParams(QJsonObject joinAndWhereParams);

    void workbookSaved();

};

#endif // WORKBOOKPROCESSOR_H
