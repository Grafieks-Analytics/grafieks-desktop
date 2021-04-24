#ifndef DRIVEMODEL_H
#define DRIVEMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "driveds.h"

/*!
 * \brief Sets the Google Drive API data to view in QtQuick
 * \details This class lists all the methods which interact with the view in QtQuick
 * \ingroup ConnectorScreen
 */

class DriveModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(DriveDS * driveds READ driveds WRITE setDriveds);

public:
    explicit DriveModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    DriveDS * driveds() const;
    void setDriveds(DriveDS * driveds);


    enum DriveRoles{
        IdRole = Qt::UserRole +1,
        NameRole,
        KindRole,
        ModifiedTimeRole,
        ExtensionRole
    };

signals:

private:
    DriveDS * m_drive;
    bool signalsConnected {false};

};

#endif // DRIVEMODEL_H
