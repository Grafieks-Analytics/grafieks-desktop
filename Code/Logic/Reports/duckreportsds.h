#ifndef DUCKREPORTSDS_H
#define DUCKREPORTSDS_H

#include <QObject>
#include <QMap>
#include <QList>
#include <QUrl>
#include <QDir>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>

#include "../Connectors/duckcrud.h"

class DuckReportsDS : public QObject
{
    Q_OBJECT
    DuckCRUD *duckCRUD;

public:
    explicit DuckReportsDS(QObject *parent = nullptr);
    explicit DuckReportsDS(DuckCRUD *duckCRUD, QObject *parent = nullptr);

    // Need to check Return types and paramter's type;

    Q_INVOKABLE QString getBarChartValues(  QString xAxisColumn
                                         , QString yAxisColumn
                                         , QString yAxisCalculationType
                                         );

    Q_INVOKABLE QString getStackedBarChartValues(  QString xAxisColumn
                                                , QString yAxisColumn
                                                , QString yAxisCalculationType
                                                , QString groupedBy
                                                );

    Q_INVOKABLE QString getAreaChartValues(       QString xAxisColumn
                                               , QString yAxisColumn
                                               , QString xAxisCalculationType
                                               , QString yAxisCalculationType
                                               );

    Q_INVOKABLE QString getLineChartValues(  QString xAxisColumn
                                          , QString yAxisColumn
                                          , QString xAxisCalculationType
                                          , QString yAxisCalculationType
                                          );

    Q_INVOKABLE QString getPieChartValues(  QString xAxisColumn
                                         , QString yAxisColumn
                                         , QString yAxisCalculationType
                                         );

    Q_INVOKABLE QString getFunnelChartValues(  QString xAxisColumn
                                            , QString yAxisColumn
                                            , QString yAxisCalculationType
                                            );

    Q_INVOKABLE QString getRadarChartValues(   QString xAxisColumn
                                            , QString yAxisColumn
                                            , QString yAxisCalculationType
                                            );

    Q_INVOKABLE QString getScatterChartValues( QString xAxisColumn
                                            , QString yAxisColumn
                                            , QString xAxisCalculationType
                                            , QString yAxisCalculationType
                                            , QString groupedBy
                                            );

    Q_INVOKABLE QString getHeatMapChartValues( QString xAxisColumn
                                            , QString yAxisColumn
                                            , QString groupedBy
                                            );

signals:

private:

};

#endif // DUCKREPORTSDS_H
