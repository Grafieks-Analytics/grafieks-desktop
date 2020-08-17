#include "connectorfilter.h"

/*!
 * \brief Constructor function for ConnectorFilter
 * \param parent
 */

ConnectorFilter::ConnectorFilter(QObject *parent) : QSortFilterProxyModel(parent)
{
    setSortOrder(false);
    setSourceModel(&m_connectorModel);
    setFilterRole(m_connectorModel.CategoryRole);
    setSortRole(m_connectorModel.NameRole);
}

/*!
 * \brief Set the search string and update model
 * \details Search string for searching by datasource name
 * \param string (search string for datasource name)
 */
void ConnectorFilter::setSearchString(QString string)
{
    setFilterRole(m_connectorModel.NameRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}

/*!
 * \brief Set the filter string and update model
 * \details Filter string for filter by datasource type
 * \param string (filter string for datasource type)
 */
void ConnectorFilter::setFilterString(QString string)
{
    setFilterRole(m_connectorModel.CategoryRole);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}

/*!
 * \brief Set sort order
 * \param checked (sort asc/desc after applying filter)
 */
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
