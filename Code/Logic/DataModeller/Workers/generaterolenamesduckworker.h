#ifndef GENERATEROLENAMESDUCKWORKER_H
#define GENERATEROLENAMESDUCKWORKER_H

#include <QThread>

class GenerateRoleNamesDuckWorker : public QThread
{
    Q_OBJECT
public:


protected:
    void run() override;
signals:

};

#endif // GENERATEROLENAMESDUCKWORKER_H
