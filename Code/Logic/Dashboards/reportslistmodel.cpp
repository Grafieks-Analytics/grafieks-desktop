#include "reportslistmodel.h"

ReportsListModel::ReportsListModel(QObject *parent) : QObject(parent)
{

}

ReportsListModel::~ReportsListModel()
{

}

void ReportsListModel::fetchReports(QStringList)
{
    QStringList output;

    // Write the logic here

    output = this->reportsList;
    emit reportsListData(output);
}
