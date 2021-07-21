#include "chartsmodel.h"

ChartsModel::ChartsModel(QObject *parent, ChartsThread *chartsThread) : QObject(parent)
{
    this->chartsThread = chartsThread;
    nullString = "";
    nullList.clear();

    // BarChartValues
    connect(&threadBarChartValues, &QThread::started, this->chartsThread, &ChartsThread::getBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalBarChartValues, this, &ChartsModel::slotBarChartValues, Qt::QueuedConnection);

    // StackedBarChartValues
    connect(&threadStackedBarChartValues, &QThread::started, this->chartsThread, &ChartsThread::getStackedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalStackedBarChartValues, this, &ChartsModel::slotStackedBarChartValues, Qt::QueuedConnection);

    // GroupedBarChartValues
    connect(&threadGroupedBarChartValues, &QThread::started, this->chartsThread, &ChartsThread::getGroupedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalGroupedBarChartValues, this, &ChartsModel::slotGroupedBarChartValues, Qt::QueuedConnection);

    // NewGroupedBarChartValues
    connect(&threadNewGroupedBarChartValues, &QThread::started, this->chartsThread, &ChartsThread::getNewGroupedBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalNewGroupedBarChartValues, this, &ChartsModel::slotNewGroupedBarChartValues, Qt::QueuedConnection);

    // AreaChartValues
    connect(&threadAreaChartValues, &QThread::started, this->chartsThread, &ChartsThread::getAreaChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalAreaChartValues, this, &ChartsModel::slotAreaChartValues, Qt::QueuedConnection);

    // LineChartValues
    connect(&threadLineChartValues, &QThread::started, this->chartsThread, &ChartsThread::getLineChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalLineChartValues, this, &ChartsModel::slotLineChartValues, Qt::QueuedConnection);

    // LineBarChartValues
    connect(&threadLineBarChartValues, &QThread::started, this->chartsThread, &ChartsThread::getLineBarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalLineBarChartValues, this, &ChartsModel::slotLineBarChartValues, Qt::QueuedConnection);

    // PieChartValues
    connect(&threadPieChartValues, &QThread::started, this->chartsThread, &ChartsThread::getPieChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalPieChartValues, this, &ChartsModel::slotPieChartValues, Qt::QueuedConnection);

    // FunnelChartValues
    connect(&threadFunnelChartValues, &QThread::started, this->chartsThread, &ChartsThread::getFunnelChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalFunnelChartValues, this, &ChartsModel::slotFunnelChartValues, Qt::QueuedConnection);

    // RadarChartValues
    connect(&threadRadarChartValues, &QThread::started, this->chartsThread, &ChartsThread::getRadarChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalRadarChartValues, this, &ChartsModel::slotRadarChartValues, Qt::QueuedConnection);

    // ScatterChartValues
    connect(&threadScatterChartValues, &QThread::started, this->chartsThread, &ChartsThread::getScatterChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalScatterChartValues, this, &ChartsModel::slotScatterChartValues, Qt::QueuedConnection);

    // HeatMapChartValues
    connect(&threadHeatMapChartValues, &QThread::started, this->chartsThread, &ChartsThread::getHeatMapChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalHeatMapChartValues, this, &ChartsModel::slotHeatMapChartValues, Qt::QueuedConnection);

    // SunburstChartValues
    connect(&threadSunburstChartValues, &QThread::started, this->chartsThread, &ChartsThread::getSunburstChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalSunburstChartValues, this, &ChartsModel::slotSunburstChartValues, Qt::QueuedConnection);

    // WaterfallChartValues
    connect(&threadWaterfallChartValues, &QThread::started, this->chartsThread, &ChartsThread::getWaterfallChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalWaterfallChartValues, this, &ChartsModel::slotWaterfallChartValues, Qt::QueuedConnection);

    // GaugeChartValues
    connect(&threadGaugeChartValues, &QThread::started, this->chartsThread, &ChartsThread::getGaugeChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalGaugeChartValues, this, &ChartsModel::slotGaugeChartValues, Qt::QueuedConnection);

    // SankeyChartValues
    connect(&threadSankeyChartValues, &QThread::started, this->chartsThread, &ChartsThread::getSankeyChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalSankeyChartValues, this, &ChartsModel::slotSankeyChartValues, Qt::QueuedConnection);

    // TreeChartValues
    connect(&threadTreeChartValues, &QThread::started, this->chartsThread, &ChartsThread::getTreeChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalTreeChartValues, this, &ChartsModel::slotTreeChartValues, Qt::QueuedConnection);

    // TreeMapChartValues
    connect(&threadTreeMapChartValues, &QThread::started, this->chartsThread, &ChartsThread::getTreeMapChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalTreeMapChartValues, this, &ChartsModel::slotTreeMapChartValues, Qt::QueuedConnection);

    // KPIChartValues
    connect(&threadKPIChartValues, &QThread::started, this->chartsThread, &ChartsThread::getKPIChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalKPIChartValues, this, &ChartsModel::slotKPIChartValues, Qt::QueuedConnection);

    // TableChartValues
    connect(&threadTableChartValues, &QThread::started, this->chartsThread, &ChartsThread::getTableChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalTableChartValues, this, &ChartsModel::slotTableChartValues, Qt::QueuedConnection);

    // PivotChartValues
    connect(&threadPivotChartValues, &QThread::started, this->chartsThread, &ChartsThread::getPivotChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalPivotChartValues, this, &ChartsModel::slotPivotChartValues, Qt::QueuedConnection);

    // StackedAreaChartValues
    connect(&threadStackedAreaChartValues, &QThread::started, this->chartsThread, &ChartsThread::getStackedAreaChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalStackedAreaChartValues, this, &ChartsModel::slotStackedAreaChartValues, Qt::QueuedConnection);

    // MultiLineChartValues
    connect(&threadMultiLineChartValues, &QThread::started, this->chartsThread, &ChartsThread::getMultiLineChartValues, Qt::QueuedConnection);
    connect(this->chartsThread, &ChartsThread::signalMultiLineChartValues, this, &ChartsModel::slotMultiLineChartValues, Qt::QueuedConnection);

}

