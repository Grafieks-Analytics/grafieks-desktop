#include "datasourcefilter.h"

/*!
 * \brief Default Constructor function
 * \param parent
 */
DatasourceFilter::DatasourceFilter(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setSortOrder(false);
    setSourceModel(&m_datasourceModel);
    setFilterRole(m_datasourceModel.DescriptionsRole);
    setSortRole(m_datasourceModel.DatasourceNameRole);
}


/*!
 * \brief Set filter string for Datasource filter
 * \param string (search string)
 */
void DatasourceFilter::setFilterString(QString string)
{
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}

/*!
 * \brief Set sort order for Datasource
 * \param checked (sort Asc/Desc)
 */
void DatasourceFilter::setSortOrder(bool checked)
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
