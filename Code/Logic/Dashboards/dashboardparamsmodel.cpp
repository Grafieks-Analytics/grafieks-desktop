#include "dashboardparamsmodel.h"

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

bool DashboardParamsModel::dragNewReport(int dashboardId, int reportId)
{

    QVector<int> reportIds;
    QMap<int, QString> reportNames;
    QMap<int, QString> reportBackgroundColors;
    QMap<int, QString> reportLineColors;
    QMap<int, int> reportOpacities;

    // Dashboard Report Mapping

    if (!this->dashboardReportsMap.isEmpty())
    {
        reportIds = this->dashboardReportsMap.value(dashboardId);
        reportNames = this->reportName.value(dashboardId);
        reportBackgroundColors = this->reportBackgroundColor.value(dashboardId);
        reportLineColors = this->reportLineColor.value(dashboardId);
        reportOpacities = this->reportOpacity.value(dashboardId);
    }

    reportIds.append(reportId);
    reportNames.insert(reportId, "Report " + QString::number(reportId));
    reportBackgroundColors.insert(reportId, Constants::DefaultBackgroundColor);
    reportLineColors.insert(reportId, Constants::DefaultBackgroundColor);
    reportOpacities.insert(reportId, 0);

    this->dashboardReportsMap[dashboardId] = reportIds;
    this->reportName[dashboardId] = reportNames;
    this->reportBackgroundColor[dashboardId] = reportBackgroundColors;
    this->reportLineColor[dashboardId] = reportLineColors;
    this->reportOpacity[dashboardId] = reportOpacities;
    this->setCurrentReport(reportId);

    return true;
}

