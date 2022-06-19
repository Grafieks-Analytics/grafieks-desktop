#include "dashboardparamsmodel.h"
#include "../Reports/reportparamsmodel.h"

DashboardParamsModel::DashboardParamsModel(QObject *parent) : QObject(parent)
{
    m_currentReport = 0;

    this->setDashboardCount(1);
    this->setCurrentDashboard(0);
    this->setZIndex(1);

    // Create 1 default dashboard
    QVariantList canvasDimensions;
    canvasDimensions.append(Constants::defaultCanvasWidth); // width
    canvasDimensions.append(Constants::defaultCanvasHeight); // height

    this->dashboardName.insert(0, "Dashboard 1");
    this->dashboardBackgroundColor.insert(0, Constants::DefaultBackgroundColor);
    this->dashboardOpacity.insert(0, 0);
    this->dashboardGrid.insert(0, false);

    this->dashboardCanvasDimensions.insert(0, canvasDimensions);
}

bool DashboardParamsModel::dragNewReport(int dashboardId, int widgetId, QString reportName)
{

    QVector<int> widgetIds;
    QMap<int, QString> reportNames;
    QMap<int, QString> reportBackgroundColors;
    QMap<int, QString> reportLineColors;
    QMap<int, int> reportOpacities;

    // Dashboard Report Mapping

    if (!this->dashboardWidgetsMap.isEmpty())
    {
        widgetIds = this->dashboardWidgetsMap.value(dashboardId);
        reportNames = this->reportName.value(dashboardId);
        reportBackgroundColors = this->reportBackgroundColor.value(dashboardId);
        reportLineColors = this->reportLineColor.value(dashboardId);
        reportOpacities = this->reportOpacity.value(dashboardId);
    }

    widgetIds.append(widgetId);
    reportNames.insert(widgetId, reportName);
    reportBackgroundColors.insert(widgetId, Constants::DefaultBackgroundColor);
    reportLineColors.insert(widgetId, Constants::DefaultReportLineColor);
    reportOpacities.insert(widgetId, 0);

    this->dashboardWidgetsMap[dashboardId] = widgetIds;
    this->reportName[dashboardId] = reportNames;
    this->reportBackgroundColor[dashboardId] = reportBackgroundColors;
    this->reportLineColor[dashboardId] = reportLineColors;
    this->reportOpacity[dashboardId] = reportOpacities;
    this->setCurrentReport(widgetId);

    return true;
}

bool DashboardParamsModel::removeReport(int dashboardId, int widgetId)
{

    int reportPosition = 0;

    // Remove customize report parameters

    this->reportName[dashboardId].remove(widgetId);
    this->reportBackgroundColor[dashboardId].remove(widgetId);
    this->reportLineColor[dashboardId].remove(widgetId);
    this->reportOpacity[dashboardId].remove(widgetId);

    // Remove dashboard report mapping parameters

    this->dashboardWidgetsZorder[dashboardId].remove(widgetId);
    this->dashboardWidgetCoordinates[dashboardId].remove(widgetId);
    this->dashboardWidgetTypeMap[dashboardId].remove(widgetId);
    this->dashboardWidgetUrl[dashboardId].remove(widgetId);

    // Remove the dashboard report mapping

    reportPosition = this->dashboardWidgetsMap[dashboardId].indexOf(widgetId);
    this->dashboardWidgetsMap[dashboardId].remove(reportPosition);

    return true;
}

bool DashboardParamsModel::createNewDashboard(int dashboardId)
{

    QVariantList canvasDimensions;
    canvasDimensions.append(Constants::defaultCanvasWidth); // default width
    canvasDimensions.append(Constants::defaultCanvasHeight); // default height

    this->dashboardName.insert(dashboardId, "Dashboard " + QString::number(dashboardId + 1));
    this->dashboardBackgroundColor.insert(dashboardId, "#FFFFFF");
    this->dashboardOpacity.insert(dashboardId, 0);
    this->dashboardGrid.insert(dashboardId, false);

    this->dashboardCanvasDimensions.insert(dashboardId, canvasDimensions);

    this->setDashboardCount(dashboardId + 1);
    this->setCurrentDashboard(dashboardId);

    return true;
}

bool DashboardParamsModel::destroyDashboard(int dashboardId, bool destroyAll)
{
    if(destroyAll == false){
        // Customize dashboard parameters
        this->dashboardName.remove(dashboardId);
        this->dashboardBackgroundColor.remove(dashboardId);
        this->dashboardOpacity.remove(dashboardId);
        this->dashboardGrid.remove(dashboardId);
        this->dashboardCanvasDimensions.remove(dashboardId);

        // Dashboard report mapping
        this->dashboardWidgetUrl.remove(dashboardId);
        this->dashboardWidgetTypeMap.remove(dashboardId);
        this->dashboardWidgetCoordinates.remove(dashboardId);
        this->dashboardWidgetsZorder.remove(dashboardId);
        this->dashboardWidgetsMap.remove(dashboardId);

        // Destroy filters
        this->showColumns.remove(dashboardId);
        this->columnAliasMap.remove(dashboardId);
        this->columnFilterType.remove(dashboardId);
        this->columnIncludeExcludeMap.remove(dashboardId);
        this->columnValueMap.remove(dashboardId);

        // Customize Report parameters
        this->reportName.remove(dashboardId);
        this->reportBackgroundColor.remove(dashboardId);
        this->reportLineColor.remove(dashboardId);
        this->reportOpacity.remove(dashboardId);

        // Decrease dashboard count
        this->setDashboardCount(this->dashboardCount() - 1);

        emit dashboardContentDestroyed(dashboardId);
    } else{
        // Customize dashboard parameters
        this->dashboardName.clear();
        this->dashboardBackgroundColor.clear();
        this->dashboardOpacity.clear();
        this->dashboardGrid.clear();
        this->dashboardCanvasDimensions.clear();

        // Dashboard report mapping
        this->dashboardWidgetUrl.clear();
        this->dashboardWidgetTypeMap.clear();
        this->dashboardWidgetCoordinates.clear();
        this->dashboardWidgetsZorder.clear();
        this->dashboardWidgetsMap.clear();

        // Destroy filters
        this->showColumns.clear();
        this->columnAliasMap.clear();
        this->columnFilterType.clear();
        this->columnIncludeExcludeMap.clear();
        this->columnValueMap.clear();

        // Customize Report parameters
        this->reportName.clear();
        this->reportBackgroundColor.clear();
        this->reportLineColor.clear();
        this->reportOpacity.clear();

        // Decrease dashboard count
        this->setDashboardCount(1);
        this->setCurrentDashboard(0);
        this->setZIndex(1);

        // Create 1 default dashboard
        QVariantList canvasDimensions;
        canvasDimensions.append(Constants::defaultCanvasWidth); // width
        canvasDimensions.append(Constants::defaultCanvasHeight); // height

        this->dashboardName.insert(0, "Dashboard 1");
        this->dashboardBackgroundColor.insert(0, Constants::DefaultBackgroundColor);
        this->dashboardOpacity.insert(0, 0);
        this->dashboardGrid.insert(0, false);

        this->dashboardCanvasDimensions.insert(0, canvasDimensions);

        emit dashboardContentDestroyed(-1);
    }
    return true;
}

QVariantMap DashboardParamsModel::fetchAllDashboards()
{
    QVariantMap output;
    int dashboardId = 0;
    QString dashboardName;

    for (auto key : this->dashboardName.keys())
    {

        dashboardId = key;
        dashboardName = this->dashboardName.value(key);

        output.insert(QString::number(dashboardId), dashboardName);
    }

    return output;
}

