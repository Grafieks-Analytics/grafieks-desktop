#include "chartsmodel.h"

ChartsModel::ChartsModel(QObject *parent, ChartsThread *chartsThread, ChartsAPIThread *chartsAPIThread) : QObject(parent)
{
    this->chartsThread = chartsThread;
    this->chartsAPIThread = chartsAPIThread;

    nullString = "";
    nullList.clear();
    threadName = "Grafieks Charts";

    connect(&chartsThreadThread, &QThread::started, this->chartsThread, &ChartsThread::start, Qt::QueuedConnection);
    connect(&chartsAPIThreadThread, &QThread::started, this->chartsAPIThread, &ChartsAPIThread::start, Qt::QueuedConnection);

    // For Internal processing
    connect(this->chartsThread, &ChartsThread::signalBarChartValues, this, &ChartsModel::slotBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalStackedBarChartValues, this, &ChartsModel::slotStackedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalGroupedBarChartValues, this, &ChartsModel::slotGroupedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalNewGroupedBarChartValues, this, &ChartsModel::slotNewGroupedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalAreaChartValues, this, &ChartsModel::slotAreaChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalLineChartValues, this, &ChartsModel::slotLineChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalLineBarChartValues, this, &ChartsModel::slotLineBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalPieChartValues, this, &ChartsModel::slotPieChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalFunnelChartValues, this, &ChartsModel::slotFunnelChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalRadarChartValues, this, &ChartsModel::slotRadarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalScatterChartValues, this, &ChartsModel::slotScatterChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalScatterChartNumericalValues, this, &ChartsModel::slotScatterChartNumericalValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalHeatMapChartValues, this, &ChartsModel::slotHeatMapChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalSunburstChartValues, this, &ChartsModel::slotSunburstChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalWaterfallChartValues, this, &ChartsModel::slotWaterfallChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalGaugeChartValues, this, &ChartsModel::slotGaugeChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalSankeyChartValues, this, &ChartsModel::slotSankeyChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalTreeChartValues, this, &ChartsModel::slotTreeChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalTreeMapChartValues, this, &ChartsModel::slotTreeMapChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalKPIChartValues, this, &ChartsModel::slotKPIChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalTableChartValues, this, &ChartsModel::slotTableChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalPivotChartValues, this, &ChartsModel::slotPivotChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalStackedAreaChartValues, this, &ChartsModel::slotStackedAreaChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalMultiLineChartValues, this, &ChartsModel::slotMultiLineChartValues, Qt::QueuedConnection);

    // For data from API
    connect(this->chartsAPIThread, &ChartsAPIThread::signalBarChartValues, this, &ChartsModel::slotBarChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalStackedBarChartValues, this, &ChartsModel::slotStackedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalGroupedBarChartValues, this, &ChartsModel::slotGroupedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalNewGroupedBarChartValues, this, &ChartsModel::slotNewGroupedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalAreaChartValues, this, &ChartsModel::slotAreaChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalLineChartValues, this, &ChartsModel::slotLineChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalLineBarChartValues, this, &ChartsModel::slotLineBarChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalPieChartValues, this, &ChartsModel::slotPieChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalFunnelChartValues, this, &ChartsModel::slotFunnelChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalRadarChartValues, this, &ChartsModel::slotRadarChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalScatterChartValues, this, &ChartsModel::slotScatterChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalScatterChartNumericalValues, this, &ChartsModel::slotScatterChartNumericalValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalHeatMapChartValues, this, &ChartsModel::slotHeatMapChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalSunburstChartValues, this, &ChartsModel::slotSunburstChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalWaterfallChartValues, this, &ChartsModel::slotWaterfallChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalGaugeChartValues, this, &ChartsModel::slotGaugeChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalSankeyChartValues, this, &ChartsModel::slotSankeyChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalTreeChartValues, this, &ChartsModel::slotTreeChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalTreeMapChartValues, this, &ChartsModel::slotTreeMapChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalKPIChartValues, this, &ChartsModel::slotKPIChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalTableChartValues, this, &ChartsModel::slotTableChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalPivotChartValues, this, &ChartsModel::slotPivotChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalStackedAreaChartValues, this, &ChartsModel::slotStackedAreaChartValues, Qt::QueuedConnection);
    connect(this->chartsAPIThread, &ChartsAPIThread::signalMultiLineChartValues, this, &ChartsModel::slotMultiLineChartValues, Qt::QueuedConnection);
}

ChartsModel::~ChartsModel()
{
    chartsThreadThread.terminate();
}

void ChartsModel::getBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){

        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsAPIThread->methodSelector("getBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {

        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);

    }

}

