#ifndef FILTERLISTCATEGORYLISTFILTER_H
#define FILTERLISTCATEGORYLISTFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>

#include "filterlistmodel.h"
#include "../../constants.h"

class FilterListCategoryListFilter : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit FilterListCategoryListFilter(QObject *parent = nullptr);
     Q_INVOKABLE void setSearchString(QString string);

private:
    FilterListModel m_filterListModel;
};

#endif // FILTERLISTCATEGORYLISTFILTER_H
