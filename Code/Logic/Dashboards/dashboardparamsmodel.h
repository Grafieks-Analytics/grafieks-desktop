#ifndef DASHBOARDPARAMSMODEL_H
#define DASHBOARDPARAMSMODEL_H

#include <QObject>
#include <QMap>
#include <QList>
#include <QUrl>
#include <QCoreApplication>
#include <QtCore/QFileInfo>
#include <QDir>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>
#include <QRegularExpression>

#include "../../constants.h"
#include "../../statics.h"
#include "../General/generalparamsmodel.h"

class DashboardParamsModel : public QObject
{
    Q_OBJECT

    // Dashboard Report Mapping
    // QMap<int, QVector<int>> dashboardWidgetsMap; // <dashboardId, <widgetId>>
    QMap<int, QVector<int>> dashboardWidgetsMap;                   // <dashboardId, <widgetId>>
    QMap<int, QMap<int, int>> dashboardWidgetsZorder;              // <dashboardId, <widgetId, zId>>
    QMap<int, QMap<int, QVariantList>> dashboardWidgetCoordinates; // <dashboardId, <widgetId, [x1, y1, x2, y2]>>
    QMap<int, QMap<int, int>> dashboardWidgetTypeMap;              // <dashboardId, <widgetId, reportTypeId (constant)>>
    QMap<int, QMap<int, QUrl>> dashboardWidgetUrl;                 // <dashboardId, <widgetId, URI Link>>
    QMap<int, QVariantMap> dashboardUniqueWidgetMap;               // <dashboardId, <uniqueHash, widgetId>>

    QMap<int, QVector<int>> dashboardReportMap; // <dashboardId, [reportId1, reportId2]>
    // NEW
    QMap<int, QMap<int, QString>> dashboardReportUrl;          // <dashboardId, <reportId, url of image/text>>
    QMap<int, QMap<int, QVariantMap>> textReportParametersMap; // <dashboardId, <reportId, Object>>

    // Filter parameters
    QMap<int, QStringList> showColumns;                   // dashboardId - List of column names to be shown from the list
    QMap<int, QVariantMap> columnAliasMap;                // dashboardId - Alias name which will appear instead of actual column name in reports
    QMap<int, QVariantMap> columnFilterType;              // dashboardId - Whether its single list, multi list, dropdown single, dropdown multiple
    QMap<int, QVariantMap> columnIncludeExcludeMap;       // dashboardId - If the filter data is to be included or excluded
    QMap<int, QMap<QString, QStringList>> columnValueMap; // dashboardId - <Column name - value list>
    QMap<int, QMap<QString, QVariantList>> dateRelative;  // dashboardId - <dateColName <timeframe - unit>>

    // Customize Dashboard parameters
    QMap<int, QString> dashboardName;
    QMap<int, QString> dashboardBackgroundColor;
    QMap<int, int> dashboardOpacity;
    QMap<int, bool> dashboardGrid;
    QMap<int, QVariantList> dashboardCanvasDimensions; // <dashboardId, [width, height]>

    // Customize Report parameters
    QMap<int, QMap<int, QString>> reportName;            // <dashboardId, <widgetId, reportName>>
    QMap<int, QMap<int, QString>> reportBackgroundColor; // <dashboardId, <widgetId, backgroundColor>>
    QMap<int, QMap<int, QString>> reportLineColor;       // <dashboardId, <widgetId, lineColor>>
    QMap<int, QMap<int, int>> reportOpacity;             // <dashboardId, <widgetId, opacityValue>>

