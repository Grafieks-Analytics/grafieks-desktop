#ifndef TABLECOLUMNSMODEL_H
#define TABLECOLUMNSMODEL_H

#include <QObject>
#include <QMap>
#include <QDebug>

#include "../../constants.h"

class TableColumnsModel : public QObject
{
    Q_OBJECT
    QMap<int, QStringList *> newChartData;
    QMap<int, QString> newChartHeader;
    QMap<int, QStringList> chartHeaderDetails;

    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;

public:
    explicit TableColumnsModel(QObject *parent = nullptr);

public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QStringList> chartHeader);

signals:
    void sendFilteredColumn(QStringList allCategorical, QStringList allNumerical, QStringList allDates);


};

#endif // TABLECOLUMNSMODEL_H
