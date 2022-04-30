#include "setchartdataqueryworker.h"

SetChartDataQueryWorker::SetChartDataQueryWorker(QSqlQueryModel *queryModel, int totalRows, int totalCols)
{
    this->queryModel = queryModel;
    this->totalCols = totalCols;
    this->totalRows = totalRows;
}

SetChartDataQueryWorker::~SetChartDataQueryWorker()
{
}

QMap<int, QStringList *> SetChartDataQueryWorker::getSqlChartData()
{
    return this->sqlChartData;
}

void SetChartDataQueryWorker::run()
{
    int i, j;

    // To delete new pointer stringlist later
    this->maxColCount = this->totalCols > this->maxColCount ? this->totalCols : this->maxColCount;

    for(i = 0; i < this->totalCols; i++){
        vectorStringList.append(new QStringList);
    }

    for(j = 0; j < this->totalRows; j++){
        for(i = 0; i < this->totalCols; i++){
            vectorStringList.at(i)->append(this->queryModel->record(j).field(i).value().toString());
        }
    }

    for(i = 0; i < this->totalCols; i++){
        this->sqlChartData.insert(i, vectorStringList.at(i));
    }


    emit signalSetChartData(true);
}
