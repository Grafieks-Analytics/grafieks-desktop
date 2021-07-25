#ifndef SETCHARTDATAFORWARDONLYWORKER_H
#define SETCHARTDATAFORWARDONLYWORKER_H

#include <QThread>

class SetChartDataForwardOnlyWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;
signals:

};

#endif // SETCHARTDATAFORWARDONLYWORKER_H
