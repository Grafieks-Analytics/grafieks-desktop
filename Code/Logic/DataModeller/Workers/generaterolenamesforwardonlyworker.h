#ifndef GENERATEROLENAMESFORWARDONLYWORKER_H
#define GENERATEROLENAMESFORWARDONLYWORKER_H

#include <QThread>

class GenerateRoleNamesForwardOnlyWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;
signals:

};

#endif // GENERATEROLENAMESFORWARDONLYWORKER_H
