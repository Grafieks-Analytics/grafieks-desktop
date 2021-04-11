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

public:
    explicit ForwardOnlyDataModel(QObject *parent = nullptr);
    ~ForwardOnlyDataModel();


    Q_INVOKABLE void columnData(QString col, QString tableName, QString searchString = "");
    Q_INVOKABLE QStringList getColumnList(QString tableName, QString moduleName, QString searchString = "");
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList getDbList();


public slots:
    void receiveCsvFilterQuery(QString query);

signals:
    void forwardColData(QStringList colData);
    void forwardColumnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);

private:
    QSet<QString> category;
    QSet<QString> date;
    QSet<QString> numerical;
    QStringList numericalList;
    QStringList categoryList;
    QStringList dateList;
};

#endif // FORWARDONLYDATAMODEL_H
