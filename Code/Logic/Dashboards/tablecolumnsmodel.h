#ifndef TABLECOLUMNSMODEL_H
#define TABLECOLUMNSMODEL_H

#include <QObject>
#include <QMap>
#include <QDebug>

#include "../../constants.h"

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
    QMap<QString, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<QString, QString> columnTypes;

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
    void receiveReportData(QMap<QString, QMap<int, QStringList>> newChartData, QString currentReportId);

signals:
    void sendFilteredColumn(int currentDashboard, QStringList allCategorical, QStringList allNumerical, QStringList allDates);
    void visibleColumnListChanged(QVariantMap visibleColumnsTypeMap);
    void columnNamesChanged(QStringList columnNames);
    void dashboardDataChanged(QMap<int, QMap<int, QStringList>> chartData, int currentDashboardId);
    void chartValuesChanged(int currentDashboardId);


};

#endif // TABLECOLUMNSMODEL_H
