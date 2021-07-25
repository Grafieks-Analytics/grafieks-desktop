#ifndef GENERATEROLESWORKER_H
#define GENERATEROLESWORKER_H

#include <QThread>

class GenerateRolesWorker : public QThread
{
    Q_OBJECT

public:
    void run() override;

    void generateDuckRoleNames();
    void generateQueryRoleNames();
    void generateForwardOnlyRoleNames();



signals:

};

#endif // GENERATEROLESWORKER_H
