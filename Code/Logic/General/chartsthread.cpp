#include "chartsthread.h"

ChartsThread::ChartsThread(QObject *parent) : QObject(parent)
{

    this->xAxisColumn = "";
    this->yAxisColumn = "";
    this->xSplitKey = "";
    this->xAxisColumnList.clear();
    this->yAxisColumnList.clear();
    this->sourceColumn = "";
    this->destinationColumn = "";
    this->measureColumn = "";
    this->calculateColumn = "";
}

ChartsThread::~ChartsThread()
{
}

void ChartsThread::clearCache()
{
    this->dashboardReportDataCached.clear();
    this->liveDashboardFilterParamsCached.clear();
}

void ChartsThread::methodSelector(QString functionName, QString reportWhereConditions, QString dashboardWhereConditions, int chartSource, int reportId, int dashboardId, QString datasourceType)
{

    this->reportWhereConditions = reportWhereConditions;
    this->dashboardWhereConditions = dashboardWhereConditions;
    this->currentChartSource = chartSource;
    this->currentDashboardId = dashboardId;
    this->currentReportId = reportId;
    this->datasourceType = datasourceType;

    if (!this->cachedDashboardConditions.contains(reportId)){
        this->cachedDashboardConditions.insert(reportId, true);
    }

    if(this->dashboardWhereConditionsCached.value(this->currentDashboardId) != this->dashboardWhereConditions){
        this->dashboardWhereConditionsCached.insert(this->currentDashboardId, this->dashboardWhereConditions);

        foreach(int key, this->cachedDashboardConditions.keys()){
            this->cachedDashboardConditions[key] = true;
        }
    }


    if(functionName == "getBarChartValues"){
        this->getBarChartValues();
    } else if(functionName == "getStackedBarChartValues"){
        this->getStackedBarChartValues();
    } else if(functionName == "getGroupedBarChartValues"){
        this->getGroupedBarChartValues();
    } else if(functionName == "getNewGroupedBarChartValues"){
        this->getNewGroupedBarChartValues();
    } else if(functionName == "getAreaChartValues"){
        this->getAreaChartValues();
    } else if(functionName == "getLineChartValues"){
        this->getLineChartValues();
    } else if(functionName == "getLineBarChartValues"){
        this->getLineBarChartValues();
    } else if(functionName == "getPieChartValues"){
        this->getPieChartValues();
    } else if(functionName == "getFunnelChartValues"){
        this->getFunnelChartValues();
    } else if(functionName == "getRadarChartValues"){
        this->getRadarChartValues();
    } else if(functionName == "getScatterChartValues"){
        this->getScatterChartValues();
    } else if(functionName == "getScatterChartNumericalValues"){
        this->getScatterChartNumericalValues();
    } else if(functionName == "getHeatMapChartValues"){
        this->getHeatMapChartValues();
    } else if(functionName == "getSunburstChartValues"){
        this->getSunburstChartValues();
    } else if(functionName == "getWaterfallChartValues"){
        this->getWaterfallChartValues();
    } else if(functionName == "getGaugeChartValues"){
        this->getGaugeChartValues();
    } else if(functionName == "getSankeyChartValues"){
        this->getSankeyChartValues();
    } else if(functionName == "getTreeChartValues"){
        this->getTreeChartValues();
    } else if(functionName == "getTreeMapChartValues"){
        this->getTreeMapChartValues();
    } else if(functionName == "getKPIChartValues"){
        this->getKPIChartValues();
    } else if(functionName == "getTableChartValues"){
        this->getTableChartValues();
    } else if(functionName == "getPivotChartValues"){
        this->getPivotChartValues();
    } else if(functionName == "getStackedAreaChartValues"){
        this->getStackedAreaChartValues();
    } else if(functionName == "getMultiLineChartValues"){
        this->getMultiLineChartValues();
    } else {}
}

void ChartsThread::queryParams(QString masterTable, QString masterWhereParams, QString masterJoinParams)
{
    this->masterTable = masterTable;
    this->masterWhereParams = masterWhereParams;
    this->masterJoinParams = masterJoinParams;
}


void ChartsThread::setAxes(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey)
{

    this->xAxisColumn = "";
    this->yAxisColumn = "";
    this->xSplitKey = "";

    this->xAxisColumn = xAxisColumn;
    this->yAxisColumn = yAxisColumn;
    this->xSplitKey = xSplitKey;
}

void ChartsThread::setLists(QVariantList &xAxisColumnList, QVariantList &yAxisColumnList, QVariantList &row3ColumnList)
{
    this->xAxisColumnList.clear();
    this->yAxisColumnList.clear();
    this->row3ColumnList.clear();

    this->xAxisColumnList = xAxisColumnList;
    this->yAxisColumnList = yAxisColumnList;
    this->row3ColumnList = row3ColumnList;
}

void ChartsThread::setSankeyDetails(QString &sourceColumn, QString &destinationColumn, QString &measureColumn)
{
    this->sourceColumn = "";
    this->destinationColumn = "";
    this->measureColumn = "";

    this->sourceColumn = sourceColumn;
    this->destinationColumn = destinationColumn;
    this->measureColumn = measureColumn;
}

void ChartsThread::setGaugeKpiDetails(QString &calculateColumn, QString greenValue, QString yellowValue, QString redValue)
{
    this->calculateColumn = calculateColumn;
    this->greenValue = greenValue;
    this->yellowValue = yellowValue;
    this->redValue = redValue;
}

void ChartsThread::setTablePivotDateConversionOptions(QString dateConversionOptions)
{
    this->dateConversionOptions = QJsonDocument::fromJson(dateConversionOptions.toUtf8()).array();
}

void ChartsThread::start()
{
    qDebug() << "Charts Thread";
}

void ChartsThread::getBarChartValues()
{

    QJsonArray data;
    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;

    int index;
    int totalRows = 0;


    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){
            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
        }
    }

    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->insert(xAxisDataPointer->at(i), counter);

                counter++;

                xAxisData.append(xAxisDataPointer->at(i));
                yAxisData.append(yAxisDataPointer->at(i).toFloat());
            } else{

                index = uniqueHashKeywords->value(xAxisDataPointer->at(i));
                yAxisData[index] = yAxisData[index].toFloat() + yAxisDataPointer->at(i).toFloat();

            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonArray colData;
    colData.append(QJsonArray::fromStringList(xAxisData));
    colData.append(QJsonArray::fromVariantList(yAxisData));

    QString xParam;
    QString yParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;
    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));
    }


    QJsonArray columns;
    columns.append(xParam);
    columns.append(yParam);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);

    emit signalBarChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getStackedBarChartValues()
{
    this->getStackedBarAreaValues(xAxisColumn, yAxisColumn, xSplitKey, "getStackedBarChartValues");

}

