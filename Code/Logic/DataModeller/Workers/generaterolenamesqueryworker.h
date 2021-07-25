#ifndef GENERATEROLENAMESQUERYWORKER_H
#define GENERATEROLENAMESQUERYWORKER_H

#include <QThread>
#include <QVariant>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>

#include "../../General/datatype.h"


class GenerateRoleNamesQueryWorker : public QThread
{
    Q_OBJECT
    QSqlRecord record;


public:
    explicit GenerateRoleNamesQueryWorker(QSqlRecord record);

protected:
    void run() override;

signals:

    void signalGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);

};

#endif // GENERATEROLENAMESQUERYWORKER_H
