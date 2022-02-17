#ifndef CHARTSMODEL_H
#define CHARTSMODEL_H

#include <QObject>
#include <QThread>
#include <QDebug>
#include <QApplication>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include <QSettings>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QNetworkAccessManager>

#include "chartsthread.h"
#include "chartsapithread.h"

class ChartsModel : public QObject
{
    Q_OBJECT
    ChartsThread *chartsThread;
    ChartsAPIThread *chartsAPIThread;
    QString threadName;
    QMap<int, QString> reportWhereConditions;
    QMap<int, QString> dashboardWhereConditions;

    QString originalSelectParams;
    QString originalWhereConditions;
    QString originalJoinConditions;
    QString originalMasterTable;

    int currentReportId;
    int currentDashboardId;
    int currentChartSource;

    QThread chartsThreadThread;
    QThread chartsAPIThreadThread;

    QString nullString;
    QVariantList nullList;

public:
    explicit ChartsModel(QObject *parent = nullptr, ChartsThread *chartsThread = nullptr, ChartsAPIThread *chartsAPIThread = nullptr);
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
    Q_INVOKABLE void getScatterChartNumericalValues(int reportId, int dashboardId, int chartSource,   QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getHeatMapChartValues(int reportId, int dashboardId, int chartSource,   QString xAxisColumn, QString yAxisColumn, QString xSplitKey);

    Q_INVOKABLE void getSunburstChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getWaterfallChartValues(int reportId, int dashboardId, int chartSource,   QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getGaugeChartValues(int reportId, int dashboardId, int chartSource,  QString calculateColumn);
    Q_INVOKABLE void getSankeyChartValues(int reportId, int dashboardId, int chartSource,  QString sourceColumn, QString destinationColumn, QString measureColumn);

    Q_INVOKABLE void getTreeChartValues(int reportId, int dashboardId, int chartSource,   QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getTreeMapChartValues(int reportId, int dashboardId, int chartSource,   QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE void getKPIChartValues(int reportId, int dashboardId, int chartSource,   QString calculateColumn);
    Q_INVOKABLE void getTableChartValues(int reportId, int dashboardId, int chartSource,   QVariantList xAxisColumn, QVariantList yAxisColumn, QString dateConversionParameters);
    Q_INVOKABLE void getPivotChartValues(int reportId, int dashboardId, int chartSource,   QVariantList xAxisColumn, QVariantList yAxisColumn, QString dateConversionParameters);
    Q_INVOKABLE void getStackedAreaChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE void getMultiLineChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey);

    Q_INVOKABLE void saveChartsModel();

private:
    void callThread();


public slots:
    void slotBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotStackedBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotGroupedBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotNewGroupedBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotAreaChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotLineChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotLineBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotPieChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotFunnelChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotRadarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotScatterChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotScatterChartNumericalValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotHeatMapChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotSunburstChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotWaterfallChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotGaugeChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotSankeyChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotTreeChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotTreeMapChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotKPIChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotTableChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotPivotChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotStackedAreaChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void slotMultiLineChartValues(QString output, int reportId, int dashboardId, int chartSource);

    void receiveReportConditions(QString whereConditions, int currentReportId);
    void receiveDashboardConditions(QString whereConditions, int currentDashboardId);
    void receiveOriginalConditions(QString selectParams, QString whereConditions, QString joinConditions, QString masterTable);
    void getExtractWhereParams(QJsonObject whereParams);

signals:

    void signalBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalStackedBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalGroupedBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalNewGroupedBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalAreaChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalLineChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalLineBarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalPieChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalFunnelChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalRadarChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalScatterChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalHeatMapChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalSunburstChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalWaterfallChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalGaugeChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalSankeyChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalTreeChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalTreeMapChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalKPIChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalTableChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalPivotChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalStackedAreaChartValues(QString output, int reportId, int dashboardId, int chartSource);
    void signalMultiLineChartValues(QString output, int reportId, int dashboardId, int chartSource);

    void sendWhereParams(QJsonObject whereParams);

};

#endif // CHARTSMODEL_H
