#include "dsparamsmodel.h"

DSParamsModel::DSParamsModel(QObject *parent) : QObject(parent),
    m_category("list"), m_subCategory("multiple"), m_exclude(false), m_includeNull(true), m_selectAll(true)
{

}

void DSParamsModel::resetFilter()
{
    this->setCategory("list");
    this->setSubCategory("multiple");
    this->setExclude(false);
    this->setIncludeNull(true);
    this->setSelectAll(true);
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

void DSParamsModel::setSelectAll(bool selectAll)
{
    if (m_selectAll == selectAll)
        return;

    m_selectAll = selectAll;
    emit selectAllChanged(m_selectAll);
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
