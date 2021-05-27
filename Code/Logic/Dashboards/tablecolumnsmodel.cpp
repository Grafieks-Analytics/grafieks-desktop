#include "tablecolumnsmodel.h"

TableColumnsModel::TableColumnsModel(QObject *parent) : QObject(parent)
{

}

void TableColumnsModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void TableColumnsModel::getChartHeader(QMap<int, QStringList> chartHeader)
{

    this->chartHeaderDetails = chartHeader;

    // Clear existing chart headers data
    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->newChartHeader.clear();

    // Update new data
    foreach(auto key, chartHeader.keys()){

        if(chartHeader.value(key).at(1).contains(Constants::categoricalType)){
            this->categoryList.append(chartHeader.value(key).at(0)  + " [" + chartHeader.value(key).at(2) + "]");
        } else if(chartHeader.value(key).at(1).contains(Constants::numericalType)){
            this->numericalList.append(chartHeader.value(key).at(0)  + " [" + chartHeader.value(key).at(2) + "]");
        } else if(chartHeader.value(key).at(1).contains(Constants::dateType)){
            this->dateList.append(chartHeader.value(key).at(0)  + " [" + chartHeader.value(key).at(2) + "]");
        } else{
            qDebug() << "OTHER UNDETECTED FIELD TYPE" << chartHeader.value(key).at(0);
        }

        this->newChartHeader.insert(key, chartHeader.value(key).at(0));
    }

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);
    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);
}
