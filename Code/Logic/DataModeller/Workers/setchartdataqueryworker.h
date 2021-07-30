#ifndef SETCHARTDATAQUERYWORKER_H
#define SETCHARTDATAQUERYWORKER_H

#include <QThread>
#include <QDebug>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlQueryModel>

class SetChartDataQueryWorker : public QThread
{
    Q_OBJECT
    int totalRows;
    int totalCols;
    QSqlQueryModel *queryModel;
    QMap<int, QStringList *> sqlChartData;
    QVector<QStringList *>vectorStringList;
    int maxColCount;

public:
    explicit SetChartDataQueryWorker(QSqlQueryModel *queryModel = nullptr, int totalRows = 0, int totalCols = 0);
    ~SetChartDataQueryWorker();

    QMap<int, QStringList *> getSqlChartData();

protected:
    void run() override;
signals:

    void signalSetChartData(bool success);

};

#endif // SETCHARTDATAQUERYWORKER_H
