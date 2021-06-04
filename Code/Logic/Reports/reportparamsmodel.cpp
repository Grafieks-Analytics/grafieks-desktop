#include<QDebug>
#include "reportparamsmodel.h"

ReportParamsModel::ReportParamsModel()
{

}

QString ReportParamsModel::itemName() const
{
    return m_itemName;
}

QString ReportParamsModel::itemType() const
{
    return m_itemType;
}

bool ReportParamsModel::xAxisActive() const
{
    return m_xAxisActive;
}

bool ReportParamsModel::yAxisActive() const
{
    return m_yAxisActive;
}

bool ReportParamsModel::colorByActive() const
{
    return m_colorByActive;
}

QString ReportParamsModel::lastDropped() const
{
    return m_lastDropped;
}

QString ReportParamsModel::calculatedFieldPopupStatus() const
{
    return m_createFieldPopupStatus;
}

QString ReportParamsModel::xAxisColumns() const
{
    return m_xAxisColumns;
}

QString ReportParamsModel::yAxisColumns() const
{
    return m_yAxisColumns;
}

QString ReportParamsModel::chartType() const
{
    return m_chartType;
}

QString ReportParamsModel::reportId() const
{
    return m_reportId;
}

QString ReportParamsModel::reportTitle() const
{
    return m_reportTitle;
}

void ReportParamsModel::addReport(QString reportId)
{
    QMap<QString, QString> tmp;
    tmp.insert("reportTitle",this->reportTitle());
    tmp.insert("d3PropertiesConfig",this->d3PropertiesConfig());
    tmp.insert("xAxisColumns", this->xAxisColumns() );
    tmp.insert("yAxisColumns", this->yAxisColumns() );
    tmp.insert("chartUrl", this->chartUrl() );
    tmp.insert("chartType", this->chartType() );
    this->reportsMap.insert(reportId,tmp);
}

QString ReportParamsModel::getReportsList(){

    QMap<QString, QMap<QString, QString>> reportList = this->reportsMap;



    QMap<QString, QString> reportIdsData;
    if (!reportList.isEmpty()){
        for(auto key: reportList.keys()){
            qDebug() << key;
        }
    }

    return "";
}

int ReportParamsModel::internalCounter() const
{
    return m_internalCounter;
}

QString ReportParamsModel::section() const
{
    return m_section;
}

QString ReportParamsModel::category() const
{
    return m_category;
}

QString ReportParamsModel::subCategory() const
{
    return m_subCategory;
}

QString ReportParamsModel::tableName() const
{
    return m_tableName;
}

QString ReportParamsModel::colName() const
{
    return m_colName;
}

int ReportParamsModel::filterIndex() const
{
    return m_filterIndex;
}

QString ReportParamsModel::mode() const
{
    return m_mode;
}

int ReportParamsModel::filterModelIndex() const
{
    return m_filterModelIndex;
}

QList<QString> ReportParamsModel::dataValuesColumns() const
{
    return m_dataValuesColumns;
}

QString ReportParamsModel::pointerValue() const
{
    return m_pointerValue;
}

QList<QString> ReportParamsModel::colorBy() const
{
    return m_colorBy;
}

QString ReportParamsModel::d3PropertiesConfig() const
{
    return m_d3PropertiesConfig;
}

QString ReportParamsModel::chartUrl() const
{
    return m_chartUrl;
}

void ReportParamsModel::setItemName(QString itemName)
{
    if (m_itemName == itemName)
        return;

    m_itemName = itemName;
    emit itemNameChanged(m_itemName);
}

void ReportParamsModel::setItemType(QString itemType)
{
    if (m_itemType == itemType)
        return;

    m_itemType = itemType;
    emit itemTypeChanged(m_itemType);
}

void ReportParamsModel::setXAxisActive(bool xAxisActive)
{
    if (m_xAxisActive == xAxisActive)
        return;

    m_xAxisActive = xAxisActive;
    emit xAxisActiveChanged(m_xAxisActive);
}

void ReportParamsModel::setYAxisActive(bool yAxisActive)
{
    if (m_yAxisActive == yAxisActive)
        return;

    m_yAxisActive = yAxisActive;
    emit yAxisActiveChanged(m_yAxisActive);
}

void ReportParamsModel::setColorByActive(bool colorByActive)
{
    if (m_colorByActive == colorByActive)
        return;

    m_colorByActive = colorByActive;
    emit colorByActiveChanged(m_colorByActive);
}

void ReportParamsModel::setLastDropped(QString lastDropped)
{
    if (m_lastDropped == lastDropped)
        return;

    m_lastDropped = lastDropped;
    emit lastDroppedChanged(m_lastDropped);
}

