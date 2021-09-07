#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(QObject *parent) : QObject(parent),
    dashboardId(0)
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

    qDebug() << visibleColumns << this->allColumnVisibleMap.value(dashboardId);
    emit columnNamesChanged(visibleColumns);
    emit visibleColumnListChanged(this->allColumnVisibleMap.value(dashboardId));
}

QStringList TableColumnsModel::fetchColumnData(QString colName)
{


    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    QString fileName = QFileInfo(tableName).baseName().toLower();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));

    QString query = "SELECT DISTINCT " + colName + " FROM " + fileName;
    auto dataList = con.Query(query.toStdString());

    int totalRows = dataList->collection.Count();
    for(int i = 0; i < totalRows; i++){
        this->columnDataList.append(dataList->GetValue(0, i).ToString().c_str());
    }
    return this->columnDataList;
}

QStringList TableColumnsModel::searchColumnData(QString keyword, QString columnName)
{
    return this->columnDataList.filter(keyword, Qt::CaseInsensitive);
}

void TableColumnsModel::searchColumnNames(int dashboardId, QString keyword)
{
    this->dashboardId = dashboardId;
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
    this->dashboardId = dashboardId;
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

    QMap<int, QStringList> tmpColData;
    QStringList tmp;
    QString joiner = "\"";

    QList<int> chartKeys = this->newChartHeader.keys();

    equalRelationsList << "dataListMulti" << "dataListSingle" << "dataDropdownSingle" << "dataDropdownMulti" << "dataEqual";
    betweenRelationList << "dataRange" << "dataBetween";

    QString whereConditions;

    QList<int> dashboardIdLists = showColumns.keys();

    for(int i = 0; i < dashboardIdLists.length(); i++){

        int filterCount = showColumns.value(i).length();

        for(int j = 0; j < filterCount; j++){

            QString currentColumnName = showColumns.value(i).at(j);

            QString currentColumnRelation = columnFilterType.value(i).value(currentColumnName).toString();
            QString valueIncludeExclude = columnIncludeExcludeMap.value(i).value(currentColumnName).toString();
            QStringList filterValues = columnValueMap.value(i).value(currentColumnName);

            QVector<int> filterValueIds;
            QStringList selectedValues;

            // Equal relations
            if(equalRelationsList.indexOf(currentColumnRelation) >= 0){

                QStringList tmpValList;
                QString inArrayValues;
                QString notRelationString = valueIncludeExclude == "include" ? "" : " NOT ";


                foreach(QString value, filterValues){
                    if(tmpValList.indexOf(value) < 0){
                        tmpValList.append(value);

                        inArrayValues += "'" + value + "',";
                    }
                }
                inArrayValues.chop(1);
                whereConditions += joiner + currentColumnName + joiner + notRelationString + " IN (" + inArrayValues + ") AND ";
            }

            // Between relations
            else if(betweenRelationList.indexOf(currentColumnRelation) >= 0){

                float min = filterValues.at(0).toFloat();
                float max = filterValues.at(1).toFloat();
                whereConditions += joiner + currentColumnName + joiner  + " BETWEEN " + min + " AND " + max + " AND ";
            }

            // Not equal relations
            else if(currentColumnRelation == "dataNotEqual"){

                float value = filterValues.at(0).toFloat();
                whereConditions += joiner + currentColumnName + joiner + " != " + value + " AND ";
            }

            // Smaller than relations
            else if(currentColumnRelation == "dataSmaller"){

                float value = filterValues.at(0).toFloat();
                whereConditions += joiner + currentColumnName + joiner + " < " + value + " AND ";

            } else if(currentColumnRelation == "dataGreater"){

                float value = filterValues.at(0).toFloat();
                whereConditions += joiner + currentColumnName + joiner + " > " + value + " AND ";

            } else if(currentColumnRelation == "dataEqualOrSmaller"){

                float value = filterValues.at(0).toFloat();
                whereConditions += joiner + currentColumnName + joiner + " <= " + value + " AND ";

            } else if(currentColumnRelation == "dataEqualOrGreater"){

                float value = filterValues.at(0).toFloat();
                whereConditions += joiner + currentColumnName + joiner + " >= " + value + " AND ";

            } else{
                qDebug() << "ELSE CONDITION" << currentColumnRelation;
            }
        }

        this->filteredChartData.insert(i, tmpColData);
        tmpColData.clear();
    }

    // Chop trailing ' AND '
    whereConditions.chop(5);
    qDebug() << "Dashboard where conditions "<< whereConditions;
    emit dashboardDataChanged(whereConditions, dashboardId);
}

void TableColumnsModel::receiveReportData(QMap<int, QMap<int, QStringList> > newChartData, int currentReportId)
{
    QList<int> keys = newChartData.keys();
    this->reportChartData = newChartData;

}

void TableColumnsModel::generateColumnsForExtract()
{
    QString extractPath = Statics::extractPath;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    this->generateColumns(&con);
}

void TableColumnsModel::generateColumnsForReader(duckdb::Connection *con)
{
    this->generateColumns(con);
}

void TableColumnsModel::generateColumns(duckdb::Connection *con)
{
    // Fetch data from duckdb
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;

    if(Statics::currentDbIntType == Constants::excelIntType || Statics::currentDbIntType == Constants::csvIntType || Statics::currentDbIntType == Constants::jsonIntType) {
        tableName = QFileInfo(tableName).baseName().toLower();
        tableName = tableName.remove(QRegularExpression("[^A-Za-z0-9]"));
    }

    // Clear existing chart headers data
    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->newChartHeader.clear();


    auto data = con->Query("PRAGMA table_info('"+ tableName.toStdString() +"')");

    if(data->error.empty()){
        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            QString fieldName =  data->GetValue(1, i).ToString().c_str();
            fieldName = fieldName.trimmed();
            QString fieldType = data->GetValue(2, i).ToString().c_str();
            QString fieldTypeClassification = dataType.dataType(fieldType);

            if(fieldTypeClassification.contains(Constants::categoricalType)){
                this->categoryList.append(fieldName);
                this->columnTypes.insert(fieldName, Constants::categoricalType);
            } else if(fieldTypeClassification.contains(Constants::numericalType)){
                this->numericalList.append(fieldName);
                this->columnTypes.insert(fieldName, Constants::numericalType);
            } else if(fieldTypeClassification.contains(Constants::dateType)){
                this->dateList.append(fieldName);
                this->columnTypes.insert(fieldName, Constants::dateType);
            } else{
                qDebug() << "OTHER UNDETECTED FIELD TYPE" << fieldName;
            }

            this->newChartHeader.insert(i, fieldName);
        }

        this->categoryList.sort(Qt::CaseInsensitive);
        this->numericalList.sort(Qt::CaseInsensitive);
        this->dateList.sort(Qt::CaseInsensitive);
    } else{
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    }

    // Update new data

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);
    emit sendFilteredColumn(this->dashboardId, this->categoryList, this->numericalList, this->dateList);
}