bool DashboardParamsModel::removeReport(int dashboardId, int reportId)
{

    int reportPosition = 0;

    // Remove customize report parameters

    this->reportName[dashboardId].remove(reportId);
    this->reportBackgroundColor[dashboardId].remove(reportId);
    this->reportLineColor[dashboardId].remove(reportId);
    this->reportOpacity[dashboardId].remove(reportId);

    // Remove dashboard report mapping parameters

    this->dashboardReportsZorder[dashboardId].remove(reportId);
    this->dashboardReportCoordinates[dashboardId].remove(reportId);
    this->dashboardReportTypeMap[dashboardId].remove(reportId);
    this->dashboardReportUrl[dashboardId].remove(reportId);

    // Remove the dashboard report mapping

    reportPosition = this->dashboardReportsMap[dashboardId].indexOf(reportId);
    this->dashboardReportsMap[dashboardId].remove(reportPosition);

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

bool DashboardParamsModel::destroyDashboard(int dashboardId)
{
    // Customize dashboard parameters

    this->dashboardName.remove(dashboardId);
    this->dashboardBackgroundColor.remove(dashboardId);
    this->dashboardOpacity.remove(dashboardId);
    this->dashboardGrid.remove(dashboardId);
    this->dashboardCanvasDimensions.remove(dashboardId);

    // Dashboard report mapping
    this->dashboardReportUrl.remove(dashboardId);
    this->dashboardReportTypeMap.remove(dashboardId);
    this->dashboardReportCoordinates.remove(dashboardId);
    this->dashboardReportsZorder.remove(dashboardId);
    this->dashboardReportsMap.remove(dashboardId);

    // Destroy filters -TODO

    // Decrease dashboard count
    this->setDashboardCount(this->dashboardCount() - 1);

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

    output = this->dashboardReportsMap.value(dashboardId);

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportZOrder(int dashboardId)
{

    QVariantMap output;
    int reportId = 0;
    int zOrder = 0;
    QMap<int, int> reportZOrder = this->dashboardReportsZorder.value(dashboardId);

    for (auto key : reportZOrder.keys())
    {

        reportId = key;
        zOrder = reportZOrder.value(key);

        output.insert(QString::number(reportId), zOrder);
    }

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportCoordinates(int dashboardId)
{
    QVariantMap output;
    int reportId = 0;
    QVariantList coordinates;
    QMap<int, QVariantList> reportCoordinates = this->dashboardReportCoordinates.value(dashboardId);

    for (auto key : reportCoordinates.keys())
    {

        reportId = key;
        coordinates = reportCoordinates.value(key);

        output.insert(QString::number(reportId), coordinates);
    }

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportUrls(int dashboardId)
{
    QVariantMap output;
    int reportId = 0;
    QUrl url;
    QMap<int, QUrl> reportUrl = this->dashboardReportUrl.value(dashboardId);

    for (auto key : reportUrl.keys())
    {

        reportId = key;
        url = reportUrl.value(key);

        output.insert(QString::number(reportId), url);
    }

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportTypeMap(int dashboardId)
{
    QVariantMap output;
    int reportId = 0;
    int type;
    QMap<int, int> reportType = this->dashboardReportTypeMap.value(dashboardId);

    for (auto key : reportType.keys())
    {

        reportId = key;
        type = reportType.value(key);

        output.insert(QString::number(reportId), type);
    }

    return output;
}

void DashboardParamsModel::addReportToDashboard(int dashboardId, int reportId)
{
    QVector<int> reports;

    if (this->dashboardReportsMap.value(dashboardId).isEmpty())
    {

        reports.append(reportId);
        this->dashboardReportsMap.insert(dashboardId, reports);
    }
    else
    {

        reports = this->dashboardReportsMap.value(dashboardId);
        reports.append(reportId);
        this->dashboardReportsMap.insert(dashboardId, reports);
    }
}

void DashboardParamsModel::deleteReportFromDashboard(int dashboardId, int reportId)
{

    QVector<int> reports;

    if (!this->dashboardReportsMap.value(dashboardId).isEmpty())
    {

        reports = this->dashboardReportsMap.value(dashboardId);
        if (reports.contains(reportId))
        {
            reports.remove(reports.indexOf(reportId));
            this->dashboardReportsMap.insert(dashboardId, reports);
        }
    }
}

void DashboardParamsModel::setReportZOrder(int dashboardId, int reportId, int zOrder)
{

    QMap<int, int> reportsZOrder;

    if (this->dashboardReportsZorder.value(dashboardId).isEmpty())
    {

        reportsZOrder.insert(reportId, zOrder);
        this->dashboardReportsZorder.insert(dashboardId, reportsZOrder);
    }
    else
    {

        reportsZOrder = this->dashboardReportsZorder.value(dashboardId);
        reportsZOrder[reportId] = zOrder;
        this->dashboardReportsZorder.insert(dashboardId, reportsZOrder);
    }
}

int DashboardParamsModel::getReportZOrder(int dashboardId, int reportId)
{

    int output = 0;
    QMap<int, int> reportsZOrder;

    if (!this->dashboardReportsMap.value(dashboardId).isEmpty())
    {

        reportsZOrder = this->dashboardReportsZorder.value(dashboardId);
        if (reportsZOrder.contains(reportId))
        {
            output = reportsZOrder.value(reportId);
        }
    }

    return output;
}

void DashboardParamsModel::setDashboardReportCoordinates(int dashboardId, int reportId, float x1, float y1, float x2, float y2)
{

    QMap<int, QVariantList> reportCoordinates;
    QVariantList coordinates;

    coordinates << x1 << y1 << x2 << y2;

    if (this->dashboardReportCoordinates.value(dashboardId).isEmpty())
    {

        reportCoordinates.insert(reportId, coordinates);
        this->dashboardReportCoordinates.insert(dashboardId, reportCoordinates);
    }
    else
    {

        reportCoordinates = this->dashboardReportCoordinates.value(dashboardId);
        reportCoordinates[reportId] = coordinates;
        this->dashboardReportCoordinates[dashboardId] = reportCoordinates;
    }
}

QVariantList DashboardParamsModel::getDashboardReportCoordinates(int dashboardId, int reportId)
{

    QVariantList output;
    QMap<int, QVariantList> reportCoordinates;

    if (!this->dashboardReportCoordinates.value(dashboardId).isEmpty())
    {

        reportCoordinates = this->dashboardReportCoordinates.value(dashboardId);
        if (reportCoordinates.contains(reportId))
        {
            output = reportCoordinates.value(reportId);
        }
    }

    return output;
}

void DashboardParamsModel::setDashboardReportTypeMap(int dashboardId, int reportId, int reportType)
{

    QMap<int, int> reportTypeMap;

    if (this->dashboardReportTypeMap.value(dashboardId).isEmpty())
    {

        reportTypeMap.insert(reportId, reportType);
        this->dashboardReportTypeMap.insert(dashboardId, reportTypeMap);
    }
    else
    {

        reportTypeMap = this->dashboardReportTypeMap.value(dashboardId);
        reportTypeMap[reportId] = reportType;

        this->dashboardReportTypeMap.insert(dashboardId, reportTypeMap);
    }
}

int DashboardParamsModel::getDashboardReportTypeMap(int dashboardId, int reportId)
{

    int output = 0;
    QMap<int, int> reportTypeMap;

    if (!this->dashboardReportTypeMap.value(dashboardId).isEmpty())
    {
        reportTypeMap = this->dashboardReportTypeMap.value(dashboardId);
        if (reportTypeMap.contains(reportId))
        {
            output = reportTypeMap.value(reportId);
        }
    }

    return output;
}

void DashboardParamsModel::setDashboardReportUrl(int dashboardId, int reportId, QUrl url)
{
    QMap<int, QUrl> reportUrl;

    if (this->dashboardReportUrl.value(dashboardId).isEmpty())
    {

        reportUrl.insert(reportId, url);
        this->dashboardReportUrl.insert(dashboardId, reportUrl);
    }
    else
    {

        reportUrl = this->dashboardReportUrl.value(dashboardId);
        reportUrl[reportId] = url;

        this->dashboardReportUrl.insert(dashboardId, reportUrl);
    }

    emit reportUrlChanged(dashboardId, reportId, url.toString());
}

QUrl DashboardParamsModel::getDashboardReportUrl(int dashboardId, int reportId)
{

    QUrl output;
    QMap<int, QUrl> reportUrl;

    if (!this->dashboardReportUrl.value(dashboardId).isEmpty())
    {

        reportUrl = this->dashboardReportUrl.value(dashboardId);
        if (reportUrl.contains(reportId))
        {
            output = reportUrl.value(reportId);
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

    valueMap = this->columnValueMap.value(dashboardId);
    values = valueMap.value(columnName);

    if(values.indexOf(value) < 0){
        values.append(value);
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

    valueMap.insert(columnName, values);
    this->columnValueMap.insert(dashboardId, valueMap);
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

void DashboardParamsModel::setReportName(int dashboardId, int reportId, QString reportName)
{
    QMap<int, QString> name;
    if (this->reportName.value(dashboardId).isEmpty())
    {

        name.insert(reportId, reportName);
        this->reportName.insert(dashboardId, name);
    }
    else
    {

        name = this->reportName.value(dashboardId);
        name[reportId] = reportName;

        this->reportName.insert(dashboardId, name);
    }
}

QString DashboardParamsModel::getReportName(int dashboardId, int reportId)
{
    QString output;
    QMap<int, QString> name;

    if (!this->reportName.value(dashboardId).isEmpty())
    {

        name = this->reportName.value(dashboardId);
        if (name.contains(reportId))
        {
            output = name.value(reportId);
        }
    }

    return output;
}

void DashboardParamsModel::setReportBackgroundColor(int dashboardId, int reportId, QString color)
{

    QMap<int, QString> backgroundColor;
    if (this->reportBackgroundColor.value(dashboardId).isEmpty())
    {

        backgroundColor.insert(reportId, color);
        this->reportBackgroundColor.insert(dashboardId, backgroundColor);
    }
    else
    {

        backgroundColor = this->reportBackgroundColor.value(dashboardId);
        backgroundColor[reportId] = color;

        this->reportBackgroundColor.insert(dashboardId, backgroundColor);
    }

    emit reportBackgroundColorChanged(dashboardId, reportId, color);
}

QString DashboardParamsModel::getReportBackgroundColor(int dashboardId, int reportId)
{

    QString output;
    QMap<int, QString> backgroundColor;

    if (!this->reportBackgroundColor.value(dashboardId).isEmpty())
    {

        backgroundColor = this->reportBackgroundColor.value(dashboardId);
        if (backgroundColor.contains(reportId))
        {
            output = backgroundColor.value(reportId);
        }
    }

    return output;
}

void DashboardParamsModel::setReportLineColor(int dashboardId, int reportId, QString color)
{

    QMap<int, QString> lineColor;
    if (this->reportLineColor.value(dashboardId).isEmpty())
    {

        lineColor.insert(reportId, color);
        this->reportLineColor.insert(dashboardId, lineColor);
    }
    else
    {

        lineColor = this->reportLineColor.value(dashboardId);
        lineColor[reportId] = color;

        this->reportLineColor.insert(dashboardId, lineColor);
    }

    qDebug() << "LINE COLOR" << color;
    emit reportLineColorChanged(dashboardId, reportId, color);
}

QString DashboardParamsModel::getReportLineColor(int dashboardId, int reportId)
{

    QString output;
    QMap<int, QString> lineColor;

    if (!this->reportLineColor.value(dashboardId).isEmpty())
    {

        lineColor = this->reportLineColor.value(dashboardId);
        if (lineColor.contains(reportId))
        {
            output = lineColor.value(reportId);
        }
    }

    return output;
}

void DashboardParamsModel::setReportOpacity(int dashboardId, int reportId, int percent)
{

    QMap<int, int> reportOpacity;
    if (this->reportOpacity.value(dashboardId).isEmpty())
    {

        reportOpacity.insert(reportId, percent);
        this->reportOpacity.insert(dashboardId, reportOpacity);
    }
    else
    {

        reportOpacity = this->reportOpacity.value(dashboardId);
        reportOpacity[reportId] = percent;

        this->reportOpacity.insert(dashboardId, reportOpacity);
    }
}

int DashboardParamsModel::getReportOpacity(int dashboardId, int reportId)
{

    int output = 0;
    QMap<int, int> reportOpacity;

    if (!this->reportOpacity.value(dashboardId).isEmpty())
    {

        reportOpacity = this->reportOpacity.value(dashboardId);
        if (reportOpacity.contains(reportId))
        {
            output = reportOpacity.value(reportId);
        }
    }

    return output;
}

void DashboardParamsModel::setSelectAll(bool status, QString columnName, int dashboardId)
{
    emit selectAllChanged(status, columnName, dashboardId);
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
        this->setDashboardReportUrl(this->currentDashboard(), this->currentReport(), finalFileName);
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
    reportsInDashboard = this->dashboardReportsMap.value(currentDashboard);

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

    const QString defaultFilterType = "dataListSingle";  // Do not change this name
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
