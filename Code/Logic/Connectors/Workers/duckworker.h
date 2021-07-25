#ifndef DUCKWORKER_H
#define DUCKWORKER_H

// ----------------------
// IMPORTANT
// ----------------------
// This class will be replace DuckThread class in the future

#include <QThread>

class DuckWorker : public QThread
{
    Q_OBJECT
public:

    void run() override;

signals:

};

#endif // DUCKWORKER_H
