#include "dropboxmodel.h"

DropboxModel::DropboxModel(QObject *parent) : QAbstractListModel(parent)
{

}

int DropboxModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_dropbox->dataItems().count();
}

QVariant DropboxModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= m_dropbox->dataItems().count()){
        return QVariant();
    }
    Dropbox * dropbox = m_dropbox->dataItems().at(index.row());
    if(role == IdRole)
        return dropbox->id();
    if(role == TagRole)
        return dropbox->tag();
    if(role == NameRole)
        return dropbox->name();
    if(role == PathLowerRole)
        return dropbox->pathLower();
    if(role == ClientModifiedRole)
        return dropbox->clientModified();
    if(role == ExtensionRole)
        return dropbox->extension();

    return QVariant();
}

bool DropboxModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Dropbox * dropbox = m_dropbox->dataItems().at(index.row());
    bool somethingChanged = false;

    switch (role) {
    case IdRole:
        if(dropbox->id() != value.toString()){
            dropbox->setId(value.toString());
            somethingChanged = true;
        }
        break;
    case TagRole:
        if(dropbox->tag() != value.toString()){
            dropbox->setTag(value.toString());
            somethingChanged = true;
        }
        break;
    case NameRole:
        if(dropbox->name() != value.toString()){
            dropbox->setName(value.toString());
            somethingChanged = true;
        }
        break;
    case PathLowerRole:
        if(dropbox->pathLower() != value.toString()){
            dropbox->setPathLower(value.toString());
            somethingChanged = true;
        }
        break;
    case ClientModifiedRole:
        if(dropbox->clientModified() != value.toString()){
            dropbox->setClientModified(value.toString());
            somethingChanged = true;
        }
        break;
    case ExtensionRole:
        if(dropbox->extension() != value.toString()){
            dropbox->setExtension(value.toString());
            somethingChanged = true;
        }
    }

    if(somethingChanged){
        emit dataChanged(index,index,QVector<int> () << role);
        return true;
    }
    return false;
}

Qt::ItemFlags DropboxModel::flags(const QModelIndex &index) const
{
    if(!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> DropboxModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[IdRole] = "id";
    roles[TagRole] = "tag";
    roles[NameRole] = "name";
    roles[PathLowerRole] = "pathLower";
    roles[ClientModifiedRole] = "clientModified";
    roles[ExtensionRole] = "extension";

    return roles;
}

DropboxDS *DropboxModel::dropboxds() const
{
    return m_dropbox;
}

void DropboxModel::setDropboxds(DropboxDS *dropbox)
{
    beginResetModel();
    if(m_dropbox && signalsConnected)
        m_dropbox->disconnect(this);

    m_dropbox = dropbox;

    connect(m_dropbox,&DropboxDS::preItemAdded,this,[=](){
        const int index = m_dropbox->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_dropbox,&DropboxDS::postItemAdded,this,[=](){
        endInsertRows();
    });

    connect(m_dropbox,&DropboxDS::preReset,this,[=](){
        beginResetModel();
    });

    connect(m_dropbox,&DropboxDS::postReset,this,[=](){
        endResetModel();
    });

    endResetModel();
}