void ChartsModel::getStackedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsAPIThread->methodSelector("getStackedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getStackedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId,datasourceType);
    }

}

void ChartsModel::getGroupedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsAPIThread->methodSelector("getGroupedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getGroupedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }
}

void ChartsModel::getNewGroupedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsAPIThread->methodSelector("getNewGroupedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getNewGroupedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getAreaChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsAPIThread->methodSelector("getAreaChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getAreaChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getLineChartValues(int reportId, int dashboardId, int chartSource, QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsAPIThread->methodSelector("getLineChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getLineChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getLineBarChartValues(int reportId, int dashboardId, int chartSource, QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsAPIThread->methodSelector("getLineBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getLineBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getPieChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsAPIThread->methodSelector("getPieChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getPieChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getFunnelChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsAPIThread->methodSelector("getFunnelChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getFunnelChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getRadarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsAPIThread->methodSelector("getRadarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getRadarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getScatterChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsAPIThread->methodSelector("getScatterChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getScatterChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getScatterChartNumericalValues(int reportId, int dashboardId, int chartSource, QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsAPIThread->methodSelector("getScatterChartNumericalValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getScatterChartNumericalValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getHeatMapChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsAPIThread->methodSelector("getHeatMapChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getHeatMapChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getSunburstChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(nullString, yAxisColumn, nullString);
        chartsAPIThread->setLists(xAxisColumn, nullList, nullList);
        chartsAPIThread->methodSelector( "getSunburstChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(nullString, yAxisColumn, nullString);
        chartsThread->setLists(xAxisColumn, nullList, nullList);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector( "getSunburstChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getWaterfallChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsAPIThread->methodSelector("getWaterfallChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getWaterfallChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getGaugeChartValues(int reportId, int dashboardId, int chartSource,  QString calculateColumn, QString greenValue, QString yellowValue, QString redValue)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setGaugeKpiDetails(calculateColumn, greenValue, yellowValue, redValue);
        chartsAPIThread->methodSelector("getGaugeChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setGaugeKpiDetails(calculateColumn, greenValue, yellowValue, redValue);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getGaugeChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getSankeyChartValues(int reportId, int dashboardId, int chartSource,  QString sourceColumn, QString destinationColumn, QString measureColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setSankeyDetails(sourceColumn, destinationColumn, measureColumn);
        chartsAPIThread->methodSelector("getSankeyChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setSankeyDetails(sourceColumn, destinationColumn, measureColumn);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getSankeyChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getTreeChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(nullString, yAxisColumn, nullString);
        chartsAPIThread->setLists(xAxisColumn, nullList, nullList);
        chartsAPIThread->methodSelector("getTreeChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(nullString, yAxisColumn, nullString);
        chartsThread->setLists(xAxisColumn, nullList, nullList);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getTreeChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getTreeMapChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(nullString, yAxisColumn, nullString);
        chartsAPIThread->setLists(xAxisColumn, nullList, nullList);
        chartsAPIThread->methodSelector("getTreeMapChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(nullString, yAxisColumn, nullString);
        chartsThread->setLists(xAxisColumn, nullList, nullList);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getTreeMapChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getKPIChartValues(int reportId, int dashboardId, int chartSource,  QString calculateColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setGaugeKpiDetails(calculateColumn);
        chartsAPIThread->methodSelector("getKPIChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setGaugeKpiDetails(calculateColumn);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getKPIChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getTableChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QVariantList yAxisColumn, QString dateConversionParameters)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setLists(xAxisColumn, yAxisColumn, nullList);
        chartsAPIThread->setTablePivotDateConversionOptions(dateConversionParameters);
        chartsAPIThread->methodSelector("getTableChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setLists(xAxisColumn, yAxisColumn, nullList);
        chartsThread->setTablePivotDateConversionOptions(dateConversionParameters);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getTableChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getPivotChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QVariantList yAxisColumn, QString dateConversionParameters, QVariantList row3Columns)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setLists(xAxisColumn, yAxisColumn, row3Columns);
        chartsAPIThread->setTablePivotDateConversionOptions(dateConversionParameters);
        chartsAPIThread->methodSelector("getPivotChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setLists(xAxisColumn, yAxisColumn, row3Columns);
        chartsThread->setTablePivotDateConversionOptions(dateConversionParameters);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getPivotChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getStackedAreaChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsAPIThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsAPIThread->methodSelector("getStackedAreaChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getStackedAreaChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::getMultiLineChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    if(Statics::apiSwitch == true){
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->methodSelector("getMultiLineChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
    } else {
        QString datasourceType = Statics::extractPath != "" ? Constants::duckType : "";
        chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
        chartsThread->queryParams(this->originalMasterTable, this->originalWhereConditions, this->originalJoinConditions);
        chartsThread->methodSelector("getMultiLineChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId, datasourceType);
    }

}

void ChartsModel::saveChartsModel()
{
    // QMap<int, QString> reportWhereConditions;
    // QMap<int, QString> dashboardWhereConditions;

    QJsonObject reportWhereConditionsObj;
    QJsonObject dashboardWhereConditionsObj;
    QJsonObject finalObj;

    QList<int> reportKeys = this->reportWhereConditions.keys();
    foreach(int id, reportKeys){
        reportWhereConditionsObj.insert(QString::number(id), this->reportWhereConditions.value(id));
    }

    QList<int> dashboardKeys = this->dashboardWhereConditions.keys();
    foreach(int id, dashboardKeys){
        dashboardWhereConditionsObj.insert(QString::number(id), this->dashboardWhereConditions.value(id));
    }

    finalObj.insert("reportWhereConditions", reportWhereConditionsObj);
    finalObj.insert("dashboardWhereConditions", dashboardWhereConditionsObj);
    finalObj.insert("joinConditions", originalJoinConditions);

    emit sendJoinAndWhereParams(finalObj);
}

void ChartsModel::callThread()
{
    if(Statics::apiSwitch == true){
        if(!chartsAPIThreadThread.isRunning()){
            chartsAPIThreadThread.setObjectName(this->threadName);
            chartsAPIThread->moveToThread(&chartsAPIThreadThread);
            chartsAPIThreadThread.start(QThread::InheritPriority);
        }
    } else {
        if(!chartsThreadThread.isRunning()){
            chartsThreadThread.setObjectName(this->threadName);
            chartsThread->moveToThread(&chartsThreadThread);
            chartsThreadThread.start(QThread::InheritPriority);
        }
    }
}

void ChartsModel::slotBarChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalBarChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotStackedBarChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalStackedBarChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotGroupedBarChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalGroupedBarChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotNewGroupedBarChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalNewGroupedBarChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotAreaChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalAreaChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotLineChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalLineChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotLineBarChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalLineBarChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotPieChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalPieChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotFunnelChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalFunnelChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotRadarChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalRadarChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotScatterChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalScatterChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotScatterChartNumericalValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalScatterChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotHeatMapChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalHeatMapChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotSunburstChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalSunburstChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotWaterfallChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalWaterfallChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotGaugeChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalGaugeChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotSankeyChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalSankeyChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotTreeChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalTreeChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotTreeMapChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalTreeMapChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotKPIChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalKPIChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotTableChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalTableChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotPivotChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalPivotChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotStackedAreaChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalStackedAreaChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::slotMultiLineChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    emit signalMultiLineChartValues(output,reportId, dashboardId, chartSource);
    chartsThreadThread.quit();
}

void ChartsModel::receiveReportConditions(QString whereConditions, int currentReportId)
{
    this->reportWhereConditions.insert(currentReportId, whereConditions);
}

void ChartsModel::receiveDashboardConditions(QString whereConditions, int currentDashboardId)
{
    this->dashboardWhereConditions.insert(currentDashboardId, whereConditions);
}

void ChartsModel::receiveOriginalConditions(QString selectParams, QString whereConditions, QString joinConditions, QString masterTable)
{
    this->originalSelectParams = selectParams;
    this->originalWhereConditions = whereConditions;
    this->originalJoinConditions = joinConditions;
    this->originalMasterTable = masterTable;
}

void ChartsModel::getExtractJoinAndWhereParams(QJsonObject joinAndWhereParams)
{
    // reportWhereConditions
    QStringList reportIds = joinAndWhereParams.value("reportWhereConditions").toObject().keys();
    QVariantMap reportMap = joinAndWhereParams.value("reportWhereConditions").toObject().toVariantMap();

    foreach(QString reportId, reportIds){

        this->reportWhereConditions.insert(reportId.toInt(), reportMap.value(reportId).toString());
    }


    // dashboardWhereConditions
    QStringList dashboardIds = joinAndWhereParams.value("dashboardWhereConditions").toObject().keys();
    QVariantMap dashboardMap = joinAndWhereParams.value("dashboardWhereConditions").toObject().toVariantMap();

    foreach(QString dashboardId, dashboardIds){

        this->dashboardWhereConditions.insert(dashboardId.toInt(), dashboardMap.value(dashboardId).toString());
    }

}
