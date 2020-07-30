#include "filterlistmodel.h"



FilterListModel::FilterListModel(QObject *parent) : QAbstractListModel(parent), counter(0)
{

}

int FilterListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mFilter.size();
}

QVariant FilterListModel::data(const QModelIndex &index, int role) const
{

    if (index.row() < 0 || index.row() >= mFilter.count())
        return QVariant();
    //The index is valid
    FilterList * filterList = mFilter[index.row()];
    if( role == FilterListIdRole)
        return filterList->filterId();
    if( role == FilterListCategoryRole)
        return filterList->category();
    if( role == FilterListTableNameRole)
        return filterList->tableName();
    if( role == FilterListColumnNameRole)
        return filterList->columnName();
    if( role == FilterListRelationRole)
        return filterList->relation();
    if( role == FilterListValueRole)
        return filterList->value();
    return QVariant();
}

bool FilterListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    FilterList * filterList = mFilter[index.row()];
    bool somethingChanged = false;

    switch (role) {
    case FilterListIdRole:
    {
        if( filterList->filterId()!= value.toInt()){
            filterList->setFilterId(value.toInt());
            somethingChanged = true;
        }
    }
        break;
    case FilterListCategoryRole:
    {
        if( filterList->category()!= value.toString()){
            filterList->setCategory(value.toString());
            somethingChanged = true;
        }
    }
        break;
    case FilterListTableNameRole:
    {
        if( filterList->tableName()!= value.toString()){
            filterList->setTableName(value.toString());
            somethingChanged = true;
        }
        break;
    }

    case FilterListColumnNameRole:
    {
        if( filterList->columnName()!= value.toString()){
            filterList->setColumnName(value.toString());
            somethingChanged = true;
        }
    }
        break;
    case FilterListRelationRole:
    {
        if( filterList->relation()!= value.toString()){
            filterList->setRelation(value.toString());
            somethingChanged = true;
        }
    }
        break;
    case FilterListValueRole:
    {

        if( filterList->value()!= value.toString() || filterList->value()!= value.toInt() ){

            QString varType = typeid(filterList->value()).name();
            if(varType == "int"){
                filterList->setValue(value.toInt());
            } else{
                filterList->setValue(value.toString());
            }

            somethingChanged = true;
        }
        break;
    }

    }

    if( somethingChanged){
        emit dataChanged(index,index,QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags FilterListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> FilterListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FilterListIdRole] = "filterId";
    roles[FilterListCategoryRole] = "category";
    roles[FilterListTableNameRole] = "tableName";
    roles[FilterListColumnNameRole] = "columnName";
    roles[FilterListRelationRole] = "relation";
    roles[FilterListValueRole] = "value";

    return roles;
}

void FilterListModel::newFilter(QString tableName, QString colName, QString relation, QVariant requiredVal, QString category)
{

    FilterList *filterList = new FilterList(counter, category, tableName, colName, relation, requiredVal, this);
    addFilterList(filterList);

    counter++;

}

void FilterListModel::deleteFilter(int FilterID)
{
    beginRemoveRows(QModelIndex(), FilterID, FilterID);
    mFilter.removeAt(FilterID);
    endRemoveRows();
}

void FilterListModel::updateFilter(int FilterId, QString tableName, QString colName, QString relation, QVariant value, QString category)
{

    if(category != "")
        mFilter[FilterId]->setCategory(category);
    if(tableName != "")
        mFilter[FilterId]->setTableName(tableName);
    if(colName != "")
        mFilter[FilterId]->setColumnName(colName);
    if(relation != "")
        mFilter[FilterId]->setRelation(relation);
    if(value != "")
        mFilter[FilterId]->setValue(value);
}

void FilterListModel::addFilterList(FilterList *filter)
{
    const int index = mFilter.size();
    beginInsertRows(QModelIndex(),index,index);
    mFilter.append(filter);
    endInsertRows();
}

