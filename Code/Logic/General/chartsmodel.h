#ifndef CHARTSMODEL_H
#define CHARTSMODEL_H

#include <QObject>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QElapsedTimer>

#include "jsoncons/json.hpp"
#include "../../constants.h"
using namespace jsoncons;

class ChartsModel : public QObject
{
    Q_OBJECT
    QMap<int, QStringList> newChartHeader;
    QMap<int, QString> headerMap;
    QMap<QString, QMap<int, QStringList>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<int, QMap<int, QStringList>> dashboardChartData; // <DashboardId - <columnKey - Values Array list>>

    int dashboardId;
    QString reportId;
    QTime myTimer;
    QElapsedTimer myTimer2;

public:
    explicit ChartsModel(QObject *parent = nullptr);
    ~ChartsModel();

    Q_INVOKABLE QString getBarChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getStackedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE QString getGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE QString getNewGroupedBarChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE QString getAreaChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getLineChartValues(QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getLineBarChartValues(QString xAxisColumn, QString yLineAxisColumn, QString yBarAxisColumn);
    Q_INVOKABLE QString getPieChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getFunnelChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getRadarChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getScatterChartValues( QString xAxisColumn, QString yAxisColumn, QString xSplitKey);
    Q_INVOKABLE QString getHeatMapChartValues( QString xAxisColumn, QString yAxisColumn, QString xSplitKey);

    Q_INVOKABLE QString getSunburstChartValues(QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getWaterfallChartValues( QString xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE float getGaugeChartValues(QString calculateColumn);
    Q_INVOKABLE QString getSankeyChartValues(QString sourceColumn, QString destinationColumn, QString measureColumn);

    Q_INVOKABLE QString getTreeChartValues( QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE QString getTreeMapChartValues( QVariantList xAxisColumn, QString yAxisColumn);
    Q_INVOKABLE float getKPIChartValues( QString calculateColumn);
    Q_INVOKABLE QString getTableChartValues( QVariantList xAxisColumn, QVariantList yAxisColumn);
    Q_INVOKABLE QString getPivotChartValues( QVariantList xAxisColumn, QVariantList yAxisColumn);
    Q_INVOKABLE QString getStackedAreaChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey );
    Q_INVOKABLE QString getMultiLineChartValues(QString xAxisColumn, QString yAxisColumn, QString xSplitKey );

    Q_INVOKABLE QString getLineAreaWaterfallValues( QString &xAxisColumn, QString &yAxisColumn);
    Q_INVOKABLE QString getTreeSunburstValues(QVariantList &xAxisColumn, QString &yAxisColumn);
    Q_INVOKABLE QString getStackedBarAreaValues(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey);
    Q_INVOKABLE QString getTablePivotValues(QVariantList &xAxisColumn, QVariantList &yAxisColumn);

public slots:

    void receiveHeaders(QMap<int, QStringList> newChartHeader);
    void receiveReportData(QMap<QString, QMap<int, QStringList>> newChartData, QString currentReportId);
    void receiveDashboardData(QMap<int, QMap<int, QStringList>> newChartData, int currentDashboardId);

signals:

};

#endif // CHARTSMODEL_H
