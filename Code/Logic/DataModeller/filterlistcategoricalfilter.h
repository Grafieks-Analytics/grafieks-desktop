#ifndef FILTERLISTCATEGORICALFILTER_H
#define FILTERLISTCATEGORICALFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>

#include "filterlistmodel.h"
#include "../../constants.h"

class FilterListCategoricalFilter : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit FilterListCategoricalFilter(QObject *parent = nullptr);
     Q_INVOKABLE void setSearchString(QString string);

private:
    FilterListModel m_filterListModel;
};

#endif // FILTERLISTCATEGORICALFILTER_H
