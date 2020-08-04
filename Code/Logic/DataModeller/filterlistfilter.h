#ifndef FILTERLISTFILTER_H
#define FILTERLISTFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>

#include "filterlistmodel.h"

class FilterListFilter : public QSortFilterProxyModel
{
    Q_OBJECT
    FilterListModel m_filterListModel;

public:
    explicit FilterListFilter(QObject *parent = nullptr);
    Q_INVOKABLE void searchByCategory(QString filterSubCategory);
    Q_INVOKABLE void searchByFilterId(int filterId);

signals:

};

#endif // FILTERLISTFILTER_H