void ChartsThread::getGroupedBarChartValues()
{

    QJsonArray data;
    QVariantList tmpData;
    QVariantList tmpStringList;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordXList;
    QStringList masterKeywordSplitList;
    QString masterKeywordX;
    QString masterKeywordSplit;

    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    QStringList xAxisData;
    QVariantList yAxisData;
    int splitIndex;
    QJsonArray colData;
    int xIndex;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalGroupedBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\", \"" + xSplitKey + "\" FROM "+ tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
            splitDataPointer->append(dataListExtract->GetValue(2, i).ToString().c_str());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListExtract->GetValue(0, i).ToString().c_str());
            splitDataPointerPre.append(dataListExtract->GetValue(2, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalGroupedBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + ", " + xSplitKey + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){

            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
            splitDataPointer->append(dataListLive.value(2).toString());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListLive.value(0).toString());
            splitDataPointerPre.append(dataListLive.value(2).toString());
        }
    }


    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();



    // Pre - Populate the json array
    try{
        for(int i = 0; i < xAxisDataPointerPre.length(); i++){

            tmpData.clear();
            for(int j = 0; j < splitDataPointerPre.length(); j++){

                tmpData.append(0);
            }

            colData.append(QJsonArray::fromVariantList(tmpData));
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    // Populate the actual data
    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            tmpData.clear();
            tmpStringList.clear();

            xIndex = xAxisDataPointerPre.indexOf(xAxisDataPointer->at(i));
            splitIndex = splitDataPointerPre.indexOf(splitDataPointer->at(i));

            tmpStringList.append(colData.at(xIndex).toArray().toVariantList());
            tmpStringList[splitIndex] = tmpStringList[splitIndex].toFloat() + yAxisDataPointer->at(i).toFloat();

            colData.replace(xIndex, QJsonArray::fromVariantList(tmpStringList));
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    data.append(colData);
    data.append(QJsonArray::fromStringList(xAxisDataPointerPre));
    data.append(QJsonValue::fromVariant(splitDataPointerPre));

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalGroupedBarChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getNewGroupedBarChartValues()
{

    QJsonArray data;
    QJsonArray axisDataArray;
    QList<QString> uniqueSplitKeyData;
    QStringList reportChartDataVar;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitKeyDataPointer(new QStringList);

    QStringList xAxisData;
    QVariantList yAxisData;
    QJsonArray colData;
    QJsonObject obj;
    int index;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalNewGroupedBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\", \"" + xSplitKey + "\" FROM "+ tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
            splitKeyDataPointer->append(dataListExtract->GetValue(2, i).ToString().c_str());

            reportChartDataVar.append(dataListExtract->GetValue(2, i).ToString().c_str());
            reportChartDataVar.removeDuplicates();
            uniqueSplitKeyData = reportChartDataVar;
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalNewGroupedBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + ", " + xSplitKey + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){

            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
            splitKeyDataPointer->append(dataListLive.value(2).toString());

            reportChartDataVar.append(dataListLive.value(2).toString());
            reportChartDataVar.removeDuplicates();
            uniqueSplitKeyData = reportChartDataVar;
        }
    }


    try{
        qint64 nanoSec;
        myTimer2.start();

        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            obj = QJsonObject();

            QString uniqueHash = xAxisDataPointer->at(i);
            if(!uniqueHashKeywords->contains(uniqueHash)){
                uniqueHashKeywords->insert(uniqueHash, counter);
                counter++;

                obj.insert("mainCategory", xAxisDataPointer->at(i));

                obj[splitKeyDataPointer->at(i)] = yAxisDataPointer->at(i).toDouble();
                axisDataArray.append(obj);

            } else{

                index = uniqueHashKeywords->value(uniqueHash);
                obj = axisDataArray[index].toObject();
                obj[splitKeyDataPointer->at(i)] = obj.value(splitKeyDataPointer->at(i)).toDouble() + yAxisDataPointer->at(i).toDouble();

                axisDataArray.replace(index, obj);
            }

        }
        nanoSec = myTimer2.nsecsElapsed();
        qDebug() << "Time Elapsed" << nanoSec / 1000000000 << " seconds";
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    data.append(axisDataArray);

    QJsonArray columns;
    columns.append(QJsonArray::fromStringList(uniqueSplitKeyData));
    xAxisDataPointer->removeDuplicates();
    columns.append(QJsonArray::fromStringList(*xAxisDataPointer));

    //    QJsonArray categories;
    //    xAxisDataPointer->removeDuplicates();
    //    categories.append(QJsonArray::fromStringList(*xAxisDataPointer));

    QJsonArray categories;
    categories.append(xAxisColumn);
    categories.append(xSplitKey);
    categories.append(yAxisColumn);

    data.append(columns);
    data.append(categories);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalNewGroupedBarChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getAreaChartValues()
{
    this->getLineAreaWaterfallValues(xAxisColumn, yAxisColumn, "getAreaChartValues");
}

void ChartsThread::getLineChartValues()
{
    this->getLineAreaWaterfallValues(xAxisColumn, yAxisColumn, "getLineChartValues");
}

void ChartsThread::getLineBarChartValues()
{

    QJsonArray data;
    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yBarAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yLineAxisDataPointer(new QStringList);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;
    QVariantList tmpData;
    QJsonArray colData;
    int index;
    int totalRows;


    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalLineBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\", \"" + xSplitKey + "\" FROM "+ tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yBarAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
            yLineAxisDataPointer->append(dataListExtract->GetValue(2, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalLineBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + ", " + xSplitKey + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){

            xAxisDataPointer->append(dataListLive.value(0).toString());
            yBarAxisDataPointer->append(dataListLive.value(1).toString());
            yLineAxisDataPointer->append(dataListLive.value(2).toString());
        }
    }

    // Add data
    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){
            tmpData.clear();

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->insert(xAxisDataPointer->at(i), counter);
                counter++;

                tmpData.append(xAxisDataPointer->at(i));
                tmpData.append(yLineAxisDataPointer->at(i).toFloat());
                tmpData.append(yBarAxisDataPointer->at(i).toFloat());

                colData.append(QJsonArray::fromVariantList(tmpData));
            } else{

                index = uniqueHashKeywords->value(xAxisDataPointer->at(i));
                tmpData.append(colData.at(index).toArray().toVariantList());

                tmpData[1] = tmpData[1].toFloat() + yLineAxisDataPointer->at(i).toFloat();
                tmpData[2] = tmpData[2].toFloat() + yBarAxisDataPointer->at(i).toFloat();

                colData.replace(index, QJsonArray::fromVariantList(tmpData));

            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QString xParam;
    QString yParam;
    QString splitParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;
        splitParam = xSplitKey;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList splitPieces = xSplitKey.split( "." );
        splitParam = splitPieces.at(1);
        splitParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray columns;
    columns.append(xParam);
    columns.append(yParam);
    columns.append(splitParam);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalLineBarChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getPieChartValues()
{

    QJsonArray data;
    QJsonObject obj;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;
    QVariantList tmpData;
    QJsonArray colData;
    int totalRows;


    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalPieChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){

            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
        }

    } else{

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalPieChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){

            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
        }
    }


    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->insert(xAxisDataPointer->at(i), counter);
                counter++;

                obj.insert(xAxisDataPointer->at(i), yAxisDataPointer->at(i).toFloat());
            } else{

                obj[xAxisDataPointer->at(i)] = obj[xAxisDataPointer->at(i)].toDouble() + yAxisDataPointer->at(i).toDouble();
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }


    QString xParam;
    QString yParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray columns;
    columns.append(xParam);
    columns.append(yParam);

    data.append(obj);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);
    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalPieChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getFunnelChartValues()
{

    QJsonArray data;
    QJsonArray axisDataArray;
    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    //    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QStringList yAxisData;
    QVariantList tmpData;
    QJsonArray colData;
    QJsonObject obj;
    int index;
    int totalRows;


    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalFunnelChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){

            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalFunnelChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){

            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
        }
    }

    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            obj.empty();

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->insert(xAxisDataPointer->at(i), counter);
                counter++;

                obj.insert("key", xAxisDataPointer->at(i));
                obj.insert("value", yAxisDataPointer->at(i).toDouble());
                axisDataArray.append(obj);

            } else{

                index = uniqueHashKeywords->value(xAxisDataPointer->at(i));
                obj = axisDataArray[index].toObject();
                obj["value"] = obj.value("value").toDouble() + yAxisDataPointer->at(i).toDouble();

                axisDataArray.replace(index, obj);
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    data.append(axisDataArray);

    QString xParam;
    QString yParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray columns;
    columns.append(xParam);
    columns.append(yParam);

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalFunnelChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getRadarChartValues()
{
    QJsonArray data;
    QJsonArray axisDataArray;
    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QStringList yAxisData;
    QVariantList tmpData;
    QJsonArray colData;
    QJsonObject obj;
    int index;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalRadarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){

            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalRadarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){

            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
        }
    }

    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            obj.empty();

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->insert(xAxisDataPointer->at(i), counter);
                counter++;

                obj.insert("axis", xAxisDataPointer->at(i));
                obj.insert("value", yAxisDataPointer->at(i).toDouble());
                axisDataArray.append(obj);

            } else{

                index = uniqueHashKeywords->value(xAxisDataPointer->at(i));
                obj = axisDataArray[index].toObject();
                obj["value"] = obj.value("value").toDouble() + yAxisDataPointer->at(i).toDouble();

                axisDataArray.replace(index, obj);
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    data.append(axisDataArray);

    QString xParam;
    QString yParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray columns;
    columns.append(xParam);
    columns.append(yParam);

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalRadarChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getScatterChartValues()
{

    QJsonArray data;
    QVariantList tmpData;
    float xAxisTmpData;
    float yAxisTmpData;
    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QString masterKeyword;
    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;
    QJsonArray colData;
    int index;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalScatterChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\", \"" + xSplitKey + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){

            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
            splitDataPointer->append(dataListExtract->GetValue(2, i).ToString().c_str());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListExtract->GetValue(0, i).ToString().c_str());
            splitDataPointerPre.append(dataListExtract->GetValue(2, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalScatterChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + ", " + xSplitKey + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){

            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
            splitDataPointer->append(dataListLive.value(2).toString());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListLive.value(0).toString());
            splitDataPointerPre.append(dataListLive.value(2).toString());
        }
    }
    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();


    // Populate the actual data
    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            masterKeyword = splitDataPointer->at(i);
            tmpData.clear();
            xAxisTmpData = 0.0;
            yAxisTmpData = 0.0;

            if(!uniqueHashKeywords->contains(masterKeyword)){
                uniqueHashKeywords->insert(masterKeyword, counter);
                counter++;

                tmpData.append(xAxisDataPointer->at(i).toFloat());
                tmpData.append(yAxisDataPointer->at(i).toFloat());
                tmpData.append(splitDataPointer->at(i));

                colData.append(QJsonArray::fromVariantList(tmpData));
            } else{

                index = uniqueHashKeywords->value(masterKeyword);
                xAxisTmpData =  colData.at(index).toArray().at(0).toDouble() + xAxisDataPointer->at(i).toDouble();
                yAxisTmpData =  colData.at(index).toArray().at(1).toDouble() + yAxisDataPointer->at(i).toDouble();

                tmpData.append(xAxisTmpData);
                tmpData.append(yAxisTmpData);
                tmpData.append(splitDataPointer->at(i));

                colData.replace(index, QJsonArray::fromVariantList(tmpData));
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }


    QString xParam;
    QString yParam;
    QString splitParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;
        splitParam = xSplitKey;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList splitPieces = xSplitKey.split( "." );
        splitParam = splitPieces.at(1);
        splitParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray columns;
    columns.append(xParam);
    columns.append(yParam);
    columns.append(splitParam);



    data.append(colData);
    data.append(columns);
    data.append(QJsonArray::fromStringList(splitDataPointerPre));


    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalScatterChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getScatterChartNumericalValues()
{
    QJsonArray data;
    QJsonArray colData;
    QVariantList tmpData;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QString xAxisValue;
    QString yAxisValue;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalScatterChartNumericalValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT SUM(\"" + xAxisColumn + "\"), SUM(\"" + yAxisColumn + "\") FROM "+tableName;
        dataListExtract = this->queryExtractFunction(queryString);

        xAxisValue = dataListExtract->GetValue(0, 0).ToString().c_str();
        yAxisValue = dataListExtract->GetValue(1, 0).ToString().c_str();

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalScatterChartNumericalValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT SUM(" + xAxisColumn + "), SUM(" + yAxisColumn + ") FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;
        dataListLive = this->queryLiveFunction(queryString);

        xAxisValue = dataListLive.value(0).toString();
        yAxisValue = dataListLive.value(1).toString();

    }

    tmpData.append(0);
    tmpData.append(0);
    colData.append(QJsonArray::fromVariantList(tmpData));

    tmpData.clear();
    tmpData.append(xAxisValue);
    tmpData.append(yAxisValue);

    colData.append(QJsonArray::fromVariantList(tmpData));

    QString xParam;
    QString yParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QStringList colNames;
    colNames.append(xParam);
    colNames.append(yParam);

    data.append(colData);
    data.append(QJsonArray::fromStringList(colNames));

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalScatterChartNumericalValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getHeatMapChartValues()
{

    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QHash<QString, int> masterKeywordList;
    QString masterKeyword;
    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;
    QJsonArray colData;
    int index;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalHeatMapChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\", \"" + xSplitKey + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){

            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
            splitDataPointer->append(dataListExtract->GetValue(2, i).ToString().c_str());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListExtract->GetValue(0, i).ToString().c_str());
            splitDataPointerPre.append(dataListExtract->GetValue(2, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalHeatMapChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + ", " + xSplitKey + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){

            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
            splitDataPointer->append(dataListLive.value(2).toString());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListLive.value(0).toString());
            splitDataPointerPre.append(dataListLive.value(2).toString());
        }
    }

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();


    // Populate the actual data
    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            masterKeyword = xAxisDataPointer->at(i) + splitDataPointer->at(i);
            tmpData.clear();
            yAxisTmpData = 0.0;

            if(!masterKeywordList.contains(masterKeyword)){
                masterKeywordList.insert(masterKeyword, counter);
                counter++;

                try{
                    tmpData.append(xAxisDataPointer->at(i));
                    tmpData.append(splitDataPointer->at(i));
                    tmpData.append(yAxisDataPointer->at(i).toDouble());

                    colData.append(QJsonArray::fromVariantList(tmpData));
                } catch(std::exception &e){
                    qDebug() << "C1" << e.what();
                }

            } else{

                index = masterKeywordList.value(masterKeyword);
                yAxisTmpData =  colData.at(index).toArray().at(2).toDouble() + yAxisDataPointer->at(i).toDouble();

                tmpData.append(xAxisDataPointer->at(i));
                tmpData.append(splitDataPointer->at(i));
                tmpData.append(yAxisTmpData);

                colData.replace(index, QJsonArray::fromVariantList(tmpData));
            }

        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonArray columns;
    columns.append(QJsonArray::fromStringList(xAxisDataPointerPre));
    columns.append(QJsonArray::fromStringList(splitDataPointerPre));

    QString xParam;
    QString yParam;
    QString splitParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;
        splitParam = xSplitKey;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList splitPieces = xSplitKey.split( "." );
        splitParam = splitPieces.at(1);
        splitParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QStringList inputKeys;
    inputKeys.append(xParam);
    inputKeys.append(yParam);
    inputKeys.append(splitParam);

    QJsonArray input = QJsonArray::fromStringList(inputKeys);


    data.append(colData);
    data.append(columns);
    data.append(input);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalHeatMapChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getSunburstChartValues()
{

    this->getTreeSunburstValues(xAxisColumnList, yAxisColumn, "getSunburstChartValues");
}

