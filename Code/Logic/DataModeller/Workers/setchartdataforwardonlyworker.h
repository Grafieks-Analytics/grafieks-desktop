#ifndef SETCHARTDATAFORWARDONLYWORKER_H
#define SETCHARTDATAFORWARDONLYWORKER_H

#include <QThread>
#include <QDebug>
#include <QSqlQuery>

#include "../../General/datatype.h"
#include "../../General/querysplitter.h"

class SetChartDataForwardOnlyWorker : public QThread
{
    Q_OBJECT
    int internalColCount;
    int internalRowCount;
    QSqlDatabase *dbForward;
    QString query;

    QMap<int, QStringList*> *forwardOnlyChartData;
    QVector<QStringList *>vectorStringList;
    int maxColCount;

public:

    explicit SetChartDataForwardOnlyWorker(QSqlDatabase *dbForward = nullptr, QString query = "", int internalColCount = 0);
    ~SetChartDataForwardOnlyWorker();

    QMap<int, QStringList *> getChartData();
    int getInternalRowCount();

protected:
    void run() override;
signals:

//    void signalSetChartData( QMap<int, QStringList> *forwardOnlyChartData, int internalRowCount);
    void signalSetChartData(bool success);

};

#endif // SETCHARTDATAFORWARDONLYWORKER_H
