#include "dsparamsmodel.h"

DSParamsModel::DSParamsModel(QObject *parent) : QObject(parent)
{

    m_section = Constants::defaultTabSection;
    m_category = Constants::defaultCategory;
    m_subCategory = Constants::defaultSubCategory;
    m_mode = Constants::defaultMode;
    m_exclude = Constants::defaultExclude;
    m_includeNull = Constants::defaultIncludeNull;
    m_selectAll = Constants::defaultSelectAll;
}

void DSParamsModel::resetFilter()
{
    this->setSection(Constants::defaultTabSection);
    this->setCategory(Constants::defaultCategory);
    this->setSubCategory(Constants::defaultSubCategory);
    this->setMode(Constants::defaultMode);
    this->setValue(Constants::defaultValue);
    this->setRelation(Constants::defaultRelation);
    this->setExclude(Constants::defaultExclude);
    this->setIncludeNull(Constants::defaultIncludeNull);
    this->setSelectAll( Constants::defaultSelectAll);
}

void DSParamsModel::addToHideColumns(QString colName)
{
    this->hideColumns.append(colName);
    emit hideColumnsChanged(this->hideColumns);
}

void DSParamsModel::removeFromHideColumns(QString colName)
{
    this->hideColumns.removeOne(colName);
    emit hideColumnsChanged(this->hideColumns);
}

QStringList DSParamsModel::fetchHideColumns(QString searchKeyword)
{
    return this->hideColumns.filter(searchKeyword);
}

void DSParamsModel::addToJoinBoxTableMap(int refObjId, QString firstTable, QString secondTable)
{
    QStringList joinedTables;
    joinedTables << firstTable << secondTable;

    joinBoxTableMap.insert(refObjId, joinedTables);
}

void DSParamsModel::removeJoinBoxTableMap(int refObjId)
{
    joinBoxTableMap.remove(refObjId);
}

QVariantList DSParamsModel::fetchJoinBoxTableMap(int refObjId)
{
    QVariantList returnObj;
    returnObj << refObjId << joinBoxTableMap.value(refObjId).at(0) << joinBoxTableMap.value(refObjId).at(1);
    return returnObj;
}

void DSParamsModel::addToJoinTypeMap(int refObjId, QString joinType)
{
    QVariantList outData;
    outData << refObjId << joinType;

    this->joinTypeMap.insert(refObjId, joinType);
    emit joinTypeMapChanged(outData);
}

void DSParamsModel::updateJoinTypeMap(int refObjId, QString joinType)
{
    QVariantList outData;
    outData << refObjId << joinType;

    this->joinTypeMap[refObjId] = joinType;
    emit joinTypeMapChanged(outData);
}

void DSParamsModel::removeJoinTypeMap(int refObjId)
{
    this->joinTypeMap.remove(refObjId);
}

QString DSParamsModel::fetchJoinTypeMap(int refObjId)
{
    return this->joinTypeMap.value(refObjId);
}

void DSParamsModel::addToJoinIconMap(int refObjId, QString iconLink)
{
    QVariantList outData;
    outData << refObjId << iconLink;

    this->joinIconMap.insert(refObjId, iconLink);
    emit joinIconMapChanged(outData);

    qDebug() << "DS PARAMS INS" << iconLink << refObjId;
}

void DSParamsModel::updateJoinIconMap(int refObjId, QString iconLink)
{
    QVariantList outData;
    outData << refObjId << iconLink;

    this->joinIconMap[refObjId] = iconLink;
    emit joinIconMapChanged(outData);
}

void DSParamsModel::removeJoinIconMap(int refObjId)
{
    this->joinIconMap.remove(refObjId);
}

QString DSParamsModel::fetchJoinIconMap(int refObjId)
{
    qDebug() << "DS PARAMS" << this->joinIconMap.value(refObjId) << refObjId << this->joinIconMap;
    return this->joinIconMap.value(refObjId);
}

void DSParamsModel::addToJoinMapList(int refObjId, int internalCounter, QString leftParam, QString rightParam)
{
    Q_UNUSED(refObjId);
    Q_UNUSED(internalCounter);
    Q_UNUSED(leftParam);
    Q_UNUSED(rightParam);
}

void DSParamsModel::updateJoinMapList(int refObjId, int internalCounter, QString leftParam, QString rightParam)
{

    Q_UNUSED(refObjId);
    Q_UNUSED(internalCounter);
    Q_UNUSED(leftParam);
    Q_UNUSED(rightParam);
}

void DSParamsModel::removeJoinMapList(int refObjId, int internalCounter)
{

    Q_UNUSED(refObjId);
    Q_UNUSED(internalCounter);
}

QMap<int, QStringList> DSParamsModel::fetchJoinMapList(int refObjId)
{
    Q_UNUSED(refObjId);

    QMap<int, QStringList> out;

    return out;
}

QString DSParamsModel::dsName() const
{
    return m_dsName;
}

