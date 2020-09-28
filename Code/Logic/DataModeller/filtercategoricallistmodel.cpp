#include "filtercategoricallistmodel.h"


FilterCategoricalListModel::FilterCategoricalListModel(QObject *parent) : QAbstractListModel(parent), counter(0)
{


//    explicit FilterList(const int & filterId, const QString & section, const QString & category, const QString & subcategory, const QString & tableName, const QString & columnName, const QString & relation, const QString & value, const bool & includeNull, const bool & exclude, QObject *parent = nullptr);

//    qDebug() << "CALLED model constructor";
//    addFilterList(new FilterList(0,"categorical", "categoricalList", "multiple", "users", "username", "IN", "%", true, false, this));
//    addFilterList(new FilterList(1,"categorical", "categoricalList", "multiple", "email", "username", "IN", "%", true, false, this));

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

void FilterCategoricalListModel::callNewFilter()
{
//    qDebug() << "CALLED new filter";
//    addFilterList(new FilterList(1,"categorical", "categoricalList", "multiple", "reset_hash", "username", "IN", "%", true, false, this));
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
    roles[FilterListValueRole] = "value";
    roles[FilterListIncludeNullRole] = "includeNull";
    roles[FilterListExcludeRole] = "exclude";

    return roles;
}



void FilterCategoricalListModel::newFilter(QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QString val, bool includeNull, bool exclude )
{

//    FilterList *filterList = new FilterList(counter, section, category, subcategory, tableName, colName, relation, val, includeNull, exclude, this);
//    qDebug << counter << section<< category<< subcategory < tableName, colName, relation, val, includeNull, exclude, this;
    addFilterList(new FilterCategoricalList(counter, section, category, subcategory, tableName, colName, relation, val, includeNull, exclude, this));

    counter++;

}

void FilterCategoricalListModel::deleteFilter(int FilterIndex)
{
    beginRemoveRows(QModelIndex(), FilterIndex, FilterIndex);
    mFilter.removeAt(FilterIndex);
    endRemoveRows();

    emit rowCountChanged();
}

void FilterCategoricalListModel::updateFilter(int FilterIndex, QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QString value, bool includeNull, bool exclude)
{

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
    if(value != "")
        mFilter[FilterIndex]->setValue(value);

    mFilter[FilterIndex]->setIncludeNull(includeNull);
    mFilter[FilterIndex]->setExclude(exclude);

    endResetModel();


}

void FilterCategoricalListModel::callQueryModel(QString tmpSql)
{
    FilterCategoricalList *filter;
    QString newWhereConditions;
    QString newQuery;
    QString existingWhereString;


    mQuerySplitter.setQuery(tmpSql);
    newWhereConditions = mQuerySplitter.getWhereCondition();

    foreach(filter, mFilter){

        newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), filter->value(), filter->exclude(), filter->includeNull());

    }

    // Replace the WHERE condition with the new one

    QRegularExpression whereListRegex(R"(\sWHERE\s+(.*?)(?:\s+(?:GROUP|ORDER|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);

    QRegularExpressionMatch whereIterator = whereListRegex.match(tmpSql);
    existingWhereString = whereIterator.captured(1).trimmed();
    newQuery = tmpSql.replace(existingWhereString, newWhereConditions);

    qDebug() << newQuery << "FINAL QUERY";

    emit sendFilterQuery(newQuery);
}


void FilterCategoricalListModel::addFilterList(FilterCategoricalList *filter)
{
    const int index = mFilter.size();
    beginInsertRows(QModelIndex(),index,index);
    mFilter.append(filter);
    endInsertRows();

    emit rowCountChanged();
}

void FilterCategoricalListModel::columnList(QVariantList &columns)
{

    Q_UNUSED(columns);
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

    int counter = 0;

    // If there are several relations involved

    if(relation.contains(",", Qt::CaseInsensitive)){
        relationList = relation.split(",");
        conditionList = conditions.split(",");

        foreach(tmpRelation, relationList){

            notSign = sqlComparisonOperators.contains(tmpRelation)? " !" : " NOT ";
            excludeCase = exclude ? tmpRelation.prepend(notSign) : tmpRelation;
            newCondition = tmpRelation.contains("in", Qt::CaseInsensitive) ? " ('" + conditionList[counter] + "')" : conditionList[counter] ;
            newIncludeNull = isNull == false ? "AND " + tableName + "." + columnName + " IS NOT NULL" : "";

            tmpWhereConditions = QString("%1.%2 %3 %4 %5")
                            .arg(tableName).arg(columnName).arg(excludeCase).arg(newCondition).arg(newIncludeNull);

            counter++;
        }

        counter = 0;

    } else{

        conditionList = conditions.split(",");

        foreach(individualCondition, conditionList){

            concetantedCondition.append("'" + individualCondition + "',");
        }
       concetantedCondition.chop(1);

        notSign = sqlComparisonOperators.contains(relation)? " !" : " NOT ";
        excludeCase = exclude ? relation.prepend(notSign) : relation;
        newCondition = relation.contains("in", Qt::CaseInsensitive) ? " (" + concetantedCondition+ ")" : concetantedCondition ;
        newIncludeNull = isNull == false ? " AND " + tableName + "." + columnName + " IS NOT NULL" : "";

        tmpWhereConditions = QString("%1.%2 %3 %4 %5")
                        .arg(tableName).arg(columnName).arg(excludeCase).arg(newCondition).arg(newIncludeNull);
    }

    return tmpWhereConditions;
}

