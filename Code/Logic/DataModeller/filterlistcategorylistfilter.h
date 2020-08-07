#ifndef FILTERLISTCATEGORYLISTFILTER_H
#define FILTERLISTCATEGORYLISTFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>

#include "filterlistmodel.h"
#include "../../constants.h"

class FilterListCategoryListFilter : public QSortFilterProxyModel
{
    Q_OBJECT
    FilterListModel m_filterListModel;

public:
    explicit FilterListCategoryListFilter(QObject *parent = nullptr);

};

#endif // FILTERLISTCATEGORYLISTFILTER_H
