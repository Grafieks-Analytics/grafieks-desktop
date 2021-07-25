#ifndef CHARTSWORKER_H
#define CHARTSWORKER_H

// ----------------------
// IMPORTANT
// ----------------------
// This class will replace ChartsThread class in the future

#include <QThread>

class ChartsWorker: public QThread
{
    Q_OBJECT

public:
    void run() override;

};

#endif // CHARTSWORKER_H
