#ifndef CHARTSTHREAD_H
#define CHARTSTHREAD_H

// ----------------------
// IMPORTANT
// ----------------------
// This class will be replaced ChartsWorker class in the future

#include <QObject>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QElapsedTimer>
#include <QFileInfo>

#include "jsoncons/json.hpp"
#include "../../constants.h"
#include "../../statics.h"

#include "../../duckdb.hpp"

using namespace jsoncons;

class ChartsThread : public QObject
{
    Q_OBJECT
    QMap<int, QStringList> newChartHeader;
    QMap<int, QString> headerMap;
//    QMap<int, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
//    QMap<int, QMap<int, QStringList>> dashboardChartData; // <DashboardId - <columnKey - Values Array list>>

    int dashboardId;
    int reportId;
    QStringList chartSources;
    QString currentChartSource;
    bool dashboardFilterApplied;
    QTime myTimer;
    QElapsedTimer myTimer2;

    QString xAxisColumn;
    QString yAxisColumn;
    QString xSplitKey;
    QVariantList xAxisColumnList;
    QVariantList yAxisColumnList;
    QString sourceColumn;
    QString destinationColumn;
    QString measureColumn;
    QString calculateColumn;

public:
    explicit ChartsThread(QObject *parent = nullptr);
    ~ChartsThread();

    void methodSelector(QString functionName = "");
    void setAxes(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey);
    void setLists(QVariantList &xAxisColumnList, QVariantList &yAxisColumnList);
    void setSankeyDetails(QString &sourceColumn, QString &destinationColumn, QString &measureColumn);
    void setGaugeKpiDetails(QString &calculateColumn);

public slots:

    void start();

    void getBarChartValues();
    void getStackedBarChartValues(); // getStackedBarAreaValues
    void getGroupedBarChartValues();
    void getNewGroupedBarChartValues();
    void getAreaChartValues(); // getLineAreaWaterfallValues
    void getLineChartValues(); // getLineAreaWaterfallValues
    void getLineBarChartValues();
    void getPieChartValues();
    void getFunnelChartValues();
    void getRadarChartValues();
    void getScatterChartValues();
    void getHeatMapChartValues();

    void getSunburstChartValues(); // getTreeSunburstValues
    void getWaterfallChartValues(); // getLineAreaWaterfallValues
    void getGaugeChartValues(); // float
    void getSankeyChartValues();

    void getTreeChartValues(); // getTreeSunburstValues
    void getTreeMapChartValues(); // getTreeSunburstValues
    void getKPIChartValues(); // float
    void getTableChartValues(); // getTablePivotValues
    void getPivotChartValues(); // getTablePivotValues
    void getStackedAreaChartValues(); // getStackedBarAreaValues
    void getMultiLineChartValues();

    void getLineAreaWaterfallValues( QString &xAxisColumn, QString &yAxisColumn, QString identifier = "");
    void getTreeSunburstValues(QVariantList &xAxisColumn, QString &yAxisColumn, QString identifier = "");
    void getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey, QString identifier = "");
    void getTablePivotValues(QVariantList &xAxisColumn, QVariantList &yAxisColumn, QString identifier = "");

    void setChartSource(QString sourceType, QVariant currentSelectedTypeId, bool dashboardFilterApplied = false); //void

    void receiveHeaders(QMap<int, QStringList> newChartHeader);
    void receiveReportData(QMap<int, QMap<int, QStringList>> newChartData, int currentReportId);
    void receiveDashboardData(QMap<int, QMap<int, QStringList>> newChartData, int currentDashboardId);

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

    void signalLineAreaWaterfallValues(QString output);
    void signalTreeSunburstValues(QString output);
    void signalStackedBarAreaValues(QString output);
    void signalTablePivotValues(QString output);

};

#endif // CHARTSTHREAD_H
