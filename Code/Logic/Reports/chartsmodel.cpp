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
    qDebug() << "CLICKED ME";
    QStringList xAxisColumn;
    QString yAxisColumn;

    xAxisColumn << "country" << "state" << "district";
    yAxisColumn = "population";

    QJsonArray data;
    QJsonArray axisArray;
    json output(json_array_arg);
    QMap<QString, json> tmpJsonOutput;
    json emptyJsonArray(json_array_arg);
    QMap<QString, int> positions;

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
    long measure = 0;
for(int i = 0; i < 2; i++){
//    for(int i = 0; i < totalData; i++){

        measure = (*newChartData.value(yKey)).at(i).toLong();

        json tmpOutput;
        QString pastHashKeyword;
        json tmpJsonArray(json_array_arg);

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

                    tmpJsonArray.push_back(tmpOutput);
                    output.push_back(tmpOutput);
                    tmpJsonOutput.insert(hashKeyword, tmpJsonArray);
                    positions.insert(hashKeyword, 0);
                    pastHashKeyword = hashKeyword;


                } else{
                    tmpOutput["name"] = paramName.toStdString();
                    tmpOutput["size"] = measure;
                    tmpOutput["children"] = emptyJsonArray;

                    tmpJsonArray = tmpJsonOutput.value(pastHashKeyword).at(positions.value(pastHashKeyword)).at("children");
                    tmpJsonArray.push_back(tmpOutput);


                    json *jsonPointer = new json;
                    jsonPointer = &output;
                    for(int k =0; k < j; k++){

                        if(j - k == 1){
                            jsonPointer->at(positions.value(pastHashKeyword)).at("children").push_back(tmpOutput);
                        } else{
                            jsonPointer = &jsonPointer->at(positions.value(pastHashKeyword)).at("children");
                            positions.insert(hashKeyword, jsonPointer->size() - 1);
                            pastHashKeyword = hashKeyword;

                        }
                    }

                    tmpJsonOutput.insert(hashKeyword, tmpJsonArray);
                    positions.insert(hashKeyword, jsonPointer->size() - 1);
                    pastHashKeyword = hashKeyword;
                }

            } else{

                long newValue = totalCount->value(hashKeyword) + measure;
                totalCount->insert(hashKeyword, newValue);

                if(j == 0){
                    pastHashKeyword = hashKeyword;

                } else{
                    tmpOutput["name"] = paramName.toStdString();
                    tmpOutput["size"] = measure;
                    tmpOutput["children"] = emptyJsonArray;

                    tmpJsonArray = tmpJsonOutput.value(pastHashKeyword).at(positions.value(pastHashKeyword)).at("children");
                    tmpJsonArray.push_back(tmpOutput);

                    json *jsonPointer = new json;
                    jsonPointer = &output;
                    for(int k =0; k < j; k++){

                        if(j - k == 1){
                            jsonPointer->at(positions.value(pastHashKeyword)).at("children").push_back(tmpOutput);
                        } else{
                            jsonPointer = &jsonPointer->at(positions.value(pastHashKeyword)).at("children");
                            positions.insert(hashKeyword, jsonPointer->size() - 1);
                            pastHashKeyword = hashKeyword;
                        }
                    }
                    tmpJsonOutput.insert(hashKeyword, tmpJsonArray);
                    positions.insert(hashKeyword, jsonPointer->size() - 1);
                    pastHashKeyword = hashKeyword;
                }


            }

        }
    }

    qDebug() << output.to_string().c_str();
    return "";
}

void ChartsModel::testing()
{
    qDebug() << "TESTING TRAIN";
    // create an empty structure (null)
    json j;

    // add a number that is stored as double (note the implicit conversion of j to an object)
    j["pi"] = 3.141;

    //    // add a Boolean that is stored as bool
    j["happy"] = true;

    //    // add a string that is stored as std::string
    j["name"] = "Niels";

    //    // add another null object by passing nullptr
    //    j["nothing"] = nullptr;

    //    // add an object inside the object
    j["answer"]["everything"] = 42;
    j["answer"]["everything2"]["a"] = 11;
    //    j["answer"]["everything2"]["a"] = 21;
    j["answer"]["everything2"]["b"]["b1"] = 2;
    //    j["answer"]["everything2"]["b"]["b2"] = 3;

    json a = json::make_array(2,0); // angle brackets can be omitted when N = 1
    a[0] = j;
    a[1] = j;

    json b = a;

    json color_spaces(json_array_arg); // an empty array
    color_spaces.push_back(a);
    color_spaces.push_back("AdobeRGB");
    color_spaces.push_back("ProPhoto RGB");
    qDebug() <<color_spaces.size() << "SIZE1";

    json color_spaces1(json_array_arg); // an empty array
    json x;
    x["children"] = color_spaces1;

    qDebug() <<x.at("children").to_string().c_str() << "CORO";
    //    qDebug() <<a.to_string().c_str() << "TRAINING" << j.at("answer").at("everything").to_string().c_str() << j.contains("answer") << color_spaces.to_string().c_str();

}

void ChartsModel::finalTesting()
{
    json finale;

    finale.make_array(5,0);
    finale.push_back(1);
    finale.push_back(2);
    finale.push_back(3);
    finale.push_back(4);
}

void ChartsModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void ChartsModel::getChartHeader(QMap<int, QString> chartHeader)
{
    this->newChartHeader = chartHeader;
}
