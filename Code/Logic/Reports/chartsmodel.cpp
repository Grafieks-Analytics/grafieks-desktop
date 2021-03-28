#include "chartsmodel.h"

ChartsModel::ChartsModel(QObject *parent) : QObject(parent)
{

}

ChartsModel::~ChartsModel()
{
    newChartData.clear();
    newChartHeader.clear();
}

QString ChartsModel::getBarChartValues(QString xAxisColumn, QString yAxisColumn)
{
    QJsonArray data;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);

    QStringList xAxisData;
    QVariantList yAxisData;

    int index;


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

    return strData;
}

QString ChartsModel::getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    QString output;
    output = this->getStackedBarAreaValues(xAxisColumn, yAxisColumn, xSplitKey);
    return output;

}

QString ChartsModel::getGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{

    QJsonArray data;
    QVariantList tmpData;
    QVariantList tmpStringList;

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordXList;
    QStringList masterKeywordSplitList;
    QString masterKeywordX;
    QString masterKeywordSplit;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);


    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int splitKey = newChartHeader.key( xSplitKey );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);
    *splitDataPointer = *newChartData.value(splitKey);

    // To pre-populate json array
    QStringList xAxisDataPointerPre = (*newChartData.value(xKey));
    QStringList splitDataPointerPre = (*newChartData.value(splitKey));

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int xIndex;
    int splitIndex;
    QJsonArray colData;

    // Pre - Populate the json array
    for(int i = 0; i < xAxisDataPointerPre.length(); i++){

        tmpData.clear();
        for(int j = 0; j < splitDataPointerPre.length(); j++){

            tmpData.append(0);
        }

        colData.append(QJsonArray::fromVariantList(tmpData));
    }

    // Populate the actual data
    for(int i = 0; i < xAxisDataPointer->length(); i++){

        tmpData.clear();
        tmpStringList.clear();

        xIndex = xAxisDataPointerPre.indexOf(xAxisDataPointer->at(i));
        splitIndex = splitDataPointerPre.indexOf(splitDataPointer->at(i));

        tmpStringList.append(colData.at(xIndex).toArray().toVariantList());
        tmpStringList[splitIndex] = tmpStringList[splitIndex].toFloat() + yAxisDataPointer->at(i).toFloat();

        colData.replace(xIndex, QJsonArray::fromVariantList(tmpStringList));
    }

    data.append(colData);
    data.append(QJsonArray::fromStringList(xAxisDataPointerPre));
    data.append(QJsonValue::fromVariant(splitDataPointerPre));

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;

    //    return "";
}

QString ChartsModel::getAreaChartValues(QString xAxisColumn, QString yAxisColumn)
{
    QString output;
    output = this->getLineAreaWaterfallValues(xAxisColumn, yAxisColumn);
    return output;
}

QString ChartsModel::getLineChartValues(QString xAxisColumn, QString yAxisColumn)
{
    QString output;
    output = this->getLineAreaWaterfallValues(xAxisColumn, yAxisColumn);
    return output;
}

QString ChartsModel::getLineBarChartValues(QString xAxisColumn, QString yLineAxisColumn, QString yBarAxisColumn)
{

    QJsonArray data;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yBarAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yLineAxisDataPointer(new QStringList);

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yBarKey = newChartHeader.key( yBarAxisColumn );
    int yLineKey = newChartHeader.key( yLineAxisColumn );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yBarAxisDataPointer = *newChartData.value(yBarKey);
    *yLineAxisDataPointer = *newChartData.value(yLineKey);

    QVariantList tmpData;
    int index;
    QJsonArray colData;

    // Add data
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

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yLineAxisColumn);
    columns.append(yBarAxisColumn);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
}

QString ChartsModel::getPieChartValues(QString xAxisColumn, QString yAxisColumn)
{
    QJsonArray data;
    QJsonObject obj;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);

    for(int i = 0; i < xAxisDataPointer->length(); i++){

        if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
            uniqueHashKeywords->append(xAxisDataPointer->at(i));

            obj.insert(xAxisDataPointer->at(i), yAxisDataPointer->at(i).toFloat());
        } else{

            obj[xAxisDataPointer->at(i)] = obj[xAxisDataPointer->at(i)].toDouble() + yAxisDataPointer->at(i).toDouble();
        }
    }

    QJsonDocument doc;
    doc.setObject(obj);

    QString strData = doc.toJson();
    return strData;
}

