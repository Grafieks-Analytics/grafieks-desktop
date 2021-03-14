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
    int xKey = newChartHeader.key( xAxisColumn );
    int yKey = newChartHeader.key( yAxisColumn );

    xAxisData = QJsonArray::fromStringList(*newChartData.value(xKey));
    yAxisData = QJsonArray::fromStringList(*newChartData.value(yKey));

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
