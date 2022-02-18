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

    emit columnNamesChanged(dashboardId, visibleColumns);
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

    QString joiner = "\"";
    QString query = "SELECT DISTINCT " + joiner + colName + joiner + " FROM " + fileName;
    auto dataList = con.Query(query.toStdString());

    int totalRows = dataList->collection.Count();
    this->columnDataList.clear();
    for(int i = 0; i < totalRows; i++){
        this->columnDataList.append(dataList->GetValue(0, i).ToString().c_str());
    }
    return this->columnDataList;
}

QStringList TableColumnsModel::fetchColumnDataLive(QString colName)
{
    QString dbString;

    this->columnDataList.clear();

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::sqliteIntType:
    case Constants::postgresIntType:
    case Constants::oracleIntType:
    case Constants::mssqlIntType:
    case Constants::accessIntType:
    case Constants::mongoIntType:{
        QString dbString;

        switch (Statics::currentDbIntType) {

        case Constants::mysqlIntType:
            dbString = Constants::mysqlStrQueryType;
            break;
        case Constants::mysqlOdbcIntType:
            dbString = Constants::mysqlOdbcStrQueryType;
            break;
        case Constants::sqliteIntType:
            dbString = Constants::sqliteStrQueryType;
            break;
        case Constants::postgresIntType:
            dbString = Constants::postgresOdbcStrQueryType;
            break;
        case Constants::oracleIntType:
            dbString = Constants::oracleOdbcStrQueryType;
            break;
        case Constants::mssqlIntType:
            dbString = Constants::mssqlOdbcStrQueryType;
            break;
        case Constants::accessIntType:
            dbString = Constants::accessOdbcStrQueryType;
            break;
        case Constants::mongoIntType:
            dbString = Constants::mongoOdbcStrQueryType;
            break;

        }

        QSqlDatabase dbCon = QSqlDatabase::database(dbString);
        QString queryString = "SELECT DISTINCT " + colName + " FROM " + this->liveMasterTable + " " + this->liveJoinParams + " " + this->liveWhereParams;
        QSqlQuery query(queryString, dbCon);

        while(query.next()){
            this->columnDataList.append(query.value(0).toString());
        }

        break;
    }


    }

    return this->columnDataList;
}

QStringList TableColumnsModel::searchColumnData(QString keyword, QString columnName)
{
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    QString fileName = QFileInfo(tableName).baseName().toLower();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));


    QString joiner = "\"";
    QString query = "SELECT DISTINCT " + joiner + columnName + joiner + " FROM " + fileName + " WHERE " + columnName + " LIKE '%" + keyword + "%'";
    auto dataList = con.Query(query.toStdString());
    if(!dataList->success)
        qDebug() << Q_FUNC_INFO << dataList->error.c_str();

    int totalRows = dataList->collection.Count();
    this->columnDataList.clear();
    for(int i = 0; i < totalRows; i++){
        this->columnDataList.append(dataList->GetValue(0, i).ToString().c_str());
    }
    return this->columnDataList;
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