QString ChartsModel::getFunnelChartValues(QString xAxisColumn, QString yAxisColumn)
{
    QJsonArray data;
    QJsonArray axisDataArray;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);

    QStringList xAxisData;
    QStringList yAxisData;

    QJsonObject obj;
    int index;

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

    data.append(axisDataArray);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;
}

QString ChartsModel::getRadarChartValues(QString xAxisColumn, QString yAxisColumn)
{
    QJsonArray data;
    QJsonArray axisDataArray;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);


    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);

    QStringList xAxisData;
    QStringList yAxisData;

    QJsonObject obj;
    int index;

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

    data.append(axisDataArray);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;
}

QString ChartsModel::getScatterChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
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

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int splitKey = newChartHeader.key( xSplitKey );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);
    *splitDataPointer = *newChartData.value(splitKey);

    // To pre-populate json array
    QStringList xAxisDataPointerPre = (*newChartData.value(xKey));
    QStringList splitDataPointerPre = (*newChartData.value(splitKey));

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;


    // Populate the actual data
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
            yAxisTmpData =  colData.at(index).toArray().at(0).toString().toFloat() + yAxisDataPointer->at(i).toFloat();

            tmpData.append(yAxisTmpData);
            tmpData.append(splitDataPointer->at(i));
            tmpData.append(xAxisDataPointer->at(i));

            colData.replace(index, QJsonArray::fromVariantList(tmpData));

        }

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
    return strData;
}

QString ChartsModel::getHeatMapChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordList;
    QString masterKeyword;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int splitKey = newChartHeader.key( xSplitKey );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);
    *splitDataPointer = *newChartData.value(splitKey);

    // To pre-populate json array
    QStringList xAxisDataPointerPre = (*newChartData.value(xKey));
    QStringList splitDataPointerPre = (*newChartData.value(splitKey));

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;

    // Pre - Populate the json array
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


    // Populate the actual data
    for(int i = 0; i < xAxisDataPointer->length(); i++){

        masterKeyword = xAxisDataPointer->at(i) + splitDataPointer->at(i);
        tmpData.clear();
        yAxisTmpData = 0.0;

        index = masterKeywordList.indexOf(masterKeyword);
        yAxisTmpData =  colData.at(index).toArray().at(2).toString().toFloat() + yAxisDataPointer->at(i).toFloat();

        tmpData.append(xAxisDataPointer->at(i));
        tmpData.append(splitDataPointer->at(i));
        tmpData.append(yAxisTmpData);

        colData.replace(index, QJsonArray::fromVariantList(tmpData));

    }

    QJsonArray columns;
    columns.append(QJsonArray::fromStringList(xAxisDataPointerPre));
    columns.append(QJsonArray::fromStringList(splitDataPointerPre));

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
}

QString ChartsModel::getSunburstChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{

    QString output;
    output = this->getTreeSunburstValues(xAxisColumn, yAxisColumn);
//    output = this->getSunburstChartValues2();
    return output;
}

QString ChartsModel::getWaterfallChartValues(QString xAxisColumn, QString yAxisColumn)
{
    QString output;
    output = this->getLineAreaWaterfallValues(xAxisColumn, yAxisColumn);
    return output;
}

float ChartsModel::getGaugeChartValues(QString calculateColumn)
{
    int calculateColumnKey = newChartHeader.key( calculateColumn );
    QStringList *calculateColumnPointer = &(*newChartData.value(calculateColumnKey));
    float output = 0.0;

    for(int i = 0; i < calculateColumnPointer->length(); i++){

        output += calculateColumnPointer->at(i).toFloat();
    }
    qDebug() << output << "GAUGE";
    return output;
}

