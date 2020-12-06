#ifndef REPORTMODELLIST_H
#define REPORTMODELLIST_H

#include <QVariant>
#include <QObject>
#include <QDebug>
#include <QElapsedTimer>

#include <typeinfo>
#include "../General/querysplitter.h"
#include "../General/tableschemamodel.h"

class ReportModelList : public QObject
{
    Q_OBJECT

    QuerySplitter mQuerySplitter;
    DataType dataType;

public:
    explicit ReportModelList(QObject *parent = nullptr);
    void getColumnsForTable(QString tableName);

    Q_INVOKABLE void setTmpSql(QString query);
    Q_INVOKABLE void getData();

public slots:



signals:
     void sendFilteredColumn(QStringList allCategorical, QStringList allNumerical, QStringList allDates);
     void sendData(QVariantList xAxis, QVariantList yAxis);

private:

    QSet<QString> category;
    QSet<QString> date;
    QSet<QString> numerical;
    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;

};

#endif // REPORTMODELLIST_H
