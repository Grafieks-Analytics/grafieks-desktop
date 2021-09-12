#ifndef GENERATEROLENAMESFORWARDONLYWORKER_H
#define GENERATEROLENAMESFORWARDONLYWORKER_H

#include <QThread>
#include <QDebug>
#include <QSqlDatabase>

#include "../../General/datatype.h"
#include "../../General/querysplitter.h"

class GenerateRoleNamesForwardOnlyWorker : public QThread
{
    Q_OBJECT
    QString query;

    QHash<int, QByteArray> roleNames;
    QMap<int, QStringList> forwardOnlyChartHeader;
    QStringList tableHeaders;
    int internalColCount;
    QuerySplitter *querySplitter;

    QSqlDatabase dbForward2;


public:
    explicit GenerateRoleNamesForwardOnlyWorker( QString query = "", QuerySplitter *querySplitter = nullptr);

protected:
    void run() override;

private:
    QString returnDatatypeQuery(QString tableName);
    QMap<QString, QString> returnColumnList(QString tableName, QSqlDatabase dbForward);

signals:

    void signalGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);

};

#endif // GENERATEROLENAMESFORWARDONLYWORKER_H