void ReportParamsModel::setCalculatedFieldPopupStatus(QString createFieldPopupStatus)
{
    if (m_createFieldPopupStatus == createFieldPopupStatus)
        return;

    m_createFieldPopupStatus = createFieldPopupStatus;
    emit calculatedFieldPopupStatusChanged(m_createFieldPopupStatus);
}

void ReportParamsModel::setXAxisColumns(QString xAxisColumns)
{
    if (m_xAxisColumns == xAxisColumns)
        return;

    m_xAxisColumns = xAxisColumns;
    emit xAxisColumnsChanged(m_xAxisColumns);
}

void ReportParamsModel::setYAxisColumns(QString yAxisColumns)
{
    if (m_yAxisColumns == yAxisColumns)
        return;

    m_yAxisColumns = yAxisColumns;
    emit yAxisColumnsChanged(m_yAxisColumns);
}

void ReportParamsModel::setChartType(QString chartType)
{
    if (m_chartType == chartType)
        return;

    m_chartType = chartType;
    emit chartTypeChanged(m_chartType);
}

void ReportParamsModel::setReportId(QString reportId)
{
    if (m_reportId == reportId)
        return;

    m_reportId = reportId;
    emit reportIdChanged(m_reportId);
}

void ReportParamsModel::setReportTitle(QString reportTitle)
{
    if (m_reportTitle == reportTitle)
        return;

    m_reportTitle = reportTitle;
    emit reportTitleChanged(m_reportTitle);
}

void ReportParamsModel::setDataValuesColumns(QList<QString> dataValuesColumns)
{
    if (m_dataValuesColumns == dataValuesColumns)
        return;

    m_dataValuesColumns = dataValuesColumns;
    emit dataValuesChanged(m_dataValuesColumns);
}

void ReportParamsModel::setPointerValue(QString pointerValue)
{
    if (m_pointerValue == pointerValue)
        return;

    m_pointerValue = pointerValue;
    emit pointerValueChanged(m_pointerValue);
}

void ReportParamsModel::setColorBy(QList<QString> colorBy)
{
    if (m_colorBy == colorBy)
        return;

    m_colorBy = colorBy;
    emit colorByChanged(m_colorBy);
}

void ReportParamsModel::setD3PropertiesConfig(QString d3PropertiesConfig)
{
    if (m_d3PropertiesConfig == d3PropertiesConfig)
        return;

    m_d3PropertiesConfig = d3PropertiesConfig;
    emit d3PropertiesConfigChanged(m_d3PropertiesConfig);
}

void ReportParamsModel::setInternalCounter(int internalCounter)
{
    if (m_internalCounter == internalCounter)
        return;

    m_internalCounter = internalCounter;
    emit internalCounterChanged(m_internalCounter);
}

void ReportParamsModel::setSection(QString section)
{
    if (m_section == section)
        return;

    m_section = section;
    emit sectionChanged(m_section);
}

void ReportParamsModel::setCategory(QString category)
{
    if (m_category == category)
        return;

    m_category = category;
    emit categoryChanged(m_category);
}

void ReportParamsModel::setSubCategory(QString subCategory)
{
    if (m_subCategory == subCategory)
        return;

    m_subCategory = subCategory;
    emit subCategoryChanged(m_subCategory);
}

void ReportParamsModel::setTableName(QString tableName)
{
    if (m_tableName == tableName)
        return;

    m_tableName = tableName;
    emit tableNameChanged(m_tableName);
}

void ReportParamsModel::setColName(QString colName)
{
    if (m_colName == colName)
        return;

    m_colName = colName;
    emit colNameChanged(m_colName);
}

void ReportParamsModel::setFilterIndex(int filterIndex)
{
    if (m_filterIndex == filterIndex)
        return;

    m_filterIndex = filterIndex;
    emit filterIndexChanged(m_filterIndex);
}

void ReportParamsModel::setMode(QString mode)
{
    if (m_mode == mode)
        return;

    m_mode = mode;
    emit modeChanged(m_mode);
}

void ReportParamsModel::setFilterModelIndex(int filterModelIndex)
{
    if (m_filterModelIndex == filterModelIndex)
        return;

    m_filterModelIndex = filterModelIndex;
    emit filterModelIndexChanged(m_filterModelIndex);
}

void ReportParamsModel::setChartUrl(QString chartUrl)
{
    if (m_chartUrl == chartUrl)
        return;

    m_chartUrl = chartUrl;
    emit chartUrlChanged(m_chartUrl);
}
