#ifndef DUCKDATA_H
#define DUCKDATA_H

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

class DuckData : public QObject
{
    Q_OBJECT
    DuckCRUD *duckCRUD;

public:
    explicit DuckData(QObject *parent = nullptr);
    explicit DuckData(DuckCRUD *duckCRUD, QObject *parent = nullptr);

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
                                          , QString xAxisCalculationType
                                          , QString yAxisColumn
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
    QMap<QString,QPair<int, QString>> colInfo;

};

#endif // DUCKDATA_H
