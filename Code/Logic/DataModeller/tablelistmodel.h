#ifndef TABLELISTMODEL_H
#define TABLELISTMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "tablelist.h"
#include "../../Connectors/mysqlcon.h"
#include "../../statics.h"

class TableListModel : public QAbstractListModel
{
    Q_OBJECT

    QList<TableList*> mTableList;

public:
    explicit TableListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    void addTableList( TableList *tableList);
    Q_INVOKABLE void requestTableList();

    enum ConnectorRoles{
        TableNameRole = Qt::UserRole + 1

    };

signals:

};

#endif // TABLELISTMODEL_H
