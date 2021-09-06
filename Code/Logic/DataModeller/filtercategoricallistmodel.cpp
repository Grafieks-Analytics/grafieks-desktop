#include "filtercategoricallistmodel.h"


FilterCategoricalListModel::FilterCategoricalListModel(QObject *parent) : QAbstractListModel(parent)
{

    sqlComparisonOperators.append("=");
    sqlComparisonOperators.append("!=");
    sqlComparisonOperators.append("<>");
    sqlComparisonOperators.append("<");
    sqlComparisonOperators.append(">");
    sqlComparisonOperators.append("<=");
    sqlComparisonOperators.append(">=");
    sqlComparisonOperators.append("!>");
    sqlComparisonOperators.append("!<");
    sqlComparisonOperators.append("~");  // Case sensitive posix comparators
    sqlComparisonOperators.append("~*"); // Case insensitive posix comparators
}


int FilterCategoricalListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mFilter.size();
}

QVariant FilterCategoricalListModel::data(const QModelIndex &index, int role) const
{

    if (index.row() < 0 || index.row() >= mFilter.count())
        return QVariant();
    //The index is valid
    FilterCategoricalList * filterList = mFilter[index.row()];

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
    if( role == FilterListSlugRole)
        return filterList->slug();
    if( role == FilterListValueRole)
        return filterList->value();
    if( role == FilterListIncludeNullRole)
        return filterList->includeNull();
    if( role == FilterListExcludeRole)
        return filterList->exclude();
    return QVariant();
}

bool FilterCategoricalListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    FilterCategoricalList * filterList = mFilter[index.row()];
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

    case FilterListSlugRole:
    {
        if( filterList->relation()!= value.toString()){
            filterList->setRelation(value.toString());
            somethingChanged = true;
        }
        break;
    }

    case FilterListValueRole:
    {

        if( filterList->value()!= value.toString() ){
            filterList->setValue(value.toString());
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

Qt::ItemFlags FilterCategoricalListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> FilterCategoricalListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FilterListIdRole] = "filterId";
    roles[FilterListSectionRole] = "section";
    roles[FilterListCategoryRole] = "category";
    roles[FilterListSubCategoryRole] = "subCategory";
    roles[FilterListTableNameRole] = "tableName";
    roles[FilterListColumnNameRole] = "columnName";
    roles[FilterListRelationRole] = "relation";
    roles[FilterListSlugRole] = "slug";
    roles[FilterListValueRole] = "value";
    roles[FilterListIncludeNullRole] = "includeNull";
    roles[FilterListExcludeRole] = "exclude";

    return roles;
}



void FilterCategoricalListModel::newFilter(int counter, QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QString slug, QString val, bool includeNull, bool exclude )
{

    if(Statics::currentDbClassification == Constants::excelType){
        colName = "["+colName+"]";
    }

    addFilterList(new FilterCategoricalList(counter, section, category, subcategory, tableName, colName, relation, slug, val, includeNull, exclude, this));
    emit rowCountChanged();
}

void FilterCategoricalListModel::deleteFilter(int FilterIndex)
{
    beginRemoveRows(QModelIndex(), FilterIndex, FilterIndex);
    mFilter.removeAt(FilterIndex);
    endRemoveRows();

    emit rowCountChanged();
}

void FilterCategoricalListModel::updateFilter(int FilterIndex, QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QString slug, QString value, bool includeNull, bool exclude)
{

    if(Statics::currentDbClassification == Constants::excelType){
        colName = "["+colName+"]";
    }

    beginResetModel();
    if(section != "")
        mFilter[FilterIndex]->setSection(section);
    if(category != "")
        mFilter[FilterIndex]->setCategory(category);
    if(subcategory != "")
        mFilter[FilterIndex]->setSubCategory(subcategory);
    if(tableName != "")
        mFilter[FilterIndex]->setTableName(tableName);
    if(colName != "")
        mFilter[FilterIndex]->setColumnName(colName);
    if(relation != "")
        mFilter[FilterIndex]->setRelation(relation);
    if(slug != "")
        mFilter[FilterIndex]->setValue(slug);

    mFilter[FilterIndex]->setValue(value);
    mFilter[FilterIndex]->setIncludeNull(includeNull);
    mFilter[FilterIndex]->setExclude(exclude);

    endResetModel();

    emit rowCountChanged();


}

QString FilterCategoricalListModel::callQueryModel()
{
    FilterCategoricalList *filter;
    QString newWhereConditions = "";

    foreach(filter, mFilter){

        newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), filter->value(), filter->exclude(), filter->includeNull());

    }
    return newWhereConditions;
}

void FilterCategoricalListModel::clearFilters()
{
    beginResetModel();
    mFilter.clear();
    endResetModel();

    emit rowCountChanged();
}

int FilterCategoricalListModel::getFilterCategoricalListId(int FilterIndex)
{
    return mFilter.at(FilterIndex)->filterId();
}

QList<FilterCategoricalList *> FilterCategoricalListModel::getFilters()
{
    return mFilter;
}


