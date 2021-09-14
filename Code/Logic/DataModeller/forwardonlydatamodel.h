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

class ForwardOnlyDataModel : public QAbstractListModel
{
    Q_OBJECT
    DataType dataType;

    QList<QStringList> allColumns;
    QStringList tables;

    QHash<int, QByteArray> m_roleNames;
    QStringList resultData;
    int totalRowCount;
    int totalColCount;

public:
    explicit ForwardOnlyDataModel(QObject *parent = nullptr);
    Q_INVOKABLE void clearData();
    ~ForwardOnlyDataModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;


    Q_INVOKABLE void columnData(QString col, QString tableName, QString options);
    Q_INVOKABLE void columnSearchData(QString col, QString tableName, QString searchString, QString options);
    Q_INVOKABLE QStringList getColumnList(QString tableName, QString moduleName, QString searchString = "");
    Q_INVOKABLE QStringList getTableList();
    Q_INVOKABLE QStringList filterTableList(QString keyword);
    Q_INVOKABLE QStringList getDbList();


private:
    QString getQueryJoiner();


public slots:

signals:
    void forwardColumnListObtained(QList<QStringList> allColumns, QString tableName, QString moduleName);
    void columnListModelDataChanged(QString options);

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
