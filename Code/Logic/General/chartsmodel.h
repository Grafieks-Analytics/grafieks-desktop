#ifndef CHARTSMODEL_H
#define CHARTSMODEL_H

#include <QObject>
#include <QThread>
#include <QDebug>
#include <QApplication>

#include "chartsthread.h"

class ChartsModel : public QObject
{
    Q_OBJECT
    ChartsThread *chartsThread;
    QString threadName;

    QThread chartsThreadThread;
    QThread threadBarChartValues;
    QThread threadStackedBarChartValues;
    QThread threadGroupedBarChartValues;
    QThread threadNewGroupedBarChartValues;
    QThread threadAreaChartValues;
    QThread threadLineChartValues;
    QThread threadLineBarChartValues;
    QThread threadPieChartValues;
    QThread threadFunnelChartValues;
    QThread threadRadarChartValues;
    QThread threadScatterChartValues;
    QThread threadHeatMapChartValues;
    QThread threadSunburstChartValues;
    QThread threadWaterfallChartValues;
    QThread threadGaugeChartValues;
    QThread threadSankeyChartValues;
    QThread threadTreeChartValues;
    QThread threadTreeMapChartValues;
    QThread threadKPIChartValues;
    QThread threadTableChartValues;
    QThread threadPivotChartValues;
    QThread threadStackedAreaChartValues;
    QThread threadMultiLineChartValues;

    QString nullString;
    QVariantList nullList;

public:
    explicit ChartsModel(QObject *parent = nullptr, ChartsThread *chartsThread = nullptr);
    ~ChartsModel();

    Q_INVOKABLE void getBarChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getNewGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getAreaChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getLineChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getLineBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getPieChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getFunnelChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getRadarChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getScatterChartValues( QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getHeatMapChartValues( QString xAxisColumn, QString yAxisColumn, QString xSplitKey);

    Q_INVOKABLE void getSunburstChartValues(QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getWaterfallChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getGaugeChartValues(QString calculateColumn);
    Q_INVOKABLE void getSankeyChartValues(QString sourceColumn, QString destinationColumn, QString measureColumn);

    Q_INVOKABLE void getTreeChartValues( QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getTreeMapChartValues( QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getKPIChartValues( QString calculateColumn);
    Q_INVOKABLE void getTableChartValues( QVariantList xAxisColumn, QVariantList yAxisColumn);
    Q_INVOKABLE void getPivotChartValues( QVariantList xAxisColumn, QVariantList yAxisColumn);
    Q_INVOKABLE void getStackedAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey );
    Q_INVOKABLE void getMultiLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey );

private:
    void callThread();


public slots:
    void slotBarChartValues(QString output);
    void slotStackedBarChartValues(QString output);
    void slotGroupedBarChartValues(QString output);
    void slotNewGroupedBarChartValues(QString output);
    void slotAreaChartValues(QString output);
    void slotLineChartValues(QString output);
    void slotLineBarChartValues(QString output);
    void slotPieChartValues(QString output);
    void slotFunnelChartValues(QString output);
    void slotRadarChartValues(QString output);
    void slotScatterChartValues(QString output);
    void slotHeatMapChartValues(QString output);
    void slotSunburstChartValues(QString output);
    void slotWaterfallChartValues(QString output);
    void slotGaugeChartValues(float output);
    void slotSankeyChartValues(QString output);
    void slotTreeChartValues(QString output);
    void slotTreeMapChartValues(QString output);
    void slotKPIChartValues(float output);
    void slotTableChartValues(QString output);
    void slotPivotChartValues(QString output);
    void slotStackedAreaChartValues(QString output);
    void slotMultiLineChartValues(QString output);


signals:

    void signalBarChartValues(QString output);
    void signalStackedBarChartValues(QString output);
    void signalGroupedBarChartValues(QString output);
    void signalNewGroupedBarChartValues(QString output);
    void signalAreaChartValues(QString output);
    void signalLineChartValues(QString output);
    void signalLineBarChartValues(QString output);
    void signalPieChartValues(QString output);
    void signalFunnelChartValues(QString output);
    void signalRadarChartValues(QString output);
    void signalScatterChartValues(QString output);
    void signalHeatMapChartValues(QString output);
    void signalSunburstChartValues(QString output);
    void signalWaterfallChartValues(QString output);
    void signalGaugeChartValues(float output);
    void signalSankeyChartValues(QString output);
    void signalTreeChartValues(QString output);
    void signalTreeMapChartValues(QString output);
    void signalKPIChartValues(float output);
    void signalTableChartValues(QString output);
    void signalPivotChartValues(QString output);
    void signalStackedAreaChartValues(QString output);
    void signalMultiLineChartValues(QString output);


};

#endif // CHARTSMODEL_H
