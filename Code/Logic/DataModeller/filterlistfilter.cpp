#include "filterlistfilter.h"

FilterListFilter::FilterListFilter(QObject *parent) : QSortFilterProxyModel(parent)
{
    setSourceModel(&m_filterListModel);
}

void FilterListFilter::searchByCategory(QString filterSubCategory)
{

    setFilterRole(m_filterListModel.FilterListCategoryRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(filterSubCategory);
}

void FilterListFilter::searchByFilterId(int filterId)
{
    setFilterRole(m_filterListModel.FilterListIdRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(QString::number(filterId));
}
