#ifndef SETCHARTDATAQUERYWORKER_H
#define SETCHARTDATAQUERYWORKER_H

#include <QThread>

class SetChartDataQueryWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;
signals:

};

#endif // SETCHARTDATAQUERYWORKER_H
