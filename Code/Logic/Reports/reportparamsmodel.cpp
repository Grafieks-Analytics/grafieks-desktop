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

    this->reportsData.insert(this->reportId(),this->reportTitle());
}

QVariantMap ReportParamsModel::getReportsList(){

    return this->reportsData;
}

void ReportParamsModel::addToCategoricalFilters(int filterId)
{
    if(this->categoricalFilters.indexOf(filterId) < 0)
        this->categoricalFilters.append(filterId);
}

QVector<int> ReportParamsModel::fetchCategoricalFilters()
{
    return this->categoricalFilters;
}

void ReportParamsModel::removeCategoricalFilters(int filterId)
{
    this->categoricalFilters.remove(filterId);
}

void ReportParamsModel::addToDateFilters(int filterId)
{
    if(this->dateFilters.indexOf(filterId) < 0)
        this->dateFilters.append(filterId);
}

QVector<int> ReportParamsModel::fetchDateFilters()
{
    return this->dateFilters;
}

void ReportParamsModel::removeDateFilters(int filterId)
{
    this->dateFilters.remove(filterId);
}

void ReportParamsModel::addToNumericalFilters(int filterId)
{
    if(this->numericalFilters.indexOf(filterId) < 0)
        this->numericalFilters.append(filterId);
}

QVector<int> ReportParamsModel::fetchNumericalFilters()
{
    return this->numericalFilters;
}

void ReportParamsModel::removeNumericalFilters(int filterId)
{
    this->numericalFilters.remove(filterId);
}

void ReportParamsModel::addToFilterColumnMap(int filterId, QString value)
{
    this->filterColumnMap.insert(filterId, value);
}

QStringList ReportParamsModel::fetchFilterColumnMap(int filterId, bool fetchAll)
{
    QStringList out;

    if(fetchAll == true){
        foreach(QString tmp, this->filterColumnMap){
            out.append(tmp);
        }
    } else{
        out.append(this->filterColumnMap.value(filterId));
    }
    return out;
}

void ReportParamsModel::removeFilterColumnMap(int filterId)
{
    this->filterColumnMap.remove(filterId);
}

void ReportParamsModel::addToFilterValueMap(int filterId, QVariant value)
{
    QVariantList tmpList;

    if(!this->filterValueMap.contains(filterId)){
        tmpList.append(value);
        this->filterValueMap.insert(filterId, tmpList);

    } else{

        if(tmpList.indexOf(value) < 0){
            tmpList.append(value);
            this->filterValueMap.insert(filterId, tmpList);
        }
    }
}

QVariantMap ReportParamsModel::fetchFilterValueMap(int filterId, bool fetchAll)
{
    QVariantMap out;

    if(fetchAll == false){
        out.insert(QString::number(filterId), this->filterValueMap.value(filterId));
    } else{
        for(int i = 0; i < this->filterValueMap.size(); i++){
            out.insert(QString::number(i), this->filterValueMap.value(i));
        }
    }
    return out;
}

void ReportParamsModel::removeFilterValueMap(int filterId)
{
    this->filterValueMap.remove(filterId);
}

void ReportParamsModel::addToFilterRelationMap(int filterId, QString relation)
{
    this->filterRelationMap.insert(filterId, relation);
}

QStringList ReportParamsModel::fetchFilterRelationMap(int filterId, bool fetchAll)
{
    QStringList out;

    if(fetchAll == true){
        foreach(QString tmp, this->filterRelationMap){
            out.append(tmp);
        }
    } else{
        out.append(this->filterRelationMap.value(filterId));
    }

    return out;
}

void ReportParamsModel::removeFilterRelationMap(int filterId)
{
    this->filterRelationMap.remove(filterId);
}

void ReportParamsModel::addToIncludeExcludeMap(int filterId, bool includeExclude)
{
    this->includeExcludeMap.insert(filterId, includeExclude);
}

QVector<bool> ReportParamsModel::fetchIncludeExcludeMap(int filterId, bool fetchAll)
{
    QVector<bool> out;

    if(fetchAll == true){
        foreach(bool tmp, this->includeExcludeMap){
            out.append(tmp);
        }
    } else{
        out.append(this->includeExcludeMap.value(filterId));
    }

    return out;
}

void ReportParamsModel::removeIncludeExcludeMap(int filterId)
{
    this->includeExcludeMap.remove(filterId);
}

void ReportParamsModel::addToIncludeNullMap(int filterId, bool includeNull)
{
    this->includeExcludeMap.insert(filterId, includeNull);
}

QVector<bool> ReportParamsModel::fetchIncludeNullMap(int filterId, bool fetchAll)
{
    QVector<bool> out;

    if(fetchAll == true){
        foreach(bool tmp, this->includeNullMap){
            out.append(tmp);
        }
    } else{
        out.append(this->includeNullMap.value(filterId));
    }

    return out;
}

void ReportParamsModel::removeIncludeNullMap(int filterId)
{
    this->includeNullMap.remove(filterId);
}

void ReportParamsModel::addToFilterSectionMap(int filterId, QString section)
{
    this->filterSectionMap.insert(filterId, section);
}

QStringList ReportParamsModel::fetchFilterSectionMap(int filterId, bool fetchAll)
{
    QStringList out;
    if(fetchAll == true){
        foreach(QString tmp, this->filterSectionMap){
            out.append(tmp);
        }
    } else{
        out.append(this->filterSectionMap.value(filterId));
    }

    return out;
}

void ReportParamsModel::removeFilterSectionMap(int filterId)
{
    this->filterSectionMap.remove(filterId);
}

void ReportParamsModel::addToFilterCategoryMap(int filterId, QString category)
{
    this->filterCategoryMap.insert(filterId, category);
}

QStringList ReportParamsModel::fetchFilterCategoryMap(int filterId, bool fetchAll)
{
    QStringList out;
    if(fetchAll == true){
        foreach(QString tmp, this->filterCategoryMap){
            out.append(tmp);
        }
    } else{
        out.append(this->filterCategoryMap.value(filterId));
    }

    return out;
}

void ReportParamsModel::removeFilterCategoryMap(int filterId)
{
    this->filterCategoryMap.remove(filterId);
}

void ReportParamsModel::addToFilterSubCategoryMap(int filterId, QString subCategory)
{
    this->filterSubCategoryMap.insert(filterId, subCategory);
}

QStringList ReportParamsModel::fetchFilterSubCategoryMap(int filterId, bool fetchAll)
{
    QStringList out;
    if(fetchAll == true){
        foreach(QString tmp, this->filterSubCategoryMap){
            out.append(tmp);
        }
    } else{
        out.append(this->filterSubCategoryMap.value(filterId));
    }

    return out;
}

void ReportParamsModel::removeFilterSubCategoryMap(int filterId)
{
    this->filterSubCategoryMap.remove(filterId);
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
