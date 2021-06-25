#include "chartsmodel.h"

ChartsModel::ChartsModel(QObject *parent) : QObject(parent)
{
}

ChartsModel::~ChartsModel()
{
}

QString ChartsModel::getBarChartValues(QString xAxisColumn, QString yAxisColumn)
{
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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

    return strData;
}

QString ChartsModel::getNewGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

    QJsonArray data;
    QJsonArray axisDataArray;
    QScopedPointer<QStringList> uniqueHashKeywords(new QStringList);
    QScopedPointer<QStringList> xAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> yAxisDataPointer(new QStringList);
    QScopedPointer<QStringList> splitKeyDataPointer(new QStringList);

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int splitKey = newChartHeader.key( xSplitKey );

    *xAxisDataPointer = *newChartData.value(xKey);
    *yAxisDataPointer = *newChartData.value(yKey);
    *splitKeyDataPointer = *newChartData.value(splitKey);

    QList<QString> *uniqueSplitKeyData;
    newChartData.value(splitKey)->removeDuplicates();
    uniqueSplitKeyData = newChartData.value(splitKey);

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
    columns.append(QJsonArray::fromStringList(*uniqueSplitKeyData));

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;
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
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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
    return strData;
}

QString ChartsModel::getFunnelChartValues(QString xAxisColumn, QString yAxisColumn)
{
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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
    return strData;
}

QString ChartsModel::getRadarChartValues(QString xAxisColumn, QString yAxisColumn)
{

    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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
    return strData;
}

QString ChartsModel::getScatterChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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
    return strData;
}

QString ChartsModel::getHeatMapChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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

    return strData;
}

