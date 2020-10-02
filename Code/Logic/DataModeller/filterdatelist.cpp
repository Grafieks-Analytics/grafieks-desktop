#include "filterdatelist.h"

FilterDateList::FilterDateList(const int &filterId, const QString &section, const QString &category, const QString &subcategory, const QString &tableName, const QString &columnName, const QString &relation, const QString &value, const bool &includeNull, const bool &exclude, QObject *parent):

    QObject(parent), m_filterId(filterId), m_section(section), m_category(category), m_subCategory(subcategory), m_tableName(tableName), m_columnName(columnName), m_relation(relation), m_value(value), m_includeNull(includeNull), m_exclude(exclude)
{

}


QString FilterDateList::tableName() const
{
    return m_tableName;
}

QString FilterDateList::columnName() const
{
    return m_columnName;
}

QString FilterDateList::relation() const
{
    return m_relation;
}

QString FilterDateList::value() const
{
    return m_value;
}

bool FilterDateList::includeNull() const
{
    return m_includeNull;
}

bool FilterDateList::exclude() const
{
    return m_exclude;
}

QString FilterDateList::category() const
{
    return m_category;
}

QString FilterDateList::subCategory() const
{
    return m_subCategory;
}

int FilterDateList::filterId() const
{
    return m_filterId;
}

QString FilterDateList::section() const
{
    return m_section;
}

void FilterDateList::setTableName(QString tableName)
{
    if (m_tableName == tableName)
        return;

    m_tableName = tableName;
    emit tableNameChanged(m_tableName);
}

void FilterDateList::setColumnName(QString columnName)
{
    if (m_columnName == columnName)
        return;

    m_columnName = columnName;
    emit columnNameChanged(m_columnName);
}

void FilterDateList::setRelation(QString relation)
{
    if (m_relation == relation)
        return;

    m_relation = relation;
    emit relationChanged(m_relation);
}

void FilterDateList::setValue(QString value)
{
    if (m_value == value)
        return;

    m_value = value;
    emit valueChanged(m_value);
}

void FilterDateList::setIncludeNull(bool includeNull)
{
    if (m_includeNull == includeNull)
        return;

    m_includeNull = includeNull;
    emit includeNullChanged(m_includeNull);
}

void FilterDateList::setExclude(bool exclude)
{
    if (m_exclude == exclude)
        return;

    m_exclude = exclude;
    emit excludeChanged(m_exclude);
}

void FilterDateList::setCategory(QString category)
{
    if (m_category == category)
        return;

    m_category = category;
    emit categoryChanged(m_category);
}

void FilterDateList::setSubCategory(QString subCategory)
{
    if (m_subCategory == subCategory)
        return;

    m_subCategory = subCategory;
    emit subCategoryChanged(m_subCategory);
}

void FilterDateList::setFilterId(int filterId)
{
    if (m_filterId == filterId)
        return;

    m_filterId = filterId;
    emit filterIdChanged(m_filterId);
}

void FilterDateList::setSection(QString section)
{
    if (m_section == section)
        return;

    m_section = section;
    emit sectionChanged(m_section);
}
