#ifndef CHARTSMODEL_H
#define CHARTSMODEL_H

#include <QObject>
#include <QDebug>

#include "duckreportsds.h"
#include "jsoncons/json.hpp"
using namespace jsoncons;

class ChartsModel : public QObject
{
    Q_OBJECT
    QMap<int, QStringList *> newChartData;
    QMap<int, QString> newChartHeader;

public:
    explicit ChartsModel(QObject *parent = nullptr);

    Q_INVOKABLE QString getBarChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE QString getGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE QString getAreaChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getLineChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getPieChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getFunnelChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getRadarChartValues( QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType);
    Q_INVOKABLE QString getScatterChartValues( QString xAxisColumn, QString yAxisColumn, QString groupName);
    Q_INVOKABLE QString getHeatMapChartValues( QString xAxisColumn, QString yAxisColumn, QString groupName);

    Q_INVOKABLE QString getSunburstChartValues( QStringList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getWaterfallChartValues( QString xAxisColumn, QString yAxisColumn, QStringList groupNames);
    Q_INVOKABLE QString getGaugeChartValues(QString calculateColumn);
    Q_INVOKABLE QString getSankeyChartValues( QString xAxisColumn, QString yAxisColumn, QStringList groupNames);

    Q_INVOKABLE QString getTreeChartValues( QStringList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getTreeMapChartValues( QStringList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getKPIChartValues( QString calculateColumn);
    Q_INVOKABLE QString getTableChartValues( QString xAxisColumn, QString yAxisColumn, QStringList groupNames);
    Q_INVOKABLE QString getPivotChartValues( QString xAxisColumn, QString yAxisColumn, QStringList groupNames);

    Q_INVOKABLE QString getLineAreaValues( QString &xAxisColumn, QString &yAxisColumn);
    Q_INVOKABLE QString getTreeSunburstValues(QStringList &xAxisColumn, QString &yAxisColum);

public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QString> chartHeader);

signals:

};

#endif // CHARTSMODEL_H
