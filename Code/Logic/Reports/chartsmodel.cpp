#include "chartsmodel.h"

ChartsModel::ChartsModel(QObject *parent) : QObject(parent)
{

}

QString ChartsModel::getBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    QJsonArray colData;
    colData.append(QJsonArray::fromStringList(*newChartData.value(xKey)));
    colData.append(QJsonArray::fromStringList(*newChartData.value(yKey)));

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

QString ChartsModel::getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType, QString groupedBy)
{

    QJsonArray data;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    QJsonArray colData;
    colData.append(QJsonArray::fromStringList(*newChartData.value(xKey)));
    colData.append(QJsonArray::fromStringList(*newChartData.value(yKey)));

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

QString ChartsModel::getSunburstChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{

    QJsonArray data;
    QJsonArray axisArray;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    // Group name operations
    QVector<int> groupKeyValues;
    int groupKeySize = groupNames.length();

    for(int i = 0; i < groupKeySize; i++){
        groupKeyValues.append(newChartHeader.key(groupNames.at(i)));
    }

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){
        QJsonObject axisData;
        axisData.insert("name", (*newChartData.value(xKey)).at(i));
        axisData.insert("size", (*newChartData.value(yKey)).at(i));
        axisArray.append(axisData);

    }

    QJsonObject colData;
    colData.insert("name", groupNames.at(0));
    colData.insert("children", axisArray);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
    return "";
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

QString ChartsModel::getGaugeChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    return "";
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

QString ChartsModel::getTreeChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{

    return "";
}

QString ChartsModel::getTreeMapChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    QJsonArray data;
    QJsonArray axisArray;

    // Fetch data here
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    // Group name operations
    QVector<int> groupKeyValues;
    int groupKeySize = groupNames.length();

    for(int i = 0; i < groupKeySize; i++){
        groupKeyValues.append(newChartHeader.key(groupNames.at(i)));
    }

    int totalData = (*newChartData.value(xKey)).length();

    for(int i = 0; i < totalData; i++){
        QJsonObject axisData;
        axisData.insert("name", (*newChartData.value(xKey)).at(i));
        axisData.insert("size", (*newChartData.value(yKey)).at(i));
        axisArray.append(axisData);

    }

    QJsonObject colData;
    colData.insert("name", groupNames.at(0));
    colData.insert("children", axisArray);

    QJsonArray columns;
    columns.append(xAxisColumn);
    columns.append(yAxisColumn);

    data.append(colData);
    data.append(columns);

    QJsonDocument doc;
    doc.setArray(data);

    QString strData = doc.toJson();

    return strData;
    return "";
}

QString ChartsModel::getKPIChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    return "";
}

QString ChartsModel::getTableChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    return "";
}

QString ChartsModel::getPivotChartValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
{
    return "";
}

//QString ChartsModel::getParentChildValues(QStringList xAxisColumn, QString yAxisColumn)
QString ChartsModel::getParentChildValues()
{

    // [a,b,c]
    // [x,y,z]
    qDebug() << "CLICKED ME";
    QStringList xAxisColumn;
    QString yAxisColumn;
    int pointerSize;
    int tmpSize;

    xAxisColumn << "country" << "state" << "city" <<  "district";
    yAxisColumn = "population";

    QJsonArray data;
    QJsonArray axisArray;
    json output(json_array_arg);
    json emptyJsonArray(json_array_arg);
    QMap<QString, int> positions;
    QMap<int, QString> pastHashKeyword;
    long measure = 0;

    json *jsonPointer = new json;

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

    int yKeyLoop = 0;
    QString paramName = "";
    QString hashKeyword = "";

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

                // Check if first element of json is already there
                // If not, then add it
                if(j == 0){

                    tmpOutput["name"] = paramName.toStdString();
                    tmpOutput["size"] = measure;
                    tmpOutput["children"] = emptyJsonArray;

                    output.push_back(tmpOutput);
                    positions.insert(hashKeyword, output.size() - 1);
                    pastHashKeyword[0] = hashKeyword;


                } else{
                    tmpOutput["name"] = paramName.toStdString();
                    tmpOutput["size"] = measure;
                    tmpOutput["children"] = emptyJsonArray;


                    jsonPointer = &output;
                    for(int k =0; k < j; k++){

                        if(j - k == 1){
                            try{

                                jsonPointer->at(positions.value(pastHashKeyword.value(k))).at("children").push_back(tmpOutput);
                                pastHashKeyword.insert(j, hashKeyword);

                                pointerSize = jsonPointer->at(positions.value(pastHashKeyword.value(k))).at("children").size() - 1;
                                positions.insert(hashKeyword, pointerSize);
                            }catch (std::exception &e) {
                                qDebug() << "C2" << e.what()
                                         << k << jsonPointer->to_string().c_str()
                                         << pointerSize << pastHashKeyword.value(j) << positions.value(hashKeyword);
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
                    output.at(positions.value(hashKeyword)).at("size") = newValue;

                } else{

                }

            }

        }
    }

    qDebug() << output.to_string().c_str();
    return "";
}


void ChartsModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void ChartsModel::getChartHeader(QMap<int, QString> chartHeader)
{
    this->newChartHeader = chartHeader;
}
