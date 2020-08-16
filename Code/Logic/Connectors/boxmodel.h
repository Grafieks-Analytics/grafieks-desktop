#ifndef BOXMODEL_H
#define BOXMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "boxds.h"

/*!
 * \brief Sets the BoxDS API data to view in QtQuick
 * \details This class lists all the methods which interact with the view in QtQuick
 * \ingroup ConnectorScreen
 */

class BoxModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(BoxDS * boxds READ boxds WRITE setBoxds);
public:
    explicit BoxModel(QObject *parent = nullptr);


    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    BoxDS * boxds() const;
    void setBoxds(BoxDS * box);

    enum BoxRoles{
        IdRole = Qt::UserRole +1,
        NameRole,
        TypeRole,
        ModifiedAtRole,
        ExtensionRole

    };
signals:

private:

    BoxDS * m_box;
    bool signalsConnected {false};

};

#endif // BOXMODEL_H
