#include "filterlistcategorylistfilter.h"

FilterListCategoryListFilter::FilterListCategoryListFilter(QObject *parent) : QSortFilterProxyModel(parent)
{
    //    qDebug() << "CALLED filter constructor";
    this->setSourceModel(&m_filterListModel);
    this->setFilterRole(m_filterListModel.FilterListCategoryRole);
}

void FilterListCategoryListFilter::setSearchString(QString string)
{
    this->setSourceModel(&m_filterListModel);
    this->setFilterRole(m_filterListModel.FilterListCategoryRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(Constants::categoryMainListType);
    //    qDebug() << "CALLED filter function";
}
