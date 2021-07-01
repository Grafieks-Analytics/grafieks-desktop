#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(QObject *parent) : QObject(parent)
{

}

void TableColumnsModel::setColumnVisibility(int dashboardId, QString columnName, QString columnType, bool show)
{
    QVariantMap allVisibleColumnMap = this->allColumnVisibleMap.value(dashboardId);
    if(show == false){
        allVisibleColumnMap.remove(columnName);
        this->allColumnVisibleMap.insert(dashboardId, allVisibleColumnMap);
    } else{

        // Check if already exists
        // If no, then append

        QStringList visibleKeys = allVisibleColumnMap.keys();

        if(visibleKeys.indexOf(columnName) < 0){
            allVisibleColumnMap.insert(columnName, columnType);
            this->allColumnVisibleMap.insert(dashboardId, allVisibleColumnMap);
        }
    }

}

QVariantMap TableColumnsModel::fetchVisibleColumns(int dashboardId)
{
    return this->allColumnVisibleMap.value(dashboardId);
}

void TableColumnsModel::applyColumnVisibility(int dashboardId)
{
    QStringList visibleColumns = this->allColumnVisibleMap.value(dashboardId).keys();

    emit columnNamesChanged(visibleColumns);
    emit visibleColumnListChanged(this->allColumnVisibleMap.value(dashboardId));
}

QStringList TableColumnsModel::fetchColumnData(QString colName)
{
    int columnKey = newChartHeader.key( colName );

    QStringList columnDataList = *newChartData.value(columnKey);
    columnDataList.removeDuplicates();

    return columnDataList;
}

QStringList TableColumnsModel::searchColumnData(QString keyword, QString columnName)
{
    int columnKey = newChartHeader.key( columnName );

    QStringList columnDataList = *newChartData.value(columnKey);
    columnDataList.removeDuplicates();
    return columnDataList.filter(keyword, Qt::CaseInsensitive);
}

void TableColumnsModel::searchColumnNames(int dashboardId, QString keyword)
{
    emit sendFilteredColumn(dashboardId, this->categoryList.filter(keyword, Qt::CaseInsensitive), this->numericalList.filter(keyword, Qt::CaseInsensitive), this->dateList.filter(keyword, Qt::CaseInsensitive));
}

QString TableColumnsModel::findColumnType(QString columnName)
{
    return this->columnTypes.value(columnName);
}

void TableColumnsModel::addNewDashboard(int dashboardId)
{
    emit sendFilteredColumn(dashboardId, this->categoryList, this->numericalList, this->dateList);
}

void TableColumnsModel::deleteDashboard(int dashboardId)
{
    this->allColumnVisibleMap.remove(dashboardId);
}

void TableColumnsModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void TableColumnsModel::getChartHeader(QMap<int, QStringList> chartHeader)
{

    this->chartHeaderDetails = chartHeader;

    // Clear existing chart headers data
    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->newChartHeader.clear();
    this->columnTypes.clear();

    QStringList tmpVisibleColumnList;

    // Update new data
    foreach(auto key, chartHeader.keys()){

        QString fullColumnName = chartHeader.value(key).at(0);

        if(chartHeader.value(key).at(1).contains(Constants::categoricalType)){
            this->categoryList.append(fullColumnName);
            this->columnTypes.insert(fullColumnName, Constants::categoricalType);
        } else if(chartHeader.value(key).at(1).contains(Constants::numericalType)){
            this->numericalList.append(fullColumnName);
            this->columnTypes.insert(fullColumnName, Constants::numericalType);
        } else if(chartHeader.value(key).at(1).contains(Constants::dateType)){
            this->dateList.append(fullColumnName);
            this->columnTypes.insert(fullColumnName, Constants::dateType);
        } else{
            qDebug() << "OTHER UNDETECTED FIELD TYPE" << chartHeader.value(key).at(0);
        }

        this->newChartHeader.insert(key, fullColumnName);
    }

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);

    int currentDashboard = 0;
    emit sendFilteredColumn(currentDashboard, this->categoryList, this->numericalList, this->dateList);

}

void TableColumnsModel::getFilterValues(QMap<int, QStringList> showColumns, QMap<int, QVariantMap> columnFilterType, QMap<int, QVariantMap> columnIncludeExcludeMap, QMap<int, QMap<QString, QStringList> > columnValueMap)
{
    qDebug() << "FILTER SIGNAL RECEIVED" << showColumns << columnFilterType << columnIncludeExcludeMap << columnValueMap;
}
