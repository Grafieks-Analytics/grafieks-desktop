#ifndef QUERYDATAMODEL_H
#define QUERYDATAMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlDatabase>
#include <QObject>
#include <QDebug>

#include "../../Connectors/allconnectors.h"
#include "../../constants.h"
#include "../../statics.h"

class QueryDataModel : public QAbstractTableModel
{
    Q_OBJECT

    QHash<int, QByteArray> m_roleNames;
    QStringList resultData;
    int totalRowCount;
    int totalColCount;

public:
    explicit QueryDataModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void columnData(QString col, QString tableName, QString options);
    Q_INVOKABLE void columnSearchData(QString col, QString tableName, QString searchString, QString options);

private:
    QString getQueryJoiner();

signals:
     void columnListModelDataChanged(QString options, bool searchMode = false);

private:
     QStringList getData(QString query);


};

#endif // QUERYDATAMODEL_H
