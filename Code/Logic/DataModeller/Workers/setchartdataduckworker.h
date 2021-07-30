#ifndef SETCHARTDATADUCKWORKER_H
#define SETCHARTDATADUCKWORKER_H

#include <QThread>

#include "../../Connectors/duckcon.h"

class SetChartDataDuckWorker : public QThread
{
    Q_OBJECT
    int internalRowCount;
    int internalColCount;
    QMap<int, QStringList*> *duckChartData;
    DuckCon *duckCon;
    QString query;
    QVector<QStringList *>vectorStringList;
    int maxColCount;

public:
    explicit SetChartDataDuckWorker(DuckCon *duckCon = nullptr, QString query = "", QObject *parent = nullptr);
    ~SetChartDataDuckWorker();

    int getInternalRowCount();
    int getInternalColCount();
    QMap<int, QStringList *> getDuckChartData();

protected:
    void run() override;

signals:

    void signalSetChartData( bool success);

};

#endif // SETCHARTDATADUCKWORKER_H