void ChartsModel::getBarChartValues(QString xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->moveToThread(&threadBarChartValues);
    threadBarChartValues.start();
}

void ChartsModel::getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->moveToThread(&threadStackedBarChartValues);
    threadStackedBarChartValues.start();
}

void ChartsModel::getGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->moveToThread(&threadGroupedBarChartValues);
    threadGroupedBarChartValues.start();
}

void ChartsModel::getNewGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->moveToThread(&threadNewGroupedBarChartValues);
    threadNewGroupedBarChartValues.start();
}

void ChartsModel::getAreaChartValues(QString xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->moveToThread(&threadAreaChartValues);
    threadAreaChartValues.start();
}

void ChartsModel::getLineChartValues(QString xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->moveToThread(&threadLineChartValues);
    threadLineChartValues.start();
}

void ChartsModel::getLineBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->moveToThread(&threadLineBarChartValues);
    threadLineBarChartValues.start();
}

void ChartsModel::getPieChartValues(QString xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->moveToThread(&threadPieChartValues);
    threadPieChartValues.start();
}

void ChartsModel::getFunnelChartValues(QString xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->moveToThread(&threadFunnelChartValues);
    threadFunnelChartValues.start();
}

void ChartsModel::getRadarChartValues(QString xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->moveToThread(&threadRadarChartValues);
    threadRadarChartValues.start();
}

void ChartsModel::getScatterChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->moveToThread(&threadScatterChartValues);
    threadScatterChartValues.start();
}

void ChartsModel::getHeatMapChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->moveToThread(&threadHeatMapChartValues);
    threadHeatMapChartValues.start();
}

void ChartsModel::getSunburstChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->moveToThread(&threadSunburstChartValues);
    threadSunburstChartValues.start();
}

void ChartsModel::getWaterfallChartValues(QString xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, nullString);
    chartsThread->moveToThread(&threadWaterfallChartValues);
    threadWaterfallChartValues.start();
}

void ChartsModel::getGaugeChartValues(QString calculateColumn)
{
    chartsThread->setGaugeKpiDetails(calculateColumn);
    chartsThread->moveToThread(&threadGaugeChartValues);
    threadGaugeChartValues.start();
}

void ChartsModel::getSankeyChartValues(QString sourceColumn, QString destinationColumn, QString measureColumn)
{
    chartsThread->setSankeyDetails(sourceColumn, destinationColumn, measureColumn);
    chartsThread->moveToThread(&threadSankeyChartValues);
    threadSankeyChartValues.start();
}

void ChartsModel::getTreeChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->moveToThread(&threadTreeChartValues);
    threadTreeChartValues.start();
}

