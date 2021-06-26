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
    QMap<int, QStringList *> newChartData;
    QMap<QString, QMap<int, QStringList *>> reportChartData; // <ReportId - <columnKey - Values Array list>>
    QMap<QString, QMap<int, QStringList *>> dashboardChartData; // <DashboardId - <columnKey - Values Array list>>
    QMap<int, QString> newChartHeader;
    QMap<int, QStringList> chartHeaderDetails; // This i dont think is of use. delete in future

    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;
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


    Q_INVOKABLE void searchColumnNames(QString keyword);
    Q_INVOKABLE QStringList fetchColumnData(QString columnName, QString options = "");
    Q_INVOKABLE QStringList searchColumnData(QString columnName, QString keyword);
    Q_INVOKABLE void clearData();
    Q_INVOKABLE void removeTmpChartData();


public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QStringList> chartHeader);
    void updateFilterData(QMap<int, QVariantMap> masterReportFilters, QString reportId);
    void currentScreenChanged(int currentScreen);
    void getReportId(QString reportId);

signals:
    void sendFilteredColumn(QStringList allCategorical, QStringList allNumerical, QStringList allDates);
    void sendData(QVariantList xAxis, QVariantList yAxis);
    void columnDataChanged(QStringList columnData, QString options);


private:
    QVariant convertToDateFormatTimeFromString(QString stringDateFormat);

};

#endif // CHARTSMODEL_H
