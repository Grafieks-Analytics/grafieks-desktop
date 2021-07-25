#include "chartsthread.h"

ChartsThread::ChartsThread(QObject *parent) : QObject(parent), dashboardId(0), reportId(0), dashboardFilterApplied(false)
{
    chartSources.append("dashboard");
    chartSources.append("report");

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

void ChartsThread::methodSelector(QString functionName)
{
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


void ChartsThread::setAxes(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey)
{

    this->xAxisColumn = "";
    this->yAxisColumn = "";
    this->xSplitKey = "";

    this->xAxisColumn = xAxisColumn;
    this->yAxisColumn = yAxisColumn;
    this->xSplitKey = xSplitKey;
}

void ChartsThread::setLists(QVariantList &xAxisColumnList, QVariantList &yAxisColumnList)
{
    this->xAxisColumnList.clear();
    this->yAxisColumnList.clear();

    this->xAxisColumnList = xAxisColumnList;
    this->yAxisColumnList = yAxisColumnList;
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

void ChartsThread::setGaugeKpiDetails(QString &calculateColumn)
{
    this->calculateColumn = calculateColumn;
}

void ChartsThread::start()
{
    qDebug() << "Charts Thread";
}

void ChartsThread::getBarChartValues()
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    // Fetch data here
    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);

    } else{
        *xAxisDataPointer = reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = reportChartData.value(this->reportId).value(yKey);
    }

    QStringList xAxisData;
    QVariantList yAxisData;

    int index;

    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->append(xAxisDataPointer->at(i));

                xAxisData.append(xAxisDataPointer->at(i));
                yAxisData.append(yAxisDataPointer->at(i).toFloat());
            } else{

                index = uniqueHashKeywords->indexOf(xAxisDataPointer->at(i));
                yAxisData[index] = yAxisData[index].toFloat() + yAxisDataPointer->at(i).toFloat();

            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonArray colData;
    colData.append(QJsonArray::fromStringList(xAxisData));
    colData.append(QJsonArray::fromVariantList(yAxisData));


    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    emit signalBarChartValues(strData);
}

void ChartsThread::getStackedBarChartValues()
{
    this->getStackedBarAreaValues(xAxisColumn, yAxisColumn, xSplitKey, "getStackedBarChartValues");

}

void ChartsThread::getGroupedBarChartValues()
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QVariantList tmpData;
    QVariantList tmpStringList;

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


    // Fetch data here
    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );
    int splitKey = this->headerMap.key( xSplitKey );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){

        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
        *splitDataPointer = this->dashboardChartData.value(this->dashboardId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(xKey));
        splitDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(splitKey));

    } else {
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
        *splitDataPointer = this->reportChartData.value(this->reportId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->reportChartData.value(this->reportId).value(xKey));
        splitDataPointerPre = (this->reportChartData.value(this->reportId).value(splitKey));
    }

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int xIndex;
    int splitIndex;
    QJsonArray colData;

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

    QString strData = doc.toJson();

    emit signalGroupedBarChartValues(strData);
}

