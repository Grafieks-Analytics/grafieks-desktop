#ifndef REPORTSDATAMODEL_H
#define REPORTSDATAMODEL_H

#include <QVariant>
#include <QObject>
#include <QDebug>
#include <QElapsedTimer>

#include <typeinfo>
#include "../General/querysplitter.h"
#include "../General/tableschemamodel.h"
#include "../../duckdb.hpp"
#include "../Connectors/duckcon.h"

class ReportsDataModel : public QObject
{
    Q_OBJECT

    QuerySplitter mQuerySplitter;
    DataType dataType;
    DuckCon *duckCRUD;

public:
    explicit ReportsDataModel(QObject *parent = nullptr);
    explicit ReportsDataModel(DuckCon *duckCRUD, QObject *parent = nullptr);
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

#endif // REPORTSDATAMODEL_H
