#ifndef TABLECOLUMNSMODEL_H
#define TABLECOLUMNSMODEL_H

#include <QObject>
#include <QMap>
#include <QFileInfo>
#include <QRegularExpression>
#include <QDebug>

#include "../General/datatype.h"

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

    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;
    QMap<int, QVariantMap> allColumnVisibleMap;         // dashboardId - <columnName - columnType>
    QMap<int, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<QString, QString> columnTypes;
    QStringList columnDataList;

    DataType dataType;
    int dashboardId;

public:
    explicit TableColumnsModel(QObject *parent = nullptr);

    Q_INVOKABLE void setColumnVisibility(int dashboardId, QString columnName, QString columnType, bool show = true);
    Q_INVOKABLE QVariantMap fetchVisibleColumns(int dashboardId);
    Q_INVOKABLE void applyColumnVisibility(int dashboardId);
    Q_INVOKABLE void addNewDashboard(int dashboardId);
    Q_INVOKABLE void deleteDashboard(int dashboardId, bool deleteAll = false);

    Q_INVOKABLE QStringList fetchColumnData(QString colName);
    Q_INVOKABLE QStringList searchColumnData(QString keyword, QString columnName);
    Q_INVOKABLE void searchColumnNames(int dashboardId, QString keyword);
    Q_INVOKABLE QString findColumnType(QString columnName);

    Q_INVOKABLE void redrawCharts(int dashboardId);



public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QStringList> chartHeader);
    void getFilterValues(QMap<int, QStringList> showColumns, QMap<int, QVariantMap> columnFilterType, QMap<int, QVariantMap> columnIncludeExcludeMap, QMap<int, QMap<QString, QStringList>> columnValueMap, int dashboardId);
    void receiveReportData(QMap<int, QMap<int, QStringList>> newChartData, int currentReportId);
    void generateColumnsForExtract();
    void generateColumnsForReader(duckdb::Connection *con);

signals:
    void sendFilteredColumn(int currentDashboard, QStringList allCategorical, QStringList allNumerical, QStringList allDates);
    void visibleColumnListChanged(QVariantMap visibleColumnsTypeMap);
    void columnNamesChanged(QStringList columnNames);
    void dashboardWhereConditions(QString whereConditions, int currentDashboardId);
    void chartValuesChanged(int currentDashboardId);


private:
    void generateColumns(duckdb::Connection *con);

};

#endif // TABLECOLUMNSMODEL_H
