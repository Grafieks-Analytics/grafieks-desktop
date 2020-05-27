#include "dblistmodel.h"

DBListModel::DBListModel(QObject *parent) : QAbstractListModel(parent)
{
//    addDbList(new DBList("Amazon Redshift","../../Images/icons/aws-redshift-logo.png","rdbms"));
}

int DBListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mDbList.size();
}

QVariant DBListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mDbList.count())
        return QVariant();
    //The index is valid
    DBList * dblist = mDbList[index.row()];
    if( role == DBIdRole)
        return dblist->dbId();
    if( role == DBNameRole)
        return dblist->dbName();

    return QVariant();
}

bool DBListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

    DBList * dbList = mDbList[index.row()];
    bool somethingChanged = false;

    switch (role) {
    case DBIdRole:
    {
        if( dbList->dbId()!= value.toString()){
            qDebug() << "Changing names for " << dbList->dbId();
            dbList->setDbId(value.toInt());
            somethingChanged = true;
        }
    }
        break;
    case DBNameRole:
    {
        if( dbList->dbName()!= value.toString()){
            qDebug() << "Changing color for " << dbList->dbName();
            dbList->setDbName(value.toString());
            somethingChanged = true;
        }
    }
        break;


    }

    if( somethingChanged){
        emit dataChanged(index,index,QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags DBListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> DBListModel::roleNames() const
{

    QHash<int, QByteArray> roles;
    roles[DBIdRole] = "id";
    roles[DBNameRole] = "dbName";
    return roles;
}

void DBListModel::addDbList(DBList *dbList)
{

    const int index = mDbList.size();
    beginInsertRows(QModelIndex(),index,index);
    mDbList.append(dbList);
    endInsertRows();
}

void DBListModel::addDbList(const int &id, const QString &name)
{

    DBList *dbList=new DBList(id,name);
    addDbList(dbList);
}