void FilterCategoricalListModel::addFilterList(FilterCategoricalList *filter)
{
    const int index = mFilter.size();
    beginInsertRows(QModelIndex(),index,index);
    mFilter.append(filter);
    endInsertRows();

    emit rowCountChanged();
}


QString FilterCategoricalListModel::setRelation(QString tableName, QString columnName, QString relation, QString conditions, bool exclude, bool isNull)
{

    QStringList conditionList;
    QStringList relationList;
    QString tmpCondition;
    QString tmpRelation;
    QString tmpWhereConditions;

    QString notSign;
    QString excludeCase;
    QString newCondition;
    QString newIncludeNull;
    QString individualCondition;
    QString concetantedCondition;

    int localCounter = 0;
    QString joiner = this->getQueryJoiner();


    // If there are several relations involved
    switch(Statics::currentDbIntType){


    case Constants::jsonIntType:
    case Constants::csvIntType:{

        // Directly send the object to ProxyFilter to process
        // getFilters() function

        break;
    }

    case Constants::excelIntType:{

        if(relation.contains(",", Qt::CaseInsensitive)){
            relationList = relation.split(",");
            conditionList = conditions.split(",");

            foreach(tmpRelation, relationList){

                notSign = sqlComparisonOperators.contains(tmpRelation)? " !" : " NOT ";
                excludeCase = exclude ? tmpRelation.prepend(notSign) : tmpRelation;
                newCondition = tmpRelation.contains("in", Qt::CaseInsensitive) ? " ('" + conditionList[localCounter] + "')" : conditionList[localCounter] ;

                tmpWhereConditions = QString("%1.%2 %3 %4")
                        .arg(joiner + tableName + joiner).arg(joiner + columnName + joiner).arg(excludeCase).arg(newCondition);

                localCounter++;
            }

            localCounter = 0;

        } else{

            conditionList = conditions.split(",");

            foreach(individualCondition, conditionList){

                concetantedCondition.append("'" + individualCondition + "',");
            }
            concetantedCondition.chop(1);

            notSign = sqlComparisonOperators.contains(relation)? " !" : " NOT ";
            excludeCase = exclude ? relation.prepend(notSign) : relation;
            newCondition = relation.contains("in", Qt::CaseInsensitive) ? " (" + concetantedCondition+ ")" : concetantedCondition ;

            tmpWhereConditions = QString("%1.%2 %3 %4")
                    .arg(joiner + tableName + joiner).arg(joiner + columnName + joiner).arg(excludeCase).arg(newCondition);
        }

        break;
    }

    default:

        if(relation.contains(",", Qt::CaseInsensitive)){
            relationList = relation.split(",");
            conditionList = conditions.split(",");

            foreach(tmpRelation, relationList){

                notSign = sqlComparisonOperators.contains(tmpRelation)? " !" : " NOT ";
                excludeCase = exclude ? tmpRelation.prepend(notSign) : tmpRelation;
                newCondition = tmpRelation.contains("in", Qt::CaseInsensitive) ? " ('" + conditionList[localCounter] + "')" : conditionList[localCounter] ;

                tmpWhereConditions = QString("%1.%2 %3 %4")
                        .arg(joiner + tableName + joiner).arg(joiner + columnName + joiner).arg(excludeCase).arg(newCondition);

                localCounter++;
            }

            localCounter = 0;

        } else{

            conditionList = conditions.split(",");

            foreach(individualCondition, conditionList){

                concetantedCondition.append("'" + individualCondition + "',");
            }
            concetantedCondition.chop(1);

            notSign = sqlComparisonOperators.contains(relation)? " !" : " NOT ";
            excludeCase = exclude ? relation.prepend(notSign) : relation;
            newCondition = relation.contains("in", Qt::CaseInsensitive) ? " (" + concetantedCondition+ ")" : concetantedCondition ;

            tmpWhereConditions = QString("%1.%2 %3 %4")
                    .arg(joiner + tableName + joiner).arg(joiner + columnName + joiner).arg(excludeCase).arg(newCondition);
        }
        break;
    }

    return tmpWhereConditions;
}

QString FilterCategoricalListModel::getQueryJoiner()
{
    QString joiner;

    switch(Statics::currentDbIntType){
    case Constants::mysqlIntType:
        joiner = "`";
        break;

    case Constants::mongoIntType:
        joiner = "\"";
        break;

    case Constants::postgresIntType:
        joiner = "`";
        break;

    case Constants::oracleIntType:
        joiner = "'";
        break;

    case Constants::mssqlIntType:
        joiner = "\"";
        break;

    case Constants::accessIntType:
        joiner = "\"";
        break;
    case Constants::sqliteIntType:
        joiner = "`";
        break;

    case Constants::redshiftIntType:
        joiner = "\"";
        break;

    case Constants::snowflakeIntType:
        joiner = "\"";
        break;

    case Constants::teradataIntType:
        joiner = "\"";
        break;

    case Constants::jsonIntType:
    case Constants::csvIntType:
        joiner = "\"";
        break;
    case Constants::excelIntType:
        joiner = "";
        break;
    }

    return joiner;
}

