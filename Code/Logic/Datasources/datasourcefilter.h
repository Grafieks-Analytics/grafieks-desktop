#ifndef DATASOURCEFILTER_H
#define DATASOURCEFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>

#include "datasourcemodel.h"

class DatasourceFilter : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit DatasourceFilter(QObject *parent = nullptr);
    Q_INVOKABLE void setSearchString(QString string);
    Q_INVOKABLE void setFilterString(QString string);
    Q_INVOKABLE void setSortOrder(bool checked);

signals:

private :
    DatasourceModel m_datasourceModel;

};

#endif // DATASOURCEFILTER_H
