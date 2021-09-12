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
    QMap<int, QStringList> newChartHeaderreportWhereConditions;
    QMap<int, QString> headerMap;
    QString reportWhereConditions;
    QString dashboardWhereConditions;
    int currentDashboardId;
    int currentReportId;

    int currentChartSource;
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

    void methodSelector(QString functionName = "", QString reportWhereConditions = "", QString dashboardWhereConditions = "", int chartSource = Constants::reportScreen, int reportId = 0, int dashboardId = 0);
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
    void getScatterChartNumericalValues();

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

private:
    duckdb::unique_ptr<duckdb::MaterializedQueryResult> queryFunction(QString mainQuery);
    QString getTableName();

signals:

    void signalBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalStackedBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalGroupedBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalNewGroupedBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalAreaChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalLineChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalLineBarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalPieChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalFunnelChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalRadarChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalScatterChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalHeatMapChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalSunburstChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalWaterfallChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalGaugeChartValues(float output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalSankeyChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeMapChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalKPIChartValues(float output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTableChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalPivotChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalStackedAreaChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalMultiLineChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);

    void signalLineAreaWaterfallValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeSunburstValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalStackedBarAreaValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTablePivotValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);

};

#endif // CHARTSTHREAD_H