QString DSParamsModel::dsType() const
{
    return m_dsType;
}

bool DSParamsModel::isFullExtract() const
{
    return m_isFullExtract;
}

QString DSParamsModel::extractColName() const
{
    return m_extractColName;
}

int DSParamsModel::schedulerId() const
{
    return m_schedulerId;
}

int DSParamsModel::displayRowsCount() const
{
    return m_displayRowsCount;
}


int DSParamsModel::joinId() const
{
    return m_joinId;
}


QString DSParamsModel::section() const
{
    return m_section;
}

QString DSParamsModel::colName() const
{
    return m_colName;
}

QString DSParamsModel::tableName() const
{
    return m_tableName;
}

bool DSParamsModel::exclude() const
{
    return m_exclude;
}

bool DSParamsModel::includeNull() const
{
    return m_includeNull;
}

bool DSParamsModel::selectAll() const
{
    return m_selectAll;
}

int DSParamsModel::filterIndex() const
{
    return m_filterIndex;
}

QString DSParamsModel::mode() const
{
    return m_mode;
}

QString DSParamsModel::category() const
{
    return m_category;
}

QString DSParamsModel::subCategory() const
{
    return m_subCategory;
}

QString DSParamsModel::relation() const
{
    return m_relation;
}

QVariant DSParamsModel::value() const
{
    return m_value;
}

void DSParamsModel::setDsName(QString dsName)
{
    if (m_dsName == dsName)
        return;

    m_dsName = dsName;
    emit dsNameChanged(m_dsName);
}

void DSParamsModel::setDsType(QString dsType)
{
    if (m_dsType == dsType)
        return;

    m_dsType = dsType;
    emit dsTypeChanged(m_dsType);
}

void DSParamsModel::setIsFullExtract(bool isFullExtract)
{
    if (m_isFullExtract == isFullExtract)
        return;

    m_isFullExtract = isFullExtract;
    emit isFullExtractChanged(m_isFullExtract);
}

void DSParamsModel::setExtractColName(QString extractColName)
{
    if (m_extractColName == extractColName)
        return;

    m_extractColName = extractColName;
    emit extractColNameChanged(m_extractColName);
}

void DSParamsModel::setSchedulerId(int schedulerId)
{
    if (m_schedulerId == schedulerId)
        return;

    m_schedulerId = schedulerId;
    emit schedulerIdChanged(m_schedulerId);
}

void DSParamsModel::setDisplayRowsCount(int displayRowsCount)
{
    if (m_displayRowsCount == displayRowsCount)
        return;

    m_displayRowsCount = displayRowsCount;
    emit displayRowsCountChanged(m_displayRowsCount);
}



void DSParamsModel::setJoinId(int joinId)
{
    if (m_joinId == joinId)
        return;

    m_joinId = joinId;
    emit joinIdChanged(m_joinId);
}


void DSParamsModel::setSection(QString section)
{
    if (m_section == section)
        return;

    m_section = section;
    emit sectionChanged(m_section);
}

void DSParamsModel::setColName(QString colName)
{
    if (m_colName == colName)
        return;

    m_colName = colName;
    emit colNameChanged(m_colName);
}

void DSParamsModel::setTableName(QString tableName)
{
    if (m_tableName == tableName)
        return;

    m_tableName = tableName;
    emit tableNameChanged(m_tableName);
}

void DSParamsModel::setExclude(bool exclude)
{
    if (m_exclude == exclude)
        return;

    m_exclude = exclude;
    emit excludeChanged(m_exclude);
}

void DSParamsModel::setIncludeNull(bool includeNull)
{
    if (m_includeNull == includeNull)
        return;

    m_includeNull = includeNull;
    emit includeNullChanged(m_includeNull);
}

void DSParamsModel::setFilterIndex(int filterIndex)
{
    if (m_filterIndex == filterIndex)
        return;

    m_filterIndex = filterIndex;
    emit filterIndexChanged(m_filterIndex);
}

void DSParamsModel::setSelectAll(bool selectAll)
{
    if (m_selectAll == selectAll)
        return;

    m_selectAll = selectAll;
    emit selectAllChanged(m_selectAll);
}

void DSParamsModel::setMode(QString mode)
{
    if (m_mode == mode)
        return;

    m_mode = mode;
    emit modeChanged(m_mode);
}

void DSParamsModel::setCategory(QString category)
{
    if (m_category == category)
        return;

    m_category = category;
    emit categoryChanged(m_category);
}

void DSParamsModel::setSubCategory(QString subCategory)
{
    if (m_subCategory == subCategory)
        return;

    m_subCategory = subCategory;
    emit subCategoryChanged(m_subCategory);
}

void DSParamsModel::setRelation(QString relation)
{
    if (m_relation == relation)
        return;

    m_relation = relation;
    emit relationChanged(m_relation);
}

void DSParamsModel::setValue(QVariant value)
{
    if (m_value == value)
        return;

    m_value = value;
    emit valueChanged(m_value);
}
