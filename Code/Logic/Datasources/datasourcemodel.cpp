#include "datasourcemodel.h"

DatasourceModel::DatasourceModel(QObject *parent) : QAbstractListModel(parent)
{

}

int DatasourceModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_datasource->dataItems().count();
}

QVariant DatasourceModel::data(const QModelIndex &index, int role) const
{


    if( index.row() < 0 || index.row() >= m_datasource->dataItems().count()){
        return QVariant();
    }
    Datasource * datasource = m_datasource->dataItems().at(index.row());
    if( role == ConnectionTypeRole)
        return datasource->connectionType();
    if( role == DatasourceNameRole)
        return datasource->datasourceName();
    if( role == DescriptionsRole)
        return datasource->descriptions();
    if( role == ImageLinkRole)
        return datasource->imageLink();

    if( role == DatasourceIdRole)
        return datasource->id();
    if( role == ConnectedWorkbooksCountRole)
        return datasource->connectedWorkbooksCount();
    if( role == DSProfileIDRole)
        return datasource->profileId();
    if( role == SourceTypeRole)
        return datasource->sourceType();

    if( role == DatasourceLinkRole)
        return datasource->downloadLink();
    if( role == CreatedDateRole)
        return datasource->createdDate();
    if( role == FirstnameRole)
        return datasource->firstName();
    if( role == LastnameRole)
        return datasource->lastName();
    return QVariant();
}

bool DatasourceModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Datasource * datasource = m_datasource->dataItems().at(index.row());
    bool somethingChanged = false;

    switch (role) {
    case  ConnectionTypeRole :
        if ( datasource->connectionType() != value.toString()){
            datasource->setConnectionType(value.toString());
            somethingChanged = true;
        }
        break;

    case DatasourceNameRole:
        if ( datasource->datasourceName() != value.toString()){
            datasource->setDatasourceName(value.toString());
            somethingChanged = true;
        }
        break;

    case DescriptionsRole:
        if ( datasource->descriptions() != value.toString()){
            datasource->setDescriptions(value.toString());
            somethingChanged = true;
        }
        break;

    case ImageLinkRole:
        if ( datasource->imageLink() != value.toString()){
            datasource->setImageLink(value.toString());
            somethingChanged = true;
        }
        break;
    case  DatasourceIdRole :
        if ( datasource->id() != value.toInt()){
            datasource->setId(value.toInt());
            somethingChanged = true;
        }
        break;

    case ConnectedWorkbooksCountRole:
        if ( datasource->connectedWorkbooksCount() != value.toInt()){
            datasource->setConnectedWorkbooksCount(value.toInt());
            somethingChanged = true;
        }
        break;

    case DSProfileIDRole:
        if ( datasource->profileId() != value.toString()){
            datasource->setProfileId(value.toInt());
            somethingChanged = true;
        }
        break;

    case SourceTypeRole:
        if ( datasource->sourceType() != value.toString()){
            datasource->setSourceType(value.toString());
            somethingChanged = true;
        }
        break;
    case  DatasourceLinkRole :
        if ( datasource->downloadLink() != value.toString()){
            datasource->setDownloadLink(value.toString());
            somethingChanged = true;
        }
        break;

    case CreatedDateRole:
        if ( datasource->createdDate() != value.toString()){
            datasource->setCreatedDate(value.toString());
            somethingChanged = true;
        }
        break;

    case FirstnameRole:
        if ( datasource->firstName() != value.toString()){
            datasource->setFirstName(value.toString());
            somethingChanged = true;
        }
        break;

    case LastnameRole:
        if ( datasource->lastName() != value.toString()){
            datasource->setLastName(value.toString());
            somethingChanged = true;
        }
        break;

    }

    if ( somethingChanged){
        emit dataChanged(index,index,QVector<int> () << role);
        return true;
    }
    return false;
}

Qt::ItemFlags DatasourceModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> DatasourceModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[DatasourceIdRole] = "id";
    roles[ConnectedWorkbooksCountRole] = "connectedWorkbooksCount";
    roles[DSProfileIDRole] = "profileId";
    roles[ConnectionTypeRole] = "connectionType";
    roles[DatasourceNameRole] = "datasourceName";
    roles[DescriptionsRole] = "descriptions";
    roles[SourceTypeRole] = "sourceType";
    roles[ImageLinkRole] = "imageLink";
    roles[DatasourceLinkRole] = "datasourceLink";
    roles[CreatedDateRole] = "createdDate";
    roles[FirstnameRole] = "firstname";
    roles[LastnameRole] = "lastname";

    return roles;
}


DatasourceDS *DatasourceModel::datasourceds() const
{
    return m_datasource;
}

void DatasourceModel::setDatasourceds(DatasourceDS *datasource)
{
    beginResetModel();

    if( m_datasource && signalsConnected)
        m_datasource->disconnect(this);

    m_datasource = datasource;

    connect(m_datasource,&DatasourceDS::preItemAdded,this,[=](){
        const int index = m_datasource->dataItems().count();
        beginInsertRows(QModelIndex(),index,index);
    });

    connect(m_datasource,&DatasourceDS::postItemAdded,this,[=](){
        endInsertRows();
    });

    connect(m_datasource,&DatasourceDS::preItemRemoved,this,[=](int index){
        beginRemoveRows(QModelIndex(),index,index);
    });

    connect(m_datasource,&DatasourceDS::postItemRemoved,this,[=](){
        endRemoveRows();
    });

    connect(m_datasource,&DatasourceDS::preReset,this,[=](){
        beginResetModel();
    });

    connect(m_datasource,&DatasourceDS::postReset,this,[=](){
        endResetModel();
    });




    endResetModel();
}