QVector<int> DashboardParamsModel::fetchReportsInDashboard(int dashboardId)
{
    QVector<int> output;

    output = this->dashboardWidgetsMap.value(dashboardId);

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportZOrder(int dashboardId)
{

    QVariantMap output;
    int widgetId = 0;
    int zOrder = 0;
    QMap<int, int> reportZOrder = this->dashboardWidgetsZorder.value(dashboardId);

    for (auto key : reportZOrder.keys())
    {

        widgetId = key;
        zOrder = reportZOrder.value(key);

        output.insert(QString::number(widgetId), zOrder);
    }

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportCoordinates(int dashboardId)
{
    QVariantMap output;
    int widgetId = 0;
    QVariantList coordinates;
    QMap<int, QVariantList> reportCoordinates = this->dashboardWidgetCoordinates.value(dashboardId);

    for (auto key : reportCoordinates.keys())
    {

        widgetId = key;
        coordinates = reportCoordinates.value(key);

        output.insert(QString::number(widgetId), coordinates);
    }

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportUrls(int dashboardId)
{
    QVariantMap output;
    int widgetId = 0;
    QUrl url;
    QMap<int, QUrl> reportUrl = this->dashboardWidgetUrl.value(dashboardId);

    for (auto key : reportUrl.keys())
    {

        widgetId = key;
        url = reportUrl.value(key);

        output.insert(QString::number(widgetId), url);
    }

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportTypeMap(int dashboardId)
{
    QVariantMap output;
    int widgetId = 0;
    int type;
    QMap<int, int> reportType = this->dashboardWidgetTypeMap.value(dashboardId);

    for (auto key : reportType.keys())
    {

        widgetId = key;
        type = reportType.value(key);

        output.insert(QString::number(widgetId), type);
    }

    return output;
}

void DashboardParamsModel::deleteReport(int reportId, int dashboardId)
{
    // Delete from all dashboards
    if(dashboardId == -1){
        QList<int> dashboardIds = this->dashboardReportMap.keys();

        foreach(int dashboardId, dashboardIds){
            QVector<int> reportIds = this->dashboardReportMap.value(dashboardId);

            if(reportIds.contains(reportId)){
                this->deleteReportFromDashboard(dashboardId, reportId);
                this->deleteReportZOrder(dashboardId, reportId);
                this->deleteDashboardWidgetCoordinates(dashboardId, reportId);
                this->deleteDashboardWidgetTypeMap(dashboardId, reportId);
                this->deleteDashboardWidgetUrl(dashboardId, reportId);

                this->deleteDashboardReportMap(dashboardId, reportId);

                this->deleteDashboardReportUrl(dashboardId, reportId);
                this->deleteTextReportParametersMap(dashboardId, reportId);

                this->deleteReportName(dashboardId, reportId);
                this->deleteReportBackgroundColor(dashboardId, reportId);
                this->deleteReportLineColor(dashboardId, reportId);
                this->deleteReportOpacity(dashboardId, reportId);

                // deleteDashboardUniqueWidget is unique because inner QVariantmap contains Hash as key and widgetId as value
                QVariantMap map = this->dashboardUniqueWidgetMap.value(dashboardId);
                QMapIterator<QString, QVariant> i(map);
                while (i.hasNext()) {
                    i.next();
                    if(i.value() == reportId){
                        this->deleteDashboardUniqueWidget(dashboardId, i.key());
                    }
                }
            }
        }

    } else {
        this->deleteReportFromDashboard(dashboardId, reportId);
        this->deleteReportZOrder(dashboardId, reportId);
        this->deleteDashboardWidgetCoordinates(dashboardId, reportId);
        this->deleteDashboardWidgetTypeMap(dashboardId, reportId);
        this->deleteDashboardWidgetUrl(dashboardId, reportId);

        this->deleteDashboardReportMap(dashboardId, reportId);

        this->deleteDashboardReportUrl(dashboardId, reportId);
        this->deleteTextReportParametersMap(dashboardId, reportId);

        this->deleteReportName(dashboardId, reportId);
        this->deleteReportBackgroundColor(dashboardId, reportId);
        this->deleteReportLineColor(dashboardId, reportId);
        this->deleteReportOpacity(dashboardId, reportId);
    }
}

void DashboardParamsModel::addReportToDashboard(int dashboardId, int widgetId)
{
    QVector<int> reports;

    if (this->dashboardWidgetsMap.value(dashboardId).isEmpty())
    {

        reports.append(widgetId);
        this->dashboardWidgetsMap.insert(dashboardId, reports);
    }
    else
    {

        reports = this->dashboardWidgetsMap.value(dashboardId);
        reports.append(widgetId);
        this->dashboardWidgetsMap.insert(dashboardId, reports);
    }
}

void DashboardParamsModel::deleteReportFromDashboard(int dashboardId, int widgetId)
{

    QVector<int> reports;

    if (!this->dashboardWidgetsMap.value(dashboardId).isEmpty())
    {

        reports = this->dashboardWidgetsMap.value(dashboardId);
        if (reports.contains(widgetId))
        {
            reports.remove(reports.indexOf(widgetId));
            this->dashboardWidgetsMap.insert(dashboardId, reports);
        }
    }
}

void DashboardParamsModel::setReportZOrder(int dashboardId, int widgetId, int zOrder)
{

    QMap<int, int> reportsZOrder;

    if (this->dashboardWidgetsZorder.value(dashboardId).isEmpty())
    {

        reportsZOrder.insert(widgetId, zOrder);
        this->dashboardWidgetsZorder.insert(dashboardId, reportsZOrder);
    }
    else
    {

        reportsZOrder = this->dashboardWidgetsZorder.value(dashboardId);
        reportsZOrder[widgetId] = zOrder;
        this->dashboardWidgetsZorder.insert(dashboardId, reportsZOrder);
    }
}

int DashboardParamsModel::getReportZOrder(int dashboardId, int widgetId)
{

    int output = 0;
    QMap<int, int> reportsZOrder;

    if (!this->dashboardWidgetsMap.value(dashboardId).isEmpty())
    {

        reportsZOrder = this->dashboardWidgetsZorder.value(dashboardId);
        if (reportsZOrder.contains(widgetId))
        {
            output = reportsZOrder.value(widgetId);
        }
    }

    return output;
}

void DashboardParamsModel::deleteReportZOrder(int dashboardId, int widgetId)
{
    int output = 0;
    QMap<int, int> reportsZOrder;

    if (!this->dashboardWidgetsMap.value(dashboardId).isEmpty())
    {

        reportsZOrder = this->dashboardWidgetsZorder.value(dashboardId);
        if (reportsZOrder.contains(widgetId))
        {
            reportsZOrder.remove(widgetId);
        }
        this->dashboardWidgetsZorder.insert(dashboardId, reportsZOrder);
    }
}

void DashboardParamsModel::setDashboardWidgetCoordinates(int dashboardId, int widgetId, float x1, float y1, float x2, float y2)
{

    QMap<int, QVariantList> reportCoordinates;
    QVariantList coordinates;

    coordinates << x1 << y1 << x2 << y2;

    if (this->dashboardWidgetCoordinates.value(dashboardId).isEmpty())
    {

        reportCoordinates.insert(widgetId, coordinates);
        this->dashboardWidgetCoordinates.insert(dashboardId, reportCoordinates);
    }
    else
    {

        reportCoordinates = this->dashboardWidgetCoordinates.value(dashboardId);
        reportCoordinates[widgetId] = coordinates;
        this->dashboardWidgetCoordinates[dashboardId] = reportCoordinates;
    }
}

QVariantList DashboardParamsModel::getDashboardWidgetCoordinates(int dashboardId, int widgetId)
{

    QVariantList output;
    QMap<int, QVariantList> reportCoordinates;

    if (!this->dashboardWidgetCoordinates.value(dashboardId).isEmpty())
    {

        reportCoordinates = this->dashboardWidgetCoordinates.value(dashboardId);
        if (reportCoordinates.contains(widgetId))
        {
            output = reportCoordinates.value(widgetId);
        }
    }

    return output;
}

void DashboardParamsModel::deleteDashboardWidgetCoordinates(int dashboardId, int widgetId)
{
    QMap<int, QVariantList> reportCoordinates;

    if (!this->dashboardWidgetCoordinates.value(dashboardId).isEmpty())
    {

        reportCoordinates = this->dashboardWidgetCoordinates.value(dashboardId);
        if (reportCoordinates.contains(widgetId))
        {
            reportCoordinates.remove(widgetId);
        }
        this->dashboardWidgetCoordinates.insert(dashboardId, reportCoordinates);
    }
}

void DashboardParamsModel::setDashboardWidgetTypeMap(int dashboardId, int widgetId, int reportType)
{

    QMap<int, int> reportTypeMap;

    if (this->dashboardWidgetTypeMap.value(dashboardId).isEmpty())
    {

        reportTypeMap.insert(widgetId, reportType);
        this->dashboardWidgetTypeMap.insert(dashboardId, reportTypeMap);
    }
    else
    {

        reportTypeMap = this->dashboardWidgetTypeMap.value(dashboardId);
        reportTypeMap[widgetId] = reportType;

        this->dashboardWidgetTypeMap.insert(dashboardId, reportTypeMap);
    }

    // If report type is text type, then save here specially
    if(reportType == Constants::reportTypeText){
        QUrl finalFileName;
        finalFileName = QString::number(this->currentDashboard()) + "_" + QString::number(this->currentReport()) + "_" + generalParamsModel.getFileToken() + ".html";
        this->setDashboardWidgetUrl(this->currentDashboard(), this->currentReport(), finalFileName);
    }
}

int DashboardParamsModel::getDashboardWidgetTypeMap(int dashboardId, int widgetId)
{

    int output = 0;
    QMap<int, int> reportTypeMap;

    if (!this->dashboardWidgetTypeMap.value(dashboardId).isEmpty())
    {
        reportTypeMap = this->dashboardWidgetTypeMap.value(dashboardId);
        if (reportTypeMap.contains(widgetId))
        {
            output = reportTypeMap.value(widgetId);
        }
    }

    return output;
}

void DashboardParamsModel::deleteDashboardWidgetTypeMap(int dashboardId, int widgetId)
{
    QMap<int, int> reportTypeMap;

    if (!this->dashboardWidgetTypeMap.value(dashboardId).isEmpty())
    {
        reportTypeMap = this->dashboardWidgetTypeMap.value(dashboardId);
        if (reportTypeMap.contains(widgetId))
        {
            reportTypeMap.remove(widgetId);
        }
        this->dashboardWidgetTypeMap.insert(dashboardId, reportTypeMap);
    }
}

void DashboardParamsModel::setDashboardWidgetUrl(int dashboardId, int widgetId, QUrl url)
{
    QMap<int, QUrl> reportUrl;

    if (this->dashboardWidgetUrl.value(dashboardId).isEmpty())
    {

        reportUrl.insert(widgetId, url);
        this->dashboardWidgetUrl.insert(dashboardId, reportUrl);
    }
    else
    {

        reportUrl = this->dashboardWidgetUrl.value(dashboardId);
        reportUrl[widgetId] = url;

        this->dashboardWidgetUrl.insert(dashboardId, reportUrl);
    }

    emit reportUrlChanged(dashboardId, widgetId, url.toString());
}

QUrl DashboardParamsModel::getDashboardWidgetUrl(int dashboardId, int widgetId)
{

    QUrl output;
    QMap<int, QUrl> reportUrl;

    if (!this->dashboardWidgetUrl.value(dashboardId).isEmpty())
    {

        reportUrl = this->dashboardWidgetUrl.value(dashboardId);
        if (reportUrl.contains(widgetId))
        {
            output = reportUrl.value(widgetId);
        }
    }

    return output;
}

void DashboardParamsModel::deleteDashboardWidgetUrl(int dashboardId, int widgetId)
{
    QMap<int, QUrl> reportUrl;

    if (!this->dashboardWidgetUrl.value(dashboardId).isEmpty())
    {

        reportUrl = this->dashboardWidgetUrl.value(dashboardId);
        if (reportUrl.contains(widgetId))
        {
            reportUrl.remove(widgetId);
        }

        this->dashboardWidgetUrl.insert(dashboardId, reportUrl);
    }
}

void DashboardParamsModel::setDashboardUniqueWidget(int dashboardId, int widgetId, QString hash)
{
    QVariantMap tmpWidgetHash;

    tmpWidgetHash = this->dashboardUniqueWidgetMap.value(dashboardId);
    tmpWidgetHash.insert(hash, widgetId);

    this->dashboardUniqueWidgetMap.insert(dashboardId, tmpWidgetHash);
}

QString DashboardParamsModel::getDashboardUniqueWidget(int dashboardId, int widgetId)
{
    return this->dashboardUniqueWidgetMap.value(dashboardId).key(widgetId);
}

void DashboardParamsModel::deleteDashboardUniqueWidget(int dashboardId, QString hash)
{
    QVariantMap tmpWidgetHash;

    tmpWidgetHash = this->dashboardUniqueWidgetMap.value(dashboardId);
    tmpWidgetHash.remove(hash);

    this->dashboardUniqueWidgetMap.insert(dashboardId, tmpWidgetHash);
}

void DashboardParamsModel::setTextReportParametersMap(int dashboardId, int widgetId, QVariantMap textReportParams)
{
    QMap<int, QVariantMap> tmp;
    tmp = this->textReportParametersMap.value(dashboardId);

    if(tmp.contains(widgetId)){
        tmp[widgetId] = textReportParams;
    } else {
        tmp.insert(widgetId, textReportParams);
    }

    this->textReportParametersMap.insert(dashboardId, tmp);
}

QVariant DashboardParamsModel::getTextReportParametersMap(int dashboardId, int widgetId)
{
    return this->textReportParametersMap.value(dashboardId).value(widgetId);
}

void DashboardParamsModel::deleteTextReportParametersMap(int dashboardId, int widgetId)
{
    QMap<int, QVariantMap> textReportParam;
    textReportParam = this->textReportParametersMap.value(dashboardId);
    textReportParam.remove(widgetId);

    this->textReportParametersMap.insert(dashboardId, textReportParam);
}

void DashboardParamsModel::addToShowColumns(int dashboardId, QString colName, bool status)
{

    QStringList colNames = this->showColumns.value(dashboardId);
    if(status == true){
        if(colNames.indexOf(colName) < 0)
            colNames.append(colName);
    } else{
        colNames.removeAll(colName);

        // Remove from include/exclude
        QVariantMap colIncludeExclude = this->columnIncludeExcludeMap.value(dashboardId);
        colIncludeExclude.remove(colName);
        this->columnIncludeExcludeMap.insert(dashboardId, colIncludeExclude);

        // Remove from alias name
        QVariantMap colFilterType = this->columnFilterType.value(dashboardId);
        colFilterType.remove(colName);
        this->columnFilterType.insert(dashboardId, colFilterType);

        // Remove from filter type
        QVariantMap colAliasNames = this->columnAliasMap.value(dashboardId);
        colAliasNames.remove(colName);
        this->columnAliasMap.insert(dashboardId, colAliasNames);
    }
    this->showColumns.insert(dashboardId, colNames);
    //    emit hideColumnsChanged(colNames, dashboardId);
}


QStringList DashboardParamsModel::fetchShowColumns(int dashboardId, QString searchKeyword)
{
    QStringList colNames = this->showColumns.value(dashboardId);
    return colNames.filter(searchKeyword);
}

void DashboardParamsModel::setColumnAliasName(int dashboardId, QString columnName, QString columnAlias)
{
    QVariantMap colAliasNames = this->columnAliasMap.value(dashboardId);
    colAliasNames.insert(columnName, columnAlias);
    this->columnAliasMap.insert(dashboardId, colAliasNames);
    emit aliasChanged(columnAlias, columnName, dashboardId);
}

QString DashboardParamsModel::fetchColumnAliasName(int dashboardId, QString columnName)
{
    QVariantMap colAliasNames = this->columnAliasMap.value(dashboardId);
    return colAliasNames.value(columnName).toString();
}

void DashboardParamsModel::setColumnFilterType(int dashboardId, QString columnName, QString filterType)
{
    QVariantMap colFilterType = this->columnFilterType.value(dashboardId);
    colFilterType.insert(columnName, filterType);
    this->columnFilterType.insert(dashboardId, colFilterType);

    emit columnFilterTypeChanged();
}

QString DashboardParamsModel::fetchColumnFilterType(int dashboardId, QString columnName)
{
    QVariantMap colFilterType = this->columnFilterType.value(dashboardId);
    return colFilterType.value(columnName).toString();
}

void DashboardParamsModel::setIncludeExcludeMap(int dashboardId, QString columnName, QString type)
{
    QVariantMap colIncludeExclude = this->columnIncludeExcludeMap.value(dashboardId);
    colIncludeExclude.insert(columnName, type);
    this->columnIncludeExcludeMap.insert(dashboardId, colIncludeExclude);
}

QString DashboardParamsModel::fetchIncludeExcludeMap(int dashboardId, QString columnName)
{
    QVariantMap colIncludeExclude = this->columnIncludeExcludeMap.value(dashboardId);
    return colIncludeExclude.value(columnName).toString();
}

void DashboardParamsModel::setColumnValueMap(int dashboardId, QString columnName, QString value)
{
    QMap<QString, QStringList> valueMap;
    QStringList values;
    QString relation = this->fetchColumnFilterType(dashboardId, columnName);

    valueMap = this->columnValueMap.value(dashboardId);
    values = valueMap.value(columnName);

    if(relation == "dataBetween" || relation == "dataRange" || relation == "dataDateRange"){
        values = value.split(",");
    } else{
        if(values.indexOf(value) < 0){
            values.append(value);
        }
    }

    valueMap.insert(columnName, values);
    this->columnValueMap.insert(dashboardId, valueMap);
}

QStringList DashboardParamsModel::fetchColumnValueMap(int dashboardId, QString columnName)
{
    return this->columnValueMap.value(dashboardId).value(columnName);
}

void DashboardParamsModel::deleteColumnValueMap(int dashboardId, QString columnName, QString value, bool removeAll)
{
    QMap<QString, QStringList> valueMap;
    QStringList values;
    valueMap = this->columnValueMap.value(dashboardId);

    values = valueMap.value(columnName);
    if(removeAll == true){
        values.clear();
    } else{
        values.removeAll(value);
    }

    if(values.length() > 0){
        valueMap.insert(columnName, values);
        this->columnValueMap.insert(dashboardId, valueMap);
    } else {
        QMap<QString, QStringList> tmpColMap = this->columnValueMap.value(dashboardId);
        tmpColMap.remove(columnName);
        this->columnValueMap.insert(dashboardId, tmpColMap);

    }
}

void DashboardParamsModel::applyFilterToDashboard(int dashboardId)
{
    qDebug() << "Col val map" << this->columnValueMap;
    emit filterValuesChanged(this->showColumns, this->columnFilterType, this->columnIncludeExcludeMap, this->columnValueMap, dashboardId);
}

void DashboardParamsModel::clearFilters(){
    this->showColumns.clear();
    this->columnAliasMap.clear();
    this->columnFilterType.clear();
    this->columnIncludeExcludeMap.clear();
    this->columnValueMap.clear();
}

void DashboardParamsModel::setDashboardName(int dashboardId, QString dashboardName)
{

    this->dashboardName.insert(dashboardId, dashboardName);
    emit dashboardNameChanged(dashboardId, dashboardName);
}

QString DashboardParamsModel::getDashboardName(int dashboardId)
{

    QString output;
    output = this->dashboardName.value(dashboardId);

    return output;
}

void DashboardParamsModel::setDashboardBackgroundColor(int dashboardId, QString color)
{

    this->dashboardBackgroundColor.insert(dashboardId, color);

    emit dashboardBackgroundColorChanged(dashboardId, color);
}

QString DashboardParamsModel::getDashboardBackgroundColor(int dashboardId)
{

    QString output;
    output = this->dashboardBackgroundColor.value(dashboardId);

    return output;
}

void DashboardParamsModel::setDashboardOpacity(int dashboardId, int percent)
{

    this->dashboardOpacity.insert(dashboardId, percent);
}

int DashboardParamsModel::getDashboardOpacity(int dashboardId)
{

    int output = 0;
    output = this->dashboardOpacity.value(dashboardId);

    return output;
}

void DashboardParamsModel::setDashboardGrid(int dashboardId, bool gridVisible)
{

    this->dashboardGrid.insert(dashboardId, gridVisible);
}

bool DashboardParamsModel::getDashboardGrid(int dashboardId)
{
    bool output;
    output = this->dashboardGrid.value(dashboardId);
    return output;
}

void DashboardParamsModel::setDashboardDimensions(int dashboardId, int width, int height)
{

    QVariantList dimensions;
    dimensions << width << height;
    this->dashboardCanvasDimensions.insert(dashboardId, dimensions);


}

QVariantList DashboardParamsModel::getDashboardDimensions(int dashboardId)
{
    QVariantList output;
    output = this->dashboardCanvasDimensions.value(dashboardId);

    return output;
}

void DashboardParamsModel::setReportName(int dashboardId, int widgetId, QString reportName)
{
    QMap<int, QString> name;
    if (this->reportName.value(dashboardId).isEmpty())
    {

        name.insert(widgetId, reportName);
        this->reportName.insert(dashboardId, name);
    }
    else
    {

        name = this->reportName.value(dashboardId);
        name[widgetId] = reportName;

        this->reportName.insert(dashboardId, name);
    }
    emit reportNameChanged(dashboardId, widgetId, reportName);
}

QString DashboardParamsModel::getReportName(int dashboardId, int widgetId)
{
    QString output;
    QMap<int, QString> name;

    if (!this->reportName.value(dashboardId).isEmpty())
    {

        name = this->reportName.value(dashboardId);
        if (name.contains(widgetId))
        {
            output = name.value(widgetId);
        }
    }

    return output;
}

void DashboardParamsModel::deleteReportName(int dashboardId, int widgetId)
{
    QMap<int, QString> name;

    if (!this->reportName.value(dashboardId).isEmpty())
    {

        name = this->reportName.value(dashboardId);
        if (name.contains(widgetId))
        {
            name.remove(widgetId);
        }
        this->reportName.insert(dashboardId, name);
    }
}

void DashboardParamsModel::clearAllMapValuesAfterDisconnect(){
    this->dashboardWidgetsMap.clear();                   // <dashboardId, <widgetId>>
    this->dashboardWidgetsZorder.clear();              // <dashboardId, <widgetId, zId>>
    this->dashboardWidgetCoordinates.clear(); // <dashboardId, <widgetId, [x1, y1, x2, y2]>>
    this->dashboardWidgetTypeMap.clear();              // <dashboardId, <widgetId, reportTypeId (constant)>>
    this->dashboardWidgetUrl.clear();                 // <dashboardId, <widgetId, URI Link>>
    this->dashboardUniqueWidgetMap.clear();               
    this->dashboardReportMap.clear();
}
    

void DashboardParamsModel::setReportBackgroundColor(int dashboardId, int widgetId, QString color)
{

    QMap<int, QString> backgroundColor;
    if (this->reportBackgroundColor.value(dashboardId).isEmpty())
    {

        backgroundColor.insert(widgetId, color);
        this->reportBackgroundColor.insert(dashboardId, backgroundColor);
    }
    else
    {

        backgroundColor = this->reportBackgroundColor.value(dashboardId);
        backgroundColor[widgetId] = color;

        this->reportBackgroundColor.insert(dashboardId, backgroundColor);
    }

    emit reportBackgroundColorChanged(dashboardId, widgetId, color);
}

QString DashboardParamsModel::getReportBackgroundColor(int dashboardId, int widgetId)
{

    QString output;
    QMap<int, QString> backgroundColor;

    if (!this->reportBackgroundColor.value(dashboardId).isEmpty())
    {

        backgroundColor = this->reportBackgroundColor.value(dashboardId);
        if (backgroundColor.contains(widgetId))
        {
            output = backgroundColor.value(widgetId);
        }
    }

    return output;
}

void DashboardParamsModel::deleteReportBackgroundColor(int dashboardId, int widgetId)
{
    QMap<int, QString> backgroundColor;

    if (!this->reportBackgroundColor.value(dashboardId).isEmpty())
    {

        backgroundColor = this->reportBackgroundColor.value(dashboardId);
        if (backgroundColor.contains(widgetId))
        {
            backgroundColor.remove(widgetId);
        }

        this->reportBackgroundColor.insert(dashboardId, backgroundColor);
    }
}

void DashboardParamsModel::setReportLineColor(int dashboardId, int widgetId, QString color)
{

    QMap<int, QString> lineColor;
    if (this->reportLineColor.value(dashboardId).isEmpty())
    {

        lineColor.insert(widgetId, color);
        this->reportLineColor.insert(dashboardId, lineColor);
    }
    else
    {

        lineColor = this->reportLineColor.value(dashboardId);
        lineColor[widgetId] = color;

        this->reportLineColor.insert(dashboardId, lineColor);
    }

    emit reportLineColorChanged(dashboardId, widgetId, color);
}


void DashboardParamsModel::deleteReportLineColor(int dashboardId, int widgetId)
{
    QMap<int, QString> lineColor;

    if (!this->reportLineColor.value(dashboardId).isEmpty())
    {

        lineColor = this->reportLineColor.value(dashboardId);
        if (lineColor.contains(widgetId))
        {
            lineColor.remove(widgetId);
        }

        this->reportLineColor.insert(dashboardId, lineColor);
    }
}

void DashboardParamsModel::setReportOpacity(int dashboardId, int widgetId, int percent)
{

    QMap<int, int> reportOpacity;
    if (this->reportOpacity.value(dashboardId).isEmpty())
    {

        reportOpacity.insert(widgetId, percent);
        this->reportOpacity.insert(dashboardId, reportOpacity);
    }
    else
    {

        reportOpacity = this->reportOpacity.value(dashboardId);
        reportOpacity[widgetId] = percent;

        this->reportOpacity.insert(dashboardId, reportOpacity);
    }
}

int DashboardParamsModel::getReportOpacity(int dashboardId, int widgetId)
{

    int output = 0;
    QMap<int, int> reportOpacity;

    if (!this->reportOpacity.value(dashboardId).isEmpty())
    {

        reportOpacity = this->reportOpacity.value(dashboardId);
        if (reportOpacity.contains(widgetId))
        {
            output = reportOpacity.value(widgetId);
        }
    }

    return output;
}

void DashboardParamsModel::deleteReportOpacity(int dashboardId, int widgetId)
{
    QMap<int, int> reportOpacity;

    if (!this->reportOpacity.value(dashboardId).isEmpty())
    {

        reportOpacity = this->reportOpacity.value(dashboardId);
        if (reportOpacity.contains(widgetId))
        {
            reportOpacity.remove(widgetId);
        }

        this->reportOpacity.insert(dashboardId, reportOpacity);
    }
}

void DashboardParamsModel::setDashboardReportUrl(int dashboardId, int reportId, QUrl url)
{
    QMap<int, QString> reportUrl;

    if (this->dashboardReportUrl.value(dashboardId).isEmpty())
    {

        reportUrl.insert(reportId, url.toString());
        this->dashboardReportUrl.insert(dashboardId, reportUrl);
    }
    else
    {

        reportUrl = this->dashboardReportUrl.value(dashboardId);
        reportUrl[reportId] = url.toString();

        this->dashboardReportUrl.insert(dashboardId, reportUrl);
    }

    emit reportUrlChanged(dashboardId, reportId, url.toString());
}


void DashboardParamsModel::deleteDashboardReportUrl(int dashboardId, int reportId)
{
    QMap<int, QString> reportUrl;

    if (!this->dashboardReportUrl.value(dashboardId).isEmpty())
    {

        reportUrl = this->dashboardReportUrl.value(dashboardId);
        if (reportUrl.contains(reportId))
        {
            reportUrl.remove(reportId);
        }
        this->dashboardReportUrl.insert(dashboardId, reportUrl);
    }
}

void DashboardParamsModel::saveImage(QUrl originalFile, QString newFilename)
{
    QFileInfo fi(originalFile.toString());
    QString ext = fi.completeSuffix();
    QString finalFileName = newFilename + "." + ext;

    QString tmpFilePath = QCoreApplication::applicationDirPath() + "/" + "tmp/";
    QDir tmpDir(tmpFilePath);

    // Check if tmp directory exists
    if (!tmpDir.exists())
    {
        QDir().mkdir(tmpFilePath);
    }

    QString filePath = tmpFilePath + finalFileName;

    // Save the file
    bool result = QFile::copy(originalFile.toLocalFile(), filePath);

    if (result == true)
    {
        this->setDashboardWidgetUrl(this->currentDashboard(), this->currentReport(), finalFileName);
    }
}

QString DashboardParamsModel::lastContainerType() const
{
    return m_lastContainerType;
}

int DashboardParamsModel::positionY() const
{
    return m_positionY;
}

int DashboardParamsModel::positionX() const
{
    return m_positionX;
}

int DashboardParamsModel::zIndex() const
{
    return m_zIndex;
}

int DashboardParamsModel::dashboardCount() const
{
    return m_dashboardCount;
}

int DashboardParamsModel::currentDashboard() const
{
    return m_currentDashboard;
}

int DashboardParamsModel::currentReport() const
{
    return m_currentReport;
}

int DashboardParamsModel::tmpCanvasHeight() const
{
    return m_tmpCanvasHeight;
}

int DashboardParamsModel::tmpCanvasWidth() const
{
    return m_tmpCanvasWidth;
}

QString DashboardParamsModel::currentColumnType() const
{
    return m_currentColumnType;
}

QString DashboardParamsModel::wbName() const
{
    return m_wbName;
}

QString DashboardParamsModel::currentSelectedColumn() const
{
    return m_currentSelectedColumn;
}

void DashboardParamsModel::hideAllDashboardRight()
{
    emit hideAllDashboardParams();
}

void DashboardParamsModel::setLastContainerType(QString lastContainerType)
{
    if (m_lastContainerType == lastContainerType)
        return;

    m_lastContainerType = lastContainerType;
    emit lastContainerTypeChanged(m_lastContainerType);
}

void DashboardParamsModel::setPositionY(int positionY)
{
    if (m_positionY == positionY)
        return;

    m_positionY = positionY;
    emit positionYChanged(m_positionY);
}

void DashboardParamsModel::setPositionX(int positionX)
{
    if (m_positionX == positionX)
        return;

    m_positionX = positionX;
    emit positionXChanged(m_positionX);
}

void DashboardParamsModel::setZIndex(int zIndex)
{
    if (m_zIndex == zIndex)
        return;

    m_zIndex = zIndex;
    emit zIndexChanged(m_zIndex);
}

void DashboardParamsModel::setDashboardCount(int dashboardCount)
{
    if (m_dashboardCount == dashboardCount)
        return;

    m_dashboardCount = dashboardCount;
    emit dashboardCountChanged(m_dashboardCount);
}

void DashboardParamsModel::setCurrentDashboard(int currentDashboard)
{
    if (m_currentDashboard == currentDashboard)
        return;

    QVector<int> reportsInDashboard;
    reportsInDashboard = this->dashboardWidgetsMap.value(currentDashboard);

    QVariantMap uniqueWidgets;
    uniqueWidgets = this->dashboardUniqueWidgetMap.value(currentDashboard);

    m_currentDashboard = currentDashboard;
    emit currentDashboardChanged(m_currentDashboard, reportsInDashboard, uniqueWidgets);
}

void DashboardParamsModel::setCurrentReport(int currentReport)
{
    if (m_currentReport == currentReport)
        return;

    m_currentReport = currentReport;
    emit currentReportChanged(m_currentReport);
}

void DashboardParamsModel::setTmpCanvasHeight(int tmpCanvasHeight)
{
    if (m_tmpCanvasHeight == tmpCanvasHeight)
        return;

    m_tmpCanvasHeight = tmpCanvasHeight;
    // Change all the default heights of the canvases
    for(int i = 0; i < this->dashboardCount(); i++){
        qDebug() << m_tmpCanvasHeight << "CANVAS HEIGHT";
        this->dashboardCanvasDimensions[i][1] = m_tmpCanvasHeight;
    }
    emit tmpCanvasHeightChanged(m_tmpCanvasHeight);
}

void DashboardParamsModel::setTmpCanvasWidth(int tmpCanvasWidth)
{
    if (m_tmpCanvasWidth == tmpCanvasWidth)
        return;

    m_tmpCanvasWidth = tmpCanvasWidth;

    // Change all the default widths of the canvases
    for(int i = 0; i < this->dashboardCount(); i++){
        qDebug() << m_tmpCanvasWidth << "CANVAS WIDTH";
        this->dashboardCanvasDimensions[i][0] = m_tmpCanvasWidth;
    }
    emit tmpCanvasWidthChanged(m_tmpCanvasWidth);
}

void DashboardParamsModel::setCurrentColumnType(QString currentColumnType)
{
    if (m_currentColumnType == currentColumnType)
        return;

    m_currentColumnType = currentColumnType;
    emit currentColumnTypeChanged(m_currentColumnType);
}

void DashboardParamsModel::setWbName(QString wbName)
{
    if (m_wbName == wbName)
        return;

    m_wbName = wbName;
    emit wbNameChanged(m_wbName);
}

void DashboardParamsModel::getColumnNames(int dashboardId, QStringList columnNames, QStringList columnTypes)
{

    const QString defaultFilterTypeCategorical = "dataListMulti";  // Do not change this name
    const QString defaultFilterTypeNumerical = "dataRange";        // Do not change this name
    const QString defaultIncludeType = "include";                  // Do not change this name

    int i = 0;
    foreach(QString column, columnNames){

        // Set default column alias name to the existing column name
        if(this->fetchColumnAliasName(dashboardId, column) == "")
            this->setColumnAliasName(dashboardId, column, column);

        // Set default filter type
        if(this->fetchColumnFilterType(dashboardId, column) == ""){

            QString defaultFilterType;
            if(columnTypes.at(i) == Constants::categoricalType ||columnTypes.at(i) == Constants::dateType  ) {
                defaultFilterType = defaultFilterTypeCategorical;
            } else {
                defaultFilterType = defaultFilterTypeNumerical;
            }

            this->setColumnFilterType(dashboardId, column, defaultFilterType);
        }


        // Set default include/exclude type
        if(this->fetchIncludeExcludeMap(dashboardId, column) == "")
            this->setIncludeExcludeMap(dashboardId, column, defaultIncludeType);

        i++;
    }
}

void DashboardParamsModel::setCurrentSelectedColumn(QString currentSelectedColumn)
{
    if (m_currentSelectedColumn == currentSelectedColumn)
        return;

    m_currentSelectedColumn = currentSelectedColumn;
    emit currentSelectedColumnChanged(m_currentSelectedColumn);
}

void DashboardParamsModel::getExtractDashboardParams(QJsonObject dashboardParams)
{
    QJsonObject mainObj;
    QJsonObject childObj;

    QStringList dashboardIds = dashboardParams.value("dashboardReportMap").toObject().keys();

    this->setDashboardCount(dashboardIds.length());

    foreach(QString dashboardId, dashboardIds){

        // dashboardWidgetsMap
        mainObj = dashboardParams.value("dashboardWidgetsMap").toObject();
        foreach(QVariant widgetId, mainObj.value(dashboardId).toArray())
            this->addReportToDashboard(dashboardId.toInt(), widgetId.toInt());

        // dashboardWidgetsZorder
        mainObj = dashboardParams.value("dashboardWidgetsZorder").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList dashboardWidgetsZorderKeys = childObj.keys();

        foreach(QString widgetId, dashboardWidgetsZorderKeys){
            int zOrder = childObj.value(widgetId).toInt();
            this->setReportZOrder(dashboardId.toInt(), widgetId.toInt(), zOrder);
        }

        // dashboardWidgetCoordinates
        mainObj = dashboardParams.value("dashboardWidgetCoordinates").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList dashboardWidgetCoordinatesKeys = childObj.keys();

        foreach(QString widgetId, dashboardWidgetCoordinatesKeys){
            QVariantList coordinates = childObj.value(widgetId).toArray().toVariantList();
            this->setDashboardWidgetCoordinates(dashboardId.toInt(), widgetId.toInt(), coordinates.at(0).toFloat(), coordinates.at(1).toFloat(), coordinates.at(2).toFloat(), coordinates.at(3).toFloat());
        }

        // dashboardWidgetTypeMap
        mainObj = dashboardParams.value("dashboardWidgetTypeMap").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList dashboardWidgetTypeMapKeys = childObj.keys();

        foreach(QString widgetId, dashboardWidgetTypeMapKeys){
            int typeMap = childObj.value(widgetId).toInt();
            this->setDashboardWidgetTypeMap(dashboardId.toInt(), widgetId.toInt(), typeMap);
        }

        // dashboardWidgetUrl
        mainObj = dashboardParams.value("dashboardWidgetUrl").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList dashboardWidgetUrlKeys = childObj.keys();

        foreach(QString widgetId, dashboardWidgetUrlKeys){
            QUrl url(childObj.value(widgetId).toString());
            this->setDashboardWidgetUrl(dashboardId.toInt(), widgetId.toInt(), url);
        }

        // dashboardUniqueWidgetMap
        mainObj = dashboardParams.value("dashboardUniqueWidgetMap").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList dashboardUniqueWidgetKeys = childObj.keys();

        foreach(QString hash, dashboardUniqueWidgetKeys){
            int widgetId = childObj.value(hash).toString().toInt();
            this->setDashboardUniqueWidget(dashboardId.toInt(), widgetId, hash);
        }

        // dashboardReportMap
        mainObj = dashboardParams.value("dashboardReportMap").toObject();
        foreach(QVariant reportId, mainObj.value(dashboardId).toArray()){

            QVector<int> dashboardReportMapList = this->dashboardReportMap.value(dashboardId.toInt());
            dashboardReportMapList.append(reportId.toInt());
            this->dashboardReportMap.insert(dashboardId.toInt(), dashboardReportMapList);
        }

        // dashboardReportUrl
        mainObj = dashboardParams.value("dashboardReportUrl").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList dashboardReportUrlKeys = childObj.keys();

        foreach(QString widgetId, dashboardReportUrlKeys){
            QUrl url(childObj.value(widgetId).toString());
            this->setDashboardReportUrl(dashboardId.toInt(), widgetId.toInt(), url);
        }

        // textReportParameters
        mainObj = dashboardParams.value("textReportParametersMap").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList textReportParametersKeys = childObj.keys();

        foreach(QString widgetId, textReportParametersKeys){
            QVariantMap map = childObj.value(widgetId).toObject().toVariantMap();
            this->setTextReportParametersMap(dashboardId.toInt(), widgetId.toInt(), map);
        }

        // showColumns
        mainObj = dashboardParams.value("showColumns").toObject();
        QStringList tmpList;
        foreach(QVariant params, mainObj.value(dashboardId).toArray()){
            tmpList.append(params.toString());
        }
        this->showColumns.insert(dashboardId.toInt(), tmpList);


        // columnAliasMap
        mainObj = dashboardParams.value("columnAliasMap").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList columnAliasMapKeys = childObj.keys();

        foreach(QString column, columnAliasMapKeys){
            QString alias = childObj.value(column).toString();
            this->setColumnAliasName(dashboardId.toInt(), column, alias);
        }

        // columnFilterType
        mainObj = dashboardParams.value("columnFilterType").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList columnFilterTypeKeys = childObj.keys();

        foreach(QString column, columnFilterTypeKeys){
            QString filter = childObj.value(column).toString();
            this->setColumnFilterType(dashboardId.toInt(), column, filter);
        }

        // columnIncludeExcludeMap
        mainObj = dashboardParams.value("columnIncludeExcludeMap").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList columnIncludeExcludeMapKeys = childObj.keys();

        foreach(QString column, columnIncludeExcludeMapKeys){
            QVariantMap tmp;
            tmp.insert(column, childObj.value(column).toString());
            this->columnIncludeExcludeMap.insert(dashboardId.toInt(), tmp);
        }

        // columnValueMap
        mainObj = dashboardParams.value("columnValueMap").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList columnValueMapKeys = childObj.keys();
        QMap<QString, QStringList> valueMap;

        foreach(QString columnName, columnValueMapKeys){
            QVariantList valueMapVariantList = childObj.value(columnName).toArray().toVariantList();
            QStringList valueMapStringList;

            foreach(QVariant values, valueMapVariantList){
                valueMapStringList.append(values.toString());
            }
            valueMap.insert(columnName, valueMapStringList);

        }
        this->columnValueMap.insert(dashboardId.toInt(), valueMap);

        // dashboardName
        mainObj = dashboardParams.value("dashboardName").toObject();
        this->dashboardName.insert(dashboardId.toInt(), mainObj.value(dashboardId).toString());

        // dashboardBackgroundColor;
        mainObj = dashboardParams.value("dashboardBackgroundColor").toObject();
        this->dashboardBackgroundColor.insert(dashboardId.toInt(), mainObj.value(dashboardId).toString());

        // dashboardOpacity;
        mainObj = dashboardParams.value("dashboardOpacity").toObject();
        this->dashboardOpacity.insert(dashboardId.toInt(), mainObj.value(dashboardId).toInt());

        // dashboardGrid;
        mainObj = dashboardParams.value("dashboardGrid").toObject();
        this->dashboardGrid.insert(dashboardId.toInt(), mainObj.value(dashboardId).toBool());

        // dashboardCanvasDimensions;
        mainObj = dashboardParams.value("dashboardCanvasDimensions").toObject();
        this->dashboardCanvasDimensions.insert(dashboardId.toInt(), mainObj.value(dashboardId).toArray().toVariantList());

        // reportName
        mainObj = dashboardParams.value("reportName").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList reportNameKeys = childObj.keys();

        foreach(QString widgetId, reportNameKeys){
            QString name = childObj.value(widgetId).toString();
            this->setReportName(dashboardId.toInt(), widgetId.toInt(), name);
        }

        // reportBackgroundColor
        mainObj = dashboardParams.value("reportBackgroundColor").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList reportBackgroundColorKeys = childObj.keys();

        foreach(QString widgetId, reportBackgroundColorKeys){
            QString color = childObj.value(widgetId).toString();
            this->setReportBackgroundColor(dashboardId.toInt(), widgetId.toInt(), color);
        }

        // reportLineColor
        mainObj = dashboardParams.value("reportLineColor").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList reportLineColorKeys = childObj.keys();

        foreach(QString widgetId, reportLineColorKeys){
            QString color = childObj.value(widgetId).toString();
            this->setReportLineColor(dashboardId.toInt(), widgetId.toInt(), color);
        }

        // reportOpacity
        mainObj = dashboardParams.value("reportOpacity").toObject();
        childObj = mainObj.value(dashboardId).toObject();
        QStringList reportOpacityKeys = childObj.keys();

        foreach(QString widgetId, reportOpacityKeys){
            int opacity = childObj.value(widgetId).toInt();
            this->setReportOpacity(dashboardId.toInt(), widgetId.toInt(), opacity);
        }
    }


    // EMIT SIGNALS TO NOTIFY THE UI

    // General
    emit moveToDashboardScreen();

    emit dashboardNameChanged(dashboardIds.at(0).toInt(), this->dashboardName.value(dashboardIds.at(0).toInt()));
    emit dashboardBackgroundColorChanged(dashboardIds.at(0).toInt(), this->dashboardBackgroundColor.value(dashboardIds.at(0).toInt()));
    emit tmpCanvasHeightChanged(this->dashboardCanvasDimensions.value(dashboardIds.at(0).toInt()).at(1).toInt());
    emit tmpCanvasWidthChanged(this->dashboardCanvasDimensions.value(dashboardIds.at(0).toInt()).at(0).toInt());

    // Customize Report parameter signals

    QList<int> reportBackgroundColorKeys = this->reportBackgroundColor.value(dashboardIds.at(0).toInt()).keys();
    foreach(int widgetId, reportBackgroundColorKeys){
        emit reportBackgroundColorChanged(dashboardIds.at(0).toInt(), widgetId, this->reportBackgroundColor.value(dashboardIds.at(0).toInt()).value(widgetId));
    }

    QList<int> reportLineColorKeys = this->reportLineColor.value(dashboardIds.at(0).toInt()).keys();
    foreach(int widgetId, reportLineColorKeys){
        emit reportLineColorChanged(dashboardIds.at(0).toInt(), widgetId, this->reportLineColor.value(dashboardIds.at(0).toInt()).value(widgetId));
    }

}

void DashboardParamsModel::setDashboardReportMap(int reportId){
    QVector<int> dashboardReportMapList = dashboardReportMap.value(this->currentDashboard());
    dashboardReportMapList.append(reportId);
    this->dashboardReportMap.insert(this->currentDashboard(),dashboardReportMapList);
}

void DashboardParamsModel::saveDashboard()
{
    QJsonObject dashboardParamsObject;
    QList<int> dashboardIds = this->dashboardName.keys();

    QJsonObject dashboardWidgetsMapObj;
    QJsonObject dashboardWidgetsZorderObj;
    QJsonObject dashboardWidgetCoordinatesObj;
    QJsonObject dashboardWidgetTypeMapObj;
    QJsonObject dashboardWidgetUrlObj;
    QJsonObject dashboardUniqueWidgetObj;
    QJsonObject dashboardReportMapObj;
    QJsonObject dashboardReportUrlObj;
    QJsonObject textReportParametersMapObj;
    QJsonObject showColumnsObj;

    QJsonObject columnAliasMapObj;
    QJsonObject columnFilterTypeObj;
    QJsonObject columnIncludeExcludeMapObj;
    QJsonObject columnValueMapObj;

    QJsonObject dashboardNameObj;
    QJsonObject dashboardBackgroundColorObj;
    QJsonObject dashboardOpacityObj;
    QJsonObject dashboardGridObj;
    QJsonObject dashboardCanvasDimensionsObj;

    QJsonObject reportNameObj;
    QJsonObject reportBackgroundColorObj;
    QJsonObject reportLineColorObj;
    QJsonObject reportOpacityObj;

    foreach(int dashboardId, dashboardIds){

        // dashboardWidgetsMap
        QVariantList dashboardWidgetsMapList;
        foreach(int widgetId, this->dashboardWidgetsMap.value(dashboardId))
            dashboardWidgetsMapList.append(widgetId);

        dashboardWidgetsMapObj.insert(QString::number(dashboardId), QJsonArray::fromVariantList(dashboardWidgetsMapList));

        // dashboardWidgetsZorder
        QJsonObject dashboardWidgetsZorderTmpObj;
        foreach(int widgetId, this->dashboardWidgetsZorder.value(dashboardId).keys())
            dashboardWidgetsZorderTmpObj.insert(QString::number(widgetId), this->dashboardWidgetsZorder.value(dashboardId).value(widgetId));

        dashboardWidgetsZorderObj.insert(QString::number(dashboardId), dashboardWidgetsZorderTmpObj);

        // dashboardWidgetCoordinates
        QJsonObject dashboardWidgetCoordinatesTmpObj;
        foreach(int widgetId, this->dashboardWidgetCoordinates.value(dashboardId).keys())
            dashboardWidgetCoordinatesTmpObj.insert(QString::number(widgetId), QJsonArray::fromVariantList(this->dashboardWidgetCoordinates.value(dashboardId).value(widgetId)));

        dashboardWidgetCoordinatesObj.insert(QString::number(dashboardId), dashboardWidgetCoordinatesTmpObj);

        // dashboardWidgetTypeMap
        QJsonObject dashboardWidgetTypeMapTmpObj;
        foreach(int widgetId, this->dashboardWidgetTypeMap.value(dashboardId).keys()){
            dashboardWidgetTypeMapTmpObj.insert(QString::number(widgetId), this->dashboardWidgetTypeMap.value(dashboardId).value(widgetId));
        }

        dashboardWidgetTypeMapObj.insert(QString::number(dashboardId), dashboardWidgetTypeMapTmpObj);

        // dashboardWidgetUrl
        QJsonObject dashboardWidgetUrlTmpObj;
        foreach(int widgetId, this->dashboardWidgetUrl.value(dashboardId).keys())
            dashboardWidgetUrlTmpObj.insert(QString::number(widgetId), this->dashboardWidgetUrl.value(dashboardId).value(widgetId).toString());

        dashboardWidgetUrlObj.insert(QString::number(dashboardId), dashboardWidgetUrlTmpObj);

        // dashboardUniqueWidgetMap
        QJsonObject dashboardUniqueWidgetTmpObj;
        foreach(QString hash, this->dashboardUniqueWidgetMap.value(dashboardId).keys())
            dashboardUniqueWidgetTmpObj.insert(hash, this->dashboardUniqueWidgetMap.value(dashboardId).value(hash).toString());

        dashboardUniqueWidgetObj.insert(QString::number(dashboardId), dashboardUniqueWidgetTmpObj);

        // dashboardReportMap
        QVariantList dashboardReportMapList;
        foreach(int reportId, this->dashboardReportMap.value(dashboardId))
            dashboardReportMapList.append(reportId);

        dashboardReportMapObj.insert(QString::number(dashboardId), QJsonArray::fromVariantList(dashboardReportMapList));

        // dashboardReportUrl
        QJsonObject dashboardReportUrlTmpObj;
        foreach(int reportId, this->dashboardReportUrl.value(dashboardId).keys())
            dashboardReportUrlTmpObj.insert(QString::number(reportId), this->dashboardReportUrl.value(dashboardId).value(reportId));

        dashboardReportUrlObj.insert(QString::number(dashboardId), dashboardReportUrlTmpObj);

        // textReportParametersMap
        QJsonObject textReportParametersMapTmpObj;
        foreach(int reportId, this->textReportParametersMap.value(dashboardId).keys())
            textReportParametersMapTmpObj.insert(QString::number(reportId), QJsonObject::fromVariantMap(this->textReportParametersMap.value(dashboardId).value(reportId)));

        textReportParametersMapObj.insert(QString::number(dashboardId), textReportParametersMapTmpObj);


        // showColumns
        showColumnsObj.insert(QString::number(dashboardId), QJsonArray::fromStringList(this->showColumns.value(dashboardId)));

        // columnAliasMap
        QJsonObject columnAliasMapTmpObj;
        foreach(QString columnName, this->columnAliasMap.value(dashboardId).keys())
            columnAliasMapTmpObj.insert(columnName, this->columnAliasMap.value(dashboardId).value(columnName).toString());

        columnAliasMapObj.insert(QString::number(dashboardId), columnAliasMapTmpObj);

        // columnFilterType
        QJsonObject columnFilterTypeTmpObj;
        foreach(QString columnName, this->columnFilterType.value(dashboardId).keys())
            columnFilterTypeTmpObj.insert(columnName, this->columnFilterType.value(dashboardId).value(columnName).toString());

        columnFilterTypeObj.insert(QString::number(dashboardId), columnFilterTypeTmpObj);

        // columnIncludeExcludeMap
        QJsonObject columnIncludeExcludeMapTmpObj;
        foreach(QString columnName, this->columnIncludeExcludeMap.value(dashboardId).keys())
            columnIncludeExcludeMapTmpObj.insert(columnName, this->columnIncludeExcludeMap.value(dashboardId).value(columnName).toString());

        columnIncludeExcludeMapObj.insert(QString::number(dashboardId), columnIncludeExcludeMapTmpObj);


        // columnValueMap
        QJsonObject columnValueMapTmpObj;
        foreach(QString columnName, this->columnValueMap.value(dashboardId).keys())
            columnValueMapTmpObj.insert(columnName, QJsonArray::fromStringList(this->columnValueMap.value(dashboardId).value(columnName)));

        columnValueMapObj.insert(QString::number(dashboardId), columnValueMapTmpObj);

        // dashboardName
        dashboardNameObj.insert(QString::number(dashboardId), this->dashboardName.value(dashboardId));

        // dashboardBackgroundColor
        dashboardBackgroundColorObj.insert(QString::number(dashboardId), this->dashboardBackgroundColor.value(dashboardId));

        // dashboardOpacity
        dashboardOpacityObj.insert(QString::number(dashboardId), this->dashboardOpacity.value(dashboardId));

        // dashboardGrid
        dashboardGridObj.insert(QString::number(dashboardId), this->dashboardGrid.value(dashboardId));

        // dashboardCanvasDimensions
        dashboardCanvasDimensionsObj.insert(QString::number(dashboardId), QJsonArray::fromVariantList(this->dashboardCanvasDimensions.value(dashboardId)));

        // reportName
        QJsonObject reportNameTmpObj;
        foreach(int widgetId, this->reportName.value(dashboardId).keys())
            reportNameTmpObj.insert(QString::number(widgetId), this->reportName.value(dashboardId).value(widgetId));

        reportNameObj.insert(QString::number(dashboardId), reportNameTmpObj);

        // reportBackgroundColor
        QJsonObject reportBackgroundColorTmpObj;
        foreach(int widgetId, this->reportBackgroundColor.value(dashboardId).keys())
            reportBackgroundColorTmpObj.insert(QString::number(widgetId), this->reportBackgroundColor.value(dashboardId).value(widgetId));

        reportBackgroundColorObj.insert(QString::number(dashboardId), reportBackgroundColorTmpObj);

        // reportLineColor
        QJsonObject reportLineColorTmpObj;
        foreach(int widgetId, this->reportLineColor.value(dashboardId).keys())
            reportLineColorTmpObj.insert(QString::number(widgetId), this->reportLineColor.value(dashboardId).value(widgetId));

        reportLineColorObj.insert(QString::number(dashboardId), reportLineColorTmpObj);

        // reportOpacity
        QJsonObject reportOpacityTmpObj;
        foreach(int widgetId, this->reportOpacity.value(dashboardId).keys())
            reportOpacityTmpObj.insert(QString::number(widgetId), this->reportOpacity.value(dashboardId).value(widgetId));

        reportOpacityObj.insert(QString::number(dashboardId), reportOpacityTmpObj);

    }


    // Final Object
    dashboardParamsObject.insert("dashboardWidgetsMap", dashboardWidgetsMapObj);
    dashboardParamsObject.insert("dashboardWidgetsZorder", dashboardWidgetsZorderObj);
    dashboardParamsObject.insert("dashboardWidgetCoordinates", dashboardWidgetCoordinatesObj);
    dashboardParamsObject.insert("dashboardWidgetTypeMap", dashboardWidgetTypeMapObj);
    dashboardParamsObject.insert("dashboardWidgetUrl", dashboardWidgetUrlObj);
    dashboardParamsObject.insert("dashboardUniqueWidgetMap", dashboardUniqueWidgetObj);
    dashboardParamsObject.insert("dashboardReportMap", dashboardReportMapObj);
    dashboardParamsObject.insert("dashboardReportUrl", dashboardReportUrlObj);
    dashboardParamsObject.insert("textReportParametersMap", textReportParametersMapObj);
    dashboardParamsObject.insert("showColumns", showColumnsObj);

    dashboardParamsObject.insert("columnAliasMap", columnAliasMapObj);
    dashboardParamsObject.insert("columnFilterType", columnFilterTypeObj);
    dashboardParamsObject.insert("columnIncludeExcludeMap", columnIncludeExcludeMapObj);
    dashboardParamsObject.insert("columnValueMap", columnValueMapObj);

    dashboardParamsObject.insert("dashboardName", dashboardNameObj);
    dashboardParamsObject.insert("dashboardBackgroundColor", dashboardBackgroundColorObj);
    dashboardParamsObject.insert("dashboardOpacity", dashboardOpacityObj);
    dashboardParamsObject.insert("dashboardGrid", dashboardGridObj);
    dashboardParamsObject.insert("dashboardCanvasDimensions", dashboardCanvasDimensionsObj);

    dashboardParamsObject.insert("reportName", reportNameObj);
    dashboardParamsObject.insert("reportBackgroundColor", reportBackgroundColorObj);
    dashboardParamsObject.insert("reportLineColor", reportLineColorObj);
    dashboardParamsObject.insert("reportOpacity", reportOpacityObj);

    emit sendDashboardParams(dashboardParamsObject);
}

void DashboardParamsModel::deleteDashboardReportMap(int dashboardId, int reportId)
{
    QVector<int> reportIds;

    reportIds = this->dashboardReportMap.value(dashboardId);
    reportIds.removeAll(reportId);

    this->dashboardReportMap.insert(dashboardId, reportIds);
}

bool DashboardParamsModel::getDashboardReportMap(int reportId)
{
    bool output = false;
    foreach(QVector<int> reportIds, this->dashboardReportMap){
        if(reportIds.contains(reportId)){
            output = true;
            break;
        }
    }
    return output;
}

int DashboardParamsModel::getDasbboardReportCount(int dashboardId)
{
    QVector<int> reports = this->dashboardReportMap.value(dashboardId);
    return reports.count();
}
