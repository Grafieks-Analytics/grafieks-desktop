#include "reportparamsmodel.h"

ReportParamsModel::ReportParamsModel(QObject *parent) : QObject(parent)
{

    m_section = Constants::defaultTabSection;
    m_category = Constants::defaultCategory;
    m_subCategory = Constants::defaultSubCategory;
    m_mode = Constants::defaultMode;
    //    m_exclude = Constants::defaultExclude;
    //    m_includeNull = Constants::defaultIncludeNull;
    //    m_selectAll = Constants::defaultSelectAll;
    m_internalCounter = 0;
    m_filterIndex = 0;
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

void ReportParamsModel::addDashboardReportInstance(QVariant newDroppedReportInstance, QString reportId){
    this->dashboardReportInstances.insert(reportId,newDroppedReportInstance);
}


QVariant ReportParamsModel::getDashboardReportInstance(QString reportId){
    return this->dashboardReportInstances.value(reportId);
}

QVariant ReportParamsModel::getAllDashboardReportInstances()
{
    return this->dashboardReportInstances;
}

QString ReportParamsModel::editReportToggle() const
{
    return m_editReportToggle;
}

QString ReportParamsModel::chartTitle() const
{
    return m_chartTitle;
}

QString ReportParamsModel::colorByDataColoumns() const
{
    return m_colorByDataColoumns;
}

QVariant ReportParamsModel::getReport(QString reportId){
    return this->reportsMap.value(reportId);
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
    QVariantMap tmp;
    tmp.insert("reportTitle",this->reportTitle());
    tmp.insert("d3PropertiesConfig",this->d3PropertiesConfig());
    tmp.insert("xAxisColumns", this->xAxisColumns() );
    tmp.insert("yAxisColumns", this->yAxisColumns() );
    tmp.insert("chartUrl", this->chartUrl() );
    tmp.insert("chartType", this->chartType() );
    tmp.insert("chartTitle", this->chartTitle() );
    tmp.insert("colorByDataColoumns",this->colorByDataColoumns());

    this->reportsMap.insert(reportId,tmp);

    this->reportsData.insert(this->reportId(),this->reportTitle());

    // Emitting singal to update report list
    // in dashboards
    emit reportListChanged();
    
}

QVariantMap ReportParamsModel::getReportsList(){

    return this->reportsData;
}

void ReportParamsModel::resetFilter()
{

    // Q_PROPERTY clear
    this->setInternalCounter(0);
    this->setSection(Constants::defaultTabSection);
    this->setCategory(Constants::defaultCategory);
    this->setSubCategory(Constants::defaultSubCategory);
    this->setTableName("");
    this->setColName("");
    this->setFilterIndex(0);
    this->setFilterModelIndex(0);
    this->setMode(Constants::defaultMode);
}

void ReportParamsModel::clearFilter()
{

    // Q_PROPERTY
    //    this->setSection(Constants::defaultTabSection);
    //    this->setCategory(Constants::defaultCategory);
    //    this->setSubCategory(Constants::defaultSubCategory);

    // variable change
    this->removeTmpSelectedValues(0, true);
    this->removeTmpFilterIndex(0, true);
}

void ReportParamsModel::removeFilter(int filterId, QString reportId, QString filterType)
{
    this->removeFilterColumnMap(filterId);
    this->removeFilterValueMap(filterId);
    this->removeFilterRelationMap(filterId);
    this->removeFilterSlugMap(filterId);
    this->removeIncludeExcludeMap(filterId);
    this->removeIncludeNullMap(filterId);
    this->removeSelectAllMap(filterId);
    this->removeFilterSectionMap(filterId);
    this->removeFilterCategoryMap(filterId);
    this->removeFilterSubCategoryMap(filterId);
    this->removeDateFormatMap(filterId);
    this->removeActualDateValues(filterId);

    if(filterType == Constants::categoricalType){
        this->removeCategoricalFilters(filterId);
        emit categoricalFilterChanged(this->categoricalFilters);
    } else if(filterType == Constants::numericalType){
        this->removeNumericalFilters(filterId);
        emit numericalFilterChanged(this->numericalFilters);
    } else if(filterType == Constants::dateType){
        this->removeDateFilters(filterId);
        emit dateFilterChanged(this->dateFilters);
    }

    QMap<int, QVariantMap> intermediateMasterReportsMap = this->masterReportFilters.value(reportId);
    intermediateMasterReportsMap.remove(filterId);
    this->masterReportFilters.insert(reportId, intermediateMasterReportsMap);
}

void ReportParamsModel::resetInputFields()
{
    emit resetInput();
}

void ReportParamsModel::addToMasterReportFilters(QString reportId)
{
    QMap<int, QVariantMap> intermediateMasterReportsMap;

    // Categorical filters
    foreach(int filterId, this->categoricalFilters){

        QVariantMap tmp = insertMasterFilters(filterId);
        intermediateMasterReportsMap.insert(filterId, tmp);
    }

    // Date filters
    foreach(int filterId, this->dateFilters){
        QVariantMap tmp = insertMasterFilters(filterId);
        intermediateMasterReportsMap.insert(filterId, tmp);
    }

    // Numerical filters
    foreach(int filterId, this->numericalFilters){
        QVariantMap tmp = insertMasterFilters(filterId);
        intermediateMasterReportsMap.insert(filterId, tmp);
    }

    this->masterReportFilters.insert(reportId, intermediateMasterReportsMap);

    int count = this->masterReportFilters.value(reportId).count();
    emit masterReportFiltersChanged(count);

}

void ReportParamsModel::fetchMasterReportFilters(QString reportId)
{
    QMap<int, QVariantMap> output;
    output = this->masterReportFilters.value(reportId);

    emit reportFilterChanged(output, reportId);
}

void ReportParamsModel::restoreMasterReportFilters(QString reportId)
{
    QMap<int, QVariantMap> masterValues = this->masterReportFilters.value(reportId);
    QList<int> keys = masterValues.keys();

    foreach(int filterId, keys){
        restoreMasterFilters(filterId, masterValues.value(filterId));
    }
}

void ReportParamsModel::deleteMasterReportFilters(QString reportId, bool deleteAll)
{
    if(deleteAll == true){
        this->masterReportFilters.clear();
    } else{
        this->masterReportFilters.remove(reportId);
    }

    int count = this->masterReportFilters.value(reportId).count();
    emit masterReportFiltersChanged(count);
}

void ReportParamsModel::addToCategoricalFilters(int filterId)
{
    if(this->categoricalFilters.indexOf(filterId) < 0){
        this->categoricalFilters.append(filterId);
    }
    emit categoricalFilterChanged(this->categoricalFilters);

}

QVector<int> ReportParamsModel::fetchCategoricalFilters()
{
    return this->categoricalFilters;
}

void ReportParamsModel::removeCategoricalFilters(int filterId, bool removeAll)
{
    if(removeAll == true){
        this->categoricalFilters.clear();
    } else{
        this->categoricalFilters.removeAll(filterId);
    }
}

void ReportParamsModel::addToDateFilters(int filterId)
{
    if(this->dateFilters.indexOf(filterId) < 0){
        this->dateFilters.append(filterId);
    }
    emit dateFilterChanged(this->dateFilters);
}

QVector<int> ReportParamsModel::fetchDateFilters()
{
    return this->dateFilters;
}

void ReportParamsModel::removeDateFilters(int filterId, bool removeAll)
{
    if(removeAll == true){
        this->dateFilters.clear();
    } else{
        this->dateFilters.removeAll(filterId);
    }
}

void ReportParamsModel::addToNumericalFilters(int filterId)
{
    if(this->numericalFilters.indexOf(filterId) < 0){
        this->numericalFilters.append(filterId);
    }

    emit numericalFilterChanged(this->numericalFilters);

}

QVector<int> ReportParamsModel::fetchNumericalFilters()
{
    return this->numericalFilters;
}

void ReportParamsModel::removeNumericalFilters(int filterId, bool removeAll)
{
    if(removeAll == true){
        this->numericalFilters.clear();
    } else{
        this->numericalFilters.removeAll(filterId);
    }
}

void ReportParamsModel::addToFilterColumnMap(int filterId, QString value, QString tableName)
{
    QStringList columnTableList;
    columnTableList << value << tableName;
    this->filterColumnMap.insert(filterId, columnTableList);
}

QStringList ReportParamsModel::fetchFilterColumnMap(int filterId, bool fetchAll)
{
    QStringList out;

    if(fetchAll == true){
        foreach(QStringList tmp, this->filterColumnMap){
            out.append(tmp.at(0));
        }
    } else{
        out.append(this->filterColumnMap.value(filterId).at(0));
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

void ReportParamsModel::addToFilterSlugMap(int filterId, QString slug)
{
    this->filterSlugMap.insert(filterId, slug);
}

QStringList ReportParamsModel::fetchFilterSlugMap(int filterId, bool fetchAll)
{

    QStringList out;

    if(fetchAll == true){
        foreach(QString tmp, this->filterSlugMap){
            out.append(tmp);
        }
    } else{
        out.append(this->filterSlugMap.value(filterId));
    }

    return out;
}

void ReportParamsModel::removeFilterSlugMap(int filterId)
{
    this->filterSlugMap.remove(filterId);
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
    this->includeNullMap.insert(filterId, includeNull);
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

void ReportParamsModel::addToSelectAllMap(int filterId, bool selectAll)
{
    this->selectAllMap.insert(filterId, selectAll);
}

QVector<bool> ReportParamsModel::fetchSelectAllMap(int filterId, bool fetchAll)
{
    QVector<bool> out;

    if(fetchAll == true){
        foreach(bool tmp, this->selectAllMap){
            out.append(tmp);
        }
    } else{
        out.append(this->selectAllMap.value(filterId));
    }

    return out;
}

void ReportParamsModel::removeSelectAllMap(int filterId)
{
    this->selectAllMap.remove(filterId);
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

void ReportParamsModel::setTmpSelectedValues(QString value)
{
    if(this->tmpSelectedValues.indexOf(value) < 0){
        this->tmpSelectedValues.append(value);

        emit tmpSelectedValuesChanged(this->tmpSelectedValues);
    }
}

void ReportParamsModel::removeTmpSelectedValues(int refObjId, bool removeAll)
{
    if(removeAll == true){
        this->tmpSelectedValues.clear();
    } else{
        this->tmpSelectedValues.removeAt(refObjId);
    }
}

QStringList ReportParamsModel::getTmpSelectedValues(int refObjId, bool fetchAll)
{
    QStringList output;

    if(fetchAll == false){
        output.append(this->tmpSelectedValues.value(refObjId));
    } else{
        output = this->tmpSelectedValues;
    }

    return output;
}

int ReportParamsModel::searchTmpSelectedValues(QString keyword)
{
    return this->tmpSelectedValues.indexOf(keyword);
}

void ReportParamsModel::setTmpFilterIndex(int value)
{
    if(!this->tmpFilterIndex.contains(value))
        this->tmpFilterIndex.append(value);
}

void ReportParamsModel::removeTmpFilterIndex(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->tmpFilterIndex.remove(refObjId);
    } else{
        this->tmpFilterIndex.clear();
    }
}

QVector<int> ReportParamsModel::getTmpFilterIndex(int refObjId, bool fetchAll)
{
    QVector<int> output;

    if(fetchAll == false){
        output.append(this->tmpFilterIndex.value(refObjId));
    } else{
        output = this->tmpFilterIndex;
    }

    return output;
}

void ReportParamsModel::setDateFormatMap(int refObjId, int formatId)
{
    this->dateFormatMap.insert(refObjId, formatId);
}

void ReportParamsModel::removeDateFormatMap(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->dateFormatMap.remove(refObjId);
    } else{
        this->dateFormatMap.clear();
    }
}

int ReportParamsModel::getDateFormatMap(int refObjId)
{
    return this->dateFormatMap.value(refObjId);
}

void ReportParamsModel::setActualDateValues(int refObjId, QString value1, QString value2)
{
    QStringList input;

    input << value1;
    if(value2 != ""){
        input << value2;
    }
    this->actualDateValues.insert(refObjId, input);
}

void ReportParamsModel::removeActualDateValues(int refObjId, bool removeAll)
{
    if(removeAll == false){
        this->actualDateValues.remove(refObjId);
    } else{
        this->actualDateValues.clear();
    }
}

QStringList ReportParamsModel::getActualDateValues(int refObjId)
{
    QStringList output;
    output = this->actualDateValues.value(refObjId);
    return output;
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

void ReportParamsModel::setEditReportToggle(QString editReportToggle)
{
    if (m_editReportToggle == editReportToggle)
        return;

    m_editReportToggle = editReportToggle;
    emit editReportToggleChanged(m_editReportToggle);
}

QVariantMap ReportParamsModel::insertMasterFilters(int filterId)
{
    QVariantMap tmp;

    // filterColumnMap
    tmp.insert("columnName", this->filterColumnMap.value(filterId));

    // filterValueMap
    tmp.insert("filterValue", this->filterValueMap.value(filterId));

    // filterRelationMap
    tmp.insert("filterRelation", this->filterRelationMap.value(filterId));

    // filterSlugMap
    tmp.insert("filterSlug", this->filterSlugMap.value(filterId));

    // includeExcludeMap
    tmp.insert("includeExclude", this->includeExcludeMap.value(filterId));

    // includeNullMap
    tmp.insert("includeNull", this->includeNullMap.value(filterId));

    // selectAllMap
    tmp.insert("selectAll", this->selectAllMap.value(filterId));

    // filterSectionMap
    tmp.insert("section", this->filterSectionMap.value(filterId));

    // filterCategoryMap
    tmp.insert("category", this->filterCategoryMap.value(filterId));

    // filterSubCategoryMap
    tmp.insert("subCategory", this->filterSubCategoryMap.value(filterId));

    // dateFormat
    tmp.insert("dateFormat", this->dateFormatMap.value(filterId));

    // actualDateValues
    tmp.insert("actualDateValues", this->actualDateValues.value(filterId));

    return tmp;
}

void ReportParamsModel::restoreMasterFilters(int filterId, QVariantMap filterData)
{
    if(filterData.value("section") == Constants::categoricalType){
        this->categoricalFilters.append(filterId);
    } else if(filterData.value("section") == Constants::dateType){
        this->dateFilters.append(filterId);
    } else{
        this->numericalFilters.append(filterId);
    }

    QStringList columnTableList;
    columnTableList << filterData.value("columnName").toString() << filterData.value("tableName").toString();
    this->filterColumnMap.insert(filterId, columnTableList);
    this->filterValueMap.insert(filterId, filterData.value("filterValue").toList());
    this->filterRelationMap.insert(filterId, filterData.value("filterRelation").toString());
    this->filterSlugMap.insert(filterId, filterData.value("filterSlug").toString());
    this->includeExcludeMap.insert(filterId, filterData.value("includeExclude").toBool());
    this->includeNullMap.insert(filterId, filterData.value("includeNull").toBool());
    this->selectAllMap.insert(filterId, filterData.value("selectAll").toBool());
    this->filterSectionMap.insert(filterId, filterData.value("section").toString());
    this->filterCategoryMap.insert(filterId, filterData.value("category").toString());
    this->filterSubCategoryMap.insert(filterId, filterData.value("subCategory").toString());
    this->dateFormatMap.insert(filterId, filterData.value("dateFormat").toInt());
    this->actualDateValues.insert(filterId, filterData.value("actualDateValues").toStringList());
}

void ReportParamsModel::setChartTitle(QString chartTitle)
{
    if (m_chartTitle == chartTitle)
        return;

    m_chartTitle = chartTitle;
    emit chartTitleChanged(m_chartTitle);
}

void ReportParamsModel::setColorByDataColoumns(QString colorByDataColoumns)
{
    if (m_colorByDataColoumns == colorByDataColoumns)
        return;

    m_colorByDataColoumns = colorByDataColoumns;
    emit colorByDataColoumnsChanged(m_colorByDataColoumns);
}

void ReportParamsModel::setChartUrl(QString chartUrl)
{
    if (m_chartUrl == chartUrl)
        return;

    m_chartUrl = chartUrl;
    emit chartUrlChanged(m_chartUrl);
}
