#include "filterlistcategorywildcardfilter.h"

FilterListCategoryWildcardFilter::FilterListCategoryWildcardFilter(QObject *parent) : QSortFilterProxyModel(parent)
{

    setSourceModel(&m_filterListModel);
    setFilterRole(m_filterListModel.FilterListSubCategoryRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(Constants::categoryMainWildCardType);
}
