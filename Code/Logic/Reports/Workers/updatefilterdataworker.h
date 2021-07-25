#ifndef UPDATEFILTERDATAWORKER_H
#define UPDATEFILTERDATAWORKER_H

#include <QThread>

class UpdateFilterDataWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;

signals:

};

#endif // UPDATEFILTERDATAWORKER_H
