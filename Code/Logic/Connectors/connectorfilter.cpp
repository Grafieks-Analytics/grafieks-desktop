#include "connectorfilter.h"

ConnectorFilter::ConnectorFilter(QObject *parent) : QSortFilterProxyModel(parent)
{
    setSortOrder(false);
    setSourceModel(&m_connectorModel);
    setFilterRole(m_connectorModel.CategoryRole);
    setSortRole(m_connectorModel.NameRole);
}

void ConnectorFilter::setSearchString(QString string)
{
    setFilterRole(m_connectorModel.NameRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}

void ConnectorFilter::setFilterString(QString string)
{
    setFilterRole(m_connectorModel.CategoryRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}

void ConnectorFilter::setSortOrder(bool checked)
{
    if(checked)
    {
        this->sort(0, Qt::DescendingOrder);
    }
    else
    {
        this->sort(0, Qt::AscendingOrder);
    }
}
