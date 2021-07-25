#ifndef SETPREVIEWQUERYFORWARDONLYWORKER_H
#define SETPREVIEWQUERYFORWARDONLYWORKER_H

#include <QThread>

class SetPreviewQueryForwardOnlyWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;
signals:

};

#endif // SETPREVIEWQUERYFORWARDONLYWORKER_H
