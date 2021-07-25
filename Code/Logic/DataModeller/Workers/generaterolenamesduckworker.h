#ifndef GENERATEROLENAMESDUCKWORKER_H
#define GENERATEROLENAMESDUCKWORKER_H

#include <QThread>
#include <QDebug>

#include "../../Connectors/duckcon.h"
#include "../../General/datatype.h"
#include "../../General/querysplitter.h"

class GenerateRoleNamesDuckWorker : public QThread
{
    Q_OBJECT
    DuckCon *duckCon;
    QString query;

    QHash<int, QByteArray> roleNames;
    QMap<int, QStringList> duckChartHeader;
    QStringList tableHeaders;
    int internalColCount;
    QuerySplitter *querySplitter;

public:

    explicit GenerateRoleNamesDuckWorker(DuckCon *duckCon = nullptr, QString query = "", QuerySplitter *querySplitter = nullptr);


protected:
    void run() override;

private:
    QMap<QString, QString> returnColumnList(QString tableName);

signals:

    void signalGenerateRoleNames(const QStringList &tableHeaders, const QMap<int, QStringList> &duckChartHeader, const QHash<int, QByteArray> roleNames, const int internalColCount);

};

#endif // GENERATEROLENAMESDUCKWORKER_H