void ChartsThread::getNewGroupedBarChartValues()
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QJsonArray axisDataArray;
    QList<QString> uniqueSplitKeyData;
    QStringList reportChartDataVar;

    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitKeyDataPointer(new QStringList);

    // Fetch data here
    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );
    int splitKey = this->headerMap.key( xSplitKey );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){

        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
        *splitKeyDataPointer = this->dashboardChartData.value(this->dashboardId).value(splitKey);

        reportChartDataVar = this->dashboardChartData.value(this->dashboardId).value(splitKey);
        reportChartDataVar.removeDuplicates();
        uniqueSplitKeyData = reportChartDataVar;

    } else {
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
        *splitKeyDataPointer = this->reportChartData.value(this->reportId).value(splitKey);

        reportChartDataVar = this->reportChartData.value(this->reportId).value(splitKey);
        reportChartDataVar.removeDuplicates();
        uniqueSplitKeyData = reportChartDataVar;
    }

    QJsonObject obj;
    int index;

    try{
        qint64 nanoSec;
        myTimer2.start();

        for(int i = 0; i < xAxisDataPointer->length(); i++){

            obj = QJsonObject();

            QString uniqueHash = xAxisDataPointer->at(i);
            if(!uniqueHashKeywords->contains(uniqueHash)){
                uniqueHashKeywords->append(uniqueHash);

                obj.insert("mainCategory", xAxisDataPointer->at(i));

                obj[splitKeyDataPointer->at(i)] = yAxisDataPointer->at(i).toDouble();
                axisDataArray.append(obj);

            } else{

                index = uniqueHashKeywords->indexOf(uniqueHash);
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

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    emit signalNewGroupedBarChartValues(strData);
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
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yBarAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yLineAxisDataPointer(new QStringList);

    // Fetch data here

    int xKey = this->headerMap.key( xAxisColumn );
    int yBarKey = this->headerMap.key( yAxisColumn );
    int yLineKey = this->headerMap.key( xSplitKey );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){

        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yBarAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yBarKey);
        *yLineAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yLineKey);

    } else{
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yBarAxisDataPointer = this->reportChartData.value(this->reportId).value(yBarKey);
        *yLineAxisDataPointer = this->reportChartData.value(this->reportId).value(yLineKey);
    }

    QVariantList tmpData;
    int index;
    QJsonArray colData;

    // Add data
    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){
            tmpData.clear();

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->append(xAxisDataPointer->at(i));

                tmpData.append(xAxisDataPointer->at(i));
                tmpData.append(yLineAxisDataPointer->at(i).toFloat());
                tmpData.append(yBarAxisDataPointer->at(i).toFloat());

                colData.append(QJsonArray::fromVariantList(tmpData));
            } else{

                index = uniqueHashKeywords->indexOf(xAxisDataPointer->at(i));
                tmpData.append(colData.at(index).toArray().toVariantList());

                tmpData[1] = tmpData[1].toFloat() + yLineAxisDataPointer->at(i).toFloat();
                tmpData[2] = tmpData[2].toFloat() + yBarAxisDataPointer->at(i).toFloat();

                colData.replace(index, QJsonArray::fromVariantList(tmpData));

            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);
    columns.append(xSplitKey);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    emit signalLineBarChartValues(strData);
}

void ChartsThread::getPieChartValues()
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QJsonObject obj;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);

    // Fetch data here
    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){

        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);

    } else{
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
    }

    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->append(xAxisDataPointer->at(i));

                obj.insert(xAxisDataPointer->at(i), yAxisDataPointer->at(i).toFloat());
            } else{

                obj[xAxisDataPointer->at(i)] = obj[xAxisDataPointer->at(i)].toDouble() + yAxisDataPointer->at(i).toDouble();
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonDocument doc;
    doc.setObject(obj);

    QString strData = doc.toJson();

    emit signalPieChartValues(strData);
}

void ChartsThread::getFunnelChartValues()
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QJsonArray axisDataArray;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    // Fetch data here


    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
    } else {
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
    }

    QStringList xAxisData;
    QStringList yAxisData;

    QJsonObject obj;
    int index;

    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            obj.empty();

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->append(xAxisDataPointer->at(i));

                obj.insert("key", xAxisDataPointer->at(i));
                obj.insert("value", yAxisDataPointer->at(i).toDouble());
                axisDataArray.append(obj);

            } else{

                index = uniqueHashKeywords->indexOf(xAxisDataPointer->at(i));
                obj = axisDataArray[index].toObject();
                obj["value"] = obj.value("value").toDouble() + yAxisDataPointer->at(i).toDouble();

                axisDataArray.replace(index, obj);
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    data.append(axisDataArray);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    emit signalFunnelChartValues(strData);
}

