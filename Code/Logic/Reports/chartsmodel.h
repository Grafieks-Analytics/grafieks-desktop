#ifndef CHARTSMODEL_H
#define CHARTSMODEL_H

#include <QObject>
#include <QDebug>

#include "duckreportsds.h"
#include "sqlreportsds.h"

class ChartsModel : public QObject
{
    Q_OBJECT
    QMap<int, QStringList *> newChartData;
    QMap<int, QString> newChartHeader;

public:
    explicit ChartsModel(QObject *parent = nullptr);

    Q_INVOKABLE QString getBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType);
    Q_INVOKABLE QString getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType, QString groupedBy);
    Q_INVOKABLE QString getAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType);
    Q_INVOKABLE QString getLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType);
    Q_INVOKABLE QString getPieChartValues( QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType);
    Q_INVOKABLE QString getFunnelChartValues( QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType);
    Q_INVOKABLE QString getRadarChartValues( QString xAxisColumn, QString yAxisColumn, QString yAxisCalculationType);
    Q_INVOKABLE QString getScatterChartValues( QString xAxisColumn, QString yAxisColumn, QString xAxisCalculationType, QString yAxisCalculationType, QString groupedBy);
    Q_INVOKABLE QString getHeatMapChartValues( QString xAxisColumn, QString yAxisColumn, QString groupedBy);

public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QString> chartHeader);

signals:

};

#endif // CHARTSMODEL_H