void TableColumnsModel::saveTableColumns()
{

    QJsonObject masterObj;

    // filteredChartData
    QJsonObject filteredChartDataTmp;
    QList<int> filteredChartDataKeys = this->filteredChartData.keys();
    for(int i = 0; i < filteredChartDataKeys.length(); i++){

        QList<int> columnKeys = this->filteredChartData.value(i).keys();
        QJsonObject tmp;

        foreach(int colKey, columnKeys){
            tmp.insert(QString::number(colKey), QJsonArray::fromStringList(this->reportChartData.value(i).value(colKey)));
        }
        filteredChartDataTmp.insert(QString::number(filteredChartDataKeys.at(i)), tmp);
    }
    masterObj.insert("reportChartData", filteredChartDataTmp);


    // numericalList
    masterObj.insert("numericalList", QJsonArray::fromStringList(this->numericalList));

    // categoryList
    masterObj.insert("categoryList", QJsonArray::fromStringList(this->categoryList));

    // dateList
    masterObj.insert("dateList", QJsonArray::fromStringList(this->dateList));

    // allColumnVisibleMap
    QJsonObject allColumnVisibleMapTmp;
    QList<int> columnVisibleMapKeys = this->allColumnVisibleMap.keys();
    for(int i = 0; i < columnVisibleMapKeys.length(); i++){

        QList<QString> columnNameKeys = this->allColumnVisibleMap.value(i).keys();
        QJsonObject tmp;

        foreach(QString colKey, columnNameKeys){
            tmp.insert(colKey, this->allColumnVisibleMap.value(i).value(colKey).toString());
        }
        allColumnVisibleMapTmp.insert(QString::number(columnVisibleMapKeys.at(i)), tmp);
    }

    masterObj.insert("allColumnVisibleMap", allColumnVisibleMapTmp);

    // reportChartData
    QJsonObject reportChartDataTmp;
    QList<int> reportChartDataKeys = this->reportChartData.keys();
    for(int i = 0; i < reportChartDataKeys.length(); i++){

        QList<int> columnKeys = this->reportChartData.value(i).keys();
        QJsonObject tmp;

        foreach(int colKey, columnKeys){
            tmp.insert(QString::number(colKey), QJsonArray::fromStringList(this->reportChartData.value(i).value(colKey)));
        }
        reportChartDataTmp.insert(QString::number(reportChartDataKeys.at(i)), tmp);
    }
    masterObj.insert("reportChartData", reportChartDataTmp);


    // columnTypes
    QJsonObject columnTypesTmp;
    QStringList columnTypesList = this->columnTypes.keys();
    for(int k = 0; k < columnTypesList.length(); k++){
        columnTypesTmp.insert(columnTypesList.at(k), this->columnTypes.value(columnTypesList.at(k)));
    }
    masterObj.insert("columnTypes", columnTypesTmp);

    // columnDataList
    // This list is not required
    // masterObj.insert("columnDataList", QJsonArray::fromStringList(columnDataList));

    emit signalSaveTableColumns(masterObj);
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


void TableColumnsModel::getFilterValues(QMap<int, QStringList> showColumns, QMap<int, QVariantMap> columnFilterType, QMap<int, QVariantMap> columnIncludeExcludeMap, QMap<int, QMap<QString, QStringList> > columnValueMap, int dashboardId)
{

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


    int filterCount = showColumns.value(dashboardId).length();

    for(int j = 0; j < filterCount; j++){

        QString currentColumnName = showColumns.value(dashboardId).at(j);

        QString currentColumnRelation = columnFilterType.value(dashboardId).value(currentColumnName).toString();
        QString valueIncludeExclude = columnIncludeExcludeMap.value(dashboardId).value(currentColumnName).toString();
        QStringList filterValues = columnValueMap.value(dashboardId).value(currentColumnName);

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
            whereConditions += joiner + currentColumnName + joiner  + " BETWEEN " + QString::number(min) + " AND " + QString::number(max) + " AND ";
        }

        // Not equal relations
        else if(currentColumnRelation == "dataNotEqual"){

            float value = filterValues.at(0).toFloat();
            whereConditions += joiner + currentColumnName + joiner + " != " + QString::number(value) + " AND ";
        }

        // Smaller than relations
        else if(currentColumnRelation == "dataSmaller"){

            float value = filterValues.at(0).toFloat();
            whereConditions += joiner + currentColumnName + joiner + " < " + QString::number(value) + " AND ";

        } else if(currentColumnRelation == "dataGreater"){

            float value = filterValues.at(0).toFloat();
            whereConditions += joiner + currentColumnName + joiner + " > " + QString::number(value) + " AND ";

        } else if(currentColumnRelation == "dataEqualOrSmaller"){

            float value = filterValues.at(0).toFloat();
            whereConditions += joiner + currentColumnName + joiner + " <= " + QString::number(value) + " AND ";

        } else if(currentColumnRelation == "dataEqualOrGreater"){

            float value = filterValues.at(0).toFloat();
            whereConditions += joiner + currentColumnName + joiner + " >= " + QString::number(value) + " AND ";

        } else{
            qDebug() << "ELSE CONDITION" << currentColumnRelation;
        }
    }

    this->filteredChartData.insert(dashboardId, tmpColData);
    tmpColData.clear();

    // Chop trailing ' AND '
    whereConditions.chop(5);
    emit dashboardWhereConditions(whereConditions, dashboardId);
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

void TableColumnsModel::generateColumnsForLive(QMap<int, QStringList> sqlHeaders)
{

    qDebug() << "I HAVE RECEIVED" << sqlHeaders;
    // Clear existing chart headers data
    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->newChartHeader.clear();

    int i = 0;
    foreach(QStringList headers, sqlHeaders){

        if(headers.at(1).contains(Constants::categoricalType)){
            this->categoryList.append(headers.at(0));
            this->columnTypes.insert(headers.at(0), Constants::categoricalType);
        } else if(headers.at(1).contains(Constants::numericalType)){
            this->numericalList.append(headers.at(0));
            this->columnTypes.insert(headers.at(0), Constants::numericalType);
        } else if(headers.at(1).contains(Constants::dateType)){
            this->dateList.append(headers.at(0));
            this->columnTypes.insert(headers.at(0), Constants::dateType);
        } else{
            qDebug() << "OTHER UNDETECTED FIELD TYPE" << headers.at(0);
        }

        this->newChartHeader.insert(i, headers.at(0));
        i++;
    }

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);

    // Update new data

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);
    emit sendFilteredColumn(this->dashboardId, this->categoryList, this->numericalList, this->dateList);

}


