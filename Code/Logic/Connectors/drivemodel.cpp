#include "drivemodel.h"

DriveModel::DriveModel(QObject *parent) : QAbstractListModel(parent)
{

}

int DriveModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_drive->dataItems().count();
}

QVariant DriveModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= m_drive->dataItems().count()){
        return QVariant();
    }
    Drive * drive = m_drive->dataItems().at(index.row());
    if(role == IdRole)
        return drive->id();
    if(role == NameRole)
        return drive->name();
    if(role == KindRole)
        return drive->kind();
    if(role == ModifiedTimeRole)
        return drive->modifiedTime();
    if(role == ExtensionRole)
        return drive->extension();

    return QVariant();
}

bool DriveModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Drive * drive = m_drive->dataItems().at(index.row());
    bool somethingChanged = false;
    switch(role){
        case IdRole:
        if(drive->id() != value.toString()){
            drive->setId(value.toString());
            somethingChanged = true;
        }
        break;
    case NameRole:
        if(drive->name() != value.toString()){
            drive->setName(value.toString());
            somethingChanged = true;
        }
        break;
    case KindRole:
        if(drive->kind() != value.toString()){
            drive->setKind(value.toString());
            somethingChanged = true;
        }
    case ModifiedTimeRole:
        if(drive->modifiedTime() != value.toString()){
            drive->setModifiedTime(value.toString());
            somethingChanged = true;
        }
        break;
    case ExtensionRole:
        if(drive->extension() != value.toString()){
            drive->setExtension(value.toString());
            somethingChanged= true;
        }
        break;


    }
    if(somethingChanged){
        emit dataChanged(index,index,QVector<int> () << role);
        return true;
    }
    return false;
}

Qt::ItemFlags DriveModel::flags(const QModelIndex &index) const
{
    if(!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> DriveModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[KindRole] = "kind";
    roles[ModifiedTimeRole] = "modifiedTime";
    roles[ExtensionRole] = "extension";

    return roles;
}

DriveDS *DriveModel::driveds() const
{
    return m_drive;
}

void DriveModel::setDriveds(DriveDS *drive)
{
    beginResetModel();
    if(m_drive && signalsConnected)
        m_drive->disconnect(this);

    m_drive = drive;

    connect(m_drive,&DriveDS::preItemAdded,this,[=](){
        const int index = m_drive->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_drive,&DriveDS::postItemAdded,this,[=](){
        endInsertRows();
    });

    connect(m_drive,&DriveDS::preReset,this,[=](){
        beginResetModel();
    });

    connect(m_drive,&DriveDS::postReset,this,[=](){
        endResetModel();
    });

    endResetModel();


}
