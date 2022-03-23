#ifndef CHARTSAPITHREAD_H
#define CHARTSAPITHREAD_H

#include <QObject>
#include <QDebug>
#include <QSettings>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include "../../constants.h"
#include "../../statics.h"

class ChartsAPIThread : public QObject
{
    Q_OBJECT

    QString reportWhereConditions;
    QString dashboardWhereConditions;
    QString joinConditions;
    QString currentFunctionName;
    int currentChartSource;
    int currentDashboardId;
    int currentReportId;

    QString xAxisColumn;
    QString yAxisColumn;
    QString xSplitKey;
    QVariantList xAxisColumnList;
    QVariantList yAxisColumnList;
    QString sourceColumn;
    QString destinationColumn;
    QString measureColumn;
    QString calculateColumn;
    QString greenValue;
    QString yellowValue;
    QString redValue;
    QJsonArray dateConversionOptions;

    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QByteArray * m_dataBuffer;
    QNetworkRequest m_NetworkRequest;

    QString baseUrl;
    QByteArray sessionToken;
    int profileId;

public:
    explicit ChartsAPIThread(QObject *parent = nullptr);
    ~ChartsAPIThread();

    void methodSelector(QString functionName = "", QString reportWhereConditions = "", QString dashboardWhereConditions = "", int chartSource = Constants::reportScreen, int reportId = 0, int dashboardId = 0);
    void setAxes(QString &xAxisColumn, QString &yAxisColumn, QString &xSplitKey);
    void setLists(QVariantList &xAxisColumnList, QVariantList &yAxisColumnList);
    void setSankeyDetails(QString &sourceColumn, QString &destinationColumn, QString &measureColumn);
    void setGaugeKpiDetails(QString &calculateColumn, QString greenValue = "", QString yellowValue = "", QString redValue = "");
    void setTablePivotDateConversionOptions(QString dateConversionOptions);

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

public slots:
    void start();
    void dataReadyRead();
    void dataReadFinished();

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

private:
    void fetchSettings();

};

#endif // CHARTSAPITHREAD_H
