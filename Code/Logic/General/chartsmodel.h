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
    QMap<int, QString> reportWhereConditions;
    QMap<int, QString> dashboardWhereConditions;

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

    Q_INVOKABLE void getBarChartValues(int reportId, int dashboardId, int chartSource, QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getStackedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getGroupedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getNewGroupedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getAreaChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getLineChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getLineBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getPieChartValues( int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getFunnelChartValues( int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getRadarChartValues( int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getScatterChartValues(int reportId, int dashboardId, int chartSource,   QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getHeatMapChartValues(int reportId, int dashboardId, int chartSource,   QString xAxisColumn, QString yAxisColumn, QString xSplitKey);

    Q_INVOKABLE void getSunburstChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getWaterfallChartValues(int reportId, int dashboardId, int chartSource,   QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getGaugeChartValues(int reportId, int dashboardId, int chartSource,  QString calculateColumn);
    Q_INVOKABLE void getSankeyChartValues(int reportId, int dashboardId, int chartSource,  QString sourceColumn, QString destinationColumn, QString measureColumn);

    Q_INVOKABLE void getTreeChartValues(int reportId, int dashboardId, int chartSource,   QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getTreeMapChartValues(int reportId, int dashboardId, int chartSource,   QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getKPIChartValues(int reportId, int dashboardId, int chartSource,   QString calculateColumn);
    Q_INVOKABLE void getTableChartValues(int reportId, int dashboardId, int chartSource,   QVariantList xAxisColumn, QVariantList yAxisColumn);
    Q_INVOKABLE void getPivotChartValues(int reportId, int dashboardId, int chartSource,   QVariantList xAxisColumn, QVariantList yAxisColumn);
    Q_INVOKABLE void getStackedAreaChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getMultiLineChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey);

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

    void receiveReportConditions(QString whereConditions, int currentReportId);
    void receiveDashboardConditions(QString whereConditions, int currentDashboardId);

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
