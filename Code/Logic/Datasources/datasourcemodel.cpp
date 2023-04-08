#include "datasourcemodel.h"

/*!
 * \brief Constructor function for DatasourceModel
 * \param parent
 */
DatasourceModel::DatasourceModel(QObject *parent) : QAbstractListModel(parent)
{

}

/*!
 * \brief Override QAbstractListModel::rowCount
 * \details Override method to return the number of results in new model
 * \param parent
 * \return int
 */
int DatasourceModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_datasource->dataItems().count();
}

/*!
 * \brief Override QAbstractListModel::data
 * \details Override method to return the data of the object for a given index
 * \param index (object index)
 * \param role (object role)
 * \return QVariant
 */
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
    if( role == DatabaseNameRole)
        return datasource->databaseName();
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
    if( role == LastRunRole)
        return datasource->lastRun();

    if( role == DownloadAllowedRole)
        return datasource->downloadAllowed();
    if( role == ConnectAllowedRole)
        return datasource->connectAllowed();
    if( role == PublishAllowedRole)
        return datasource->publishAllowed();
    return QVariant();
}

/*!
 * \brief Override QAbstractListModel::setData
 * \details Override method to set new data in the object at given index
 * \param index (Object index)
 * \param value (New value for the object at index)
 * \param role (role name)
 * \return bool
 */
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

    case DatabaseNameRole:
        if ( datasource->databaseName() != value.toString()){
            datasource->setDatabaseName(value.toString());
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
        if ( datasource->profileId() != value.toInt()){
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

    case LastRunRole:
        if ( datasource->lastRun() != value.toString()){
            datasource->setLastRun(value.toString());
            somethingChanged = true;
        }
        break;

    case DownloadAllowedRole:
        if ( datasource->downloadAllowed() != value.toBool()){
            datasource->setDownloadAllowed(value.toBool());
            somethingChanged = true;
        }
        break;

    case ConnectAllowedRole:
        if ( datasource->connectAllowed() != value.toBool()){
            datasource->setConnectAllowed(value.toBool());
            somethingChanged = true;
        }
        break;

    case PublishAllowedRole:
        if ( datasource->publishAllowed() != value.toBool()){
            datasource->setPublishAllowed(value.toBool());
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


/*!
 * \brief Override QAbstractListModel::flags
 * \details Override method to tell the model that at given index of the object, data is editable
 * \param index (Object index)
 * \return Qt::ItemFlags
 */
Qt::ItemFlags DatasourceModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

/*!
 * \brief Override QAbstractListModel::roleNames
 * \details Override method to tell the view the exact role names with which the value can be accessed from the object
 * \return QHash<int, QByteArray>
 */
QHash<int, QByteArray> DatasourceModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[DatasourceIdRole] = "id";
    roles[ConnectedWorkbooksCountRole] = "connectedWorkbooksCount";
    roles[DSProfileIDRole] = "profileId";
    roles[ConnectionTypeRole] = "connectionType";
    roles[DatasourceNameRole] = "datasourceName";
    roles[DatabaseNameRole] = "databaseName";
    roles[DescriptionsRole] = "descriptions";
    roles[SourceTypeRole] = "sourceType";
    roles[ImageLinkRole] = "imageLink";
    roles[DatasourceLinkRole] = "datasourceLink";
    roles[CreatedDateRole] = "createdDate";
    roles[FirstnameRole] = "firstname";
    roles[LastnameRole] = "lastname";
    roles[LastRunRole] = "lastrun";
    roles[DownloadAllowedRole] = "downloadAllowed";
    roles[ConnectAllowedRole] = "connectAllowed";
    roles[PublishAllowedRole] = "publishAllowed";

    return roles;
}

/*!
 * \brief Getter function for the object
 * \return DatasourceDS *DatasourceModel
 */
DatasourceDS *DatasourceModel::datasourceds() const
{
    return m_datasource;
}

/*!
 * \brief Setter function for the object & notify view
 */
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