void ChartsThread::getRadarChartValues()
{

    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QJsonArray axisDataArray;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);


    // Fetch data here

    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
    } else {
        *xAxisDataPointer = reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = reportChartData.value(this->reportId).value(yKey);
    }

    QStringList xAxisData;
    QStringList yAxisData;

    QJsonObject obj;
    int index;

    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            obj.empty();

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->append(xAxisDataPointer->at(i));

                obj.insert("axis", xAxisDataPointer->at(i));
                obj.insert("value", yAxisDataPointer->at(i).toDouble());
                axisDataArray.append(obj);

            } else{

                index = uniqueHashKeywords->indexOf(xAxisDataPointer->at(i));
                obj = axisDataArray[index].toObject();
                obj["value"] = obj.value("value").toDouble() + yAxisDataPointer->at(i).toDouble();

                axisDataArray.replace(index, obj);
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    data.append(axisDataArray);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    emit signalRadarChartValues(strData);
}

void ChartsThread::getScatterChartValues()
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordList;
    QString masterKeyword;
    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;

    // Fetch data here

    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );
    int splitKey = this->headerMap.key( xSplitKey );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
        *splitDataPointer = this->dashboardChartData.value(this->dashboardId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(xKey));
        splitDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(splitKey));
    } else {
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
        *splitDataPointer = this->reportChartData.value(this->reportId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->reportChartData.value(this->reportId).value(xKey));
        splitDataPointerPre = (this->reportChartData.value(this->reportId).value(splitKey));
    }

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;


    // Populate the actual data
    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            masterKeyword = xAxisDataPointer->at(i) + splitDataPointer->at(i);
            tmpData.clear();
            yAxisTmpData = 0.0;

            if(!uniqueHashKeywords->contains(masterKeyword)){
                uniqueHashKeywords->append(masterKeyword);

                tmpData.append(yAxisDataPointer->at(i).toFloat());
                tmpData.append(splitDataPointer->at(i));
                tmpData.append(xAxisDataPointer->at(i));

                colData.append(QJsonArray::fromVariantList(tmpData));
            } else{

                index = uniqueHashKeywords->indexOf(masterKeyword);
                yAxisTmpData =  colData.at(index).toArray().at(0).toDouble() + yAxisDataPointer->at(i).toDouble();

                tmpData.append(yAxisTmpData);
                tmpData.append(splitDataPointer->at(i));
                tmpData.append(xAxisDataPointer->at(i));

                colData.replace(index, QJsonArray::fromVariantList(tmpData));
            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonArray columns;
    columns.append(yAxisColumn);
    columns.append(xSplitKey);
    columns.append(xAxisColumn);


    data.append(colData);
    data.append(columns);
    data.append(QJsonArray::fromStringList(xAxisDataPointerPre));


    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    emit signalScatterChartValues(strData);
}

