#ifndef DUCKDATAMODEL_H
#define DUCKDATAMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include "../../duckdb.hpp"
#include "../../statics.h"
#include "../../constants.h"
#include "../Connectors/duckcon.h"

#include "../General/datatype.h"
#include "../General/querysplitter.h"

class DuckDataModel : public QObject
{
    Q_OBJECT
    QStringList colData;
    DuckCon *duckCon;
    DataType dataType;

    QList<QStringList> allColumns;
    QStringList tables;

public:
    explicit DuckDataModel(QObject *parent = nullptr);
    explicit DuckDataModel(DuckCon *duckCon, QObject *parent = nullptr);
    Q_INVOKABLE void clearData();
    ~DuckDataModel();


    Q_INVOKABLE void columnData(QString col, QString tableName, QString options);
    Q_INVOKABLE void columnSearchData(QString col, QString tableName, QString searchString, QString options);
    Q_INVOKABLE QStringList getColumnList(QString tableName, QString moduleName);
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList filterTableList(QString keyword);
    Q_INVOKABLE QStringList getDbList();

private:
    QString getQueryJoiner();


signals:
    void duckColData(QStringList colData);
    void columnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);
    void columnListModelDataChanged(QStringList colData, QString options);

private:
    QStringList getData(QString query);


};

#endif // DUCKDATAMODEL_H
