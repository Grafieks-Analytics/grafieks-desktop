#ifndef SAVEEXTRACTQUERYWORKER_H
#define SAVEEXTRACTQUERYWORKER_H

#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QDebug>

class saveExtractQueryWorker : public QThread
{
    Q_OBJECT
public:
    explicit saveExtractQueryWorker();

protected:
    void run() override;

signals:

};

#endif // SAVEEXTRACTQUERYWORKER_H