void ChartsModel::getTreeMapChartValues(QVariantList xAxisColumn, QString yAxisColumn)
{
    chartsThread->setAxes(nullString, yAxisColumn, nullString);
    chartsThread->setLists(xAxisColumn, nullList);
    chartsThread->moveToThread(&threadTreeMapChartValues);
    threadTreeMapChartValues.start();
}

void ChartsModel::getKPIChartValues(QString calculateColumn)
{
    chartsThread->setGaugeKpiDetails(calculateColumn);
    chartsThread->moveToThread(&threadKPIChartValues);
    threadKPIChartValues.start();
}

void ChartsModel::getTableChartValues(QVariantList xAxisColumn, QVariantList yAxisColumn)
{
    chartsThread->setLists(xAxisColumn, yAxisColumn);
    chartsThread->moveToThread(&threadTableChartValues);
    threadTableChartValues.start();
}

void ChartsModel::getPivotChartValues(QVariantList xAxisColumn, QVariantList yAxisColumn)
{
    chartsThread->setLists(xAxisColumn, yAxisColumn);
    chartsThread->moveToThread(&threadPivotChartValues);
    threadPivotChartValues.start();
}

void ChartsModel::getStackedAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->moveToThread(&threadStackedAreaChartValues);
    threadStackedAreaChartValues.start();
}

void ChartsModel::getMultiLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey)
{
    chartsThread->setAxes(xAxisColumn, yAxisColumn, xSplitKey);
    chartsThread->moveToThread(&threadMultiLineChartValues);
    threadMultiLineChartValues.start();
}



void ChartsModel::slotBarChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalBarChartValues(output);
    threadBarChartValues.quit();
}

void ChartsModel::slotStackedBarChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalStackedBarChartValues(output);
    threadStackedBarChartValues.quit();
}

void ChartsModel::slotGroupedBarChartValues(QString output)
{
   qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalGroupedBarChartValues(output);
    threadGroupedBarChartValues.quit();
}

void ChartsModel::slotNewGroupedBarChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalNewGroupedBarChartValues(output);
    threadNewGroupedBarChartValues.quit();
}

void ChartsModel::slotAreaChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalAreaChartValues(output);
    threadAreaChartValues.quit();
}

void ChartsModel::slotLineChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalLineChartValues(output);
    threadLineChartValues.quit();
}

void ChartsModel::slotLineBarChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalLineBarChartValues(output);
    threadLineBarChartValues.quit();
}

void ChartsModel::slotPieChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalPieChartValues(output);
    threadPieChartValues.quit();
}

void ChartsModel::slotFunnelChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalFunnelChartValues(output);
    threadFunnelChartValues.quit();
}

void ChartsModel::slotRadarChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalRadarChartValues(output);
    threadRadarChartValues.quit();
}

void ChartsModel::slotScatterChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalScatterChartValues(output);
    threadScatterChartValues.quit();
}

void ChartsModel::slotHeatMapChartValues(QString output)
{
    emit signalHeatMapChartValues(output);
    threadHeatMapChartValues.quit();
}

void ChartsModel::slotSunburstChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalSunburstChartValues(output);
    threadSunburstChartValues.quit();
}

void ChartsModel::slotWaterfallChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalWaterfallChartValues(output);
    threadWaterfallChartValues.quit();
}

void ChartsModel::slotGaugeChartValues(float output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalGaugeChartValues(output);
    threadGaugeChartValues.quit();
}

void ChartsModel::slotSankeyChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalSankeyChartValues(output);
    threadSankeyChartValues.quit();
}

void ChartsModel::slotTreeChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalTreeChartValues(output);
    threadTreeChartValues.quit();
}

void ChartsModel::slotTreeMapChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalTreeMapChartValues(output);
    threadTreeMapChartValues.quit();
}

void ChartsModel::slotKPIChartValues(float output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalKPIChartValues(output);
    threadKPIChartValues.quit();
}

void ChartsModel::slotTableChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalTableChartValues(output);
    threadTableChartValues.quit();
}

void ChartsModel::slotPivotChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalPivotChartValues(output);
    threadPivotChartValues.quit();
}

void ChartsModel::slotStackedAreaChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalStackedAreaChartValues(output);
    threadStackedAreaChartValues.quit();
}

void ChartsModel::slotMultiLineChartValues(QString output)
{
    qDebug() << Q_FUNC_INFO << "SLOT" << output;
    emit signalMultiLineChartValues(output);
    threadMultiLineChartValues.quit();
}
