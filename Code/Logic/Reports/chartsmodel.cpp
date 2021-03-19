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

QString ChartsModel::getParentChildValues(QString xAxisColumn, QString yAxisColumn, QStringList groupNames)
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
}

void ChartsModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void ChartsModel::getChartHeader(QMap<int, QString> chartHeader)
{
    this->newChartHeader = chartHeader;
}
