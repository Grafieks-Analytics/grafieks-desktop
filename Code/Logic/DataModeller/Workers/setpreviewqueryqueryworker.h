#ifndef SETPREVIEWQUERYQUERYWORKER_H
#define SETPREVIEWQUERYQUERYWORKER_H

#include <QThread>

class SetPreviewQueryQueryWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;

signals:

};

#endif // SETPREVIEWQUERYQUERYWORKER_H
