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

    QStringList *columnDataList = this->newChartData.value(columnKey);
    columnDataList->removeDuplicates();

    return *columnDataList;
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

void TableColumnsModel::redrawCharts(int dashboardId)
{
    emit chartValuesChanged(dashboardId);
}

void TableColumnsModel::addNewDashboard(int dashboardId)
{
    emit sendFilteredColumn(dashboardId, this->categoryList, this->numericalList, this->dateList);
}

void TableColumnsModel::deleteDashboard(int dashboardId, bool deleteAll)
{
    if(deleteAll == false){
        this->allColumnVisibleMap.remove(dashboardId);
    } else {
        this->filteredChartData.clear();
        this->newChartData.clear();
        this->newChartHeader.clear();
        this->chartHeaderDetails.clear();

        this->numericalList.clear();
        this->categoryList.clear();
        this->allColumnVisibleMap.clear();
        this->columnTypes.clear();
    }
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

void TableColumnsModel::getFilterValues(QMap<int, QStringList> showColumns, QMap<int, QVariantMap> columnFilterType, QMap<int, QVariantMap> columnIncludeExcludeMap, QMap<int, QMap<QString, QStringList> > columnValueMap, int dashboardId)
{
//    qDebug() << "FILTER SIGNAL RECEIVED" << showColumns << columnFilterType << columnIncludeExcludeMap << columnValueMap;

    QStringList equalRelationsList;
    QStringList betweenRelationList;
    int index;
    int incrementer;
    QMap<int, QStringList> tmpColData;
    QStringList tmp;

    bool firstIteration = true;
    QList<int> chartKeys = this->newChartHeader.keys();

    equalRelationsList << "dataListMulti" << "dataListSingle" << "dataDropdownSingle" << "dataDropdownMulti" << "dataEqual";
    betweenRelationList << "dataRange" << "dataBetween";

    QList<int> dashboardIdLists = showColumns.keys();

    for(int i = 0; i < dashboardIdLists.length(); i++){

        int filterCount = showColumns.value(i).length();

        for(int j = 0; j < filterCount; j++){

            QString currentColumnName = showColumns.value(i).at(j);
            int currentColumnKey = this->newChartHeader.key(currentColumnName);

            QString currentColumnRelation = columnFilterType.value(i).value(currentColumnName).toString();
            QString valueIncludeExclude = columnIncludeExcludeMap.value(i).value(currentColumnName).toString();
            QStringList filterValues = columnValueMap.value(i).value(currentColumnName);

            QVector<int> filterValueIds;
            QStringList selectedValues;

            // Equal relations
            if(equalRelationsList.indexOf(currentColumnRelation) >= 0){

                firstIteration = true;
                incrementer = 0;

                foreach(QString value, filterValues){

                    index = this->newChartData.value(currentColumnKey)->indexOf(value, incrementer);

                    if(valueIncludeExclude == "include"){

                        if(index >= 0){
                            filterValueIds.append(index);
                        }
                    } else {

                        if(firstIteration == true){
                            for(int tmpCount = 0; tmpCount < this->newChartData.value(currentColumnKey)->length(); tmpCount++){
                                filterValueIds.append(tmpCount);
                            }
                            firstIteration = false;
                        }

                        if(index >= 0){
                            filterValueIds.removeOne(index);
                        }

                    }

                    incrementer++;
                }
            }

            // Between relations
            else if(betweenRelationList.indexOf(currentColumnRelation) >= 0){

                float min = filterValues.at(0).toFloat();
                float max = filterValues.at(1).toFloat();

                for(int tmpCount = 0; tmpCount < this->newChartData.value(currentColumnKey)->length(); tmpCount++){

                    if(valueIncludeExclude == "include"){
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() > min && this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() < max){
                            filterValueIds.append(tmpCount);
                        }
                    } else {
                        if(!(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() > min && this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() < max)){
                            filterValueIds.append(tmpCount);
                        }
                    }
                }
            }

            // Not equal relations
            else if(currentColumnRelation == "dataNotEqual"){

                float value = filterValues.at(0).toFloat();

                for(int tmpCount = 0; tmpCount < this->newChartData.value(currentColumnKey)->length(); tmpCount++){

                    if(valueIncludeExclude == "include"){
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() != value){
                            filterValueIds.append(tmpCount);
                        }
                    } else {
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() == value){
                            filterValueIds.append(tmpCount);
                        }
                    }
                }
            }

            // Smaller than relations
            else if(currentColumnRelation == "dataSmaller"){

                float value = filterValues.at(0).toFloat();

                for(int tmpCount = 0; tmpCount < this->newChartData.value(currentColumnKey)->length(); tmpCount++){

                    if(valueIncludeExclude == "include"){
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() < value){
                            filterValueIds.append(tmpCount);
                        }
                    } else {
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() >= value){
                            filterValueIds.append(tmpCount);
                        }
                    }
                }

            } else if(currentColumnRelation == "dataGreater"){

                float value = filterValues.at(0).toFloat();

                for(int tmpCount = 0; tmpCount < this->newChartData.value(currentColumnKey)->length(); tmpCount++){

                    if(valueIncludeExclude == "include"){
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() > value){
                            filterValueIds.append(tmpCount);
                        }
                    } else {
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() <= value){
                            filterValueIds.append(tmpCount);
                        }
                    }
                }

            } else if(currentColumnRelation == "dataEqualOrSmaller"){

                float value = filterValues.at(0).toFloat();

                for(int tmpCount = 0; tmpCount < this->newChartData.value(currentColumnKey)->length(); tmpCount++){

                    if(valueIncludeExclude == "include"){
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() <= value){
                            filterValueIds.append(tmpCount);
                        }
                    } else {
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() > value){
                            filterValueIds.append(tmpCount);
                        }
                    }
                }

            } else if(currentColumnRelation == "dataEqualOrGreater"){

                float value = filterValues.at(0).toFloat();

                for(int tmpCount = 0; tmpCount < this->newChartData.value(currentColumnKey)->length(); tmpCount++){

                    if(valueIncludeExclude == "include"){
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() >= value){
                            filterValueIds.append(tmpCount);
                        }
                    } else {
                        if(this->newChartData.value(currentColumnKey)->value(tmpCount).toFloat() < value){
                            filterValueIds.append(tmpCount);
                        }
                    }
                }

            } else{
                qDebug() << "ELSE CONDITION" << currentColumnRelation;
            }

            foreach(int internalKey, chartKeys){
                // for each selected key values
                foreach(int internalIndex, filterValueIds){
                    tmp.append(this->newChartData.value(internalKey)->at(internalIndex));
                    tmpColData.insert(internalKey, tmp);
                }
                tmp.clear();
            }
        }
        this->filteredChartData.insert(i, tmpColData);
        tmpColData.clear();
    }

    emit dashboardDataChanged(this->filteredChartData, dashboardId);
}

void TableColumnsModel::receiveReportData(QMap<int, QMap<int, QStringList> > newChartData, int currentReportId)
{
    QList<int> keys = newChartData.keys();
    this->reportChartData = newChartData;

}