    // General
    Q_PROPERTY(QString lastContainerType READ lastContainerType WRITE setLastContainerType NOTIFY lastContainerTypeChanged)
    Q_PROPERTY(int positionX READ positionX WRITE setPositionX NOTIFY positionXChanged)
    Q_PROPERTY(int positionY READ positionY WRITE setPositionY NOTIFY positionYChanged)
    Q_PROPERTY(int zIndex READ zIndex WRITE setZIndex NOTIFY zIndexChanged)
    Q_PROPERTY(int dashboardCount READ dashboardCount WRITE setDashboardCount NOTIFY dashboardCountChanged)
    Q_PROPERTY(int currentDashboard READ currentDashboard WRITE setCurrentDashboard NOTIFY currentDashboardChanged)
    Q_PROPERTY(int currentReport READ currentReport WRITE setCurrentReport NOTIFY currentReportChanged)
    Q_PROPERTY(int tmpCanvasHeight READ tmpCanvasHeight WRITE setTmpCanvasHeight NOTIFY tmpCanvasHeightChanged)
    Q_PROPERTY(int tmpCanvasWidth READ tmpCanvasWidth WRITE setTmpCanvasWidth NOTIFY tmpCanvasWidthChanged)
    Q_PROPERTY(QString currentColumnType READ currentColumnType WRITE setCurrentColumnType NOTIFY currentColumnTypeChanged)
    Q_PROPERTY(QString wbName READ wbName WRITE setWbName NOTIFY wbNameChanged)

    // Filter
    Q_PROPERTY(QString currentSelectedColumn READ currentSelectedColumn WRITE setCurrentSelectedColumn NOTIFY currentSelectedColumnChanged)

    QString m_lastContainerType;
    int m_positionY;
    int m_positionX;
    int m_zIndex;
    int m_dashboardCount;
    int m_currentDashboard;
    int m_currentReport;
    int m_tmpCanvasHeight;
    int m_tmpCanvasWidth;
    QString m_currentColumnType;
    QString m_wbName;

    QString m_currentSelectedColumn;

    GeneralParamsModel generalParamsModel;

public:
    explicit DashboardParamsModel(QObject *parent = nullptr);

    Q_INVOKABLE bool dragNewReport(int dashboardId, int widgetId, QString reportName);
    Q_INVOKABLE bool removeReport(int dashboardId, int widgetId); // TO REMOVE

    Q_INVOKABLE bool createNewDashboard(int dashboardId);
    Q_INVOKABLE bool destroyDashboard(int dashboardId, bool destroyAll = false);
    Q_INVOKABLE QVariantMap fetchAllDashboards(); // returns [dashboardId, dashboardName]
    Q_INVOKABLE QVector<int> fetchReportsInDashboard(int dashboardId);
    Q_INVOKABLE QVariantMap fetchAllReportZOrder(int dashboardId); // TO REMOVE
    Q_INVOKABLE QVariantMap fetchAllReportCoordinates(int dashboardId); // TO REMOVE
    Q_INVOKABLE QVariantMap fetchAllReportUrls(int dashboardId); // TO REMOVE
    Q_INVOKABLE QVariantMap fetchAllReportTypeMap(int dashboardId);
    Q_INVOKABLE void deleteReport(int reportId, int dashboardId = -1);

    // Dashboard Report Mapping

