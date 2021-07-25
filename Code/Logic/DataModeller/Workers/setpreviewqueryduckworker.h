#ifndef SETPREVIEWQUERYDUCKWORKER_H
#define SETPREVIEWQUERYDUCKWORKER_H

#include <QThread>

class SetPreviewQueryDuckWorker : public QThread
{
    Q_OBJECT
public:

protected:
    void run() override;
signals:

};

#endif // SETPREVIEWQUERYDUCKWORKER_H
