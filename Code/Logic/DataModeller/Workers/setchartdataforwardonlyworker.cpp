#include "setchartdataforwardonlyworker.h"



SetChartDataForwardOnlyWorker::SetChartDataForwardOnlyWorker(QSqlDatabase *dbForward, QString query, int internalColCount )
{
    this->dbForward = dbForward;
    this->query = query;
    this->internalColCount = internalColCount;

}

SetChartDataForwardOnlyWorker::~SetChartDataForwardOnlyWorker()
{
//    for(int i = 0; i < this->maxColCount; i++){
//        delete vectorStringList.at(i);
//    }
}

QMap<int, QStringList *> SetChartDataForwardOnlyWorker::getChartData()
{
    return *this->forwardOnlyChartData;
}

int SetChartDataForwardOnlyWorker::getInternalRowCount()
{
    return this->internalRowCount;
}

void SetChartDataForwardOnlyWorker::run()
{

    QSqlQuery q(this->query, *dbForward);
//    if(q.lastError().type() != QSqlError::NoError){
//        qWarning() << Q_FUNC_INFO << q.lastError();
//    } else{

//        int totalRowCount = 0;
//        while(q.next()){

//            int i;

//            // To delete new pointer stringlist later
//            this->maxColCount = this->internalColCount > this->maxColCount ? this->internalColCount : this->maxColCount;

//            for(i = 0; i < this->internalColCount; i++){
//                QStringList *tmpStringList = new QStringList;
//                vectorStringList.append(tmpStringList);
//            }

//            for(i = 0; i < this->internalColCount; i++){
//                vectorStringList.at(i)->append(q.value(i).toString());
//            }

//            for(i = 0; i < this->internalColCount; i++){
//                this->forwardOnlyChartData->insert(i, vectorStringList.at(i));
//            }

//            totalRowCount++;
//        }
//        // Set the internalRowCount for the QAbstractListModel rowCount method
//        this->internalRowCount = totalRowCount;

//        emit signalSetChartData(true);
//    }
}
