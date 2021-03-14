#include "chartsmodel.h"

ChartsModel::ChartsModel(QObject *parent) : QObject(parent)
{

}

QString ChartsModel::getBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType)
{
    QJsonArray data;
    QJsonArray xAxisData;
    QJsonArray yAxisData;

// Fetch data here
    xAxisData = QJsonArray::fromStringList(*newChartData.value(0));
    yAxisData = QJsonArray::fromStringList(*newChartData.value(1));

    QJsonArray colData;
    colData.append(xAxisData);
    colData.append(yAxisData);


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
    qDebug() << "RECE" << *chartData.value(0) ;
    this->newChartData = chartData;
}

void ChartsModel::getChartHeader(QMap<int, QString> chartHeader)
{
    this->newChartHeader = chartHeader;
}
