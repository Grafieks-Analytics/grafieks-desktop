#ifndef DASHBOARDPARAMSMODEL_H
#define DASHBOARDPARAMSMODEL_H

#include <QObject>
#include <QMap>
#include <QList>
#include <QUrl>
#include <QCoreApplication>
#include <QtCore/QFileInfo>
#include <QDir>
#include <QDebug>

#include "../../constants.h"

class DashboardParamsModel: public QObject
{
    Q_OBJECT

    // Dashboard Report Mapping
    QMap<int, QVector<int>> dashboardReportsMap; // <dashboardId, <reportId>>
    QMap<int, QMap<int, int>> dashboardReportsZorder; // <dashboardId, <reportId, zId>>
    QMap<int, QMap<int, QVariantList>> dashboardReportCoordinates; // <dashboardId, <reportId, [x1, y1, x2, y2]>>
    QMap<int, QMap<int, int>> dashboardReportTypeMap; // <dashboardId, <reportId, reportTypeId (constant)>>
    QMap<int, QMap<int, QUrl>> dashboardReportUrl; // <dashboardId, <reportId, URI Link>>


    // Customize Dashboard parameters
    QMap<int, QString> dashboardName;
    QMap<int, QString> dashboardBackgroundColor;
    QMap<int, int> dashboardOpacity;
    QMap<int, bool> dashboardGrid;
    QMap<int, QVariantList> dashboardCanvasDimensions; // <dashboardId, [width, height]>

    // Customize Report parameters
    QMap<int, QMap<int, QString>> reportName; // <dashboardId, <reportId, reportName>>
    QMap<int, QMap<int, QString>> reportBackgroundColor; // <dashboardId, <reportId, backgroundColor>>
    QMap<int, QMap<int, QString>> reportLineColor; // <dashboardId, <reportId, lineColor>>
    QMap<int, QMap<int, int>> reportOpacity; // <dashboardId, <reportId, opacityValue>>


    // General
    Q_PROPERTY(QString lastContainerType READ lastContainerType WRITE setLastContainerType NOTIFY lastContainerTypeChanged)
    Q_PROPERTY(int positionX READ positionX WRITE setPositionX NOTIFY positionXChanged)
    Q_PROPERTY(int positionY READ positionY WRITE setPositionY NOTIFY positionYChanged)
    Q_PROPERTY(int zIndex READ zIndex WRITE setZIndex NOTIFY zIndexChanged)
    Q_PROPERTY(int dashboardCount READ dashboardCount WRITE setDashboardCount NOTIFY dashboardCountChanged)
    Q_PROPERTY(int currentDashboard READ currentDashboard WRITE setCurrentDashboard NOTIFY currentDashboardChanged)
    Q_PROPERTY(int currentReport READ currentReport WRITE setCurrentReport NOTIFY currentReportChanged)



    QString m_lastContainerType;
    int m_positionY;
    int m_positionX;
    int m_zIndex;
    int m_dashboardCount;
    int m_currentDashboard;
    int m_currentReport;

public:
    explicit DashboardParamsModel(QObject *parent = nullptr);


    Q_INVOKABLE bool dragNewReport(int dashboardId, int reportId);
    Q_INVOKABLE bool removeReport(int dashboardId, int reportId);