void TableColumnsModel::generateColumnsForReader(duckdb::Connection *con)
{
    this->generateColumns(con);
}

void TableColumnsModel::getExtractTableColumns(QJsonObject tableColumnParams)
{

    qDebug() << Q_FUNC_INFO << tableColumnParams;
    //    QMap<int, QMap<int, QStringList>> filteredChartData;
    //    QMap<int, QStringList *> newChartData;
    //    QMap<int, QString> newChartHeader;
    //    QMap<int, QStringList> chartHeaderDetails;

    //    QStringList numericalList;
    //    QStringList categoryList;
    //    QStringList dateList;
    //    QMap<int, QVariantMap> allColumnVisibleMap;         // dashboardId - <columnName - columnType>
    //    QMap<int, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    //    QMap<QString, QString> columnTypes;
    //    QStringList columnDataList;

    QJsonObject mainObj;
    mainObj = tableColumnParams.value("allColumnVisibleMap").toObject();
    QStringList dashboardIds = mainObj.keys();

    foreach(QString dashboardId, dashboardIds){
        QJsonObject childObj = mainObj.value(dashboardId).toObject();
        QStringList childKeys = childObj.keys();

        QVariantMap tmpMap;
        foreach(QString key, childKeys){
            tmpMap.insert(key, childObj.value(key).toString());
        }

        this->allColumnVisibleMap.insert(dashboardId.toInt(), tmpMap);
        this->applyColumnVisibility(dashboardId.toInt());
    }
}

void TableColumnsModel::receiveOriginalConditions(QString selectParams, QString whereParams, QString joinParams, QString masterTable)
{
    qDebug() << "I HAVE RECEIVED ORIGINAL CONDITONS" << selectParams << whereParams << joinParams << masterTable;
    this->liveSelectParams = selectParams;
    this->liveMasterTable = masterTable;
    this->liveWhereParams = whereParams;
    this->liveJoinParams = joinParams;
}


void TableColumnsModel::generateColumns(duckdb::Connection *con)
{

    // Fetch data from duckdb
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;

//    if(Statics::currentDbIntType == Constants::excelIntType || Statics::currentDbIntType == Constants::csvIntType || Statics::currentDbIntType == Constants::jsonIntType) {
        tableName = QFileInfo(tableName).baseName().toLower();
        tableName = tableName.remove(QRegularExpression("[^A-Za-z0-9]"));
//    }

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
