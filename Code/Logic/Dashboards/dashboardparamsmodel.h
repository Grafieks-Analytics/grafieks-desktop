#ifndef DASHBOARDPARAMSMODEL_H
#define DASHBOARDPARAMSMODEL_H

#include <QObject>
#include <QMap>
#include <QList>
#include <QUrl>
#include <QDebug>

class DashboardParamsModel: public QObject
{
    Q_OBJECT

    // Dashboard Report Mapping
    QMap<int, QVector<int>> dashboardReportsMap; // <dashboardId, <reportId>>
    QMap<int, QMap<int, int>> dashboardReportsZorder; // <dashboardId, <zId, reportId>>
    QMap<int, QMap<int, QStringList>> dashboardReportCoordinates; // <dashboardId, <reportId, [x, y]>>
    QMap<int, QMap<int, int>> dashboardReportTypeMap; // <dashboardId, <reportId, reportTypeId (constant)>>
    QMap<int, QMap<int, QUrl>> dashboardReportUrl; // <dashboardId, <reportId, URI Link>>


    // Customize Dashboard parameters
    QMap<int, QString> dashboardName;
    QMap<int, QString> dashboardBackgroundColor;
    QMap<int, QString> dashboardLineColor;
    QMap<int, int> dashboardOpacity;
    QMap<int, bool> dashboardGrid;
    QMap<int, QVector<int>> dashboardCanvasDimensions; // <dashboardId, [height, width]>

    // Customize Report parameters
    QMap<int, QString> reportName;
    QMap<int, QString> reportBackgroundColor;
    QMap<int, QString> reportLineColor;
    QMap<int, QString> reportOpacity; // <reportId, opacityValue>


    // General
    Q_PROPERTY(QString lastContainerType READ lastContainerType WRITE setLastContainerType NOTIFY lastContainerTypeChanged)
    Q_PROPERTY(int positionX READ positionX WRITE setPositionX NOTIFY positionXChanged)
    Q_PROPERTY(int positionY READ positionY WRITE setPositionY NOTIFY positionYChanged)
    Q_PROPERTY(int zIndex READ zIndex WRITE setZIndex NOTIFY zIndexChanged)



    QString m_lastContainerType;
    int m_positionY;
    int m_positionX;

    int m_zIndex;

public:
    explicit DashboardParamsModel(QObject *parent = nullptr);


    Q_INVOKABLE bool createNewDashboard();
    Q_INVOKABLE bool destroyDashboard();
    Q_INVOKABLE QVariantMap fetchAllDashboards(); // returns [dashboardId, dashboardName]
    Q_INVOKABLE QVariantList fetchReportsInDashboard(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportZOrder(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportCoordinates(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportUrls(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportTypeMap(int dashboardId);


    // Dashboard Report Mapping

    Q_INVOKABLE void addReportToDashboard(int dashboardId, int reportId);
    Q_INVOKABLE void deleteReportFromDashboard(int dashboardId, int reportId);

    Q_INVOKABLE void setReportZOrder(int dashboardId, int reportId, int zOrder);
    Q_INVOKABLE int getReportZOrder(int dashboardId, int reportId);

    Q_INVOKABLE void setDashboardReportCoordinates(int dashboardId, int reportId, float x, float y);
    Q_INVOKABLE QVector<float> getDashboardReportCoordinates(int dashboardId, int reportId);

    Q_INVOKABLE void setDashboardReportTypeMap(int dashboardId, int reportId, int reportType);
    Q_INVOKABLE int getDashboardReportTypeMap(int dashboardId, int reportId);

    Q_INVOKABLE void setDashboardReportUrl(int dashboardId, int reportId, QUrl url);
    Q_INVOKABLE QUrl getDashboardReportUrl(int dashboardId, QUrl url);

    // Customize Dashboard parameters

    Q_INVOKABLE void setDashboardName(int dashboardId,QString dashboardName);
    Q_INVOKABLE QString getDashboardName(int dashboardId);

    Q_INVOKABLE void setDashboardBackgroundColor(int dashboardId, QString color);
    Q_INVOKABLE QString getDashboardBackgroundColor(int dashboardId);

    Q_INVOKABLE void setDashboardLineColor(int dashboardId, QString color);
    Q_INVOKABLE QString getDashboardLineColor(int dashboardId);

    Q_INVOKABLE void setDashboardOpacity(int dashboardId, int percent);
    Q_INVOKABLE int getDashboardOpacity(int dashboardId);

    Q_INVOKABLE void setDashboardGrid(int dashboardId, bool gridVisible);
    Q_INVOKABLE bool getDashboardGrid(int dashboardId);

    Q_INVOKABLE void setDashboardDimensions(int dashboardId, int height, int width);
    Q_INVOKABLE QVector<int> getDashboardDimensions(int dashboardId); // returns [height, width]

    QString lastContainerType() const;
    int positionY() const;
    int positionX() const;

    int zIndex() const;

public slots:
    void setLastContainerType(QString lastContainerType);
    void setPositionY(int positionY);
    void setPositionX(int positionX);

    void setZIndex(int zIndex);

signals:
    void lastContainerTypeChanged(QString lastContainerType);
    void positionYChanged(int positionY);
    void positionXChanged(int positionX);
    void zIndexChanged(int zIndex);
};

#endif // DASHBOARDPARAMSMODEL_H
