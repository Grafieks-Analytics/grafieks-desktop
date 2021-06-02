#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(QObject *parent) : QObject(parent)
{

}

void TableColumnsModel::setColumnVisibility(int dashboardId, QString columnName, bool show)
{
    QStringList allVisibleColumnList = this->allColumnVisibleMap.value(dashboardId);
    if(show == false){
        allVisibleColumnList.removeAll(columnName);
        this->allColumnVisibleMap.insert(dashboardId, allVisibleColumnList);
    } else{

        // Check if already exists
        // If no, then append

        if(allVisibleColumnList.indexOf(columnName) < 0){
            allVisibleColumnList.append(columnName);
            this->allColumnVisibleMap.insert(dashboardId, allVisibleColumnList);
            qDebug() << "VISIBLE LIST" << allVisibleColumnList;
        }
    }

}

QStringList TableColumnsModel::fetchVisibleColumns(int dashboardId)
{
    return this->allColumnVisibleMap.value(dashboardId);
}

void TableColumnsModel::applyColumnVisibility(int dashboardId)
{
    emit columnNamesChanged(this->allColumnVisibleMap.value(dashboardId));
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

void TableColumnsModel::searchColumnNames(QString keyword)
{
    emit sendFilteredColumn(this->categoryList.filter(keyword, Qt::CaseInsensitive), this->numericalList.filter(keyword, Qt::CaseInsensitive), this->dateList.filter(keyword, Qt::CaseInsensitive));
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

    QStringList tmpVisibleColumnList;

    // Update new data
    foreach(auto key, chartHeader.keys()){

        QString fullColumnName = chartHeader.value(key).at(0);

        if(chartHeader.value(key).at(1).contains(Constants::categoricalType)){
            this->categoryList.append(fullColumnName);
        } else if(chartHeader.value(key).at(1).contains(Constants::numericalType)){
            this->numericalList.append(fullColumnName);
        } else if(chartHeader.value(key).at(1).contains(Constants::dateType)){
            this->dateList.append(fullColumnName);
        } else{
            qDebug() << "OTHER UNDETECTED FIELD TYPE" << chartHeader.value(key).at(0);
        }

        this->newChartHeader.insert(key, fullColumnName);
    }

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);

    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);

}