void ChartsThread::getWaterfallChartValues()
{
    this->getLineAreaWaterfallValues(xAxisColumn, yAxisColumn, "getWaterfallChartValues");
}

void ChartsThread::getGaugeChartValues()
{

    QStringList calculateColumnPointer;

    QStringList xAxisData;
    QVariantList yAxisData;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    float output = 0.0;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalGaugeChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + calculateColumn + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            calculateColumnPointer.append(dataListExtract->GetValue(0, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalGaugeChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + calculateColumn + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){
            calculateColumnPointer.append(dataListLive.value(0).toString());
        }
    }

    try{
        for(int i = 0; i < calculateColumnPointer.length(); i++){

            output += calculateColumnPointer.at(i).toFloat();
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QString calculateParam;

    if(this->datasourceType == Constants::extractType){
        calculateParam = calculateColumn;

    } else {
        QStringList calculatePieces = calculateColumn.split( "." );
        calculateParam = calculatePieces.at(1);
        calculateParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray finalResult;
    finalResult.append(this->greenValue.toFloat());
    finalResult.append(this->yellowValue.toFloat());
    finalResult.append(this->redValue.toFloat());
    finalResult.append(output);

    QJsonArray cols;
    cols.append(finalResult);
    cols.append(calculateParam);


    QJsonDocument doc;
    doc.setArray(cols);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);

    emit signalGaugeChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getSankeyChartValues()
{

    QJsonArray data;
    QJsonObject dataObject;
    QJsonArray nodeData;
    QJsonObject nodeObject;
    QMap<int, QString> nodeIdMap;

    QScopedPointer<QStringList> masterKeywords(new QStringList);
    QScopedPointer<QStringList> sourceDataPointer(new QStringList);
    QScopedPointer<QStringList> destinationDataPointer(new QStringList);
    QScopedPointer<QStringList> measureDataPointer(new QStringList);
    QString keyword;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;
    QJsonArray colData;
    int index;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalSankeyChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + sourceColumn + "\", \"" + destinationColumn + "\", \"" + measureColumn + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            sourceDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            destinationDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
            measureDataPointer->append(dataListExtract->GetValue(2, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalSankeyChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + sourceColumn + ", " + destinationColumn + ", " + measureColumn + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){
            sourceDataPointer->append(dataListLive.value(0).toString());
            destinationDataPointer->append(dataListLive.value(1).toString());
            measureDataPointer->append(dataListLive.value(2).toString());
        }
    }

    QStringList combinedList;
    combinedList.append(*sourceDataPointer);
    combinedList.append(*destinationDataPointer);
    combinedList.removeDuplicates();

    // Master nodes list
    try{
        for(int i = 0; i < combinedList.length(); i++){

            nodeObject.empty();
            nodeObject.insert("node", i);
            nodeObject.insert("name", combinedList.at(i));

            nodeData.append(nodeObject);
            nodeIdMap.insert(i, combinedList.at(i));
        }

    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }


    // Master Data
    try{
        for(int i = 0; i < sourceDataPointer->length(); i++){

            keyword = sourceDataPointer->at(i) + destinationDataPointer->at(i);
            dataObject.empty();

            if(!masterKeywords->contains(keyword)){
                masterKeywords->append(keyword);

                dataObject.insert("source", nodeIdMap.key(sourceDataPointer->at(i)));
                dataObject.insert("target", nodeIdMap.key(destinationDataPointer->at(i)));
                dataObject.insert("value", measureDataPointer->at(i).toFloat());

                data.append(dataObject);
            } else{

                index = masterKeywords->indexOf(keyword);

                dataObject = data.at(index).toObject();
                dataObject["value"] = dataObject.value("value").toDouble() + measureDataPointer->at(i).toFloat();

                data.replace(index, dataObject);
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonObject output;
    output.insert("nodes", nodeData);
    output.insert("links", data);


    QJsonDocument doc(output);
    QString strData(doc.toJson(QJsonDocument::Compact));

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalSankeyChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);

}

void ChartsThread::getTreeChartValues()
{
    this->getTreeSunburstValues(xAxisColumnList, yAxisColumn, "getTreeChartValues");
}

void ChartsThread::getTreeMapChartValues()
{
    this->getTreeSunburstValues(xAxisColumnList, yAxisColumn, "getTreeMapChartValues");
}

void ChartsThread::getKPIChartValues()
{

    QScopedPointer<QStringList> calculateColumnPointer(new QStringList);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;

    float output = 0.0;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalKPIChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + calculateColumn + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            calculateColumnPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalKPIChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + calculateColumn + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){
            calculateColumnPointer->append(dataListLive.value(0).toString());
        }
    }


    try{
        for(int i = 0; i < calculateColumnPointer->length(); i++){

            output += calculateColumnPointer->at(i).toFloat();
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QString calculateParam;

    if(this->datasourceType == Constants::extractType){
        calculateParam = calculateColumn;

    } else {
        QStringList calculatePieces = calculateColumn.split( "." );
        calculateParam = calculatePieces.at(1);
        calculateParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QVariantList cols;
    cols.append(output);
    cols.append(calculateParam);

    QJsonArray data;
    data.append(QJsonArray::fromVariantList(cols));

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalKPIChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getTableChartValues()
{
    QJsonArray data;
    QString masterKeyword;
    QVariantList masterTotal;
    QVariantList masterOutput;
    QMap<QString, QMap<QString, QString>> dateConversionParams;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> xDataListExtract;
    duckdb::unique_ptr<duckdb::MaterializedQueryResult> yDataListExtract;
    QSqlQuery xDataListLive;
    QSqlQuery yDataListLive;

    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    QScopedPointer<QMap<int, QStringList>> xAxisDataPointer(new  QMap<int, QStringList>);
    QScopedPointer<QMap<int, QStringList>> yAxisDataPointer(new  QMap<int, QStringList>);

    QStringList xAxisData;
    QStringList yAxisData;

    QVariantMap tmpData;
    QJsonArray colData;
    int index;

    QJsonArray columns;
    QVector<int> xKey;
    QVector<int> yKey;
    int xAxisLength;
    int yAxisLength;
    int totalRows;

    // Process date conversions, if any
    foreach(QJsonValue dateConversionValue, this->dateConversionOptions){

        QMap<QString, QString> itemDetails;
        QJsonObject dateConversionObj = dateConversionValue.toObject();

        itemDetails.insert("separator", dateConversionObj.value("separator").toString());
        itemDetails.insert("formats", dateConversionObj.value("dateFormat").toString());

        QString columnName = dateConversionObj.value("itemName").toString();
        dateConversionParams.insert(columnName, itemDetails);
    }


    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalTableChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();

        QString xQueryString =  "SELECT ";
        foreach(QVariant xCols, xAxisColumnList){
            xQueryString += "\"" + xCols.toString() + "\", ";
        }

        xQueryString.chop(2);
        xQueryString += " FROM " + tableName;

        QString yQueryString =  "SELECT ";
        foreach(QVariant yCols, yAxisColumnList){
            yQueryString += "\"" + yCols.toString() + "\", ";
        }

        yQueryString.chop(2);
        yQueryString += " FROM " + tableName;

        xDataListExtract = this->queryExtractFunction(xQueryString);
        yDataListExtract = this->queryExtractFunction(yQueryString);

        totalRows = xDataListExtract->collection.Count();

        xAxisLength = xAxisColumnList.length();
        yAxisLength = yAxisColumnList.length();

        // Fetch data from db
        try{
            for(int i = 0; i < xAxisLength; i++){
                QStringList data;
                for(int j = 0; j < totalRows; j++){

                    QString columnName = xAxisColumnList.at(i).toString();
                    QString separator = dateConversionParams.value(columnName).value("separator");


                    if(dateConversionParams.contains(columnName)){

                        QString convertedDate;
                        QStringList list = dateConversionParams.value(columnName).value("formats").split(",");

                        foreach(QString format, list){
                            QVariantList dateType = dataType.checkDateTimeType(xDataListExtract->GetValue(i, j).ToString().c_str());
                            QDateTime dateTime = QDateTime::fromString(xDataListExtract->GetValue(i, j).ToString().c_str(), dateType.at(1).toString());

                            if(format.toLower() == "day"){
                                convertedDate += QString::number(dateTime.date().day()) + separator;
                            } else if(format.toLower() == "month"){
                                convertedDate += dateTime.date().toString("MMM")  + separator;
                            } else {
                                convertedDate += QString::number(dateTime.date().year())  + separator;
                            }
                        }

                        convertedDate.chop(separator.length());
                        data.append(convertedDate);

                    } else {
                        data.append(xDataListExtract->GetValue(i, j).ToString().c_str());
                    }
                }

                xAxisDataPointer->insert(i, data);

                QString xParam;

                if(this->datasourceType == Constants::extractType){
                    xParam = xAxisColumnList.at(i).toString();
                } else {
                    QStringList xPieces = xAxisColumnList.at(i).toString().split( "." );
                    xParam = xPieces.at(1);
                    xParam.remove(QRegularExpression("[\"\'`]+"));
                }
                // Append to output columns -- all x axis names
                columns.append(xParam);
            }
        } catch(std::exception &e){
            qWarning() << Q_FUNC_INFO << e.what();
        }

        try{
            for(int i = 0; i < yAxisLength; i++){
                QStringList data;
                for(int j = 0; j < totalRows; j++)
                    data.append(yDataListExtract->GetValue(i, j).ToString().c_str());

                yAxisDataPointer->insert(i, data);

                QString yParam;

                if(this->datasourceType == Constants::extractType){
                    yParam = yAxisColumnList.at(i).toString();
                } else {
                    QStringList xPieces = yAxisColumnList.at(i).toString().split( "." );
                    yParam = xPieces.at(1);
                    yParam.remove(QRegularExpression("[\"\'`]+"));
                }
                // Append to output columns -- all y axis names
                columns.append(yParam);

            }
        } catch(std::exception &e){
            qWarning() << Q_FUNC_INFO << e.what();
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalTableChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString xQueryString =  "SELECT ";
        foreach(QVariant xCols, xAxisColumnList){
            xQueryString += xCols.toString() + ", ";
        }

        xQueryString.chop(2);

        xQueryString += " FROM " + this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        QString yQueryString =  "SELECT ";
        foreach(QVariant yCols, yAxisColumnList){
            yQueryString += yCols.toString() + ", ";
        }

        yQueryString.chop(2);

        yQueryString += " FROM " + this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        xDataListLive = this->queryLiveFunction(xQueryString);
        xAxisLength = xAxisColumnList.length();

        // Fetch data from db
        try{


            while(xDataListLive.next()){
                QStringList data;
                for(int i = 0; i < xAxisLength; i++){

                    QString columnName = xAxisColumnList.at(i).toString();
                    QString separator = dateConversionParams.value(columnName).value("separator");


                    if(dateConversionParams.contains(columnName)){

                        QString convertedDate;
                        QStringList list = dateConversionParams.value(columnName).value("formats").split(",");

                        foreach(QString format, list){
                            QVariantList dateType = dataType.checkDateTimeType(xDataListLive.value(i).toString());
                            QDateTime dateTime = QDateTime::fromString(xDataListLive.value(i).toString(), dateType.at(1).toString());

                            if(format.toLower() == "day"){
                                convertedDate += QString::number(dateTime.date().day()) + separator;
                            } else if(format.toLower() == "month"){
                                convertedDate += dateTime.date().toString("MMM")  + separator;
                            } else {
                                convertedDate += QString::number(dateTime.date().year())  + separator;
                            }
                        }

                        convertedDate.chop(separator.length());
                        data = xAxisDataPointer->value(i);
                        data.append(convertedDate);

                    } else {
                        data = xAxisDataPointer->value(i);
                        data.append(xDataListLive.value(i).toString());
                    }

                    xAxisDataPointer->insert(i, data);
                }

            }

            // Append to output columns -- all x axis names
            for(int i = 0; i < xAxisLength; i++){
                columns.append(xAxisColumnList.at(i).toString());
            }
        } catch(std::exception &e){
            qWarning() << Q_FUNC_INFO << e.what();
        }

        yDataListLive = this->queryLiveFunction(yQueryString);
        yAxisLength = yAxisColumnList.length();

        try{

            QStringList data;
            while(yDataListLive.next()){
                for(int i = 0; i < yAxisLength; i++){
                    data = yAxisDataPointer->value(i);
                    data.append(yDataListLive.value(i).toString());
                    yAxisDataPointer->insert(i, data);
                }
            }

            // Append to output columns -- all y axis names
            for(int i = 0; i < yAxisLength; i++){
                columns.append(yAxisColumnList.at(i).toString());
            }

        } catch(std::exception &e){
            qWarning() << Q_FUNC_INFO << e.what();
        }

    }


    // Actual values
    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->value(0).length(); i++){

            tmpData.clear();
            masterKeyword.clear();

            for(int j = 0; j < xAxisLength; j++){
                masterKeyword.append(xAxisDataPointer->value(j).at(i));
            }

            if(!uniqueHashKeywords->contains(masterKeyword)){
                uniqueHashKeywords->insert(masterKeyword, counter);
                counter++;

                for(int j = 0; j < xAxisLength; j++){
                    tmpData.insert(xAxisColumnList.at(j).toString(), xAxisDataPointer->value(j).at(i));
                }

                for(int j = 0; j < yAxisLength; j++){
                    tmpData.insert(yAxisColumnList.at(j).toString(), yAxisDataPointer->value(j).at(i).toFloat());
                    if(masterTotal.length() < yAxisLength){
                        masterTotal.append(yAxisDataPointer->value(j).at(i).toFloat());
                    } else{
                        masterTotal[j] = masterTotal.at(j).toFloat() + yAxisDataPointer->value(j).at(i).toFloat();
                    }
                }

                colData.append(QJsonObject::fromVariantMap(tmpData));

            } else{

                index = uniqueHashKeywords->value(masterKeyword);
                tmpData = colData.at(index).toObject().toVariantMap();

                for(int j = 0; j < yAxisLength; j++){
                    float tmpVal = tmpData.value(yAxisColumnList.at(j).toString()).toFloat() + yAxisDataPointer->value(j).at(i).toFloat();
                    tmpData.insert(yAxisColumnList.at(j).toString(), tmpVal);
                    masterTotal[j] = masterTotal.at(j).toFloat() + yAxisDataPointer->value(j).at(i).toFloat();
                }
                colData.replace(index, QJsonObject::fromVariantMap(tmpData));
            }

        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }


    // Master total
    for(int i = 0; i < xAxisLength; i++){
        masterOutput.append("");
    }

    for(int i = 0; i < yAxisLength; i++){
        masterOutput.append(masterTotal.at(i).toFloat());
    }


    data.append(colData);
    data.append(QJsonArray::fromVariantList(masterOutput));
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalTableChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);

}

void ChartsThread::getPivotChartValues()
{
    QJsonArray data;
    QString masterKeyword;
    QVariantList masterTotal;
    QVariantList masterOutput;
    QHash<QString, QHash<QString, QString>> dateConversionParams;

    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    QScopedPointer<QMap<int, QStringList>> xAxisDataPointer(new  QMap<int, QStringList>);
    QScopedPointer<QMap<int, QStringList>> yAxisDataPointer(new  QMap<int, QStringList>);
    QScopedPointer<QMap<int, QStringList>> row3DataPointer(new  QMap<int, QStringList>);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> xDataListExtract;
    duckdb::unique_ptr<duckdb::MaterializedQueryResult> yDataListExtract;
    QSqlQuery xDataListLive;
    QSqlQuery yDataListLive;

    QVariantList xAxisColumnOut = xAxisColumnList;
    QVariantList yAxisColumnOut = yAxisColumnList;
    QVariantList row3ColumnOut = row3ColumnList;


    // Process date conversions, if any
    foreach(QJsonValue dateConversionValue, this->dateConversionOptions){

        QHash<QString, QString> itemDetails;
        QJsonObject dateConversionObj = dateConversionValue.toObject();

        itemDetails.insert("separator", dateConversionObj.value("separator").toString());
        itemDetails.insert("formats", dateConversionObj.value("dateFormat").toString());

        QString columnName = dateConversionObj.value("itemName").toString();
        dateConversionParams.insert(columnName, itemDetails);

        qDebug() << "Date conversion" << columnName << itemDetails;
    }

    QStringList xAxisData;
    QStringList yAxisData;

    QVariantList tmpData;

    QJsonArray colData;
    int index;

    QJsonArray columns;
    QVector<int> xKey;
    QVector<int> yKey;
    int xAxisLength = 0;
    int yAxisLength = 0;
    int totalRows;
    QVariantList dateType;

    if(xAxisColumnList.length() > 0 && yAxisColumnList.length() > 0){
        if(this->datasourceType == Constants::extractType){

            // Check the cache if data exists and the params havent changed
            // Cache will currently work only on dashboards
            if(this->currentChartSource == Constants::dashboardScreen){

                if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                    emit signalPivotChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                    this->cachedDashboardConditions[this->currentReportId] = false;
                    return;
                }
            }

            // Fetch data from extract
            QString tableName = this->getTableName();
            QString xQueryString =  "SELECT ";
            foreach(QVariant xCols, xAxisColumnList){
                xQueryString += "\"" + xCols.toString() + "\", ";
            }

            xQueryString.chop(2);
            xQueryString += " FROM " + tableName;

            QString yQueryString =  "SELECT ";
            foreach(QVariant yCols, yAxisColumnList){
                yQueryString += "\"" + yCols.toString() + "\", ";
            }

            yQueryString.chop(2);
            yQueryString += " FROM " + tableName;

            auto xDataListExtract = this->queryExtractFunction(xQueryString);
            auto yDataListExtract = this->queryExtractFunction(yQueryString);

            totalRows = xDataListExtract->collection.Count();

            xAxisLength = xAxisColumnList.length();
            yAxisLength = yAxisColumnList.length();

            // Fetch data from db
            try{
                for(int i = 0; i < xAxisLength; i++){
                    QStringList data;
                    for(int j = 0; j < totalRows; j++){

                        QString columnName = xAxisColumnList.at(i).toString();
                        QString separator = dateConversionParams.value(columnName).value("separator");


                        if(dateConversionParams.contains(columnName)){

                            QString convertedDate;
                            QStringList list = dateConversionParams.value(columnName).value("formats").split(",");
                            foreach(QString format, list){
                                if(dateType.isEmpty())
                                    dateType = dataType.checkDateTimeType(xDataListExtract->GetValue(i, j).ToString().c_str());

                                QDateTime dateTime = QDateTime::fromString(xDataListExtract->GetValue(i, j).ToString().c_str(), dateType.at(1).toString());
                                if(format.toLower() == "day"){
                                    convertedDate += QString::number(dateTime.date().day()) + separator;
                                } else if(format.toLower() == "month"){
                                    convertedDate += dateTime.date().toString("MMM")  + separator;
                                } else {
                                    convertedDate += QString::number(dateTime.date().year())  + separator;
                                }
                            }

                            convertedDate.chop(separator.length());
                            data.append(convertedDate);

                        } else {
                            data.append(xDataListExtract->GetValue(i, j).ToString().c_str());
                        }
                    }

                    xAxisDataPointer->insert(i, data);

                    // Append to output columns -- all x axis names
                    columns.append(xAxisColumnList.at(i).toString());
                }
            } catch(std::exception &e){
                qWarning() << Q_FUNC_INFO << e.what();
            }

            try{
                for(int i = 0; i < yAxisLength; i++){
                    QStringList data;
                    for(int j = 0; j < totalRows; j++)
                        data.append(yDataListExtract->GetValue(i, j).ToString().c_str());

                    yAxisDataPointer->insert(i, data);

                    // Append to output columns -- all y axis names
                    columns.append(yAxisColumnList.at(i).toString());
                }
            } catch(std::exception &e){
                qWarning() << Q_FUNC_INFO << e.what();
            }

        } else {

            // Check the cache if data exists and the params havent changed
            // Cache will currently work only on dashboards
            if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

                if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                    emit signalPivotChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                    this->cachedDashboardConditions[this->currentReportId] = false;
                    return;
                }
            }

            // Fetch data from live
            if(Statics::currentDbIntType != Constants::postgresIntType)
                this->masterWhereParams.replace(R"('')", R"(')");

            QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

            QString xQueryString =  "SELECT ";
            foreach(QVariant xCols, xAxisColumnList){
                xQueryString += xCols.toString() + ", ";
            }

            xQueryString.chop(2);
            xQueryString += " FROM " + this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

            QString yQueryString =  "SELECT ";
            foreach(QVariant yCols, yAxisColumnList){
                yQueryString += yCols.toString() + ", ";
            }

            yQueryString.chop(2);
            yQueryString += " FROM " + this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

            xDataListLive = this->queryLiveFunction(xQueryString);
            xAxisLength = xAxisColumnList.length();

            // Fetch data from db
            try{

                while(xDataListLive.next()){
                    for(int i = 0; i < xAxisLength; i++){
                        QStringList data;

                        QString columnName = xAxisColumnList.at(i).toString();
                        QString separator = dateConversionParams.value(columnName).value("separator");



                        QStringList originalNameList = columnName.split( "." );
                        QString originalColName = originalNameList.at(1);
                        originalColName.remove(QRegularExpression("[\"\'`]+"));

                        if(dateConversionParams.contains(originalColName)){

                            QString convertedDate;
                            QStringList list = dateConversionParams.value(originalColName).value("formats").split(",");

                            foreach(QString format, list){
                                if(dateType.isEmpty())
                                    dateType = dataType.checkDateTimeType(xDataListLive.value(i).toString());

                                QDateTime dateTime = QDateTime::fromString(xDataListLive.value(i).toString(), dateType.at(1).toString());

                                if(format.toLower() == "day"){
                                    convertedDate += QString::number(dateTime.date().day()) + separator;
                                } else if(format.toLower() == "month"){
                                    convertedDate += dateTime.date().toString("MMM")  + separator;
                                } else {
                                    convertedDate += QString::number(dateTime.date().year())  + separator;
                                }
                            }

                            convertedDate.chop(separator.length());
                            data = xAxisDataPointer->value(i);
                            data.append(convertedDate);

                        } else {
                            data = xAxisDataPointer->value(i);
                            data.append(xDataListLive.value(i).toString());
                        }

                        xAxisDataPointer->insert(i, data);
                    }

                }

                for(int i = 0; i < xAxisLength; i++){
                    // Append to output columns -- all x axis names
                    columns.append(xAxisColumnList.at(i).toString());
                }

            } catch(std::exception &e){
                qWarning() << Q_FUNC_INFO << e.what();
            }


            yDataListLive = this->queryLiveFunction(yQueryString);
            yAxisLength = yAxisColumnList.length();

            try{

                while(yDataListLive.next()){
                    QStringList data;
                    for(int i = 0; i < yAxisLength; i++){

                        data = yAxisDataPointer->value(i);
                        data.append(yDataListLive.value(i).toString());

                        yAxisDataPointer->insert(i, data);
                    }

                }

                for(int i = 0; i < yAxisLength; i++){
                    // Append to output columns -- all x axis names
                    columns.append(yAxisColumnList.at(i).toString());
                }

            } catch(std::exception &e){
                qWarning() << Q_FUNC_INFO << e.what();
            }
        }



        // Actual values
        try{
            int counter = 0;
            for(int i = 0; i < xAxisDataPointer->value(0).length(); i++){

                tmpData.clear();
                masterKeyword.clear();

                for(int j = 0; j < xAxisLength; j++){
                    masterKeyword.append(xAxisDataPointer->value(j).at(i));
                }


                if(!uniqueHashKeywords->contains(masterKeyword)){
                    uniqueHashKeywords->insert(masterKeyword, counter);
                    counter++;

                    for(int j = 0; j < xAxisLength; j++){
                        tmpData.append(xAxisDataPointer->value(j).at(i));
                    }

                    for(int j = 0; j < yAxisLength; j++){
                        tmpData.append(yAxisDataPointer->value(j).at(i).toFloat());
                        if(masterTotal.length() < yAxisLength){
                            masterTotal.append(yAxisDataPointer->value(j).at(i).toFloat());
                        } else{
                            masterTotal[j] = masterTotal.at(j).toFloat() + yAxisDataPointer->value(j).at(i).toFloat();
                        }
                    }

                    colData.append(QJsonArray::fromVariantList(tmpData));

                } else{

                    index = uniqueHashKeywords->value(masterKeyword);
                    tmpData.append(colData.at(index).toArray().toVariantList());

                    for(int j = 0; j < yAxisLength; j++){
                        tmpData[xAxisLength + j] = tmpData[xAxisLength + j].toFloat() + yAxisDataPointer->value(j).at(i).toFloat();
                        masterTotal[j] = masterTotal.at(j).toFloat() + yAxisDataPointer->value(j).at(i).toFloat();
                    }
                    colData.replace(index, QJsonArray::fromVariantList(tmpData));
                }

            }
        } catch(std::exception &e){
            qWarning() << Q_FUNC_INFO << e.what();
        }


        // Master total
        for(int i = 0; i < xAxisLength; i++){
            masterOutput.append("");
        }

        for(int i = 0; i < yAxisLength; i++){
            masterOutput.append(masterTotal.at(i).toFloat());
        }

        QJsonArray finalColumns;
        QVariantList finalRow3ColumnOut;

        if(this->datasourceType == Constants::extractType){
            finalColumns = columns;
            finalRow3ColumnOut = row3ColumnOut;

        } else{

            QString colName;
            foreach(QVariant column, columns){
                QStringList xPieces = column.toString().split( "." );
                colName = xPieces.at(1);
                colName.remove(QRegularExpression("[\"\'`]+"));
                finalColumns.append(colName);
            }


            QString row3ColName;
            foreach(QVariant column, row3ColumnOut){
                QStringList tmpInnerCol;
                foreach(QVariant innerColumn, column.toJsonArray()){
                    QStringList xPieces = innerColumn.toString().split( "." );
                    row3ColName = xPieces.at(1);
                    row3ColName.remove(QRegularExpression("[\"\'`]+"));
                    tmpInnerCol.append(row3ColName);
                }
                finalRow3ColumnOut.append(tmpInnerCol);
            }
        }

        data.append(colData);
        data.append(QJsonArray::fromVariantList(masterOutput));
        data.append(finalColumns);
        data.append(QJsonValue::fromVariant(finalRow3ColumnOut));

        QJsonDocument doc;
        doc.setArray(data);

        QString strData = doc.toJson(QJsonDocument::Compact);

        // Cache report results
        this->dashboardReportDataCached.insert(this->currentReportId, strData);

        // Cache filter params
        if(this->datasourceType != Constants::extractType)
            this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


        qDebug() << "EMITTED";
        emit signalPivotChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    }
}

void ChartsThread::getStackedAreaChartValues()
{
    this->getStackedBarAreaValues(xAxisColumn, yAxisColumn, xSplitKey, "getStackedAreaChartValues");
}

void ChartsThread::getMultiLineChartValues()
{
    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QHash<QString, int> masterKeywordList;
    QString masterKeyword;
    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;
    QJsonArray colData;
    int index;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalMultiLineChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\", \"" + xSplitKey + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
            splitDataPointer->append(dataListExtract->GetValue(2, i).ToString().c_str());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListExtract->GetValue(0, i).ToString().c_str());
            splitDataPointerPre.append(dataListExtract->GetValue(2, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                emit signalMultiLineChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + ", " + xSplitKey + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){
            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
            splitDataPointer->append(dataListLive.value(2).toString());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListLive.value(0).toString());
            splitDataPointerPre.append(dataListLive.value(2).toString());
        }
    }

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    // Pre - Populate the json array
    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointerPre.length(); i++){

            for(int j = 0; j < splitDataPointerPre.length(); j++){

                masterKeyword = xAxisDataPointerPre.at(i) + splitDataPointerPre.at(j);

                masterKeywordList.insert(masterKeyword, counter);
                counter++;

                tmpData.clear();
                tmpData.append(xAxisDataPointerPre.at(i));
                tmpData.append(splitDataPointerPre.at(j));
                tmpData.append(0);

                colData.append(QJsonArray::fromVariantList(tmpData));
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }


    // Populate the actual data
    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            masterKeyword = xAxisDataPointer->at(i) + splitDataPointer->at(i);
            tmpData.clear();
            yAxisTmpData = 0.0;

            index = masterKeywordList.value(masterKeyword);
            yAxisTmpData =  colData.at(index).toArray().at(2).toDouble() + yAxisDataPointer->at(i).toDouble();

            tmpData.append(xAxisDataPointer->at(i));
            tmpData.append(splitDataPointer->at(i));
            tmpData.append(yAxisTmpData);

            colData.replace(index, QJsonArray::fromVariantList(tmpData));

        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QString xParam;
    QString yParam;
    QString splitParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;
        splitParam = xSplitKey;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList splitPieces = xSplitKey.split( "." );
        splitParam = splitPieces.at(1);
        splitParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray columns;
    columns.append(xParam);
    columns.append(yParam);
    columns.append(splitParam);


    data.append(colData);
    data.append(QJsonArray::fromStringList(splitDataPointerPre));
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    emit signalMultiLineChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
}

