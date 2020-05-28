#include "tablelistmodel.h"

TableListModel::TableListModel(QObject *parent) : QAbstractListModel(parent)
{


}

int TableListModel::rowCount(const QModelIndex &parent) const
{

    Q_UNUSED(parent)
    return mTableList.size();
}

QVariant TableListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mTableList.count())
        return QVariant();

    TableList * tablelist = mTableList[index.row()];

    if( role == TableNameRole){

        return tablelist->tableName();
    }


    return QVariant();
}

bool TableListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    TableList * tableList = mTableList[index.row()];
    bool somethingChanged = false;

    switch (role) {
    case TableNameRole:
    {
        if( tableList->tableName()!= value.toString()){
            tableList->setTableName(value.toString());
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

Qt::ItemFlags TableListModel::flags(const QModelIndex &index) const
{

    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> TableListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TableNameRole] = "tableName";
    return roles;

}

void TableListModel::addTableList(TableList *tableList)
{
    const int index = mTableList.size();
    beginInsertRows(QModelIndex(),index,index);
    mTableList.append(tableList);
    endInsertRows();
}

void TableListModel::requestTableList()
{

    MysqlCon mysqlcon;

    mysqlcon.MysqlInstance(Statics::myHost, Statics::myDb, Statics::myPort, Statics::myUsername, Statics::myPassword);
    QStringList tableList =  mysqlcon.MysqlListTables(Statics::myDb);

    foreach(QString tmpTableList, tableList){
        qDebug() << "caller" << tmpTableList;
        addTableList(new TableList(tmpTableList));
    }
}
