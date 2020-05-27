#ifndef DBLISTDS_H
#define DBLISTDS_H

#include <QAbstractListModel>
#include <QObject>
#include <QDebug>

#include "dblist.h"
#include "../../Connectors/mysqlcon.h"

class DBListModel : public QAbstractListModel
{
    Q_OBJECT

    QList<DBList*> mDbList;
public:
    explicit DBListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    void addDbList( DBList *dbList);
    Q_INVOKABLE void addDbList(const int & id, const QString & name);

    enum ConnectorRoles{
        DBIdRole = Qt::UserRole + 1,
        DBNameRole
    };

signals:

};

#endif // DBLISTDS_H