void ChartsThread::getLineAreaWaterfallValues(QString &xAxisColumn, QString &yAxisColumn, QString identifier)
{

    QJsonArray data;
    QScopedPointer<QHash<QString, int>> uniqueHashKeywords(new QHash<QString, int>);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    QStringList xAxisData;
    QVariantList yAxisData;
    QJsonArray colData;
    QJsonObject obj;
    QVariantList tmpData;
    int index;
    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                if(identifier == "getAreaChartValues"){
                    emit signalAreaChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getLineChartValues"){
                    emit signalLineChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getWaterfallChartValues"){
                    emit signalWaterfallChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else {
                    emit signalLineAreaWaterfallValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                }
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){

                if(identifier == "getAreaChartValues"){
                    emit signalAreaChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getLineChartValues"){
                    emit signalLineChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getWaterfallChartValues"){
                    emit signalWaterfallChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else {
                    emit signalLineAreaWaterfallValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                }
                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){
            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
        }

    }


    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointer->length(); i++){
            tmpData.clear();

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->insert(xAxisDataPointer->at(i), counter);
                counter++;

                tmpData.append(xAxisDataPointer->at(i));
                tmpData.append(yAxisDataPointer->at(i).toFloat());

                colData.append(QJsonArray::fromVariantList(tmpData));
            } else{

                index = uniqueHashKeywords->value(xAxisDataPointer->at(i));
                tmpData.append(colData.at(index).toArray().toVariantList());

                tmpData[1] = tmpData[1].toFloat() + yAxisDataPointer->at(i).toFloat();
                colData.replace(index, QJsonArray::fromVariantList(tmpData));

            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QString xParam;
    QString yParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray columns;
    columns.append(xParam);
    columns.append(yParam);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    if(identifier == "getAreaChartValues"){
        emit signalAreaChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    } else if(identifier == "getLineChartValues"){
        emit signalLineChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    } else if(identifier == "getWaterfallChartValues"){
        emit signalWaterfallChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    } else {
        emit signalLineAreaWaterfallValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    }


}