void ChartsThread::getHeatMapChartValues()
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordList;
    QString masterKeyword;
    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;

    // Fetch data here

    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );
    int splitKey = this->headerMap.key( xSplitKey );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){

        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
        *splitDataPointer = this->dashboardChartData.value(this->dashboardId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(xKey));
        splitDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(splitKey));
    } else {

        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
        *splitDataPointer = this->reportChartData.value(this->reportId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->reportChartData.value(this->reportId).value(xKey));
        splitDataPointerPre = (this->reportChartData.value(this->reportId).value(splitKey));
    }

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;


    // Populate the actual data
    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){

            masterKeyword = xAxisDataPointer->at(i) + splitDataPointer->at(i);
            tmpData.clear();
            yAxisTmpData = 0.0;

            if(!masterKeywordList.contains(masterKeyword)){
                masterKeywordList.append(masterKeyword);

                try{
                    tmpData.append(xAxisDataPointer->at(i));
                    tmpData.append(splitDataPointer->at(i));
                    tmpData.append(yAxisDataPointer->at(i).toDouble());

                    colData.append(QJsonArray::fromVariantList(tmpData));
                } catch(std::exception &e){
                    qDebug() << "C1" << e.what();
                }

            } else{

                index = masterKeywordList.indexOf(masterKeyword);
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

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    emit signalHeatMapChartValues(strData);
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
    Q_ASSERT(!this->newChartHeader.empty());

    QStringList calculateColumnPointer;
    int calculateColumnKey = this->headerMap.key( calculateColumn );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        calculateColumnPointer = this->dashboardChartData.value(this->dashboardId).value(calculateColumnKey);
    } else {
        calculateColumnPointer = this->reportChartData.value(this->reportId).value(calculateColumnKey);
    }
    float output = 0.0;

    try{
        for(int i = 0; i < calculateColumnPointer.length(); i++){

            output += calculateColumnPointer.at(i).toFloat();
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    emit signalGaugeChartValues(output);
}

void ChartsThread::getSankeyChartValues()
{
    Q_ASSERT(!this->newChartHeader.empty());

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

    // Fetch data here

    int sourceKey = this->headerMap.key( sourceColumn );
    int destinationKey = this->headerMap.key( destinationColumn );
    int measureKey = this->headerMap.key( measureColumn );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){

        *sourceDataPointer = this->dashboardChartData.value(this->dashboardId).value(sourceKey);
        *destinationDataPointer = this->dashboardChartData.value(this->dashboardId).value(destinationKey);
        *measureDataPointer = this->dashboardChartData.value(this->dashboardId).value(measureKey);

    } else {
        *sourceDataPointer = this->reportChartData.value(this->reportId).value(sourceKey);
        *destinationDataPointer = this->reportChartData.value(this->reportId).value(destinationKey);
        *measureDataPointer = this->reportChartData.value(this->reportId).value(measureKey);
    }

    QStringList combinedList;
    combinedList.append(*sourceDataPointer);
    combinedList.append(*destinationDataPointer);
    combinedList.removeDuplicates();

    int index;

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
    QString strJson(doc.toJson(QJsonDocument::Compact));

    emit signalSankeyChartValues(strJson);

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
    Q_ASSERT(!this->newChartHeader.empty());

    int calculateColumnKey = this->headerMap.key( calculateColumn );
    QScopedPointer<QStringList> calculateColumnPointer(new QStringList);

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        *calculateColumnPointer = this->dashboardChartData.value(this->dashboardId).value(calculateColumnKey);
    } else {
        *calculateColumnPointer = this->reportChartData.value(this->reportId).value(calculateColumnKey);
    }
    float output = 0.0;

    try{
        for(int i = 0; i < calculateColumnPointer->length(); i++){

            output += calculateColumnPointer->at(i).toFloat();
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    emit signalKPIChartValues(output);
}

void ChartsThread::getTableChartValues()
{
    this->getTablePivotValues(xAxisColumnList, yAxisColumnList, "getTableChartValues");
}

void ChartsThread::getPivotChartValues()
{
    this->getTablePivotValues(xAxisColumnList, yAxisColumnList, "getPivotChartValues");
}

void ChartsThread::getStackedAreaChartValues()
{
    this->getStackedBarAreaValues(xAxisColumn, yAxisColumn, xSplitKey, "getStackedAreaChartValues");
}

void ChartsThread::getMultiLineChartValues()
{

    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordList;
    QString masterKeyword;
    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;

    // Fetch data here
    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );
    int splitKey = this->headerMap.key( xSplitKey );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
        *splitDataPointer = this->dashboardChartData.value(this->dashboardId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(xKey));
        splitDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(splitKey));
    } else {
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
        *splitDataPointer = this->reportChartData.value(this->reportId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->reportChartData.value(this->reportId).value(xKey));
        splitDataPointerPre = (this->reportChartData.value(this->reportId).value(splitKey));
    }

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;

    // Pre - Populate the json array
    try{
        for(int i = 0; i < xAxisDataPointerPre.length(); i++){

            for(int j = 0; j < splitDataPointerPre.length(); j++){

                masterKeyword = xAxisDataPointerPre.at(i) + splitDataPointerPre.at(j);

                masterKeywordList.append(masterKeyword);

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

            index = masterKeywordList.indexOf(masterKeyword);
            yAxisTmpData =  colData.at(index).toArray().at(2).toDouble() + yAxisDataPointer->at(i).toDouble();

            tmpData.append(xAxisDataPointer->at(i));
            tmpData.append(splitDataPointer->at(i));
            tmpData.append(yAxisTmpData);

            colData.replace(index, QJsonArray::fromVariantList(tmpData));

        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(xSplitKey);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(QJsonArray::fromStringList(xAxisDataPointerPre));
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    emit signalMultiLineChartValues(strData);
}

void ChartsThread::getLineAreaWaterfallValues(QString &xAxisColumn, QString &yAxisColumn, QString identifier)
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    // Fetch data here

    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
    } else {
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
    }

    QVariantList tmpData;
    int index;
    QJsonArray colData;

    try{
        for(int i = 0; i < xAxisDataPointer->length(); i++){
            tmpData.clear();

            if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
                uniqueHashKeywords->append(xAxisDataPointer->at(i));

                tmpData.append(xAxisDataPointer->at(i));
                tmpData.append(yAxisDataPointer->at(i).toFloat());

                colData.append(QJsonArray::fromVariantList(tmpData));
            } else{

                index = uniqueHashKeywords->indexOf(xAxisDataPointer->at(i));
                tmpData.append(colData.at(index).toArray().toVariantList());

                tmpData[1] = tmpData[1].toFloat() + yAxisDataPointer->at(i).toFloat();
                colData.replace(index, QJsonArray::fromVariantList(tmpData));

            }
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    if(identifier == "getAreaChartValues"){
        emit signalAreaChartValues(strData);
    } else if(identifier == "getLineChartValues"){
        emit signalLineChartValues(strData);
    } else if(identifier == "getWaterfallChartValues"){
        emit signalWaterfallChartValues(strData);
    } else {
        emit signalLineAreaWaterfallValues(strData);
    }


}

void ChartsThread::getTreeSunburstValues(QVariantList & xAxisColumn, QString & yAxisColumn, QString identifier)
{

    Q_ASSERT(!this->newChartHeader.empty());

    int pointerSize;

    QJsonArray data;
    QJsonArray axisArray;
    json output(json_array_arg);
    json emptyJsonArray(json_array_arg);
    QMap<QString, int> positions;
    QMap<int, QString> pastHashKeyword;
    long measure = 0;
    int total = 0;

    json *jsonPointer = new json;
    json *jsonPointerMeasure = new json;
    QScopedPointer<QMap<QString, long>> totalCount(new QMap<QString, long>);

    // masterHash will be used to compare if any map has been generated earlier
    // if there is an exact match with the hash, then it exists. Else create a new hash
    QScopedPointer<QStringList> masterHash(new QStringList);


    int yKeyLoop = 0;
    QString paramName = "";
    QString hashKeyword = "";

    // Fetch data here
    int xKey ;
    xKey = this->headerMap.key( xAxisColumn.at(0).toString() );

    int yKey = this->headerMap.key( yAxisColumn );

    // Group name operations
    QVector<int> groupKeyValues;
    int groupKeySize = xAxisColumn.length();

    for(int i = 0; i < groupKeySize; i++){
        groupKeyValues.append(this->headerMap.key(xAxisColumn.at(i).toString()));
    }

    int totalData;
    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
        totalData = (this->dashboardChartData.value(this->dashboardId).value(xKey)).length();
    } else {
        totalData = (this->reportChartData.value(this->reportId).value(xKey)).length();
    }


    // Considering the measure as string here to avoid unwanted errors in wrong casting
    // The front in javascript can easily handle this

    try{
        for(int i = 0; i < totalData; i++){

            if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
                measure = (this->dashboardChartData.value(this->dashboardId).value(yKey)).at(i).toFloat();
            } else {
                measure = (this->reportChartData.value(this->reportId).value(yKey)).at(i).toFloat();
            }

            json tmpOutput;
            pastHashKeyword.clear();

            for(int j = 0; j < groupKeySize; j++){

                yKeyLoop = this->headerMap.key( xAxisColumn.at(j).toString());

                if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
                    paramName = this->dashboardChartData.value(this->dashboardId).value(yKeyLoop).at(i);
                } else {
                    paramName = this->reportChartData.value(this->reportId).value(yKeyLoop).at(i);
                }

                // Generate unique hash to strings to be stored in master hash
                if( j == 0){
                    hashKeyword.clear();
                    hashKeyword = paramName;
                } else{
                    hashKeyword.append(paramName);
                }


                // If the hash doesnt exist, add to hash
                if(!masterHash->contains(hashKeyword, Qt::CaseSensitive)){
                    masterHash->append(hashKeyword);
                    totalCount->insert(hashKeyword, measure);

                    tmpOutput["name"] = paramName.toStdString();
                    tmpOutput["size"] = measure;
                    tmpOutput["children"] = emptyJsonArray;

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

                    long newValue = totalCount->value(hashKeyword) + measure;
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

    QString s = output.to_string().c_str();
    QJsonDocument d = QJsonDocument::fromJson(s.toUtf8());

    QJsonObject obj;
    obj.insert("name", yAxisColumn);
    obj.insert("size", total);
    obj.insert("children", d.array());


    QJsonDocument doc(obj);

    if(identifier == "getSunburstChartValues"){
        emit signalSunburstChartValues(s);
    } else if(identifier == "getTreeChartValues"){
        emit signalTreeChartValues(s);
    } else if(identifier == "getTreeMapChartValues"){
        emit signalTreeMapChartValues(s);
    } else {
        emit signalTreeSunburstValues(s);
    }
}

void ChartsThread::getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey, QString identifier)
{

    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordList;
    QString masterKeyword;
    QStringList xAxisDataPointerPre;
    QStringList splitDataPointerPre;

    // Fetch data here


    int xKey = this->headerMap.key( xAxisColumn );
    int yKey = this->headerMap.key( yAxisColumn );
    int splitKey = this->headerMap.key( xSplitKey );

    if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){

        *xAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(xKey);
        *yAxisDataPointer = this->dashboardChartData.value(this->dashboardId).value(yKey);
        *splitDataPointer = this->dashboardChartData.value(this->dashboardId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(xKey));
        splitDataPointerPre = (this->dashboardChartData.value(this->dashboardId).value(splitKey));

    } else {
        *xAxisDataPointer = this->reportChartData.value(this->reportId).value(xKey);
        *yAxisDataPointer = this->reportChartData.value(this->reportId).value(yKey);
        *splitDataPointer = this->reportChartData.value(this->reportId).value(splitKey);

        // To pre-populate json array
        xAxisDataPointerPre = (this->reportChartData.value(this->reportId).value(xKey));
        splitDataPointerPre = (this->reportChartData.value(this->reportId).value(splitKey));
    }

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;

    // Pre - Populate the json array
    try{
        for(int i = 0; i < xAxisDataPointerPre.length(); i++){

            for(int j = 0; j < splitDataPointerPre.length(); j++){

                masterKeyword = xAxisDataPointerPre.at(i) + splitDataPointerPre.at(j);

                masterKeywordList.append(masterKeyword);

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

            index = masterKeywordList.indexOf(masterKeyword);
            yAxisTmpData =  colData.at(index).toArray().at(2).toDouble() + yAxisDataPointer->at(i).toDouble();

            tmpData.append(xAxisDataPointer->at(i));
            tmpData.append(splitDataPointer->at(i));
            tmpData.append(yAxisTmpData);

            colData.replace(index, QJsonArray::fromVariantList(tmpData));

        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QJsonArray columns;
    columns.append(xSplitKey);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(QJsonArray::fromStringList(xAxisDataPointerPre));
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    if(identifier == "getStackedBarChartValues"){
        emit signalStackedBarChartValues(strData);
    } else if(identifier == "getStackedAreaChartValues") {
        emit signalStackedAreaChartValues(strData);
    } else{
        emit signalStackedBarAreaValues(strData);
    }

}

void ChartsThread::getTablePivotValues(QVariantList &xAxisColumn, QVariantList &yAxisColumn, QString identifier)
{
    Q_ASSERT(!this->newChartHeader.empty());

    QJsonArray data;
    QString masterKeyword;
    QVariantList masterTotal;
    QVariantList masterOutput;

    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QMap<int, QStringList>> xAxisDataPointer(new  QMap<int, QStringList>);
    QScopedPointer<QMap<int, QStringList>> yAxisDataPointer(new  QMap<int, QStringList>);

    // Fetch data here
    QVector<int> xKey;
    QVector<int> yKey;

    int xAxisLength;
    int yAxisLength;

    xAxisLength = xAxisColumn.length();
    yAxisLength = yAxisColumn.length();

    QJsonArray columns;

    try{
        for(int i = 0; i < xAxisLength; i++){
            xKey.append(this->headerMap.key( xAxisColumn.at(i).toString()));
            if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
                xAxisDataPointer->insert(i, this->dashboardChartData.value(this->dashboardId).value(xKey.at(i)));
            } else {
                xAxisDataPointer->insert(i, this->reportChartData.value(this->reportId).value(xKey.at(i)));
            }

            // Append to output columns -- all x axis names
            columns.append(xAxisColumn.at(i).toString());
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    try{
        for(int i = 0; i < yAxisLength; i++){
            yKey.append(this->headerMap.key( yAxisColumn.at(i).toString()));
            if(this->currentChartSource == this->chartSources.at(0) && dashboardFilterApplied){
                yAxisDataPointer->insert(i, this->dashboardChartData.value(this->dashboardId).value(yKey.at(i)));
            } else {
                yAxisDataPointer->insert(i, this->reportChartData.value(this->reportId).value(yKey.at(i)));
            }

            // Append to output columns -- all y axis names
            columns.append(yAxisColumn.at(i).toString());
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    QStringList xAxisData;
    QStringList yAxisData;
    int index;

    QVariantList tmpData;
    QJsonArray colData;


    // Actual values
    try{
        for(int i = 0; i < xAxisDataPointer->value(0).length(); i++){

            tmpData.clear();
            masterKeyword.clear();

            for(int j = 0; j < xAxisLength; j++){
                masterKeyword.append(xAxisDataPointer->value(j).at(i));
            }


            if(!uniqueHashKeywords->contains(masterKeyword)){
                uniqueHashKeywords->append(masterKeyword);

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

                index = uniqueHashKeywords->indexOf(masterKeyword);
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


    data.append(colData);
    data.append(QJsonArray::fromVariantList(masterOutput));
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    if(identifier == "getTableChartValues"){
        emit signalTableChartValues(strData);
    } else if(identifier == "getPivotChartValues"){
        emit signalPivotChartValues(strData);
    } else {
        emit signalTablePivotValues(strData);
    }

}

void ChartsThread::setChartSource(QString sourceType, QVariant currentSelectedTypeId, bool dashboardFilterApplied)
{
    if(sourceType == this->chartSources.at(0)){

        this->currentChartSource = this->chartSources.at(0);
        this->dashboardId = currentSelectedTypeId.toInt();
        this->dashboardFilterApplied = dashboardFilterApplied;
    } else {

        this->currentChartSource = this->chartSources.at(1);
        this->reportId = currentSelectedTypeId.toInt();
        this->dashboardFilterApplied = false;
    }

    qDebug() << "Typer CURR INFO" << this->currentChartSource << currentSelectedTypeId << this->dashboardFilterApplied;
}

void ChartsThread::receiveHeaders(QMap<int, QStringList> newChartHeader)
{
//    qDebug() << "HEADERS" << newChartHeader;
    this->newChartHeader = newChartHeader;

    QList<int> keyList = this->newChartHeader.keys();

    foreach(int key, keyList){
        headerMap.insert(key, this->newChartHeader.value(key).at(0));
    }
}

void ChartsThread::receiveReportData(QMap<int, QMap<int, QStringList>> newChartData, int currentReportId)
{
//    qDebug() << "REPORT DATA" << newChartData;
    this->reportChartData = newChartData;
    this->reportId = currentReportId;
    this->currentChartSource = this->chartSources.at(1); // report
}

void ChartsThread::receiveDashboardData(QMap<int, QMap<int, QStringList>> newChartData, int currentDashboardId)
{
    qDebug() << "DASHBOARD DATA" << newChartData;
    this->dashboardChartData = newChartData;
    this->dashboardId = currentDashboardId;
    this->currentChartSource = this->chartSources.at(0); // dashboard
}