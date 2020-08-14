#include "filterlistcategoricalfilter.h"

FilterListCategoricalFilter::FilterListCategoricalFilter(QObject *parent) : QSortFilterProxyModel(parent)
{
    //    qDebug() << "CALLED filter constructor";
    this->setSourceModel(&m_filterListModel);
    this->setFilterRole(m_filterListModel.FilterListCategoryRole);
}

void FilterListCategoricalFilter::setSearchString(QString string)
{
    this->setSourceModel(&m_filterListModel);
    this->setFilterRole(m_filterListModel.FilterListCategoryRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(Constants::categoryMainListType);
    //    qDebug() << "CALLED filter function";
}