QString ChartsModel::getSunburstChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{

    QString output;
    output = this->getTreeSunburstValues(xAxisColumn, yAxisColumn);
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
    if(newChartHeader.empty() || newChartData.empty()){
        return 0;
    }

    int calculateColumnKey = newChartHeader.key( calculateColumn );
    QStringList *calculateColumnPointer = &(*newChartData.value(calculateColumnKey));
    float output = 0.0;

    try{
        for(int i = 0; i < calculateColumnPointer->length(); i++){

            output += calculateColumnPointer->at(i).toFloat();
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }
    return output;
}

QString ChartsModel::getSankeyChartValues(QString sourceColumn, QString destinationColumn, QString measureColumn)
{
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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
    if(newChartHeader.empty() || newChartData.empty()){
        return 0;
    }

    int calculateColumnKey = newChartHeader.key( calculateColumn );
    QScopedPointer<QStringList> calculateColumnPointer(new QStringList);

    *calculateColumnPointer = *newChartData.value(calculateColumnKey);
    float output = 0.0;

    try{
        for(int i = 0; i < calculateColumnPointer->length(); i++){

            output += calculateColumnPointer->at(i).toFloat();
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }
    return output;
}

QString ChartsModel::getTableChartValues(QVariantList xAxisColumn, QVariantList yAxisColumn)
{

    QString output;
    output = this->getTablePivotValues(xAxisColumn, yAxisColumn);
    return output;
}

QString ChartsModel::getPivotChartValues(QVariantList xAxisColumn, QVariantList yAxisColumn)
{
    QString output;
    output = this->getTablePivotValues(xAxisColumn, yAxisColumn);
    return output;
}

QString ChartsModel::getStackedAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    QString output;
    output = this->getStackedBarAreaValues(xAxisColumn, yAxisColumn, xSplitKey);
    return output;
}

QString ChartsModel::getMultiLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{

    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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

    return strData;
}

QString ChartsModel::getLineAreaWaterfallValues(QString &xAxisColumn, QString &yAxisColumn)
{
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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

    return strData;

}

QString ChartsModel::getTreeSunburstValues(QVariantList & xAxisColumn, QString & yAxisColumn)
{

    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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
    try{
        xKey = newChartHeader.key( xAxisColumn.at(0).toString() );
    }
    catch(std::exception &e){
        qDebug() << e.what();
        return "{}";
    }

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

    try{
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
    return doc.toJson();
}

QString ChartsModel::getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey)
{

    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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

    return strData;
}

QString ChartsModel::getTablePivotValues(QVariantList &xAxisColumn, QVariantList &yAxisColumn)
{
    if(newChartHeader.empty() || newChartData.empty()){
        return "";
    }

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

    try{
        xAxisLength = xAxisColumn.length();
        yAxisLength = yAxisColumn.length();
    } catch(std::exception &e){
        qDebug() << "Pivot table error" << e.what();
        return "{}";
    }

    QJsonArray columns;

    try{
        for(int i = 0; i < xAxisLength; i++){
            xKey.append(newChartHeader.key( xAxisColumn.at(i).toString()));
            xAxisDataPointer->insert(i, *newChartData.value(xKey.at(i)));

            // Append to output columns -- all x axis names
            columns.append(xAxisColumn.at(i).toString());
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
    }

    try{
        for(int i = 0; i < yAxisLength; i++){
            yKey.append(newChartHeader.key( yAxisColumn.at(i).toString()));
            yAxisDataPointer->insert(i, *newChartData.value(yKey.at(i)));

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

    return strData;
}

void ChartsModel::removeTmpChartData()
{
    this->newChartData.clear();
    this->newChartHeader.clear();
    this->chartHeaderDetails.clear();

    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();

    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);
}

void ChartsModel::updateFilterData(QMap<int, QVariantMap> masterReportFilters, QString reportId)
{

    //    qDebug() << "MC" << masterReportFilters;
    // Copy newChartData to reportChartData before begining operations
    this->reportId = reportId;
    reportChartData.insert(this->reportId, newChartData);

    QList<int> keys = masterReportFilters.keys();

    int i = 0;
    foreach(QVariantMap filters, masterReportFilters){

        int filterId = keys[i];
        QString section = filters.value("section").toString();
        QString category = filters.value("category").toString();
        QString subCategory = filters.value("subCategory").toString();
        QString columnName = filters.value("columnName").toStringList().at(0);
        QString tableName = filters.value("columnName").toStringList().at(1);

        QStringList actualDateValues = filters.value("actualDateValues").toStringList();
        int dateFormat = filters.value("dateFormat").toInt();

        QString filterRelation = filters.value("filterRelation").toString();
        QString filterSlug = filters.value("filterSlug").toString();
        bool includeExclude = filters.value("includeExclude").toBool();
        bool includeNull = filters.value("includeNull").toBool();
        bool selectAll = filters.value("selectAll").toBool();

        QVariantList filterValue = filters.value("filterValue").toList();
        QStringList filterValueList =  filterValue.at(0).toString().split(",");

        i++;

        // Start the filter operations here
        QScopedPointer<QStringList> columnData(new QStringList);
        QScopedPointer<QStringList> tmpList(new QStringList);

        // Fetch data here
        int newKey = newChartHeader.key( columnName );
        *columnData = *reportChartData.value(reportId).value(newKey);

        // 1. For like relation
        // For date and categorical only
        if(filterSlug == Constants::slugLikeRelation){

            qDebug() << "FILTER HERE" << filterSlug << "LIKE REL 1";

            QStringList tmpValues;

            if(section == Constants::dateType){

                tmpValues = actualDateValues;
                if(subCategory == Constants::dateSubYear){

                    *tmpList = columnData->filter(tmpValues.at(0));

                } else if(subCategory == Constants::dateSubDay){

                    QDate dt1 = QDate::fromString(tmpValues.at(0), "yyyy-MM-dd");
                    foreach(QString tmpVal, *columnData){

                        QDate dt = this->convertToDateFormatTimeFromString(tmpVal, "date").toDate();
                        if(dt == dt1){
                            *tmpList = columnData->filter(tmpVal);
                        }
                    }
                } else {
                    *tmpList = *columnData;
                }

            } else{

                if(filterValueList.at(0) == "%"){

                    *tmpList = *columnData;
                } else{
                    foreach(QString tmpVal, filterValueList){
                        if(tmpList->indexOf(tmpVal) < 0) {
                            tmpList->append(tmpVal);
                        }
                    }
                }
            }

            *columnData = *tmpList;
        }

        // 2. Not like relation
        // Categorical & Date only
        else if(filterSlug == Constants::slugNotLikeRelation){

            qDebug() << "FILTER HERE" << filterSlug<< "NOT LIKE REL 2";

            if(filterValueList.at(0) == "%"){
                columnData->clear();
            } else{
                foreach(QString tmpVal, filterValueList){
                    columnData->removeAll(tmpVal);
                }
            }
        }

        // 3. In array relation
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugInRelation){

            qDebug() << "FILTER HERE" << filterSlug << "IN REL 3";

            if(section == Constants::dateType){

                foreach(QString tmpVal, actualDateValues){

                    if(tmpList->indexOf(tmpVal) < 0) {
                        tmpList->append(tmpVal);
                    }
                }
            } else{
                foreach(QString tmpVal, filterValueList){

                    if(tmpList->indexOf(tmpVal) < 0) {
                        tmpList->append(tmpVal);
                    }
                }
            }
            *columnData = *tmpList;

        }

        // 4. Equal to comparison
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "EQUAL REL 4";

            QString tmp = filterValueList.at(0);

            if(section == Constants::dateType){
                tmp = actualDateValues.at(0);
                if(columnData->indexOf(tmp) >= 0) {
                    tmpList->append(tmp);
                }
            } else{
                tmp = filterValueList.at(0);
                if(columnData->indexOf(tmp) >= 0) {
                    tmpList->append(tmp);
                }
            }
            *columnData = *tmpList;


        }

        // 5. Not equal comparison
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugNotEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "NOT EQUAL REL 5";

            columnData->removeAll(filterValueList.at(0));

        }

        // 6. Between relation
        // This condition is only for numerical and date
        else if(filterSlug == Constants::slugBetweenRelation){

            QStringList tmpValues;

            qDebug() << "FILTER HERE" << filterSlug << "BETWEEN REL 6" << filterValue;

            if(section == Constants::dateType){

                tmpValues = filterValue.at(0).toString().split(",");

                QDateTime dt1 = QDateTime::fromString(tmpValues.at(0), "dd/MM/yyyy");
                QDateTime dt2 = QDateTime::fromString(tmpValues.at(1), "dd/MM/yyyy");

                foreach(QString tmpVal, *columnData){

                    QDateTime dt = this->convertToDateFormatTimeFromString(tmpVal, "datetime").toDateTime();

                    if(dt > dt1 && dt < dt2){
                        tmpList->append(tmpVal);
                    }
                }

            } else{

                tmpValues = filterValueList.at(0).split(" And ");

                foreach(QString tmpVal, *columnData){
                    if(tmpVal.toDouble() > tmpValues.at(0).toDouble() && tmpVal.toDouble() < tmpValues.at(1).toDouble()){
                        if(tmpList->indexOf(columnData->filter(tmpVal)[0]) < 0) {
                            tmpList->append(tmpVal);
                        }
                    }
                }
            }

            *columnData = *tmpList;

        }

        // 7. For smaller than relation
        // Numerical only
        else if(filterSlug == Constants::slugSmallerThanRelation){

            qDebug() << "FILTER HERE" << filterSlug << "SMALLER THAN REL 7";

            foreach(QString tmpVal, *columnData){
                if(tmpVal.toFloat() < filterValueList.at(0).toFloat()){
                    if(tmpList->indexOf(columnData->filter(tmpVal)[0]) < 0) {
                        tmpList->append(tmpVal);
                    }
                }
            }

            *columnData = *tmpList;
        }

        // 8. For greater than relation
        // Numerical only
        else if(filterSlug == Constants::slugGreaterThanRelation){

            qDebug() << "FILTER HERE" << filterSlug << "GREATER THAN REL 8";

            foreach(QString tmpVal, *columnData){
                if(tmpVal.toFloat() > filterValueList.at(0).toFloat()){
                    if(tmpList->indexOf(tmpVal) < 0) {
                        tmpList->append(tmpVal);
                    }
                }
            }

            *columnData = *tmpList;
        }

        // 9. For smaller than and equal to relation
        // Numerical only
        else if(filterSlug == Constants::slugSmallerThanEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "SMALLER THAN EQUAL REL 9";

            foreach(QString tmpVal, *columnData){
                if(tmpVal.toFloat() <= filterValueList.at(0).toFloat()){
                    if(tmpList->indexOf(tmpVal) < 0) {
                        tmpList->append(tmpVal);
                    }
                }
            }

            *columnData = *tmpList;
        }

        // 10. For greater than and equal to relation
        // Numerical only
        else if(filterSlug == Constants::slugGreaterThanEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "GREATER THAN EQUAL REL 10";

            foreach(QString tmpVal, *columnData){
                if(tmpVal.toFloat() >= filterValueList.at(0).toFloat()){
                    if(tmpList->indexOf(tmpVal) < 0) {
                        tmpList->append(tmpVal);
                    }
                }
            }

            *columnData = *tmpList;

        }

        // 11. For containig relation
        // Categorical
        else if(filterSlug == Constants::slugContainingRelation){

            qDebug() << "FILTER HERE" << filterSlug << "CONTAINING REL 11";

            QString tmpVal = filterValueList.at(0);
            tmpVal.remove(0,1); // remove first "%"
            tmpVal.chop(1); // remove last "%"

            *tmpList = columnData->filter(tmpVal, Qt::CaseInsensitive);
            *columnData = *tmpList;

        }

        // 12. For Ends With relation
        // Categorical
        else if(filterSlug == Constants::slugEndsWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "ENDS With REL 12";

            QString tmp = filterValueList.at(0);
            tmp.remove(0,1); // remove first "%"

            foreach(QString tmpVal, *columnData){

                if(tmpVal.endsWith(tmp, Qt::CaseInsensitive)){
                    tmpList->append(tmpVal);
                }
            }
            *columnData = *tmpList;
        }

        // 13. For Doesnt Start With relation
        // Categorical
        else if(filterSlug == Constants::slugDoesntStartWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "Doenst start with REL 13";

            QString tmp = filterValueList.at(0);
            tmp.chop(1); // remove last "%"

            foreach(QString tmpVal, *columnData){

                if(tmpVal.startsWith(tmp, Qt::CaseInsensitive) == false){
                    tmpList->append(tmpVal);
                }
            }
            *columnData = *tmpList;
        }

        // 14. For Doesnt End With relation
        // Categorical
        else if(filterSlug == Constants::slugDoesntEndWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "Doenst end with REL 14";

            QString tmp = filterValueList.at(0);
            tmp.remove(0,1); // remove first "%"

            foreach(QString tmpVal, *columnData){

                if(tmpVal.endsWith(tmp, Qt::CaseInsensitive) == false){
                    tmpList->append(tmpVal);
                }
            }
            *columnData = *tmpList;
        }

        // 15. Filter
        else{

            qDebug() << "FILTER HERE" << filterSlug << "UNKNOWN REL";

            qDebug() << "Else Filter values obtained"
                        <<filterId << section << category << subCategory << columnName << actualDateValues << dateFormat
                       << filterRelation << filterSlug << filterValueList << includeExclude << includeNull << selectAll;
        }

        columnData->removeDuplicates();
        qDebug() << "Filtered Column Data" << *columnData;

    }
}

