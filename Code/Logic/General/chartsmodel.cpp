#include "chartsmodel.h"

ChartsModel::ChartsModel(QObject *parent, ChartsThread *chartsThread) : QObject(parent)
{
    this->chartsThread = chartsThread;

    nullString = "";
    nullList.clear();
    threadName = "Grafieks Charts";

    connect(&chartsThreadThread, &QThread::started, this->chartsThread, &ChartsThread::start, Qt::QueuedConnection);


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

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getStackedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getStackedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getGroupedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getGroupedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getNewGroupedBarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getNewGroupedBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getAreaChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getAreaChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getLineChartValues(int reportId, int dashboardId, int chartSource, QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getLineChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getLineBarChartValues(int reportId, int dashboardId, int chartSource, QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getLineBarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getPieChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getPieChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getFunnelChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getFunnelChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getRadarChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getRadarChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getScatterChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getScatterChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getScatterChartNumericalValues(int reportId, int dashboardId, int chartSource, QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getScatterChartNumericalValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getHeatMapChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getHeatMapChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getSunburstChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->methodSelector( "getSunburstChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getWaterfallChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getWaterfallChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getGaugeChartValues(int reportId, int dashboardId, int chartSource,  QString calculateColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setGaugeKpiDetails(calculateColumn);
    chartsThread->methodSelector("getGaugeChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getSankeyChartValues(int reportId, int dashboardId, int chartSource,  QString sourceColumn, QString destinationColumn, QString measureColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setSankeyDetails(sourceColumn, destinationColumn, measureColumn);
    chartsThread->methodSelector("getSankeyChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getTreeChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->methodSelector("getTreeChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getTreeMapChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->methodSelector("getTreeMapChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getKPIChartValues(int reportId, int dashboardId, int chartSource,  QString calculateColumn)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setGaugeKpiDetails(calculateColumn);
    chartsThread->methodSelector("getKPIChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getTableChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QVariantList yAxisColumn, QString dateConversionParameters)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setLists(xAxisColumn, yAxisColumn);
    chartsThread->setTablePivotDateConversionOptions(dateConversionParameters);
    chartsThread->methodSelector("getTableChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getPivotChartValues(int reportId, int dashboardId, int chartSource,  QVariantList xAxisColumn, QVariantList yAxisColumn, QString dateConversionParameters)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setLists(xAxisColumn, yAxisColumn);
    chartsThread->setTablePivotDateConversionOptions(dateConversionParameters);
    chartsThread->methodSelector("getPivotChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getStackedAreaChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getStackedAreaChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::getMultiLineChartValues(int reportId, int dashboardId, int chartSource,  QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    this->currentReportId = reportId;
    this->currentDashboardId = dashboardId;
    this->currentChartSource = chartSource;

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getMultiLineChartValues", this->reportWhereConditions.value(reportId), this->dashboardWhereConditions.value(dashboardId), chartSource, this->currentReportId, this->currentDashboardId);
}

void ChartsModel::callThread()
{
    if(!chartsThreadThread.isRunning()){
        chartsThreadThread.setObjectName(this->threadName);
        chartsThread->moveToThread(&chartsThreadThread);
        chartsThreadThread.start(QThread::InheritPriority);
    }
}


void ChartsModel::slotBarChartValues(QString output, int reportId, int dashboardId, int chartSource)
{
    qDebug() << "BAR" << this->currentReportId << this->currentDashboardId << this->currentChartSource << output;
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
