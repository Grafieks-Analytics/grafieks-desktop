#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(DashboardParamsModel *dashboardParamsModel, QObject *parent) : QObject(parent),
    dashboardId(0),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
    this->dashboardParamsModel = dashboardParamsModel;
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

void TableColumnsModel::applyColumnVisibility(int dashboardId)
{ 
    QStringList visibleColumns = this->allColumnVisibleMap.value(dashboardId).keys();
    // columnTypes

    QStringList visibleColumnTypes;
    foreach(QString tmpType, visibleColumns){

        QString type;
        if(Statics::currentDbClassification == Constants::duckType){
            type = tmpType;
        } else {
            QStringList pieces = tmpType.split( "." );
            type = pieces.at(1);
            type.remove(QRegularExpression("[\"\'`]+"));   
        }

        this->dashboardParamsModel->setColumnAliasName(dashboardId, tmpType, type);
        visibleColumnTypes.append(this->columnTypes.value(type));
    }

    emit columnNamesChanged(dashboardId, visibleColumns, visibleColumnTypes);
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

        if(this->liveWhereParams.contains(R"('')")){
            this->liveWhereParams.replace(R"('')", R"(')");
        }

        QString whereString = this->liveWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QSqlDatabase dbCon = QSqlDatabase::database(dbString);
        QString queryString = "SELECT DISTINCT " + colName + " FROM " + this->liveMasterTable + " " + this->liveJoinParams + whereString + this->liveWhereParams;
        QSqlQuery query(queryString, dbCon);

        while(query.next()){
            this->columnDataList.append(query.value(0).toString());
        }

        break;

    }

        break;

    case Constants::teradataIntType:
    case Constants::redshiftIntType:
    case Constants::snowflakeIntType:{

        QString dbString;

        switch (Statics::currentDbIntType) {

        case Constants::redshiftIntType:
            dbString = Constants::redshiftOdbcStrQueryType;
            break;
        case Constants::snowflakeIntType:
            dbString = Constants::snowflakeOdbcStrQueryType;
            break;
        case Constants::teradataIntType:
            dbString = Constants::teradataOdbcStrQueryType;
            break;
        }

        if(this->liveWhereParams.contains(R"('')")){
            this->liveWhereParams.replace(R"('')", R"(')");
        }

        QString whereString = this->liveWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QSqlDatabase dbCon = QSqlDatabase::database(dbString);
        QString queryString = "SELECT DISTINCT " + colName + " FROM " + this->liveMasterTable + " " + this->liveJoinParams + whereString + this->liveWhereParams;
        QSqlQuery query(queryString, dbCon);

        while(query.next()){
            this->columnDataList.append(query.value(0).toString());
        }

    }
        break;


    }

    return this->columnDataList;
}

