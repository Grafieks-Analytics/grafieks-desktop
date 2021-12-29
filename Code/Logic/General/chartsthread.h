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
#include <QTime>
#include <QDateTime>
#include <QRegularExpression>
#include <QElapsedTimer>
#include <QFileInfo>
#include <QSqlQuery>
#include <QSqlError>

#include "jsoncons/json.hpp"
#include "../../constants.h"
#include "../../statics.h"

#include "../../duckdb.hpp"

using namespace jsoncons;

class ChartsThread : public QObject
{
    Q_OBJECT
    QString reportWhereConditions;
    QString dashboardWhereConditions;
    int currentDashboardId;
    int currentReportId;

    int currentChartSource;
    QTime myTimer;
    QElapsedTimer myTimer2;
    QString masterTable;
    QString masterJoinParams;
    QString masterWhereParams;

    QString datasourceType;
    QString xAxisColumn;
    QString yAxisColumn;
    QString xSplitKey;
    QVariantList xAxisColumnList;
    QVariantList yAxisColumnList;
    QString sourceColumn;
    QString destinationColumn;
    QString measureColumn;
    QString calculateColumn;
    QJsonArray dateConversionOptions;

public:
    explicit ChartsThread(QObject *parent = nullptr);
    ~ChartsThread();

    void methodSelector(QString functionName = "", QString reportWhereConditions = "", QString dashboardWhereConditions = "", int chartSource = Constants::reportScreen, int reportId = 0, int dashboardId = 0, QString datasourceType = Constants::sqlType);
    void queryParams(QString masterTable = "", QString masterWhereParams = "", QString masterJoinParams = "");
    void setAxes(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey);
    void setLists(QVariantList &xAxisColumnList, QVariantList &yAxisColumnList);
    void setSankeyDetails(QString &sourceColumn, QString &destinationColumn, QString &measureColumn);
    void setGaugeKpiDetails(QString &calculateColumn);
    void setTablePivotDateConversionOptions(QString dateConversionOptions);

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
    void getTableChartValues();
    void getPivotChartValues();
    void getStackedAreaChartValues(); // getStackedBarAreaValues
    void getMultiLineChartValues();

    void getLineAreaWaterfallValues( QString &xAxisColumn, QString &yAxisColumn, QString identifier = "");
    void getTreeSunburstValues(QVariantList &xAxisColumn, QString &yAxisColumn, QString identifier = "");
    void getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey, QString identifier = "");

private:
    duckdb::unique_ptr<duckdb::MaterializedQueryResult> queryExtractFunction(QString mainQuery);
    QSqlQuery queryLiveFunction(QString mainQuery);
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
    void signalScatterChartNumericalValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalHeatMapChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalSunburstChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalWaterfallChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalGaugeChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalSankeyChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeMapChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalKPIChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTableChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalPivotChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalStackedAreaChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalMultiLineChartValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);

    void signalLineAreaWaterfallValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalTreeSunburstValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);
    void signalStackedBarAreaValues(QString output, int currentReportId, int currentDashboardId, int currentChartSource);

};

#endif // CHARTSTHREAD_H
