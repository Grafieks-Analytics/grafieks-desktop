#ifndef CHARTSMODEL_H
#define CHARTSMODEL_H

#include <QObject>
#include <QDebug>

#include "duckreportsds.h"
#include "sqlreportsds.h"

class ChartsModel : public QObject
{
    Q_OBJECT
    QMap<int, QStringList *> newChartData;
    QMap<int, QString> newChartHeader;
public:
    explicit ChartsModel(QObject *parent = nullptr);

    Q_INVOKABLE QString getBarChartValues(  QString xAxisColumn
                                         , QString yAxisColumn
                                         , QString yAxisCalculationType
                                         );

public slots:
    void getChartData(QMap<int, QStringList*> chartData);
    void getChartHeader(QMap<int, QString> chartHeader);

signals:

};

#endif // CHARTSMODEL_H
