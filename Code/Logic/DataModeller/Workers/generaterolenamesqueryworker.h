#ifndef GENERATEROLENAMESQUERYWORKER_H
#define GENERATEROLENAMESQUERYWORKER_H

#include <QThread>

class GenerateRoleNamesQueryWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;

signals:

};

#endif // GENERATEROLENAMESQUERYWORKER_H
