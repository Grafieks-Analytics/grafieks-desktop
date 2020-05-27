#include "dblistmodel.h"

DBListModel::DBListModel(QObject *parent) : QAbstractListModel(parent)
{

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
    if( role == DBNameRole){

        return dblist->dbName();
    }


    return QVariant();
}

bool DBListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

    DBList * dbList = mDbList[index.row()];
    bool somethingChanged = false;

    switch (role) {
    case DBNameRole:
    {
        if( dbList->dbName()!= value.toString()){
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

void DBListModel::addDbList(const QString &name)
{

    DBList *dbList=new DBList(name);
    addDbList(dbList);
}

void DBListModel::requestDbList()
{
    MysqlCon mysqlcon;

    mysqlcon.MysqlInstance(Statics::myHost, Statics::myDb, Statics::myPort, Statics::myUsername, Statics::myPassword);
    QStringList dbList =  mysqlcon.MysqlListDbs();

    foreach(QString tmpDbList, dbList){
        qDebug() << "caller" << tmpDbList;
        addDbList(new DBList(tmpDbList));
    }
}
