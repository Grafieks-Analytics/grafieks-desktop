#include "setchartdataduckworker.h"

SetChartDataDuckWorker::SetChartDataDuckWorker(DuckCon *duckCon, QString query, QObject *parent):duckChartData(new QMap<int, QStringList*>), maxColCount(0)
{
    Q_UNUSED(parent);

    this->duckCon = duckCon;
    this->query = query;
}

SetChartDataDuckWorker::~SetChartDataDuckWorker()
{

//    for(int i = 0; i < this->maxColCount; i++){
//        delete vectorStringList.at(i);
//    }
//    delete duckChartData;
}

void SetChartDataDuckWorker::run()
{

    std::unique_ptr<duckdb::MaterializedQueryResult> result = this->duckCon->con.Query(this->query.toStdString());
    if(!result->error.empty()) {
        qWarning() << Q_FUNC_INFO << result->error.c_str();
    } else{

        // Set the internalRowCount & internalColCount for the QAbstractListModel rowCount method
        this->internalColCount = result->collection.ColumnCount();
        this->internalRowCount = result->collection.Count();

        if(this->internalColCount > 0 && this->internalRowCount > 0){
            int i, j;

            // To delete new pointer stringlist later
            this->maxColCount = this->internalColCount > this->maxColCount ? this->internalColCount : this->maxColCount;

            for(i = 0; i < this->internalColCount; i++){
                QStringList *tmpStringList = new QStringList;
                vectorStringList.append(tmpStringList);
            }

            for(j = 0; j < this->internalRowCount; j++){
                for(i = 0; i < this->internalColCount; i++){
                    vectorStringList.at(i)->append(result->GetValue(i, j).ToString().c_str());
                }
            }

            for(i = 0; i < this->internalColCount; i++){
                this->duckChartData->insert(i, vectorStringList.at(i));
            }

            qDebug() << "READY TO EMIT SIGNAL";
            emit signalSetChartData(true);
        }

    }

}

int SetChartDataDuckWorker::getInternalRowCount()
{
    return this->internalRowCount;
}

int SetChartDataDuckWorker::getInternalColCount()
{
    return this->internalColCount;
}

QMap<int, QStringList *> SetChartDataDuckWorker::getDuckChartData()
{
    return *this->duckChartData;
}