QString ChartsModel::getSankeyChartValues(QString sourceColumn, QString destinationColumn, QString measureColumn)
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

    // Fetch data here
    int sourceKey = newChartHeader.key( sourceColumn );
    int destinationKey = newChartHeader.key( destinationColumn );
    int measureKey = newChartHeader.key( measureColumn );

    *sourceDataPointer = *newChartData.value(sourceKey);
    *destinationDataPointer = *newChartData.value(destinationKey);
    *measureDataPointer = *newChartData.value(measureKey);

    QStringList combinedList;
    combinedList.append(*sourceDataPointer);
    combinedList.append(*destinationDataPointer);
    combinedList.removeDuplicates();

    int index;

    // Master nodes list
    for(int i = 0; i < combinedList.length(); i++){

        nodeObject.empty();
        nodeObject.insert("node", i);
        nodeObject.insert("name", combinedList.at(i));

        nodeData.append(nodeObject);
        nodeIdMap.insert(i, combinedList.at(i));
    }

    // Master Data
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

    QJsonObject output;
    output.insert("nodes", nodeData);
    output.insert("links", data);


    QJsonDocument doc(output);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    return strJson;
}

QString ChartsModel::getTreeChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{
    QString output;
    output = this->getTreeSunburstValues(xAxisColumn, yAxisColumn);
    return output;
}

QString ChartsModel::getTreeMapChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{
    QString output;
    output = this->getTreeSunburstValues(xAxisColumn, yAxisColumn);
    return output;
}

float ChartsModel::getKPIChartValues(QString calculateColumn)
{

    int calculateColumnKey = newChartHeader.key( calculateColumn );
    QScopedPointer<QStringList> calculateColumnPointer(new QStringList);

    *calculateColumnPointer = *newChartData.value(calculateColumnKey);
    float output = 0.0;

    for(int i = 0; i < calculateColumnPointer->length(); i++){

        output += calculateColumnPointer->at(i).toFloat();
    }
    qDebug() << output << "KPI";
    return output;
}

QString ChartsModel::getTableChartValues(QVariantList xAxisColumn, QVariantList yAxisColumn)
{
    QJsonArray data;
    QString masterKeyword;
    float masterTotal = 0;

    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QMap<int, QStringList>> xAxisDataPointer(new  QMap<int, QStringList>);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    // Fetch data here
    QVector<int> xKey;
    int yKey = newChartHeader.key( yAxisColumn.at(0).toString() );

    *yAxisDataPointer = *newChartData.value(yKey);

    QJsonArray columns;

    for(int i = 0; i < xAxisColumn.length(); i++){
        xKey.append(newChartHeader.key( xAxisColumn.at(i).toString()));
        xAxisDataPointer->insert(i, *newChartData.value(xKey.at(i)));

        // Append to output columns -- all x axis names
        columns.append(xAxisColumn.at(i).toString());
    }

    // Append to output columns -- all y axis name
    columns.append(yAxisColumn.at(0).toString());

    QStringList xAxisData;
    QStringList yAxisData;
    int index;

    QVariantList tmpData;
    QJsonArray colData;

    int xAxisLength = xAxisColumn.length();


    // Actual values
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

            tmpData.append(yAxisDataPointer->at(i).toFloat());
            colData.append(QJsonArray::fromVariantList(tmpData));
            masterTotal += yAxisDataPointer->at(i).toFloat();

        } else{

            index = uniqueHashKeywords->indexOf(masterKeyword);
            tmpData.append(colData.at(index).toArray().toVariantList());

            tmpData[xAxisLength] = tmpData[xAxisLength].toFloat() + yAxisDataPointer->at(i).toFloat();
            colData.replace(index, QJsonArray::fromVariantList(tmpData));
            masterTotal += yAxisDataPointer->at(i).toFloat();
        }

    }

    // Grand total
    for(int i = 0; i < xAxisLength; i++){

    }


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
}

QString ChartsModel::getPivotChartValues(QString xAxisColumn, QString yAxisColumn, QVariantList groupNames)
{
    return "";
}

QString ChartsModel::getStackedAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    QString output;
    output = this->getStackedBarAreaValues(xAxisColumn, yAxisColumn, xSplitKey);
    return output;
}

