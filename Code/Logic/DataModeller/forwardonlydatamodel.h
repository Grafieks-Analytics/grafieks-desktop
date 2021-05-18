#ifndef FORWARDONLYDATAMODEL_H
#define FORWARDONLYDATAMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include "../../statics.h"
#include "../../constants.h"

#include "../General/datatype.h"
#include "../General/querysplitter.h"

class ForwardOnlyDataModel : public QObject
{
    Q_OBJECT
    QStringList colData;
    DataType dataType;

    QList<QStringList> allColumns;
    QStringList tables;

public:
    explicit ForwardOnlyDataModel(QObject *parent = nullptr);
    Q_INVOKABLE void clearData();
    ~ForwardOnlyDataModel();


    Q_INVOKABLE void columnData(QString col, QString tableName, QString options);
    Q_INVOKABLE void columnSearchData(QString col, QString tableName, QString searchString, QString options);
    Q_INVOKABLE QStringList getColumnList(QString tableName, QString moduleName, QString searchString = "");
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList filterTableList(QString keyword);
    Q_INVOKABLE QStringList getDbList();


public slots:

signals:
    void forwardColData(QStringList colData);
    void forwardColumnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);
    void columnListModelDataChanged(QStringList colData, QString options);

private:
    QSet<QString> category;
    QSet<QString> date;
    QSet<QString> numerical;
    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;

    QStringList getData(QString queryString);
};

#endif // FORWARDONLYDATAMODEL_H