void ChartsModel::currentScreenChanged(int currentScreen)
{
    switch(currentScreen){
    case Constants::dashboardScreen:
        break;

    case Constants::reportScreen:
        break;

    default:
        break;
    }
}

QVariant ChartsModel::convertToDateFormatTimeFromString(QString stringDateFormat, QString outFormat)
{
    QStringList dateFormats;
    QDateTime dateTime;
    QDate dateOnly;
    QVariant out;
    bool status = false;

    // Custom formats
    dateFormats.append("yy");                           // 21
    dateFormats.append("yyyy");                         // 2012
    dateFormats.append("yyyy-MM-dd");                   // 2012-12-30
    dateFormats.append("dd.MM.yyyy");                   // 20.07.1969
    dateFormats.append("dd/MM/yyyy");                   // 20/07/69
    dateFormats.append("dd/MM/yyyy");                   // 20/07/1969
    dateFormats.append("ddd MMMM d yy");                // Sun July 20 69
    dateFormats.append("dddd");                         // Sunday

    // Other datetime parsing formats
    // Ref: https://help.sumologic.com/03Send-Data/Sources/04Reference-Information-for-Sources/Timestamps%2C-Time-Zones%2C-Time-Ranges%2C-and-Date-Formats
    dateFormats.append("hh:mm:ss");                     // 21:15:51
    dateFormats.append("yyyy-MM-dd hh:mm:ss");          // 2012-12-30 12:22:51
    dateFormats.append("yyyy-MM-ddThh:mm:ss");          // 2012-12-30T12:22:51
    dateFormats.append("yyyy-MM-ddThh:mm:ss.zzz");      // 2012-12-30T12:22:51.000
    dateFormats.append("yyyy-MM-ddThh:mm:ss.zzzZ");     // 2012-12-30T12:22:51.000


    foreach(QString format, dateFormats){

        if(QDateTime::fromString(stringDateFormat, format).isValid()){
            dateTime = QDateTime::fromString(stringDateFormat, format);
            status = true;
            out = dateTime;

            if(outFormat == "date"){

            }
        }

    }

    if(status == false){
        qDebug() << Q_FUNC_INFO << "Date conversion failed" << stringDateFormat;
    }

    return out;
}