void TableColumnsModel::fetchColumnDataAPI(QString colName, int forwardDashboardId)
{
    // Fetch value from settings
    QSettings settings;
    // GCS Bugfixes -- Fix Keyword
    // charts url to be replaced with actual base url
    QString chartsUrl = settings.value("general/chartsUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    QString sitename = settings.value("user/sitename").toString();
    this->colName = colName;
    this->forwardDashboardId = forwardDashboardId;

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(chartsUrl+"/fetch_column_data");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("uniqueHash", sessionToken.toStdString().c_str());
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("sitename", sitename);
    obj.insert("columnNames", this->colName);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&TableColumnsModel::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&TableColumnsModel::columnDataReadFinished);
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

    QVariantMap tmpCategorical, tmpNumerical, tmpDate;
    QList<QString> categoricalKeys, numericalKeys, dateKeys;

    categoricalKeys = this->categoricalMap.keys();
    numericalKeys = this->numericalMap.keys();
    dateKeys = this->dateMap.keys();

    foreach(QString tmpCategoricalKey, categoricalKeys){
        if(tmpCategoricalKey.contains(keyword))
            tmpCategorical.insert(tmpCategoricalKey, this->categoricalMap.value(tmpCategoricalKey));
    }

    foreach(QString tmpNumericalKey, numericalKeys){
        if(tmpNumericalKey.contains(keyword))
            tmpNumerical.insert(tmpNumericalKey, this->numericalMap.value(tmpNumericalKey));
    }

    foreach(QString tmpDateKey, dateKeys){
        if(tmpDateKey.contains(keyword))
            tmpDate.insert(tmpDateKey, this->dateMap.value(tmpDateKey));
    }

    emit sendFilteredColumn(this->dashboardId, tmpCategorical, tmpNumerical, tmpDate);
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


    // numericalMap
    masterObj.insert("numericalMap", QJsonObject::fromVariantMap(this->numericalMap));

    // categoricalMap
    masterObj.insert("categoricalMap", QJsonObject::fromVariantMap(this->categoricalMap));

    // dateMap
    masterObj.insert("dateMap", QJsonObject::fromVariantMap(this->dateMap));

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

void TableColumnsModel::clearFilters(){
    this->filteredChartData.clear();
    this->newChartData.clear();
    this->newChartHeader.clear();
    this->chartHeaderDetails.clear();

    this->numericalMap.clear();
    this->categoricalMap.clear();
    this->dateMap.clear();

    this->allColumnVisibleMap.clear();
    this->reportChartData.clear();
    this->columnTypes.clear();
    this->columnDataList.clear();

    this->dashboardId = 0;

    emit visibleColumnListChanged(this->allColumnVisibleMap.value(this->dashboardId));
}

void TableColumnsModel::addNewDashboard(int dashboardId)
{
    this->dashboardId = dashboardId;

    emit sendFilteredColumn(this->dashboardId, this->categoricalMap, this->numericalMap, this->dateMap);
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

        this->numericalMap.clear();
        this->categoricalMap.clear();
        this->dateMap.clear();
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
    QString joiner = Statics::extractPath.length() > 0 ? "\"" : "";

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

        // In relations
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

void TableColumnsModel::generateColumnsFromAPI()
{
    // Fetch value from settings
    QSettings settings;
    // GCS Bugfixes -- Fix Keyword
    // charts url to be replaced with actual base url
    QString chartsUrl = settings.value("general/chartsUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    QString sitename = settings.value("user/sitename").toString();

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(chartsUrl+"/fetch_table_columns");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    QJsonObject obj;
    obj.insert("uniqueHash", sessionToken.toStdString().c_str());
    obj.insert("dbType", Statics::currentDbClassification);
    obj.insert("dsName", Statics::currentDSFile);
    obj.insert("sitename", sitename);

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&TableColumnsModel::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&TableColumnsModel::columnReadFinished);
}

void TableColumnsModel::generateColumnsForLive(QMap<int, QStringList> sqlHeaders)
{

    // Clear existing chart headers data
    this->numericalMap.clear();
    this->categoricalMap.clear();
    this->dateMap.clear();
    this->newChartHeader.clear();

    int i = 0;
    foreach(QStringList headers, sqlHeaders){

        int dbIntType = Statics::currentDbIntType;
        QString tableColumnName = qj.getQueryJoiner(dbIntType) + headers.at(2) + qj.getQueryJoiner(dbIntType) + "." + qj.getQueryJoiner(dbIntType) + headers.at(0) + qj.getQueryJoiner(dbIntType);

        if(headers.at(1).contains(Constants::categoricalType)){
            this->categoricalMap.insert(headers.at(0), tableColumnName);
            this->columnTypes.insert(headers.at(0), Constants::categoricalType);
        } else if(headers.at(1).contains(Constants::numericalType)){
            this->numericalMap.insert(headers.at(0), tableColumnName);
            this->columnTypes.insert(headers.at(0), Constants::numericalType);
        } else if(headers.at(1).contains(Constants::dateType)){
            this->dateMap.insert(headers.at(0), tableColumnName);
            this->columnTypes.insert(headers.at(0), Constants::dateType);
        } else{
            qDebug() << "OTHER UNDETECTED FIELD TYPE" << headers.at(0);
        }

        this->newChartHeader.insert(i, headers.at(0));
        i++;
    }

    // Update new data
    emit sendFilteredColumn(this->dashboardId, this->categoricalMap, this->numericalMap, this->dateMap);

}


void TableColumnsModel::generateColumnsForReader(duckdb::Connection *con)
{
    this->generateColumns(con);
}

void TableColumnsModel::getExtractTableColumns(QJsonObject tableColumnParams)
{

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
    this->liveSelectParams = selectParams;
    this->liveMasterTable = masterTable;
    this->liveWhereParams = whereParams;
    this->liveJoinParams = joinParams;
}

void TableColumnsModel::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void TableColumnsModel::columnReadFinished()
{
    //Parse the JSON
    if( m_networkReply->error()){

        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{


        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonDocument dataDoc =  QJsonDocument::fromJson(resultObj["data"].toString().toUtf8());

        // Clear existing chart headers data
        this->numericalMap.clear();
        this->categoricalMap.clear();
        this->dateMap.clear();
        this->newChartHeader.clear();

        QJsonObject json = dataDoc.object();
        int i = 0;
        QJsonArray value = json.value("all").toArray();

        foreach(QJsonValue data, value){
            QJsonArray finalValue = data.toArray();


            int dbIntType = Statics::currentDbIntType;

            QString tableColumnName;

            if(Statics::currentDbClassification == Constants::duckType){
                tableColumnName = finalValue.at(1).toString();
            } else {
                tableColumnName = finalValue.at(4).toString();
            }

            if(finalValue.at(3).toString() == "categorical"){
                this->categoricalMap.insert(finalValue.at(1).toString(), tableColumnName);
                this->columnTypes.insert(finalValue.at(1).toString(), Constants::categoricalType);
            } else if(finalValue.at(3).toString() == "numerical"){
                this->numericalMap.insert(finalValue.at(1).toString(), tableColumnName);
                this->columnTypes.insert(finalValue.at(1).toString(), Constants::numericalType);
            } else if(finalValue.at(3).toString() == "dateformat"){
                this->dateMap.insert(finalValue.at(1).toString(), tableColumnName);
                this->columnTypes.insert(finalValue.at(1).toString(), Constants::dateType);
            }

            this->newChartHeader.insert(i, finalValue.at(1).toString());
            i++;
        }
        m_dataBuffer->clear();
        emit sendFilteredColumn(this->dashboardId, this->categoricalMap, this->numericalMap, this->dateMap);
    }
}

void TableColumnsModel::columnDataReadFinished()
{
    //Parse the JSON
    if( m_networkReply->error()){

        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{


        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonDocument dataDoc =  QJsonDocument::fromJson(resultObj["data"].toString().toUtf8());


        QJsonArray jsonArray = dataDoc.array();
        int i = 0;
        QStringList colNamesList = this->colName.split(",");
        foreach(QJsonValue jsonValue, jsonArray){

            // Clear existing chart headers data
            this->columnDataList.clear();

            QJsonObject json = jsonValue.toObject();
            QJsonArray value = json.value("colData").toArray();

            foreach(QJsonValue data, value){
                this->columnDataList.append(data.toString());
            }

            QString emitColName = colNamesList.at(i).trimmed();
            i++;

            emit columnDataChanged(this->columnDataList, emitColName, this->forwardDashboardId);
        }

    }
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
    this->numericalMap.clear();
    this->categoricalMap.clear();
    this->dateMap.clear();
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
                this->categoricalMap.insert(fieldName, fieldName);
                this->columnTypes.insert(fieldName, Constants::categoricalType);
            } else if(fieldTypeClassification.contains(Constants::numericalType)){
                this->numericalMap.insert(fieldName, fieldName);
                this->columnTypes.insert(fieldName, Constants::numericalType);
            } else if(fieldTypeClassification.contains(Constants::dateType)){
                this->dateMap.insert(fieldName, fieldName);
                this->columnTypes.insert(fieldName, Constants::dateType);
            } else{
                qDebug() << "OTHER UNDETECTED FIELD TYPE" << fieldName;
            }

            this->newChartHeader.insert(i, fieldName);
        }

    } else{
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    }

    // Update new data
    emit sendFilteredColumn(this->dashboardId, this->categoricalMap, this->numericalMap, this->dateMap);
}
