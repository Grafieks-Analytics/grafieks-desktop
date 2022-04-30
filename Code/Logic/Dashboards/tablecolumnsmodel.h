#ifndef TABLECOLUMNSMODEL_H
#define TABLECOLUMNSMODEL_H

#include <QObject>
#include <QMap>
#include <QFileInfo>
#include <QRegularExpression>
#include <QDebug>
#include <QSettings>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QNetworkAccessManager>

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

#include "../General/datatype.h"
#include "../General/queryjoiner.h"
#include "dashboardparamsmodel.h"

#include "../../constants.h"
#include "../../statics.h"
#include "../../duckdb.hpp"

class TableColumnsModel : public QObject
{
    Q_OBJECT
    QMap<int, QMap<int, QStringList>> filteredChartData;
    QMap<int, QStringList *> newChartData;
    QMap<int, QString> newChartHeader;
    QMap<int, QStringList> chartHeaderDetails;

    QVariantMap numericalMap;
    QVariantMap categoricalMap;
    QVariantMap dateMap;

    QMap<int, QVariantMap> allColumnVisibleMap;         // dashboardId - <columnName - columnType>
    QMap<int, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<QString, QString> columnTypes;
    QStringList columnDataList;

    DataType dataType;
    QueryJoiner qj;
    int forwardDashboardId;
    int dashboardId;
    QString colName;

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;

    QString liveMasterTable;
    QString liveWhereParams;
    QString liveJoinParams;
    QString liveSelectParams;

    DashboardParamsModel *dashboardParamsModel;

public:
    explicit TableColumnsModel(DashboardParamsModel *dashboardParamsModel, QObject *parent = nullptr);

    Q_INVOKABLE void setColumnVisibility(int dashboardId, QString columnName, QString columnType, bool show = true);
    Q_INVOKABLE void applyColumnVisibility(int dashboardId);
    Q_INVOKABLE void addNewDashboard(int dashboardId);
    Q_INVOKABLE void deleteDashboard(int dashboardId, bool deleteAll = false);

    Q_INVOKABLE QStringList fetchColumnData(QString colName);
    Q_INVOKABLE QStringList fetchColumnDataLive(QString colName);

    // This function has to be multithreaded
    // Else on selecting multiple filters, only the last filter value is updated
    // Rest are removed
    Q_INVOKABLE void fetchColumnDataAPI(QString colName, int forwardDashboardId);

    Q_INVOKABLE QStringList searchColumnData(QString keyword, QString columnName);
    Q_INVOKABLE void searchColumnNames(int dashboardId, QString keyword);
    Q_INVOKABLE QString findColumnType(QString columnName);

    Q_INVOKABLE void redrawCharts(int dashboardId);
    Q_INVOKABLE void saveTableColumns();

    Q_INVOKABLE void clearFilters();


public slots:

    void getFilterValues(QMap<int, QStringList> showColumns, QMap<int, QVariantMap> columnFilterType, QMap<int, QVariantMap> columnIncludeExcludeMap, QMap<int, QMap<QString, QStringList>> columnValueMap, int dashboardId);
    void receiveReportData(QMap<int, QMap<int, QStringList>> newChartData, int currentReportId);
    void generateColumnsForExtract();
    void generateColumnsFromAPI();
    void generateColumnsForLive(QMap<int, QStringList> sqlHeaders);
    void generateColumnsForReader(duckdb::Connection *con);

    void getExtractTableColumns(QJsonObject tableColumnParams);
    void receiveOriginalConditions(QString selectParams, QString whereParams, QString joinParams, QString masterTable);

    void dataReadyRead();
    void columnReadFinished();
    void columnDataReadFinished();

signals:
    void sendFilteredColumn(int currentDashboard, QVariantMap allCategoricalMap, QVariantMap allNumericalMap, QVariantMap allDatesMap);
    void visibleColumnListChanged(QVariantMap visibleColumnsTypeMap);
    void columnNamesChanged(int dashboardId, QStringList columnNames, QStringList columnTypes);
    void dashboardWhereConditions(QString whereConditions, int currentDashboardId);
    void chartValuesChanged(int currentDashboardId);
    void columnDataChanged(QStringList columnData, QString columnName, int dashboardId);

    // save table columns
    void signalSaveTableColumns(QJsonObject tableColumnParams);


private:
    void generateColumns(duckdb::Connection *con);

};

#endif // TABLECOLUMNSMODEL_H
