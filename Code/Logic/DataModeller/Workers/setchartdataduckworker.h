#ifndef SETCHARTDATADUCKWORKER_H
#define SETCHARTDATADUCKWORKER_H

#include <QThread>
#include <QDebug>

class SetChartDataDuckWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;

signals:

};

#endif // SETCHARTDATADUCKWORKER_H
