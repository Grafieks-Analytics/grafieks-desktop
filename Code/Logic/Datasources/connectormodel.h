#ifndef CONNECTORMODEL_H
#define CONNECTORMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QDebug>

#include "connector.h"

class ConnectorModel : public QAbstractListModel
{
    Q_OBJECT



public:
    explicit ConnectorModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    void addConnector( Connector *connector);
    Q_INVOKABLE void addConnector(const QString & name, const QString & imageLink, const QString & category);

    enum ConnectorRoles{
        NameRole = Qt::UserRole + 1,
        ImageLinkRole,
        CategoryRole
    };

signals:
private :
    QList<Connector*> mConnector;

};

#endif // CONNECTORMODEL_H
