#include "filternumericallist.h"

FilterNumericalList::FilterNumericalList(const int &filterId, const QString &section, const QString &category, const QString &subcategory, const QString &tableName, const QString &columnName, const QString &relation, const QString &slug, const QString &value, const bool &includeNull, const bool &exclude, QObject *parent):

    QObject(parent), m_filterId(filterId), m_section(section), m_category(category), m_subCategory(subcategory), m_tableName(tableName), m_columnName(columnName), m_relation(relation), m_slug(slug), m_value(value), m_includeNull(includeNull), m_exclude(exclude)
{

}


QString FilterNumericalList::tableName() const
{
    return m_tableName;
}

QString FilterNumericalList::columnName() const
{
    return m_columnName;
}

QString FilterNumericalList::relation() const
{
    return m_relation;
}

QString FilterNumericalList::value() const
{
    return m_value;
}

bool FilterNumericalList::includeNull() const
{
    return m_includeNull;
}

bool FilterNumericalList::exclude() const
{
    return m_exclude;
}

QString FilterNumericalList::slug() const
{
    return m_slug;
}

QString FilterNumericalList::category() const
{
    return m_category;
}

QString FilterNumericalList::subCategory() const
{
    return m_subCategory;
}

int FilterNumericalList::filterId() const
{
    return m_filterId;
}

QString FilterNumericalList::section() const
{
    return m_section;
}

void FilterNumericalList::setTableName(QString tableName)
{
    if (m_tableName == tableName)
        return;

    m_tableName = tableName;
    emit tableNameChanged(m_tableName);
}

void FilterNumericalList::setColumnName(QString columnName)
{
    if (m_columnName == columnName)
        return;

    m_columnName = columnName;
    emit columnNameChanged(m_columnName);
}

void FilterNumericalList::setRelation(QString relation)
{
    if (m_relation == relation)
        return;

    m_relation = relation;
    emit relationChanged(m_relation);
}

void FilterNumericalList::setValue(QString value)
{
    if (m_value == value)
        return;

    m_value = value;
    emit valueChanged(m_value);
}

void FilterNumericalList::setIncludeNull(bool includeNull)
{
    if (m_includeNull == includeNull)
        return;

    m_includeNull = includeNull;
    emit includeNullChanged(m_includeNull);
}

void FilterNumericalList::setExclude(bool exclude)
{
    if (m_exclude == exclude)
        return;

    m_exclude = exclude;
    emit excludeChanged(m_exclude);
}

void FilterNumericalList::setSlug(QString slug)
{
    if (m_slug == slug)
        return;

    m_slug = slug;

    emit slugChanged(m_slug);
}

void FilterNumericalList::setCategory(QString category)
{
    if (m_category == category)
        return;

    m_category = category;
    emit categoryChanged(m_category);
}

void FilterNumericalList::setSubCategory(QString subCategory)
{
    if (m_subCategory == subCategory)
        return;

    m_subCategory = subCategory;
    emit subCategoryChanged(m_subCategory);
}

void FilterNumericalList::setFilterId(int filterId)
{
    if (m_filterId == filterId)
        return;

    m_filterId = filterId;
    emit filterIdChanged(m_filterId);
}

void FilterNumericalList::setSection(QString section)
{
    if (m_section == section)
        return;

    m_section = section;
    emit sectionChanged(m_section);
}