    Q_INVOKABLE bool createNewDashboard(int dashboardId);
    Q_INVOKABLE bool destroyDashboard(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllDashboards(); // returns [dashboardId, dashboardName]
    Q_INVOKABLE QVector<int> fetchReportsInDashboard(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportZOrder(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportCoordinates(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportUrls(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportTypeMap(int dashboardId);


    // Dashboard Report Mapping

    Q_INVOKABLE void addReportToDashboard(int dashboardId, int reportId);
    Q_INVOKABLE void deleteReportFromDashboard(int dashboardId, int reportId);

    Q_INVOKABLE void setReportZOrder(int dashboardId, int reportId, int zOrder);
    Q_INVOKABLE int getReportZOrder(int dashboardId, int reportId);

    Q_INVOKABLE void setDashboardReportCoordinates(int dashboardId, int reportId, float x1, float y1, float x2, float y2);
    Q_INVOKABLE QVariantList getDashboardReportCoordinates(int dashboardId, int reportId);

    Q_INVOKABLE void setDashboardReportTypeMap(int dashboardId, int reportId, int reportType);
    Q_INVOKABLE int getDashboardReportTypeMap(int dashboardId, int reportId);

    Q_INVOKABLE void setDashboardReportUrl(int dashboardId, int reportId, QUrl url);
    Q_INVOKABLE QUrl getDashboardReportUrl(int dashboardId, int reportId);

    // Customize Dashboard parameters

    Q_INVOKABLE void setDashboardName(int dashboardId,QString dashboardName);
    Q_INVOKABLE QString getDashboardName(int dashboardId);

    Q_INVOKABLE void setDashboardBackgroundColor(int dashboardId, QString color);
    Q_INVOKABLE QString getDashboardBackgroundColor(int dashboardId);

    Q_INVOKABLE void setDashboardOpacity(int dashboardId, int percent);
    Q_INVOKABLE int getDashboardOpacity(int dashboardId);

    Q_INVOKABLE void setDashboardGrid(int dashboardId, bool gridVisible);
    Q_INVOKABLE bool getDashboardGrid(int dashboardId);

    Q_INVOKABLE void setDashboardDimensions(int dashboardId, int width, int height);
    Q_INVOKABLE QVariantList getDashboardDimensions(int dashboardId); // returns [width, height]

    // Customize Rerport parameters

    Q_INVOKABLE void setReportName(int dashboardId, int reportId, QString reportName);
    Q_INVOKABLE QString getReportName(int dashboardId, int reportId);

    Q_INVOKABLE void setReportBackgroundColor(int dashboardId, int reportId, QString color);
    Q_INVOKABLE QString getReportBackgroundColor(int dashboardId, int reportId);

    Q_INVOKABLE void setReportLineColor(int dashboardId, int reportId, QString color);
    Q_INVOKABLE QString getReportLineColor(int dashboardId, int reportId);

    Q_INVOKABLE void setReportOpacity(int dashboardId, int reportId, int percent);
    Q_INVOKABLE int getReportOpacity(int dashboardId, int reportId);

    // Save and read files

    Q_INVOKABLE void saveImage(QUrl originalFile, QString newFilename);

    // General
    QString lastContainerType() const;
    int positionY() const;
    int positionX() const;
    int zIndex() const;
    int dashboardCount() const;
    int currentDashboard() const;    
    int currentReport() const;

public slots:
    void setLastContainerType(QString lastContainerType);
    void setPositionY(int positionY);
    void setPositionX(int positionX);
    void setZIndex(int zIndex);
    void setDashboardCount(int dashboardCount);
    void setCurrentDashboard(int currentDashboard);   
    void setCurrentReport(int currentReport);

signals:
    void lastContainerTypeChanged(QString lastContainerType);
    void positionYChanged(int positionY);
    void positionXChanged(int positionX);
    void zIndexChanged(int zIndex);
    void dashboardCountChanged(int dashboardCount);
    void currentDashboardChanged(int currentDashboard, QVector<int> reportsInDashboard);
    void currentReportChanged(int currentReport);

    // Customize Dashboard parameters
    void dashboardNameChanged(int dashboardId, QString dashboardName);
    void dashboardBackgroundColorChanged(int dashboardId, QString color);


    // Customize Report parameters
    void reportBackgroundColorChanged(int dashboardId, int reportId, QString color);
    void reportLineColorChanged(int dashboardId, int reportId, QString color);
    void reportUrlChanged(int dashboardId, int reportId, QString url);
};

#endif // DASHBOARDPARAMSMODEL_H
