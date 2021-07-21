#include "dashboardparamsmodel.h"
#include "../Reports/reportparamsmodel.h"

DashboardParamsModel::DashboardParamsModel(QObject *parent) : QObject(parent)
{

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
    this->setTmpCanvasWidth(Constants::defaultCanvasWidth);
    this->setTmpCanvasHeight(Constants::defaultCanvasHeight);
}

bool DashboardParamsModel::dragNewReport(int dashboardId, int widgetId)
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
    reportNames.insert(widgetId, "Report " + QString::number(widgetId));
    reportBackgroundColors.insert(widgetId, Constants::DefaultBackgroundColor);
    reportLineColors.insert(widgetId, Constants::DefaultBackgroundColor);
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
    canvasDimensions.append(this->tmpCanvasWidth()); // default width
    canvasDimensions.append(this->tmpCanvasHeight()); // default height

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
        this->setTmpCanvasWidth(Constants::defaultCanvasWidth);
        this->setTmpCanvasHeight(Constants::defaultCanvasHeight);

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

    if(relation == "dataBetween" || relation == "dataRange"){
        values = value.split(",");
    } else{
        if(values.indexOf(value) < 0){
            values.append(value);
        }
    }

    valueMap.insert(columnName, values);
    this->columnValueMap.insert(dashboardId, valueMap);

    emit filterValuesChanged(this->showColumns, this->columnFilterType, this->columnIncludeExcludeMap, this->columnValueMap, dashboardId);
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
        this->columnValueMap.remove(dashboardId);
    }

    emit filterValuesChanged(this->showColumns, this->columnFilterType, this->columnIncludeExcludeMap, this->columnValueMap, dashboardId);
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

    qDebug() << "LINE COLOR" << color;
    emit reportLineColorChanged(dashboardId, widgetId, color);
}

QString DashboardParamsModel::getReportLineColor(int dashboardId, int widgetId)
{

    QString output;
    QMap<int, QString> lineColor;

    if (!this->reportLineColor.value(dashboardId).isEmpty())
    {

        lineColor = this->reportLineColor.value(dashboardId);
        if (lineColor.contains(widgetId))
        {
            output = lineColor.value(widgetId);
        }
    }

    return output;
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

//void DashboardParamsModel::setSelectAll(bool status, QString columnName, int dashboardId)
//{
//    emit selectAllChanged(status, columnName, dashboardId);
//}

bool DashboardParamsModel::ifFilterApplied(int dashboardId)
{
    return this->columnValueMap.value(dashboardId).size() > 0 ? true: false;
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

    m_currentDashboard = currentDashboard;
    emit currentDashboardChanged(m_currentDashboard, reportsInDashboard);
}

void DashboardParamsModel::setCurrentReport(int currentReport)
{
    if (m_currentReport == currentReport)
        return;

    m_currentReport = currentReport;
    qDebug() << "CHANGED" << currentReport;
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
    qDebug() << "COL TYPE CHANGED HERE" << m_currentColumnType;
    emit currentColumnTypeChanged(m_currentColumnType);
}

void DashboardParamsModel::getColumnNames(QStringList columnNames)
{

    const QString defaultFilterType = "dataListMulti";  // Do not change this name
    const QString defaultIncludeType = "include";       // Do not change this name

    for(int i = 0; i < this->dashboardCount(); i++){
        foreach(QString column, columnNames){

            // Set default column alias name to the existing column name
            if(this->fetchColumnAliasName(i, column) == "")
                this->setColumnAliasName(i, column, column);

            // Set default filter type
            if(this->fetchColumnFilterType(i, column) == "")
                this->setColumnFilterType(i, column, defaultFilterType);

            // Set default include/exclude type
            if(this->fetchIncludeExcludeMap(i, column) == "")
                this->setIncludeExcludeMap(i, column, defaultIncludeType);
        }
    }
}

void DashboardParamsModel::setCurrentSelectedColumn(QString currentSelectedColumn)
{
    if (m_currentSelectedColumn == currentSelectedColumn)
        return;

    m_currentSelectedColumn = currentSelectedColumn;
    emit currentSelectedColumnChanged(m_currentSelectedColumn);
}

void DashboardParamsModel::setDashboardReportMap(int reportId){
    QVector<int> dashboardReportMapList = dashboardReportMap.value(this->currentDashboard());
    dashboardReportMapList.append(reportId);
    this->dashboardReportMap.insert(this->currentDashboard(),dashboardReportMapList);
    qDebug() << "Dashboard Report Model" << reportId << this->dashboardReportMap;
}
