#ifndef GENERATEROLENAMESQUERYWORKER_H
#define GENERATEROLENAMESQUERYWORKER_H

#include <QThread>
#include <QVariant>
#include <QSqlQueryModel>
#include <QSqlField>
#include <QSqlDatabase>

#include "../../General/datatype.h"


class GenerateRoleNamesQueryWorker : public QThread
{
    Q_OBJECT
    QSqlQueryModel *queryModel;


public:
    explicit GenerateRoleNamesQueryWorker(QSqlQueryModel *queryModel = nullptr);

protected:
    void run() override;

signals:

    void signalGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &sqlChartHeader);

};

#endif // GENERATEROLENAMESQUERYWORKER_H
