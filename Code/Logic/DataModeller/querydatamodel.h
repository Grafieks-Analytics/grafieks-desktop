#ifndef QUERYDATAMODEL_H
#define QUERYDATAMODEL_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QDebug>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"
#include "../../statics.h"

class QueryDataModel : public QObject
{
    Q_OBJECT
    QStringList colData;
public:
    explicit QueryDataModel(QObject *parent = nullptr);

    Q_INVOKABLE void columnData(QString col, QString tableName, QString options);
    Q_INVOKABLE void columnSearchData(QString col, QString tableName, QString searchString, QString options);

private:
    QString getQueryJoiner();

signals:
     void columnListModelDataChanged(QStringList colData, QString options, bool searchMode = false);

private:
     QStringList getData(QString query);


};

#endif // QUERYDATAMODEL_H
