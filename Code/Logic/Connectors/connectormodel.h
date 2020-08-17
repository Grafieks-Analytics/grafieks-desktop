#ifndef CONNECTORMODEL_H
#define CONNECTORMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QDebug>

#include "connector.h"

/*!
 * \brief Sets the Connector screen data to view in QtQuick
 * \details This class lists all the methods which interact with the view in QtQuick
 * \ingroup ConnectorScreen
 */

class ConnectorModel : public QAbstractListModel
{
    Q_OBJECT

    QList<Connector*> mConnector;

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


};

#endif // CONNECTORMODEL_H
