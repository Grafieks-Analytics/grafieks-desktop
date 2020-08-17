#include "connectormodel.h"

/*!
 * \brief Constructor function for ConnectorModel
 * \details The data to be populated in the gridview of the QtQuick UI is instantiated here
 * with their names, image locations and their type
 * \param parent
 */

ConnectorModel::ConnectorModel(QObject *parent) : QAbstractListModel(parent)
{

    addConnector(new Connector("Amazon Redshift","../../Images/icons/aws-redshift-logo.png","rdbms"));
    addConnector(new Connector("Apache Hadoop","../../Images/icons/hadoop.png","nosql"));
    addConnector(new Connector("Box","../../Images/icons/box.png","cloud"));
    addConnector(new Connector("Dropbox","../../Images/icons/dropbox-2.png","cloud"));
    addConnector(new Connector("Github","../../Images/icons/github-1.png","online"));
    addConnector(new Connector("Google Drive","../../Images/icons/drive.png","online"));
    addConnector(new Connector("Google Sheets","../../Images/icons/16_google-sheets_1b1915a4b0.png","online"));
    addConnector(new Connector("GRS","../../Images/icons/GRS.png","grs"));
    addConnector(new Connector("JSON","../../Images/icons/json-icon.png","file"));
    addConnector(new Connector("Microsoft Access","../../Images/icons/microsoft-access-1.png","rdbms"));
    addConnector(new Connector("Microsoft Excel","../../Images/icons/microsoft-excel-2013.png","file"));
    addConnector(new Connector("Mysql","../../Images/icons/mysql-6.png","rdbms"));
    addConnector(new Connector("Oracle","../../Images/icons/oracle-icon.png","rdbms"));
    addConnector(new Connector("ODBC","../../Images/icons/Db - 60.png","rdbms"));
    addConnector(new Connector("Snowflake","../../Images/icons/20_snowflake-icon_a4ed1ae266.png","rdbms"));
    addConnector(new Connector("Sqlite","../../Images/icons/74_sqlite-icon_a6ac860586.png","rdbms"));
    addConnector(new Connector("Sql Server","../../Images/icons/microsoft-sql-server.png","rdbms"));
    addConnector(new Connector("Teradata","../../Images/icons/Db - 60.png","rdbms"));
    addConnector(new Connector("CSV","../../Images/icons/16_csv.png","file"));
}


/*!
 * \brief Override QAbstractListModel::rowCount
 * \details Override method to return the number of results in new model
 * \param parent
 * \return int
 */
int ConnectorModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mConnector.size();
}

/*!
 * \brief Override QAbstractListModel::data
 * \details Override method to return the data of the object for a given index
 * \param index (object index)
 * \param role (object role)
 * \return QVariant
 */
QVariant ConnectorModel::data(const QModelIndex &index, int role) const
{

    if (index.row() < 0 || index.row() >= mConnector.count())
        return QVariant();
    //The index is valid
    Connector * connector = mConnector[index.row()];
    if( role == NameRole)
        return connector->name();
    if( role == ImageLinkRole)
        return connector->imageLink();
    if( role == CategoryRole)
        return connector->category();
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
bool ConnectorModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Connector * connector = mConnector[index.row()];
    bool somethingChanged = false;

    switch (role) {
    case NameRole:
    {
        if( connector->name()!= value.toString()){
            connector->setName(value.toString());
            somethingChanged = true;
        }
    }
        break;
    case ImageLinkRole:
    {
        if( connector->imageLink()!= value.toString()){
            connector->setImageLink(value.toString());
            somethingChanged = true;
        }
    }
        break;
    case CategoryRole:
    {
        if( connector->category()!= value.toInt()){
            connector->setCategory(value.toString());
            somethingChanged = true;
        }
    }

    }

    if( somethingChanged){
        emit dataChanged(index,index,QVector<int>() << role);
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
Qt::ItemFlags ConnectorModel::flags(const QModelIndex &index) const
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
QHash<int, QByteArray> ConnectorModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[ImageLinkRole] = "imageLink";
    roles[CategoryRole] = "category";
    return roles;
}

/*!
 * \brief Push new data to the object and notify view
 */
void ConnectorModel::addConnector(Connector *connector)
{
    const int index = mConnector.size();
    beginInsertRows(QModelIndex(),index,index);
    mConnector.append(connector);
    endInsertRows();
}

/*!
 * \brief Add new data to the model
 */
void ConnectorModel::addConnector(const QString &name, const QString &imageLink, const QString &category)
{
    Connector *connector=new Connector(name,imageLink,category);
    addConnector(connector);
}