void ChartsModel::searchColumnNames(QString keyword)
{
    emit sendFilteredColumn(this->categoryList.filter(keyword, Qt::CaseInsensitive), this->numericalList.filter(keyword, Qt::CaseInsensitive), this->dateList.filter(keyword, Qt::CaseInsensitive));
}

QStringList ChartsModel::fetchColumnData(QString columnName, QString options)
{
    // Fetch data here
    int key = newChartHeader.key( columnName );

    QStringList columnDataPointer = *newChartData.value(key);
    columnDataPointer.removeDuplicates();

    emit columnDataChanged(columnDataPointer, options);

    return columnDataPointer;
}

QStringList ChartsModel::searchColumnData(QString columnName, QString keyword)
{
    QStringList searchResults;
    int key = newChartHeader.key( columnName );

    QStringList columnDataPointer = *newChartData.value(key);
    columnDataPointer.removeDuplicates();
    searchResults = columnDataPointer.filter(keyword, Qt::CaseInsensitive);

    return searchResults;
}


void ChartsModel::clearData()
{

}


void ChartsModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void ChartsModel::getChartHeader(QMap<int, QStringList> chartHeader)
{
    this->chartHeaderDetails = chartHeader;
    qDebug() << "GOT CHART HEADER" << chartHeader;

    // Clear existing chart headers data
    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->newChartHeader.clear();

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
            qDebug() << "OTHER UNDETECTED FIELD TYPE" <<   chartHeader.value(key).at(0);
        }

        this->newChartHeader.insert(key, fullColumnName);
    }

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);
    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);
}
