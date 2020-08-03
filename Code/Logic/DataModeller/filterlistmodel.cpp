#include "filterlistmodel.h"



FilterListModel::FilterListModel(QObject *parent) : QAbstractListModel(parent), counter(0), rowCountSize(0)
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
    if( role == FilterListSectionRole)
        return filterList->section();
    if( role == FilterListCategoryRole)
        return filterList->category();
    if( role == FilterListSubCategoryRole)
        return filterList->subCategory();
    if( role == FilterListTableNameRole)
        return filterList->tableName();
    if( role == FilterListColumnNameRole)
        return filterList->columnName();
    if( role == FilterListRelationRole)
        return filterList->relation();
    if( role == FilterListValueRole)
        return filterList->value();
    if( role == FilterListIncludeNullRole)
        return filterList->includeNull();
    if( role == FilterListExcludeRole)
        return filterList->exclude();
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
        break;
    }


    case FilterListSectionRole:
    {
        if( filterList->section()!= value.toString()){
            filterList->setSection(value.toString());
            somethingChanged = true;
        }
        break;
    }

    case FilterListCategoryRole:
    {
        if( filterList->category()!= value.toString()){
            filterList->setCategory(value.toString());
            somethingChanged = true;
        }
        break;
    }

    case FilterListSubCategoryRole:
    {
        if( filterList->subCategory()!= value.toString()){
            filterList->setSubCategory(value.toString());
            somethingChanged = true;
        }
        break;
    }

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
        break;
    }

    case FilterListRelationRole:
    {
        if( filterList->relation()!= value.toString()){
            filterList->setRelation(value.toString());
            somethingChanged = true;
        }
        break;
    }

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

    case FilterListIncludeNullRole:
    {
        if( filterList->includeNull()!= value.toBool()){
            filterList->setIncludeNull(value.toBool());
            somethingChanged = true;
        }
        break;
    }

    case FilterListExcludeRole:
    {
        if( filterList->exclude()!= value.toBool()){
            filterList->setExclude(value.toBool());
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
    roles[FilterListSectionRole] = "section";
    roles[FilterListCategoryRole] = "category";
    roles[FilterListSubCategoryRole] = "subCategory";
    roles[FilterListTableNameRole] = "tableName";
    roles[FilterListColumnNameRole] = "columnName";
    roles[FilterListRelationRole] = "relation";
    roles[FilterListValueRole] = "value";
    roles[FilterListIncludeNullRole] = "includeNull";
    roles[FilterListExcludeRole] = "exclude";

    return roles;
}

void FilterListModel::newFilter(QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QVariant val, bool includeNull, bool exclude )
{

    qDebug() << counter<< section<< category<< subcategory<< tableName<< colName<< relation<< val<< includeNull<< exclude;
    FilterList *filterList = new FilterList(counter, section, category, subcategory, tableName, colName, relation, val, includeNull, exclude, this);
    addFilterList(filterList);

    counter++;

}

void FilterListModel::deleteFilter(int FilterID)
{
    beginRemoveRows(QModelIndex(), FilterID, FilterID);
    mFilter.removeAt(FilterID);
    endRemoveRows();

    emit rowCountChanged();
}

void FilterListModel::updateFilter(int FilterId, QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QVariant value, bool includeNull, bool exclude)
{

    if(section != "")
        mFilter[FilterId]->setSection(section);
    if(category != "")
        mFilter[FilterId]->setCategory(category);
    if(subcategory != "")
        mFilter[FilterId]->setSubCategory(subcategory);
    if(tableName != "")
        mFilter[FilterId]->setTableName(tableName);
    if(colName != "")
        mFilter[FilterId]->setColumnName(colName);
    if(relation != "")
        mFilter[FilterId]->setRelation(relation);
    if(value != "")
        mFilter[FilterId]->setValue(value);

    mFilter[FilterId]->setIncludeNull(includeNull);
    mFilter[FilterId]->setExclude(exclude);
}

void FilterListModel::addFilterList(FilterList *filter)
{
    const int index = mFilter.size();
    beginInsertRows(QModelIndex(),index,index);
    mFilter.append(filter);
    endInsertRows();

    emit rowCountChanged();
}

void FilterListModel::columnList(QVariantList &columns)
{

    Q_UNUSED(columns);
}

