#include "filterlistcategorylistfilter.h"

FilterListCategoryListFilter::FilterListCategoryListFilter(QObject *parent) : QSortFilterProxyModel(parent)
{
    setSourceModel(&m_filterListModel);
    setFilterRole(m_filterListModel.FilterListSubCategoryRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(Constants::categoryMainListType);
}