void ChartsThread::getTreeSunburstValues(QVariantList & xAxisColumn, QString & yAxisColumn, QString identifier)
{
    int pointerSize;

    QJsonArray data;
    QJsonArray axisArray;
    json output(json_array_arg);
    json emptyJsonArray(json_array_arg);
    QMap<QString, int> positions;
    QMap<int, QString> pastHashKeyword;
    float measure = 0;
    float total = 0;

    QString paramName = "";
    QString hashKeyword = "";
    QStringList xAxisData;
    QVariantList yAxisData;

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> xDataListExtract;
    duckdb::unique_ptr<duckdb::MaterializedQueryResult> yDataListExtract;
    QSqlQuery xDataListLive;
    QMap<int, QHash<int, QString>> yDataListLive;

    json *jsonPointer = new json;
    json *jsonPointerMeasure = new json;
    QScopedPointer<QMap<QString, float>> totalCount(new QMap<QString, float>);

    // masterHash will be used to compare if any map has been generated earlier
    // if there is an exact match with the hash, then it exists. Else create a new hash
    QScopedPointer<QHash<QString, int>> masterHash(new QHash<QString, int>);

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                if(identifier == "getSunburstChartValues"){
                    emit signalSunburstChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getTreeChartValues"){
                    emit signalTreeChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getTreeMapChartValues"){
                    emit signalTreeMapChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else {
                    emit signalTreeSunburstValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                }

                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();

        QString xQueryString =  "SELECT ";
        foreach(QVariant xCols, xAxisColumn){
            xQueryString += "\"" + xCols.toString() + "\", ";
        }

        xQueryString.chop(2);
        xQueryString += " FROM " + tableName;

        QString yQueryString =  "SELECT \"" + yAxisColumn + "\" FROM " + tableName;;

        xDataListExtract = this->queryExtractFunction(xQueryString);
        yDataListExtract = this->queryExtractFunction(yQueryString);

        int totalRows = xDataListExtract->collection.Count();
        int totalXCols = xDataListExtract->ColumnCount();


        // Considering the measure as string here to avoid unwanted errors in wrong casting
        // The front in javascript can easily handle this

        try{
            float x = 0;
            for(int i = 0; i < totalRows; i++){

                QString measureString = yDataListExtract->GetValue(0, i).ToString().c_str();
                measure = measureString.toFloat();
                x += measure;


                json tmpOutput;
                pastHashKeyword.clear();

                int counter = 0;
                for(int j = 0; j < totalXCols; j++){

                    paramName = xDataListExtract->GetValue(j, i).ToString().c_str();

                    // Generate unique hash to strings to be stored in master hash
                    if( j == 0){
                        hashKeyword.clear();
                        hashKeyword = paramName;
                    } else{
                        hashKeyword.append(paramName);
                    }


                    // If the hash doesnt exist, add to hash
                    if(!masterHash->contains(hashKeyword)){
                        masterHash->insert(hashKeyword, counter);
                        counter++;
                        totalCount->insert(hashKeyword, measure);

                        tmpOutput["name"] = paramName.toStdString();
                        tmpOutput["size"] = measure;
                        tmpOutput["children"] = emptyJsonArray;
                        tmpOutput["label"] = xAxisColumn.at(j).toString().toStdString();

                        // Check if first element of json is already there
                        // If not, then add it according to the graph data
                        if(j == 0){
                            output.push_back(tmpOutput);
                            positions.insert(hashKeyword, output.size() - 1);
                            pastHashKeyword[0] = hashKeyword;
                            total += measure;

                        } else{

                            jsonPointer = &output;
                            for(int k =0; k < j; k++){

                                if(j - k == 1){
                                    try{

                                        jsonPointer->at(positions.value(pastHashKeyword.value(k))).at("children").push_back(tmpOutput);
                                        pastHashKeyword.insert(j, hashKeyword);

                                        pointerSize = jsonPointer->at(positions.value(pastHashKeyword.value(k))).at("children").size() - 1;
                                        positions.insert(hashKeyword, pointerSize);
                                    }catch (std::exception &e) {
                                        qDebug() << "C2" << e.what();
                                    }

                                } else{
                                    try{
                                        jsonPointer = &jsonPointer->at(positions.value(pastHashKeyword.value(k))).at("children");

                                    }catch (std::exception &e) {
                                        qDebug() << "C3" << e.what();
                                    }
                                }
                            }
                        }

                    } else{

                        float newValue = totalCount->value(hashKeyword) + measure;
                        totalCount->insert(hashKeyword, newValue);
                        pastHashKeyword.insert(j, hashKeyword);

                        if(j == 0){
                            total += measure;
                        }

                        jsonPointerMeasure = &output;
                        for(int k = 0; k <= j; k++){


                            if(k == j){
                                jsonPointerMeasure->at(positions.value(hashKeyword)).at("size") = newValue;

                            } else{
                                jsonPointerMeasure = &jsonPointerMeasure->at(positions.value(pastHashKeyword.value(k))).at("children");
                            }
                        }
                    }
                }
            }
        } catch(std::exception &e){
            qWarning() << Q_FUNC_INFO << e.what();
        }


    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                if(identifier == "getSunburstChartValues"){
                    emit signalSunburstChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getTreeChartValues"){
                    emit signalTreeChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getTreeMapChartValues"){
                    emit signalTreeMapChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else {
                    emit signalTreeSunburstValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                }

                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString xQueryString =  "SELECT ";
        foreach(QVariant xCols, xAxisColumn){
            xQueryString += xCols.toString() + ", ";
        }

        xQueryString.chop(2);
        xQueryString += " FROM " + this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        QString yQueryString =  "SELECT " + yAxisColumn + " FROM " + this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        int totalXCols = xAxisColumn.length();
        //        int totalYCols = yAxisColumn.length();

        yDataListLive = this->queryLiveValues(yQueryString, 1);
        xDataListLive = this->queryLiveFunction(xQueryString);



        // Considering the measure as string here to avoid unwanted errors in wrong casting
        // The front in javascript can easily handle this

        try{
            float x = 0;
            int i = -1;
            while(xDataListLive.next()){
                i++;

                QString measureString = yDataListLive.value(0).value(i);
                measure = measureString.toFloat();
                x += measure;


                json tmpOutput;
                pastHashKeyword.clear();

                int counter = 0;
                for(int j = 0; j < totalXCols; j++){

                    paramName = xDataListLive.value(j).toString();

                    // Generate unique hash to strings to be stored in master hash
                    if( j == 0){
                        hashKeyword.clear();
                        hashKeyword = paramName;
                    } else{
                        hashKeyword.append(paramName);
                    }


                    // If the hash doesnt exist, add to hash
                    if(!masterHash->contains(hashKeyword)){
                        masterHash->insert(hashKeyword, counter);
                        counter++;
                        totalCount->insert(hashKeyword, measure);

                        QString tmpLabel =  xAxisColumn.at(j).toString();
                        QStringList tmpYPieces =  tmpLabel.split( "." );
                        QString tmpYParam = tmpYPieces.at(1);
                        tmpYParam.remove(QRegularExpression("[\"\'`]+"));

                        tmpOutput["name"] = paramName.toStdString();
                        tmpOutput["size"] = measure;
                        tmpOutput["children"] = emptyJsonArray;
                        tmpOutput["label"] = tmpYParam.toStdString();

                        // Check if first element of json is already there
                        // If not, then add it according to the graph data
                        if(j == 0){
                            output.push_back(tmpOutput);
                            positions.insert(hashKeyword, output.size() - 1);
                            pastHashKeyword[0] = hashKeyword;
                            total += measure;

                        } else{

                            jsonPointer = &output;
                            for(int k =0; k < j; k++){

                                if(j - k == 1){
                                    try{

                                        jsonPointer->at(positions.value(pastHashKeyword.value(k))).at("children").push_back(tmpOutput);
                                        pastHashKeyword.insert(j, hashKeyword);

                                        pointerSize = jsonPointer->at(positions.value(pastHashKeyword.value(k))).at("children").size() - 1;
                                        positions.insert(hashKeyword, pointerSize);
                                    }catch (std::exception &e) {
                                        qDebug() << "C2" << e.what();
                                    }

                                } else{
                                    try{
                                        jsonPointer = &jsonPointer->at(positions.value(pastHashKeyword.value(k))).at("children");

                                    }catch (std::exception &e) {
                                        qDebug() << "C3" << e.what();
                                    }
                                }
                            }
                        }

                    } else{

                        float newValue = totalCount->value(hashKeyword) + measure;
                        totalCount->insert(hashKeyword, newValue);
                        pastHashKeyword.insert(j, hashKeyword);

                        if(j == 0){
                            total += measure;
                        }

                        jsonPointerMeasure = &output;
                        for(int k = 0; k <= j; k++){


                            if(k == j){
                                jsonPointerMeasure->at(positions.value(hashKeyword)).at("size") = newValue;

                            } else{
                                jsonPointerMeasure = &jsonPointerMeasure->at(positions.value(pastHashKeyword.value(k))).at("children");
                            }
                        }
                    }
                }

            }
        } catch(std::exception &e){
            qWarning() << Q_FUNC_INFO << e.what();
        }

    }



    QString s = output.to_string().c_str();
    QJsonDocument d = QJsonDocument::fromJson(s.toUtf8());

    QString yParam;

    if(this->datasourceType == Constants::extractType){
        yParam = yAxisColumn;

    } else {

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonObject obj;
    obj.insert("name", yParam);
    obj.insert("size", total);
    obj.insert("children", d.array());


    QStringList colStringList;
    foreach(QVariant xCol, xAxisColumn){
        QString xParam;

        if(this->datasourceType == Constants::extractType){
            xParam = xCol.toString();

        } else {
            QStringList xPieces = xCol.toString().split( "." );
            xParam = xPieces.at(1);
            xParam.remove(QRegularExpression("[\"\'`]+"));
        }

        colStringList.append(xParam);
    }
    colStringList.append(yParam);

    QJsonArray cols;
    cols.append(obj);
    cols.append(QJsonArray::fromStringList(colStringList));


    QJsonDocument doc;
    doc.setArray(cols);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    if(identifier == "getSunburstChartValues"){
        emit signalSunburstChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    } else if(identifier == "getTreeChartValues"){
        emit signalTreeChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    } else if(identifier == "getTreeMapChartValues"){
        emit signalTreeMapChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    } else {
        emit signalTreeSunburstValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    }
}

void ChartsThread::getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey, QString identifier)
{

    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataListExtract;
    QSqlQuery dataListLive;

    // Order of QMap - xAxisCol, SplitKey, Value
    QHash<QString, int> masterKeywordList;
    QString masterKeyword;
    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;


    // Fetch data here

    int totalRows;

    if(this->datasourceType == Constants::extractType){

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                if(identifier == "getStackedBarChartValues"){
                    emit signalStackedBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getStackedAreaChartValues") {
                    emit signalStackedAreaChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else{
                    emit signalStackedBarAreaValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                }

                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from extract
        QString tableName = this->getTableName();
        QString queryString = "SELECT \"" + xAxisColumn + "\", \"" + yAxisColumn + "\", \"" + xSplitKey + "\" FROM "+tableName;

        dataListExtract = this->queryExtractFunction(queryString);
        totalRows = dataListExtract->collection.Count();

        for(int i = 0; i < totalRows; i++){
            xAxisDataPointer->append(dataListExtract->GetValue(0, i).ToString().c_str());
            yAxisDataPointer->append(dataListExtract->GetValue(1, i).ToString().c_str());
            splitDataPointer->append(dataListExtract->GetValue(2, i).ToString().c_str());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListExtract->GetValue(0, i).ToString().c_str());
            splitDataPointerPre.append(dataListExtract->GetValue(2, i).ToString().c_str());
        }

    } else {

        // Check the cache if data exists and the params havent changed
        // Cache will currently work only on dashboards
        if(this->currentChartSource == Constants::dashboardScreen && this->liveDashboardFilterParamsCached.value(this->currentDashboardId) == this->masterWhereParams){

            if(this->dashboardReportDataCached.contains(this->currentReportId) && this->dashboardReportDataCached.value(this->currentReportId).length() > 0 && !this->cachedDashboardConditions.value(this->currentReportId)){
                if(identifier == "getStackedBarChartValues"){
                    emit signalStackedBarChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else if(identifier == "getStackedAreaChartValues") {
                    emit signalStackedAreaChartValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                } else{
                    emit signalStackedBarAreaValues(this->dashboardReportDataCached.value(this->currentReportId), this->currentReportId, this->currentDashboardId, this->currentChartSource);
                }

                this->cachedDashboardConditions[this->currentReportId] = false;
                return;
            }
        }

        // Fetch data from live
        if(Statics::currentDbIntType != Constants::postgresIntType)
            this->masterWhereParams.replace(R"('')", R"(')");

        QString whereString = this->masterWhereParams.trimmed().length() > 0 ? " WHERE " : "";

        QString queryString = "SELECT " + xAxisColumn + ", " + yAxisColumn + ", " + xSplitKey + " FROM "+ this->masterTable + " " + this->masterJoinParams + whereString + this->masterWhereParams;

        dataListLive = this->queryLiveFunction(queryString);
        totalRows = dataListLive.size();

        while(dataListLive.next()){
            xAxisDataPointer->append(dataListLive.value(0).toString());
            yAxisDataPointer->append(dataListLive.value(1).toString());
            splitDataPointer->append(dataListLive.value(2).toString());

            // To pre-populate json array
            xAxisDataPointerPre.append(dataListLive.value(0).toString());
            splitDataPointerPre.append(dataListLive.value(2).toString());
        }

    }

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;

    // Pre - Populate the json array
    try{
        int counter = 0;
        for(int i = 0; i < xAxisDataPointerPre.length(); i++){

            for(int j = 0; j < splitDataPointerPre.length(); j++){

                masterKeyword = xAxisDataPointerPre.at(i) + splitDataPointerPre.at(j);

                masterKeywordList.insert(masterKeyword, counter);
                counter++;

                tmpData.clear();
                tmpData.append(xAxisDataPointerPre.at(i));
                tmpData.append(splitDataPointerPre.at(j));
                tmpData.append(0);

                colData.append(QJsonArray::fromVariantList(tmpData));
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }


    // Populate the actual data
    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            masterKeyword = xAxisDataPointer->at(i) + splitDataPointer->at(i);
            tmpData.clear();
            yAxisTmpData = 0.0;

            index = masterKeywordList.value(masterKeyword);
            yAxisTmpData =  colData.at(index).toArray().at(2).toDouble() + yAxisDataPointer->at(i).toDouble();

            tmpData.append(xAxisDataPointer->at(i));
            tmpData.append(splitDataPointer->at(i));
            tmpData.append(yAxisTmpData);

            colData.replace(index, QJsonArray::fromVariantList(tmpData));

        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QString xParam;
    QString yParam;
    QString splitParam;

    if(this->datasourceType == Constants::extractType){
        xParam = xAxisColumn;
        yParam = yAxisColumn;
        splitParam = xSplitKey;

    } else {
        QStringList xPieces = xAxisColumn.split( "." );
        xParam = xPieces.at(1);
        xParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList yPieces = yAxisColumn.split( "." );
        yParam = yPieces.at(1);
        yParam.remove(QRegularExpression("[\"\'`]+"));

        QStringList splitPieces = xSplitKey.split( "." );
        splitParam = splitPieces.at(1);
        splitParam.remove(QRegularExpression("[\"\'`]+"));
    }

    QJsonArray columns;
    columns.append(splitParam);
    columns.append(yParam);
    columns.append(xParam);


    data.append(colData);
    data.append(QJsonArray::fromStringList(xAxisDataPointerPre));
    data.append(QJsonArray::fromStringList(splitDataPointerPre));
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson(QJsonDocument::Compact);

    // Cache report results
    this->dashboardReportDataCached.insert(this->currentReportId, strData);

    // Cache filter params
    if(this->datasourceType != Constants::extractType)
        this->liveDashboardFilterParamsCached.insert(this->currentDashboardId, this->masterWhereParams);


    if(identifier == "getStackedBarChartValues"){
        emit signalStackedBarChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    } else if(identifier == "getStackedAreaChartValues") {
        emit signalStackedAreaChartValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    } else{
        emit signalStackedBarAreaValues(strData, this->currentReportId, this->currentDashboardId, this->currentChartSource);
    }

}

duckdb::unique_ptr<duckdb::MaterializedQueryResult> ChartsThread::queryExtractFunction(QString mainQuery)
{
    // Fetch data here
    QString queryString;
    duckdb::unique_ptr<duckdb::MaterializedQueryResult> dataList;
    QString extractPath = Statics::extractPath;

    try{
        duckdb::DuckDB db(extractPath.toStdString());
        duckdb::Connection con(db);

        QString connector = this->masterWhereParams.length() > 0 ? " AND " : " WHERE ";

        // IF Reports
        // Else Dashboards
        if(this->currentChartSource == Constants::reportScreen){
            if(this->reportWhereConditions.trimmed().length() > 0){
                queryString = mainQuery + connector + this->reportWhereConditions;
            } else {
                queryString = mainQuery;
            }
        } else {
            if(this->reportWhereConditions.trimmed().length() > 0 && this->dashboardWhereConditions.trimmed().length() > 0){
                queryString =mainQuery + connector + this->reportWhereConditions + " AND " + this->dashboardWhereConditions;
            } else if(this->reportWhereConditions.trimmed().length() > 0 && this->dashboardWhereConditions.trimmed().length() == 0){
                queryString = mainQuery + connector + this->reportWhereConditions;
            } else if(this->reportWhereConditions.trimmed().length() == 0 && this->dashboardWhereConditions.trimmed().length() > 0){
                queryString = mainQuery + connector + this->dashboardWhereConditions;
            } else {
                queryString = mainQuery;
            }
        }


        dataList = con.Query(queryString.toStdString());
        if(!dataList->error.empty())
            qDebug() << Q_FUNC_INFO << dataList->success << queryString << dataList->error.c_str();

    } catch(std::exception &e){
        qDebug() << e.what();
    }

    return dataList;

}

QSqlQuery ChartsThread::queryLiveFunction(QString mainQuery)
{

    QString queryString;
    QSqlDatabase connection;

    QString connector = this->masterWhereParams.length() > 0 ? " AND " : " WHERE ";

    // IF Reports
    // Else Dashboards
    if(this->currentChartSource == Constants::reportScreen){
        if(this->reportWhereConditions.trimmed().length() > 0){
            queryString = mainQuery + connector + this->reportWhereConditions;
        } else {
            queryString = mainQuery;
        }
    } else {
        if(this->reportWhereConditions.trimmed().length() > 0 && this->dashboardWhereConditions.trimmed().length() > 0){
            queryString =mainQuery + connector + this->reportWhereConditions + " AND " + this->dashboardWhereConditions;
        } else if(this->reportWhereConditions.trimmed().length() > 0 && this->dashboardWhereConditions.trimmed().length() == 0){
            queryString = mainQuery + connector + this->reportWhereConditions;
        } else if(this->reportWhereConditions.trimmed().length() == 0 && this->dashboardWhereConditions.trimmed().length() > 0){
            queryString = mainQuery + connector + this->dashboardWhereConditions;
        } else {
            queryString = mainQuery;
        }
    }

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        connection = QSqlDatabase::addDatabase("QMYSQL", "mysqlQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);

        connection.open();
        break;
    }

    case Constants::mysqlOdbcIntType:{
        connection = QSqlDatabase::addDatabase("ODBC", "mysqlOQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);

        connection.open();
        break;
    }

    case Constants::postgresIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "postgresQ");

        connection.setDatabaseName(Statics::postgresDb);
        connection.setHostName(Statics::postgresHost);
        connection.setPort(Statics::postgresPort);
        connection.setUserName(Statics::postgresUsername);
        connection.setPassword(Statics::postgresPassword);

        connection.open();
        break;
    }

    case Constants::mssqlIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "mssqlQ");

        connection.setDatabaseName(Statics::msDb);
        connection.setHostName(Statics::msHost);
        connection.setPort(Statics::msPort);
        connection.setUserName(Statics::msUsername);
        connection.setPassword(Statics::msPassword);

        connection.open();
        break;
    }

    case Constants::oracleIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "oracleQ");

        connection.setDatabaseName(Statics::oracleDb);
        connection.setHostName(Statics::oracleHost);
        connection.setPort(Statics::oraclePort);
        connection.setUserName(Statics::oracleUsername);
        connection.setPassword(Statics::oraclePassword);

        connection.open();
        break;
    }

    case Constants::mongoIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "mongoQ");

        connection.setDatabaseName(Statics::mongoDb);
        connection.setHostName(Statics::mongoHost);
        connection.setPort(Statics::mongoPort);
        connection.setUserName(Statics::mongoUsername);
        connection.setPassword(Statics::mongoPassword);

        connection.open();
        break;
    }

    case Constants::redshiftIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "redshiftQ");

        connection.setDatabaseName(Statics::redshiftDb);
        connection.setHostName(Statics::redshiftHost);
        connection.setPort(Statics::redshiftPort);
        connection.setUserName(Statics::redshiftUsername);
        connection.setPassword(Statics::redshiftPassword);

        connection.open();
        break;
    }

    case Constants::teradataIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "teradataQ");

        connection.setDatabaseName(Statics::teradataDb);
        connection.setHostName(Statics::teradataHost);
        connection.setPort(Statics::teradataPort);
        connection.setUserName(Statics::teradataUsername);
        connection.setPassword(Statics::teradataPassword);

        connection.open();
        break;
    }

    case Constants::snowflakeIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "snowflakeQ");

        connection.setDatabaseName(Statics::snowflakeDb);
        connection.setHostName(Statics::snowflakeHost);
        connection.setPort(Statics::snowflakePort);
        connection.setUserName(Statics::snowflakeUsername);
        connection.setPassword(Statics::snowflakePassword);

        connection.open();
        break;
    }
    }

    QSqlQuery query(queryString, connection);
    if(!query.lastError().NoError){
        qDebug() << Q_FUNC_INFO << query.lastQuery() << query.lastError();
    }

    return query;

}

