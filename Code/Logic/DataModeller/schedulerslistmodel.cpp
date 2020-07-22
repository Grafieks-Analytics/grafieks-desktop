#include "schedulerslistmodel.h"

SchedulersListModel::SchedulersListModel(QObject *parent) : QAbstractListModel(parent)
{

}

int SchedulersListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
//    qDebug() <<m_schedulerslistds << "counter";
    return m_schedulerslistds->dataItems().count();
}

QVariant SchedulersListModel::data(const QModelIndex &index, int role) const
{


    if( index.row() < 0 || index.row() >= m_schedulerslistds->dataItems().count()){
        return QVariant();
    }
    SchedulersList * schedulersList = m_schedulerslistds->dataItems().at(index.row());
    if( role == SchedulerIdRole)
        return schedulersList->schedulerId();
    if( role == SchedulerNameRole)
        return schedulersList->schedulerName();
//    if( role == DescriptionsRole)
//        return SchedulersList->descriptions();
//    if( role == ImageLinkRole)
//        return SchedulersList->imageLink();

//    if( role == SchedulersListIdRole)
//        return SchedulersList->id();
//    if( role == ConnectedWorkbooksCountRole)
//        return SchedulersList->connectedWorkbooksCount();
//    if( role == DSProfileIDRole)
//        return SchedulersList->profileId();
//    if( role == SourceTypeRole)
//        return SchedulersList->sourceType();

//    if( role == SchedulersListLinkRole)
//        return SchedulersList->downloadLink();
//    if( role == CreatedDateRole)
//        return SchedulersList->createdDate();
//    if( role == FirstnameRole)
//        return SchedulersList->firstName();
//    if( role == LastnameRole)
//        return SchedulersList->lastName();
    return QVariant();
}

bool SchedulersListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    SchedulersList * schedulersList = m_schedulerslistds->dataItems().at(index.row());
    bool somethingChanged = false;

    switch (role) {
    case  SchedulerIdRole :
        if ( schedulersList->schedulerId() != value.toInt()){
            schedulersList->setSchedulerId(value.toInt());
            somethingChanged = true;
        }
        break;

    case SchedulerNameRole:
        if ( schedulersList->schedulerName() != value.toString()){
            schedulersList->setSchedulerName(value.toString());
            somethingChanged = true;
        }
        break;

//    case DescriptionsRole:
//        if ( SchedulersList->descriptions() != value.toString()){
//            SchedulersList->setDescriptions(value.toString());
//            somethingChanged = true;
//        }
//        break;

//    case ImageLinkRole:
//        if ( SchedulersList->imageLink() != value.toString()){
//            SchedulersList->setImageLink(value.toString());
//            somethingChanged = true;
//        }
//        break;
//    case  SchedulersListIdRole :
//        if ( SchedulersList->id() != value.toInt()){
//            SchedulersList->setId(value.toInt());
//            somethingChanged = true;
//        }
//        break;

//    case ConnectedWorkbooksCountRole:
//        if ( SchedulersList->connectedWorkbooksCount() != value.toInt()){
//            SchedulersList->setConnectedWorkbooksCount(value.toInt());
//            somethingChanged = true;
//        }
//        break;

//    case DSProfileIDRole:
//        if ( SchedulersList->profileId() != value.toString()){
//            SchedulersList->setProfileId(value.toInt());
//            somethingChanged = true;
//        }
//        break;

//    case SourceTypeRole:
//        if ( SchedulersList->sourceType() != value.toString()){
//            SchedulersList->setSourceType(value.toString());
//            somethingChanged = true;
//        }
//        break;
//    case  SchedulersListLinkRole :
//        if ( SchedulersList->downloadLink() != value.toString()){
//            SchedulersList->setDownloadLink(value.toString());
//            somethingChanged = true;
//        }
//        break;

//    case CreatedDateRole:
//        if ( SchedulersList->createdDate() != value.toString()){
//            SchedulersList->setCreatedDate(value.toString());
//            somethingChanged = true;
//        }
//        break;

//    case FirstnameRole:
//        if ( SchedulersList->firstName() != value.toString()){
//            SchedulersList->setFirstName(value.toString());
//            somethingChanged = true;
//        }
//        break;

//    case LastnameRole:
//        if ( SchedulersList->lastName() != value.toString()){
//            SchedulersList->setLastName(value.toString());
//            somethingChanged = true;
//        }
//        break;

    }

    if ( somethingChanged){
        emit dataChanged(index,index,QVector<int> () << role);
        return true;
    }
    return false;
}

Qt::ItemFlags SchedulersListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> SchedulersListModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[SchedulerIdRole] = "SchedulerID";
    roles[SchedulerNameRole] = "Name";
//    roles[DSProfileIDRole] = "profileId";
//    roles[ConnectionTypeRole] = "connectionType";
//    roles[SchedulersListNameRole] = "SchedulersListName";
//    roles[DescriptionsRole] = "descriptions";
//    roles[SourceTypeRole] = "sourceType";
//    roles[ImageLinkRole] = "imageLink";
//    roles[SchedulersListLinkRole] = "SchedulersListLink";
//    roles[CreatedDateRole] = "createdDate";
//    roles[FirstnameRole] = "firstname";
//    roles[LastnameRole] = "lastname";

    return roles;
}


SchedulersListDS *SchedulersListModel::schedulerslistds() const
{
    return m_schedulerslistds;
}

void SchedulersListModel::setSchedulersListds(SchedulersListDS *schedulersList)
{
    beginResetModel();

    if( m_schedulerslistds && signalsConnected)
        m_schedulerslistds->disconnect(this);

    m_schedulerslistds = schedulersList;

    connect(m_schedulerslistds,&SchedulersListDS::preItemAdded,this,[=](){
        const int index = m_schedulerslistds->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_schedulerslistds,&SchedulersListDS::postItemAdded,this,[=](){
        endInsertRows();
    });

//    connect(m_schedulerslistds,&SchedulersListDS::preItemRemoved,this,[=](int index){
//        beginRemoveRows(QModelIndex(),index,index);
//    });

//    connect(m_schedulerslistds,&SchedulersListDS::postItemRemoved,this,[=](){
//        endRemoveRows();
//    });

//    connect(m_schedulerslistds,&SchedulersListDS::preReset,this,[=](){
//        beginResetModel();
//    });

//    connect(m_schedulerslistds,&SchedulersListDS::postReset,this,[=](){
//        endResetModel();
//    });




    endResetModel();
}
