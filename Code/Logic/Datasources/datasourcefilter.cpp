#include "datasourcefilter.h"

DatasourceFilter::DatasourceFilter(QObject *parent) :
    QSortFilterProxyModel(parent)
{
//    setSortOrder(false);
    setSourceModel(&m_datasourceModel);
    setFilterRole(m_datasourceModel.DescriptionRole);
    setSortRole(m_datasourceModel.DatasourceNameRole);
}



void DatasourceFilter::setFilterString(QString string)
{
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterFixedString(string);
}


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
