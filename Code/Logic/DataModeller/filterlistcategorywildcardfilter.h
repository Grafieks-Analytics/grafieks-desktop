#ifndef FILTERLISTCATEGORYWILDCARDFILTER_H
#define FILTERLISTCATEGORYWILDCARDFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>

#include "filterlistmodel.h"
#include "../../constants.h"

class FilterListCategoryWildcardFilter : public QSortFilterProxyModel
{
    Q_OBJECT
    FilterListModel m_filterListModel;

public:
    explicit FilterListCategoryWildcardFilter(QObject *parent = nullptr);

signals:

};

#endif // FILTERLISTCATEGORYWILDCARDFILTER_H
