#ifndef DUCKDATA_H
#define DUCKDATA_H

#include <QObject>
#include <QMap>
#include <QList>
#include <QUrl>
#include <QDir>
#include <QDebug>

#include "../Connectors/duckcrud.h"

class DuckData : public QObject
{
    Q_OBJECT
    DuckCRUD *duckCRUD;

public:
    explicit DuckData(QObject *parent = nullptr);
    explicit DuckData(DuckCRUD *duckCRUD, QObject *parent = nullptr);

    // Need to check Return types and paramter's type;

    Q_INVOKABLE QJsonArray getBarChartValues(  QVariant xAxisColumn
                                             , QVariant xAxisCalculationType
                                             , QVariant yAxisColumn
                                             , QVariant yAxisCalculationType
                                            );

    Q_INVOKABLE QJsonArray getStackedBarChartValues(  QVariant xAxisColumn
                                                    , QVariant xAxisCalculationType
                                                    , QVariant yAxisColumn
                                                    , QVariant yAxisCalculationType
                                                    , QVariant groupedBy
                                                   );

    Q_INVOKABLE QJsonArray getAreaChartValues(  QVariant xAxisColumn
                                              , QVariant xAxisCalculationType
                                              , QVariant yAxisColumn
                                              , QVariant yAxisCalculationType
                                             );

    Q_INVOKABLE QJsonArray getLineChartValues(  QVariant xAxisColumn
                                              , QVariant xAxisCalculationType
                                              , QVariant yAxisColumn
                                              , QVariant yAxisCalculationType
                                             );

    Q_INVOKABLE QJsonArray getPieChartValues(  QVariant xAxisColumn
                                             , QVariant xAxisCalculationType
                                             , QVariant yAxisColumn
                                             , QVariant yAxisCalculationType
                                            );

    Q_INVOKABLE QJsonArray getFunnelChartValues(  QVariant xAxisColumn
                                                , QVariant xAxisCalculationType
                                                , QVariant yAxisColumn
                                                , QVariant yAxisCalculationType
                                               );

signals:

private:
    QMap<QString,QPair<int, QString>> colInfo;

};

#endif // DUCKDATA_H
