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

void ChartsModel::getBarChartValues(QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getBarChartValues");
}

void ChartsModel::getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getStackedBarChartValues");
}

void ChartsModel::getGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getGroupedBarChartValues");
}

void ChartsModel::getNewGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getNewGroupedBarChartValues");
}

void ChartsModel::getAreaChartValues(QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getAreaChartValues");
}

void ChartsModel::getLineChartValues(QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getLineChartValues");
}

void ChartsModel::getLineBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getLineBarChartValues");
}

void ChartsModel::getPieChartValues(QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getPieChartValues");
}

void ChartsModel::getFunnelChartValues(QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getFunnelChartValues");
}

void ChartsModel::getRadarChartValues(QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getRadarChartValues");
}

void ChartsModel::getScatterChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getScatterChartValues");
}

void ChartsModel::getHeatMapChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getHeatMapChartValues");
}

void ChartsModel::getSunburstChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->methodSelector("getSunburstChartValues");
}

void ChartsModel::getWaterfallChartValues(QString xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->methodSelector("getWaterfallChartValues");
}

void ChartsModel::getGaugeChartValues(QString calculateColumn)
{
    this->callThread();

    chartsThread->setGaugeKpiDetails(calculateColumn);
    chartsThread->methodSelector("getGaugeChartValues");
}

void ChartsModel::getSankeyChartValues(QString sourceColumn, QString destinationColumn, QString measureColumn)
{
    this->callThread();

    chartsThread->setSankeyDetails(sourceColumn, destinationColumn, measureColumn);
    chartsThread->methodSelector("getSankeyChartValues");
}

void ChartsModel::getTreeChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->methodSelector("getTreeChartValues");
}

void ChartsModel::getTreeMapChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{
    this->callThread();

    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->methodSelector("getTreeMapChartValues");
}

void ChartsModel::getKPIChartValues(QString calculateColumn)
{
    this->callThread();

    chartsThread->setGaugeKpiDetails(calculateColumn);
    chartsThread->methodSelector("getTreeMapChartValues");
}

void ChartsModel::getTableChartValues(QVariantList xAxisColumn, QVariantList yAxisColumn)
{
    this->callThread();

    chartsThread->setLists(xAxisColumn, yAxisColumn);
    chartsThread->methodSelector("getTreeMapChartValues");
}

void ChartsModel::getPivotChartValues(QVariantList xAxisColumn, QVariantList yAxisColumn)
{
    this->callThread();

    chartsThread->setLists(xAxisColumn, yAxisColumn);
    chartsThread->methodSelector("getTreeMapChartValues");
}

void ChartsModel::getStackedAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getTreeMapChartValues");
}

void ChartsModel::getMultiLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    this->callThread();

    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->methodSelector("getTreeMapChartValues");
}

void ChartsModel::callThread()
{
    if(!chartsThreadThread.isRunning()){
        chartsThreadThread.setObjectName(this->threadName);
        chartsThread->moveToThread(&chartsThreadThread);
        chartsThreadThread.start(QThread::InheritPriority);
    }
}


void ChartsModel::slotBarChartValues(QString output)
{
    emit signalBarChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotStackedBarChartValues(QString output)
{
    emit signalStackedBarChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotGroupedBarChartValues(QString output)
{
    emit signalGroupedBarChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotNewGroupedBarChartValues(QString output)
{
    emit signalNewGroupedBarChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotAreaChartValues(QString output)
{
    emit signalAreaChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotLineChartValues(QString output)
{
    emit signalLineChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotLineBarChartValues(QString output)
{
    emit signalLineBarChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotPieChartValues(QString output)
{
    emit signalPieChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotFunnelChartValues(QString output)
{
    emit signalFunnelChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotRadarChartValues(QString output)
{
    emit signalRadarChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotScatterChartValues(QString output)
{
    emit signalScatterChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotHeatMapChartValues(QString output)
{
    emit signalHeatMapChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotSunburstChartValues(QString output)
{
    emit signalSunburstChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotWaterfallChartValues(QString output)
{
    emit signalWaterfallChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotGaugeChartValues(float output)
{
    emit signalGaugeChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotSankeyChartValues(QString output)
{
    emit signalSankeyChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotTreeChartValues(QString output)
{
    emit signalTreeChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotTreeMapChartValues(QString output)
{
    emit signalTreeMapChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotKPIChartValues(float output)
{
    emit signalKPIChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotTableChartValues(QString output)
{
    emit signalTableChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotPivotChartValues(QString output)
{
    emit signalPivotChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotStackedAreaChartValues(QString output)
{
    emit signalStackedAreaChartValues(output);
    chartsThreadThread.quit();
}

void ChartsModel::slotMultiLineChartValues(QString output)
{
    emit signalMultiLineChartValues(output);
    chartsThreadThread.quit();
}
