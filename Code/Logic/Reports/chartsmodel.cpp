#include "chartsmodel.h"

ChartsModel::ChartsModel(QObject *parent) : QObject(parent)
{

}

QString ChartsModel::getBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QStringList *uniqueHashKeywords = new QStringList;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    QStringList *xAxisDataPointer = &(*newChartData.value(xKey));
    QStringList *yAxisDataPointer = &(*newChartData.value(yKey));

    QStringList xAxisData;
    QStringList yAxisData;

    int index;


    for(int i = 0; i < xAxisDataPointer->length(); i++){

        if(!uniqueHashKeywords->contains(xAxisDataPointer->at(i))){
            uniqueHashKeywords->append(xAxisDataPointer->at(i));

            xAxisData.append(xAxisDataPointer->at(i));
            yAxisData.append(yAxisDataPointer->at(i));
        } else{

            index = uniqueHashKeywords->indexOf(xAxisDataPointer->at(i));
            yAxisData[index] = QString::number(yAxisData[index].toFloat() + yAxisDataPointer->at(i).toFloat());

        }
    }

    QJsonArray colData;
    colData.append(QJsonArray::fromStringList(xAxisData));
    colData.append(QJsonArray::fromStringList(yAxisData));


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

    QJsonArray data;
    QStringList tmpData;
    float yAxisTmpData;

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordList;
    QString masterKeyword;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int splitKey = newChartHeader.key( xSplitKey );

    QStringList *xAxisDataPointer = &(*newChartData.value(xKey));
    QStringList *yAxisDataPointer = &(*newChartData.value(yKey));
    QStringList *splitDataPointer = &(*newChartData.value(splitKey));

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
            tmpData.append("0");

            colData.append(QJsonArray::fromStringList(tmpData));
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
        tmpData.append(QString::number(yAxisTmpData));

        colData.replace(index, QJsonArray::fromStringList(tmpData));

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

    delete xAxisDataPointer;
    delete yAxisDataPointer;
    delete splitDataPointer;

    return strData;
}

QString ChartsModel::getGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{

    QJsonArray data;
    QStringList tmpData;
    QVariantList tmpStringList;

    // Order of QMap - xAxisCol, SplitKey, Value
    QStringList masterKeywordXList;
    QStringList masterKeywordSplitList;
    QString masterKeywordX;
    QString masterKeywordSplit;


    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int splitKey = newChartHeader.key( xSplitKey );

    QStringList *xAxisDataPointer = &(*newChartData.value(xKey));
    QStringList *yAxisDataPointer = &(*newChartData.value(yKey));
    QStringList *splitDataPointer = &(*newChartData.value(splitKey));

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

            tmpData.append("0");
        }

        colData.append(QJsonArray::fromStringList(tmpData));
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

    delete xAxisDataPointer;
    delete yAxisDataPointer;
    delete splitDataPointer;

    return strData;

//    return "";
}

QString ChartsModel::getAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray colData;
    QJsonArray columns;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){

        QJsonArray axisData;
        axisData.append((*newChartData.value(xKey)).at(i));
        axisData.append((*newChartData.value(yKey)).at(i));

        colData.append(axisData);

    }
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;

}

QString ChartsModel::getLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray colData;
    QJsonArray columns;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){

        QJsonArray axisData;
        axisData.append((*newChartData.value(xKey)).at(i));
        axisData.append((*newChartData.value(yKey)).at(i));

        colData.append(axisData);

    }
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);


    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;
}

QString ChartsModel::getPieChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonObject obj;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){
        obj.insert((*newChartData.value(xKey)).at(i), (*newChartData.value(yKey)).at(i));
    }

    QJsonDocument doc;
    doc.setObject(obj);

    QString strData = doc.toJson();
    return strData;
}

QString ChartsModel::getFunnelChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray axisData;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){

        QJsonObject obj;

        obj.insert("key", (*newChartData.value(xKey)).at(i));
        obj.insert("value", (*newChartData.value(yKey)).at(i));
        axisData.append(obj);

    }

    data.append(axisData);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();
    return strData;
}

QString ChartsModel::getRadarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray axisArray;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){
        QJsonArray axisData;
        axisData.append((*newChartData.value(xKey)).at(i));
        axisData.append((*newChartData.value(yKey)).at(i));
        axisArray.append(axisData);
    }


    QJsonArray colData;
    colData.append(axisArray);

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

QString ChartsModel::getScatterChartValues(QString xAxisColumn, QString yAxisColumn, QString groupName)
{
    QJsonArray data;
    QJsonArray axisArray;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int groupNameKey = newChartHeader.key( groupName );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){
        QJsonArray axisData;
        axisData.append((*newChartData.value(xKey)).at(i));
        axisData.append((*newChartData.value(yKey)).at(i));
        axisData.append((*newChartData.value(groupNameKey)).at(i));
        axisArray.append(axisData);
    }

    qDebug() << axisArray << "Scatter";

    QJsonArray colData;
    colData.append(axisArray);

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

