#ifndef FILTERLISTCATEGORYTOPFILTER_H
#define FILTERLISTCATEGORYTOPFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>

#include "filterlistmodel.h"
#include "../../constants.h"

class FilterListCategoryTopFilter : public QSortFilterProxyModel
{
    Q_OBJECT
    FilterListModel m_filterListModel;
public:
    explicit FilterListCategoryTopFilter(QObject *parent = nullptr);

signals:

};

#endif // FILTERLISTCATEGORYTOPFILTER_H
