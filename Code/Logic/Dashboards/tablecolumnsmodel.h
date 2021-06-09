#ifndef TABLECOLUMNSMODEL_H
#define TABLECOLUMNSMODEL_H

#include <QObject>
#include <QMap>
#include <QDebug>

#include "../../constants.h"

class TableColumnsModel : public QObject
{
    Q_OBJECT
    QMap<int, QStringList *> newChartData;
    QMap<int, QString> newChartHeader;
    QMap<int, QStringList> chartHeaderDetails;

    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;
    QMap<int, QStringList> allColumnVisibleMap;
    QMap<QString, QString> columnTypes;

public:
    explicit TableColumnsModel(QObject *parent = nullptr);

    Q_INVOKABLE void setColumnVisibility(int dashboardId, QString columnName, bool show = true);
    Q_INVOKABLE QStringList fetchVisibleColumns(int dashboardId);
    Q_INVOKABLE void applyColumnVisibility(int dashboardId);
    Q_INVOKABLE void addNewDashboard(int dashboardId);
    Q_INVOKABLE void deleteDashboard(int dashboardId);

    Q_INVOKABLE QStringList fetchColumnData(QString colName);
    Q_INVOKABLE QStringList searchColumnData(QString keyword, QString columnName);
    Q_INVOKABLE void searchColumnNames(int dashboardId, QString keyword);
    Q_INVOKABLE QString findColumnType(QString columnName);



public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QStringList> chartHeader);

signals:
    void sendFilteredColumn(int currentDashboard, QStringList allCategorical, QStringList allNumerical, QStringList allDates);
    void visibleColumnListChanged(QStringList visibleColumns);
    void columnNamesChanged(QStringList columnNames);


};

#endif // TABLECOLUMNSMODEL_H
