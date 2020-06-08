#ifndef DROPBOXMODEL_H
#define DROPBOXMODEL_H

#include <QAbstractListModel>
#include <QObject>

#include "dropboxds.h"

class DropboxModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(DropboxDS * dropboxds READ dropboxds WRITE setDropboxds)

public:
    explicit DropboxModel(QObject *parent = nullptr);


    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex& index) const;
    QHash<int, QByteArray> roleNames() const;

    DropboxDS *dropboxds() const;
    void setDropboxds(DropboxDS * dropbox);

    enum DroboxRoles{
      IdRole = Qt::UserRole +1,
      TagRole,
      NameRole,
      PathLowerRole,
      ClientModifiedRole,
      ExtensionRole

    };


signals:

private:

    DropboxDS * m_dropbox;
    bool signalsConnected {false};

};

#endif // DROPBOXMODEL_H