QMap<int, QHash<int, QString> > ChartsThread::queryLiveValues(QString mainQuery, int totalCols)
{

    QString queryString;
    QSqlDatabase connection;
    QMap<int, QHash<int, QString>> output;
    QHash<int, QString> tmpOut;

    QString connector = this->masterWhereParams.length() > 0 ? " AND " : " WHERE ";

    // IF Reports
    // Else Dashboards
    if(this->currentChartSource == Constants::reportScreen){
        if(this->reportWhereConditions.trimmed().length() > 0){
            queryString = mainQuery + connector + this->reportWhereConditions;
        } else {
            queryString = mainQuery;
        }
    } else {
        if(this->reportWhereConditions.trimmed().length() > 0 && this->dashboardWhereConditions.trimmed().length() > 0){
            queryString =mainQuery + connector + this->reportWhereConditions + " AND " + this->dashboardWhereConditions;
        } else if(this->reportWhereConditions.trimmed().length() > 0 && this->dashboardWhereConditions.trimmed().length() == 0){
            queryString = mainQuery + connector + this->reportWhereConditions;
        } else if(this->reportWhereConditions.trimmed().length() == 0 && this->dashboardWhereConditions.trimmed().length() > 0){
            queryString = mainQuery + connector + this->dashboardWhereConditions;
        } else {
            queryString = mainQuery;
        }
    }

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        connection = QSqlDatabase::addDatabase("QMYSQL", "mysqlQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);

        connection.open();
        break;
    }

    case Constants::mysqlOdbcIntType:{
        connection = QSqlDatabase::addDatabase("ODBC", "mysqlOQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);

        connection.open();
        break;
    }

    case Constants::postgresIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "postgresQ");

        connection.setDatabaseName(Statics::postgresDb);
        connection.setHostName(Statics::postgresHost);
        connection.setPort(Statics::postgresPort);
        connection.setUserName(Statics::postgresUsername);
        connection.setPassword(Statics::postgresPassword);

        connection.open();
        break;
    }

    case Constants::mssqlIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "mssqlQ");

        connection.setDatabaseName(Statics::msDb);
        connection.setHostName(Statics::msHost);
        connection.setPort(Statics::msPort);
        connection.setUserName(Statics::msUsername);
        connection.setPassword(Statics::msPassword);

        connection.open();
        break;
    }

    case Constants::oracleIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "oracleQ");

        connection.setDatabaseName(Statics::oracleDb);
        connection.setHostName(Statics::oracleHost);
        connection.setPort(Statics::oraclePort);
        connection.setUserName(Statics::oracleUsername);
        connection.setPassword(Statics::oraclePassword);

        connection.open();
        break;
    }

    case Constants::mongoIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "mongoQ");

        connection.setDatabaseName(Statics::mongoDb);
        connection.setHostName(Statics::mongoHost);
        connection.setPort(Statics::mongoPort);
        connection.setUserName(Statics::mongoUsername);
        connection.setPassword(Statics::mongoPassword);

        connection.open();
        break;
    }
    }

    QSqlQuery query(queryString, connection);
    if(!query.lastError().NoError){
        qDebug() << Q_FUNC_INFO << query.lastQuery() << query.lastError();
    }

    int x = 0;
    while(query.next()){

        for(int i = 0; i < totalCols; i++){
            tmpOut = output.value(i);
            tmpOut.insert(x, query.value(i).toString());
            output.insert(i, tmpOut);
        }
        x++;
    }

    return output;
}

QString ChartsThread::getTableName()
{
    QString tableName = Statics::currentDbName;

    //    if(Statics::currentDbIntType == Constants::excelIntType || Statics::currentDbIntType == Constants::csvIntType || Statics::currentDbIntType == Constants::jsonIntType) {
    tableName = QFileInfo(tableName).baseName().toLower();
    tableName = tableName.remove(QRegularExpression("[^A-Za-z0-9]"));
    //    }

    return tableName;
}
