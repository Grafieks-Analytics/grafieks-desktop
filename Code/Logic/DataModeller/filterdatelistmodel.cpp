#include "filterdatelistmodel.h"

FilterDateListModel::FilterDateListModel(QObject *parent) : QAbstractListModel(parent)
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


int FilterDateListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mFilter.size();
}

QVariant FilterDateListModel::data(const QModelIndex &index, int role) const
{

    if (index.row() < 0 || index.row() >= mFilter.count())
        return QVariant();
    //The index is valid
    FilterDateList * filterList = mFilter[index.row()];

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
    if(role == FilterListActualValueRole)
        return filterList->actualValue();
    if( role == FilterListIncludeNullRole)
        return filterList->includeNull();
    if( role == FilterListExcludeRole)
        return filterList->exclude();
    return QVariant();
}

bool FilterDateListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    FilterDateList * filterList = mFilter[index.row()];
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

    case FilterListActualValueRole:
    {

        if( filterList->actualValue()!= value.toString() ){
            qDebug() << value.toString() << "Actual value insert";
            filterList->setActualValue(value.toString());
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

Qt::ItemFlags FilterDateListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> FilterDateListModel::roleNames() const
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
    roles[FilterListActualValueRole] = "actualValue";
    roles[FilterListIncludeNullRole] = "includeNull";
    roles[FilterListExcludeRole] = "exclude";

    return roles;
}



void FilterDateListModel::newFilter(int counter, int dateFormatId, QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QString slug, QString val, QString actualValue, bool includeNull, bool exclude )
{
    qDebug() << actualValue << "Actual value request";
    addFilterList(new FilterDateList(counter, dateFormatId, section, category, subcategory, tableName, colName, relation, slug, val, actualValue, includeNull, exclude, this));
    emit rowCountChanged();


}

void FilterDateListModel::deleteFilter(int FilterIndex)
{
    beginRemoveRows(QModelIndex(), FilterIndex, FilterIndex);
    mFilter.removeAt(FilterIndex);
    endRemoveRows();

    emit rowCountChanged();
}

void FilterDateListModel::updateFilter(int FilterIndex, int dateFormatId, QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QString slug, QString value, QString actualValue, bool includeNull, bool exclude)
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
    if(slug != "")
        mFilter[FilterIndex]->setSlug(slug);
    if(value != "")
        mFilter[FilterIndex]->setValue(value);
    if(actualValue != "")
        mFilter[FilterIndex]->setActualValue(actualValue);

    mFilter[FilterIndex]->setIncludeNull(includeNull);
    mFilter[FilterIndex]->setExclude(exclude);
    mFilter[FilterIndex]->setDateFormatId(dateFormatId);

    endResetModel();

    emit rowCountChanged();


}

QString FilterDateListModel::callQueryModel()
{
    FilterDateList *filter;
    QString newWhereConditions = "";
    QString newValue;
    QString value;
    QString tmpValue;

    foreach(filter, mFilter){

        QString category = filter->category();
        QString finalValue = "";

        if(category == Constants::dateMainTimeFrameType){

            QString subCategory = filter->subCategory();

            if(subCategory == Constants::dateSubYear){

                if(filter->relation().contains("between", Qt::CaseInsensitive)){
                    QStringList years =  filter->actualValue().split(",");
                    QString year1 = years[0];
                    QString year2 = years[1];
                    finalValue = year1 + "' AND '" + year2;
                } else{
                    finalValue = "%" + filter->actualValue() + "%";
                }
            }
            else if(subCategory == Constants::dateSubQuarter){

                QStringList quarters =  filter->actualValue().split(",");
                QString q1 = quarters[0];
                QString q2 = quarters[1];
                finalValue = q1 + "' AND '" + q2;

            }
            else if(subCategory == Constants::dateSubMonth){
                QStringList months =  filter->actualValue().split(",");
                QString m1 = months[0];
                QString m2 = months[1];
                finalValue = m1 + "' AND '" + m2;


            }
            else{
                if(filter->relation().contains("between", Qt::CaseInsensitive)){
                    QStringList days =  filter->actualValue().split(",");
                    QString d1 = days[0];
                    QString d2 = days[1];
                    finalValue = d1 + "' AND '" + d2;
                } else{
                    finalValue = "%" + filter->actualValue() + "%";
                }


            }
        }
        else if(category == Constants::dateMainCalendarType){

            QStringList dateRange = filter->value().split(",");
            QStringList tmpFromDate = dateRange[0].split("/");
            QString fromDate = tmpFromDate[2] + "-" + tmpFromDate[1] + "-" + tmpFromDate[0];
            tmpFromDate = dateRange[1].split("/");
            QString toDate  = tmpFromDate[2] + "-" + tmpFromDate[1] + "-" + tmpFromDate[0];
            finalValue = fromDate + "'" + " AND " + "'" + toDate;

        }
        else{

            QStringList dateValue;
            dateValue = filter->actualValue().split(',');
            finalValue = dateValue.join(",");
        }

        newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), finalValue, filter->exclude(), filter->includeNull());

    }



    return newWhereConditions;
}

void FilterDateListModel::clearFilters()
{
    beginResetModel();
    mFilter.clear();
    endResetModel();

    emit rowCountChanged();
}


void FilterDateListModel::addFilterList(FilterDateList *filter)
{
    const int index = mFilter.size();
    beginInsertRows(QModelIndex(),index,index);
    mFilter.append(filter);
    endInsertRows();

    emit rowCountChanged();
}


QString FilterDateListModel::setRelation(QString tableName, QString columnName, QString relation, QString conditions, bool exclude, bool isNull)
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

    // If there are several relations involved

    switch (Statics::currentDbIntType) {

    case Constants::jsonIntType:
    case Constants::excelIntType:
    case Constants::csvIntType:{

        if(relation.contains(",", Qt::CaseInsensitive)){
            relationList = relation.split(",");
            conditionList = conditions.split(",");

            foreach(tmpRelation, relationList){

                notSign = sqlComparisonOperators.contains(tmpRelation)? " !" : " NOT ";
                excludeCase = exclude ? tmpRelation.prepend(notSign) : tmpRelation;
                newCondition = tmpRelation.contains("in", Qt::CaseInsensitive) ? " ('" + conditionList[localCounter] + "')" : conditionList[localCounter] ;

                tmpWhereConditions = QString("%1.%2 %3 %4")
                        .arg("\"" + tableName + "\"").arg("\"" + columnName + "\"").arg(excludeCase).arg(newCondition);

                localCounter++;
            }

            localCounter = 0;

        } else{


            conditionList = conditions.split(",");

            foreach(individualCondition, conditionList){

                concetantedCondition.append("'" + individualCondition + "'");
            }



            notSign = sqlComparisonOperators.contains(relation)? " !" : " NOT ";
            excludeCase = exclude ? relation.prepend(notSign) : relation;
            newCondition = relation.contains("like", Qt::CaseInsensitive) ? " (" + concetantedCondition+ ")" : concetantedCondition ;

            tmpWhereConditions = QString("%1.%2 %3 %4")
                    .arg("\"" + tableName + "\"").arg("\"" + columnName + "\"").arg(excludeCase).arg(newCondition);
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
                newIncludeNull = isNull == false ? "AND " + tableName + "." + columnName + " IS NOT NULL" : "";

                tmpWhereConditions = QString("%1.%2 %3 %4")
                        .arg(tableName).arg(columnName).arg(excludeCase).arg(newCondition);

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
                    .arg(tableName).arg(columnName).arg(excludeCase).arg(newCondition);
        }
        break;
    }


    return tmpWhereConditions;
}