QString ChartsModel::getHeatMapChartValues(QString xAxisColumn, QString yAxisColumn, QString groupName)
{
    QJsonArray data;
    QJsonArray axisArray;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );
    int groupNameKey = newChartHeader.key( groupName );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){
        QJsonArray axisData;
        axisData.append((*newChartData.value(groupNameKey)).at(i));
        axisData.append((*newChartData.value(xKey)).at(i));
        axisData.append((*newChartData.value(yKey)).at(i));
        axisArray.append(axisData);
    }

    QJsonArray colData;
    colData.append(axisArray);

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

QString ChartsModel::getSunburstChartValues(QStringList xAxisColumn, QString yAxisColumn)
{

    QString output;
    output = this->getTreeSunburstValues(xAxisColumn, yAxisColumn);
    return output;
}

QString ChartsModel::getWaterfallChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    QJsonArray data;
    QJsonArray axisArray;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){
        QJsonArray axisData;
        axisData.append((*newChartData.value(xKey)).at(i));
        axisData.append((*newChartData.value(yKey)).at(i));
        axisArray.append(axisData);
    }

    qDebug() << "WATERFALL" << axisArray;

    QJsonArray colData;
    colData.append(axisArray);

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

QString ChartsModel::getGaugeChartValues(QString calculateColumn)
{
    int calculateColumnKey = newChartHeader.key( calculateColumn );
    QStringList *calculateColumnPointer = &(*newChartData.value(calculateColumnKey));
    float output = 0.0;

    for(int i = 0; i < calculateColumnPointer->length(); i++){

        output += calculateColumnPointer->at(i).toFloat();
    }
    qDebug() << output << "GAUGE";
    return QString::number(output);
}

QString ChartsModel::getSankeyChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    QJsonArray data;
    QJsonArray axisArray;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){
        QJsonObject axisData;
        axisData.insert("node", (*newChartData.value(xKey)).at(i));
        axisData.insert("name", (*newChartData.value(yKey)).at(i));
        axisArray.append(axisData);
    }

    qDebug() << "SANKEY" << axisArray;

    QJsonArray colData;
    colData.append(axisArray);

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

QString ChartsModel::getTreeChartValues(QStringList xAxisColumn, QString yAxisColumn)
{
    QString output;
    output = this->getTreeSunburstValues(xAxisColumn, yAxisColumn);
    return output;
}

QString ChartsModel::getTreeMapChartValues(QStringList xAxisColumn, QString yAxisColumn)
{
    QString output;
    output = this->getTreeSunburstValues(xAxisColumn, yAxisColumn);
    return output;
}

QString ChartsModel::getKPIChartValues(QString calculateColumn)
{

    int calculateColumnKey = newChartHeader.key( calculateColumn );
    QStringList *calculateColumnPointer = &(*newChartData.value(calculateColumnKey));
    float output = 0.0;

    for(int i = 0; i < calculateColumnPointer->length(); i++){

        output += calculateColumnPointer->at(i).toFloat();
    }
    qDebug() << output << "KPI";
    return QString::number(output);
}

QString ChartsModel::getTableChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    return "";
}

QString ChartsModel::getPivotChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    return "";
}

QString ChartsModel::getTreeSunburstValues(QStringList & xAxisColumn, QString & yAxisColumn)
{
    int pointerSize;

    QJsonArray data;
    QJsonArray axisArray;
    json output(json_array_arg);
    json emptyJsonArray(json_array_arg);
    QMap<QString, int> positions;
    QMap<int, QString> pastHashKeyword;
    long measure = 0;

    json *jsonPointer = new json;
    json *jsonPointerMeasure = new json;

    int yKeyLoop = 0;
    QString paramName = "";
    QString hashKeyword = "";

    // masterHash will be used to compare if any map has been generated earlier
    // if there is an exact match with the hash, then it exists. Else create a new hash
    QStringList *masterHash = new QStringList;

    //
    QMap<QString, long> *totalCount = new QMap<QString, long>;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn.at(0) );
    int yKey = newChartHeader.key( yAxisColumn );

    // Group name operations
    QVector<int> groupKeyValues;
    int groupKeySize = xAxisColumn.length();

    for(int i = 0; i < groupKeySize; i++){
        groupKeyValues.append(newChartHeader.key(xAxisColumn.at(i)));
    }

    int totalData = (*newChartData.value(xKey)).length();


    // Considering the measure as string here to avoid unwanted errors in wrong casting
    // The front in javascript can easily handle this

    for(int i = 0; i < totalData; i++){

        measure = (*newChartData.value(yKey)).at(i).toLong();

        json tmpOutput;
        pastHashKeyword.clear();

        for(int j = 0; j < groupKeySize; j++){

            yKeyLoop = newChartHeader.key( xAxisColumn.at(j));
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


void ChartsModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void ChartsModel::getChartHeader(QMap<int, QString> chartHeader)
{
    this->newChartHeader = chartHeader;
}
