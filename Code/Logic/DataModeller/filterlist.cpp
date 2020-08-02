#include "filterlist.h"

FilterList::FilterList(const int &filterId, const QString &section, const QString &category, const QString &subcategory, const QString &tableName, const QString &columnName, const QString &relation, const QVariant &value, const bool &includeNull, const bool &exclude, QObject *parent):

    QObject(parent), m_filterId(filterId), m_section(section), m_category(category), m_subCategory(subcategory), m_tableName(tableName), m_columnName(columnName), m_relation(relation), m_value(value), m_includeNull(includeNull), m_exclude(exclude)
{

}


QString FilterList::tableName() const
{
    return m_tableName;
}

QString FilterList::columnName() const
{
    return m_columnName;
}

QString FilterList::relation() const
{
    return m_relation;
}

QVariant FilterList::value() const
{
    return m_value;
}

bool FilterList::includeNull() const
{
    return m_includeNull;
}

bool FilterList::exclude() const
{
    return m_exclude;
}

QString FilterList::category() const
{
    return m_category;
}

QString FilterList::subCategory() const
{
    return m_subCategory;
}

int FilterList::filterId() const
{
    return m_filterId;
}

QString FilterList::section() const
{
    return m_section;
}

void FilterList::setTableName(QString tableName)
{
    if (m_tableName == tableName)
        return;

    m_tableName = tableName;
    emit tableNameChanged(m_tableName);
}

void FilterList::setColumnName(QString columnName)
{
    if (m_columnName == columnName)
        return;

    m_columnName = columnName;
    emit columnNameChanged(m_columnName);
}

void FilterList::setRelation(QString relation)
{
    if (m_relation == relation)
        return;

    m_relation = relation;
    emit relationChanged(m_relation);
}

void FilterList::setValue(QVariant value)
{
    if (m_value == value)
        return;

    m_value = value;
    emit valueChanged(m_value);
}

void FilterList::setIncludeNull(bool includeNull)
{
    if (m_includeNull == includeNull)
        return;

    m_includeNull = includeNull;
    emit includeNullChanged(m_includeNull);
}

void FilterList::setExclude(bool exclude)
{
    if (m_exclude == exclude)
        return;

    m_exclude = exclude;
    emit excludeChanged(m_exclude);
}

void FilterList::setCategory(QString category)
{
    if (m_category == category)
        return;

    m_category = category;
    emit categoryChanged(m_category);
}

void FilterList::setSubCategory(QString subCategory)
{
    if (m_subCategory == subCategory)
        return;

    m_subCategory = subCategory;
    emit subCategoryChanged(m_subCategory);
}

void FilterList::setFilterId(int filterId)
{
    if (m_filterId == filterId)
        return;

    m_filterId = filterId;
    emit filterIdChanged(m_filterId);
}

void FilterList::setSection(QString section)
{
    if (m_section == section)
        return;

    m_section = section;
    emit sectionChanged(m_section);
}
