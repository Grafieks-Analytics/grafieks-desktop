#ifndef GENERATEROLENAMESFORWARDONLYWORKER_H
#define GENERATEROLENAMESFORWARDONLYWORKER_H

#include <QThread>
#include <QDebug>

#include "../../Connectors/duckcon.h"
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
    QSqlDatabase *dbForward;


public:
    explicit GenerateRoleNamesForwardOnlyWorker(QSqlDatabase *dbForward = nullptr, QString query = "", QuerySplitter *querySplitter = nullptr);

protected:
    void run() override;

private:
    QString returnDatatypeQuery(QString tableName);
    QString returnConnectionName();
    QMap<QString, QString> returnColumnList(QString tableName);
signals:

    void signalGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);

};

#endif // GENERATEROLENAMESFORWARDONLYWORKER_H