QString ChartsModel::getMultiLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{

    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordList;
    QString masterKeyword;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int splitKey = newChartHeader.key( xSplitKey );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);
    *splitDataPointer = *newChartData.value(splitKey);

    // To pre-populate json array
    QStringList xAxisDataPointerPre = (*newChartData.value(xKey));
    QStringList splitDataPointerPre = (*newChartData.value(splitKey));

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;

    // Pre - Populate the json array
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


    // Populate the actual data
    for(int i = 0; i < xAxisDataPointer->length(); i++){

        masterKeyword = xAxisDataPointer->at(i) + splitDataPointer->at(i);
        tmpData.clear();
        yAxisTmpData = 0.0;

        index = masterKeywordList.indexOf(masterKeyword);
        yAxisTmpData =  colData.at(index).toArray().at(2).toString().toFloat() + yAxisDataPointer->at(i).toFloat();

        tmpData.append(xAxisDataPointer->at(i));
        tmpData.append(splitDataPointer->at(i));
        tmpData.append(yAxisTmpData);

        colData.replace(index, QJsonArray::fromVariantList(tmpData));

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

    return strData;
}

QString ChartsModel::getLineAreaWaterfallValues(QString &xAxisColumn, QString &yAxisColumn)
{
    QJsonArray data;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);

    QVariantList tmpData;
    int index;
    QJsonArray colData;

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

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;

}

QString ChartsModel::getTreeSunburstValues(QVariantList & xAxisColumn, QString & yAxisColumn)
{
    int pointerSize;

    xAxisColumn << "state" << "city" << "ward";
    yAxisColumn = "population";

    QJsonArray data;
    QJsonArray axisArray;
    json output(json_array_arg);
    json emptyJsonArray(json_array_arg);
    QMap<QString, int> positions;
    QMap<int, QString> pastHashKeyword;
    long measure = 0;

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
    int xKey = newChartHeader.key( xAxisColumn.at(0).toString() );
    int yKey = newChartHeader.key( yAxisColumn );

    // Group name operations
    QVector<int> groupKeyValues;
    int groupKeySize = xAxisColumn.length();

    for(int i = 0; i < groupKeySize; i++){
        groupKeyValues.append(newChartHeader.key(xAxisColumn.at(i).toString()));
    }

    int totalData = (*newChartData.value(xKey)).length();


    // Considering the measure as string here to avoid unwanted errors in wrong casting
    // The front in javascript can easily handle this

    for(int i = 0; i < totalData; i++){

        measure = (*newChartData.value(yKey)).at(i).toFloat();

        json tmpOutput;
        pastHashKeyword.clear();

        for(int j = 0; j < groupKeySize; j++){

            yKeyLoop = newChartHeader.key( xAxisColumn.at(j).toString());
            paramName = newChartData.value(yKeyLoop)->at(i);

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


    return output.to_string().c_str();
}

QString ChartsModel::getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey)
{

    QJsonArray data;
    QVariantList tmpData;
    float yAxisTmpData;

    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitDataPointer(new QStringList);

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordList;
    QString masterKeyword;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int splitKey = newChartHeader.key( xSplitKey );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);
    *splitDataPointer = *newChartData.value(splitKey);

    // To pre-populate json array
    QStringList xAxisDataPointerPre = (*newChartData.value(xKey));
    QStringList splitDataPointerPre = (*newChartData.value(splitKey));

    // Fetch unique xAxisData & splitter
    xAxisDataPointerPre.removeDuplicates();
    splitDataPointerPre.removeDuplicates();

    int index;
    QJsonArray colData;

    // Pre - Populate the json array
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


    // Populate the actual data
    for(int i = 0; i < xAxisDataPointer->length(); i++){

        masterKeyword = xAxisDataPointer->at(i) + splitDataPointer->at(i);
        tmpData.clear();
        yAxisTmpData = 0.0;

        index = masterKeywordList.indexOf(masterKeyword);
        yAxisTmpData =  colData.at(index).toArray().at(2).toString().toFloat() + yAxisDataPointer->at(i).toFloat();

        tmpData.append(xAxisDataPointer->at(i));
        tmpData.append(splitDataPointer->at(i));
        tmpData.append(yAxisTmpData);

        colData.replace(index, QJsonArray::fromVariantList(tmpData));

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

    return strData;
}


void ChartsModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void ChartsModel::getChartHeader(QMap<int, QString> chartHeader)
{
    this->newChartHeader = chartHeader;
}