    Q_INVOKABLE void addReportToDashboard(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE
    Q_INVOKABLE void deleteReportFromDashboard(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE

    Q_INVOKABLE void setReportZOrder(int dashboardId, int widgetId, int zOrder);
    Q_INVOKABLE int getReportZOrder(int dashboardId, int widgetId);
    Q_INVOKABLE void deleteReportZOrder(int dashboardId, int widgetId);

    Q_INVOKABLE void setDashboardWidgetCoordinates(int dashboardId, int widgetId, float x1, float y1, float x2, float y2);
    Q_INVOKABLE QVariantList getDashboardWidgetCoordinates(int dashboardId, int widgetId);
    Q_INVOKABLE void deleteDashboardWidgetCoordinates(int dashboardId, int widgetId);

    Q_INVOKABLE void setDashboardWidgetTypeMap(int dashboardId, int widgetId, int reportType);
    Q_INVOKABLE int getDashboardWidgetTypeMap(int dashboardId, int widgetId); // TO REMOVE
    Q_INVOKABLE void deleteDashboardWidgetTypeMap(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE

    Q_INVOKABLE void setDashboardWidgetUrl(int dashboardId, int widgetId, QUrl url);
    Q_INVOKABLE QUrl getDashboardWidgetUrl(int dashboardId, int widgetId);
    Q_INVOKABLE void deleteDashboardWidgetUrl(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE

    Q_INVOKABLE void setDashboardUniqueWidget(int dashboardId, int widgetId, QString hash);
    Q_INVOKABLE QString getDashboardUniqueWidget(int dashboardId, int widgetId);
    Q_INVOKABLE void deleteDashboardUniqueWidget(int dashboardId, QString hash);

    Q_INVOKABLE void setTextReportParametersMap(int dashboardId, int widgetId, QVariantMap textReportParams);
    Q_INVOKABLE QVariant getTextReportParametersMap(int dashboardId, int widgetId);
    Q_INVOKABLE void deleteTextReportParametersMap(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE

    // Filter Parameters
    Q_INVOKABLE void addToShowColumns(int dashboardId, QString colName, bool status);
    Q_INVOKABLE QStringList fetchShowColumns(int dashboardId, QString searchKeyword = "");

    Q_INVOKABLE void setColumnAliasName(int dashboardId, QString columnName, QString columnAlias);
    Q_INVOKABLE QString fetchColumnAliasName(int dashboardCountdashboardId, QString columnName);

    Q_INVOKABLE void setColumnFilterType(int dashboardId, QString columnName, QString filterType);
    Q_INVOKABLE QString fetchColumnFilterType(int dashboardId, QString columnName);

    Q_INVOKABLE void setIncludeExcludeMap(int dashboardId, QString columnName, QString type);
    Q_INVOKABLE QString fetchIncludeExcludeMap(int dashboardId, QString columnName);

    Q_INVOKABLE void setColumnValueMap(int dashboardId, QString columnName, QString value);
    Q_INVOKABLE QStringList fetchColumnValueMap(int dashboardId, QString columnName);
    Q_INVOKABLE void deleteColumnValueMap(int dashboardId, QString columnName, QString value = "", bool removeAll = false);

    // Specific filter cases
    Q_INVOKABLE void setDateRelative(int dashboardId, QString colName, QString comparator, int dateValue, QString dateUnit);
    Q_INVOKABLE QVariantList fetchDateRelative(int dashboardId, QString columnName);
    Q_INVOKABLE void deleteDateRelative(int dashboardId, QString columnName);


    Q_INVOKABLE void applyFilterToDashboard(int dashboardId);
    Q_INVOKABLE void clearFilters();

    // Customize Dashboard parameters

    Q_INVOKABLE void setDashboardName(int dashboardId, QString dashboardName);
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

    Q_INVOKABLE void setReportName(int dashboardId, int widgetId, QString reportName);
    Q_INVOKABLE QString getReportName(int dashboardId, int widgetId);
    Q_INVOKABLE void deleteReportName(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE

    Q_INVOKABLE void setReportBackgroundColor(int dashboardId, int widgetId, QString color);
    Q_INVOKABLE QString getReportBackgroundColor(int dashboardId, int widgetId);
    Q_INVOKABLE void deleteReportBackgroundColor(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE

    Q_INVOKABLE void setReportLineColor(int dashboardId, int widgetId, QString color);
    Q_INVOKABLE void deleteReportLineColor(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE

    // This is extra step while restoring dashboards
    // because charts are drawn a lot later in qml after signals are fired from CPP
    // which results is some signals being missed by qml components and has to be manually called

    Q_INVOKABLE void fetchReportBackgroundAndLineColor(int dashboardId, int widgetId);
    // Ends here

    Q_INVOKABLE void setReportOpacity(int dashboardId, int widgetId, int percent);
    Q_INVOKABLE int getReportOpacity(int dashboardId, int widgetId);
    Q_INVOKABLE void deleteReportOpacity(int dashboardId, int widgetId); // TO CHANGE - MAKE PRIVATE

    Q_INVOKABLE void setDashboardReportUrl(int dashboardId, int reportId, QUrl url);
    Q_INVOKABLE void deleteDashboardReportUrl(int dashboardId, int reportId); // TO CHANGE - MAKE PRIVATE

    // Save and read files

    Q_INVOKABLE void saveImage(QUrl originalFile, QString newFilename);
    Q_INVOKABLE void setDashboardReportMap(int reportId);
    Q_INVOKABLE void saveDashboard();

    Q_INVOKABLE void deleteDashboardReportMap(int dashboardId, int reportId); // TO CHANGE - MAKE PRIVATE
    Q_INVOKABLE bool getDashboardReportMap(int reportId);
    Q_INVOKABLE int getDasbboardReportCount(int dashboardId);

    Q_INVOKABLE void clearAllMapValuesAfterDisconnect();

    // General
    QString lastContainerType() const;
    int positionY() const;
    int positionX() const;
    int zIndex() const;
    int dashboardCount() const;
    int currentDashboard() const;
    int currentReport() const;
    int tmpCanvasHeight() const;
    int tmpCanvasWidth() const;
    QString currentColumnType() const;
    QString wbName() const;

    QString currentSelectedColumn() const;

    // Function to call to emit a signal to hide all right columns in dashboard
    Q_INVOKABLE void hideAllDashboardRight();

public slots:
    void setLastContainerType(QString lastContainerType);
    void setPositionY(int positionY);
    void setPositionX(int positionX);
    void setZIndex(int zIndex);
    void setDashboardCount(int dashboardCount);
    void setCurrentDashboard(int currentDashboard);
    void setCurrentReport(int currentReport);
    void setTmpCanvasHeight(int tmpCanvasHeight);
    void setTmpCanvasWidth(int tmpCanvasWidth);
    void setCurrentColumnType(QString currentColumnType);
    void setWbName(QString wbName);

    // Filter column names
    void getColumnNames(int dashboardId, QStringList columnNames, QStringList columnTypes);
    void setCurrentSelectedColumn(QString currentSelectedColumn);

    // Receive extract workbook data params
    void getExtractDashboardParams(QJsonObject dashboardParams);

signals:
    void lastContainerTypeChanged(QString lastContainerType);
    void positionYChanged(int positionY);
    void positionXChanged(int positionX);
    void zIndexChanged(int zIndex);
    void dashboardCountChanged(int dashboardCount);
    void dashboardContentDestroyed(int dashboardId);
    void currentDashboardChanged(int currentDashboard, QVector<int> reportsInDashboard, QVariantMap dashboardUniqueWidgets);
    void currentReportChanged(int currentReport);

    void hideAllDashboardParams();

    // Filter parameters
    //    void hideColumnsChanged(QStringList hideColumns, int dashboardId);
    void aliasChanged(QString newAlias, QString columnName, int dashboardId);
    void columnFilterTypeChanged(QString filterType);
    void filterValuesChanged(QMap<int, QStringList> showColumns, QMap<int, QVariantMap> columnFilterType, QMap<int, QVariantMap> columnIncludeExcludeMap, QMap<int, QMap<QString, QStringList>> columnValueMap, int dashboardId);

    // Customize Dashboard parameters
    void dashboardNameChanged(int dashboardId, QString dashboardName);
    void dashboardBackgroundColorChanged(int dashboardId, QString color);
    void selectAllChanged(bool status, QString columnName, int dashboardId);

    // Customize Report parameters
    void reportNameChanged(int dashboardId, int widgetId, QString reportName);
    void reportBackgroundColorChanged(int dashboardId, int widgetId, QString color);
    void reportLineColorChanged(int dashboardId, int widgetId, QString color);
    void reportUrlChanged(int dashboardId, int widgetId, QString url);
    void tmpCanvasHeightChanged(int tmpCanvasHeight);
    void tmpCanvasWidthChanged(int tmpCanvasWidth);
    void currentColumnTypeChanged(QString currentColumnType);
    void wbNameChanged(QString wbName);

    void currentSelectedColumnChanged(QString currentSelectedColumn);

    // Save Dashboard Params
    void sendDashboardParams(QJsonObject dashboardParamsObj);
    void moveToDashboardScreen();
    void generateDashboards();
};

#endif // DASHBOARDPARAMSMODEL_H
