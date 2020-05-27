#ifndef CONNECTORFILTER_H
#define CONNECTORFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>

#include "connectormodel.h"

class ConnectorFilter : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit ConnectorFilter(QObject *parent = nullptr);
    Q_INVOKABLE void setSearchString(QString string);
    Q_INVOKABLE void setFilterString(QString string);
    Q_INVOKABLE void setSortOrder(bool checked);

signals:

private:
    ConnectorModel m_connectorModel;

};

#endif // CONNECTORFILTER_H
