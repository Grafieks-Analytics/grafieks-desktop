#include "filterdatelistmodel.h"
#include <QDate>

FilterDateListModel::FilterDateListModel(QObject *parent) : QAbstractListModel(parent), counter(0)
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
    roles[FilterListIncludeNullRole] = "includeNull";
    roles[FilterListExcludeRole] = "exclude";

    return roles;
}



void FilterDateListModel::newFilter(QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QString slug, QString val, bool includeNull, bool exclude )
{

    //    FilterList *filterList = new FilterList(counter, section, category, subcategory, tableName, colName, relation, val, includeNull, exclude, this);
    //    qDebug() <<"FROM FilterDateListModel newFilter" << counter << section<< category<< subcategory << tableName<< colName<< relation<< slug <<val<< includeNull<< exclude<< this;
    addFilterList(new FilterDateList(this->counter, section, category, subcategory, tableName, colName, relation, slug, val, includeNull, exclude, this));

    this->counter++;

    emit rowCountChanged();


}

void FilterDateListModel::deleteFilter(int FilterIndex)
{
    beginRemoveRows(QModelIndex(), FilterIndex, FilterIndex);
    mFilter.removeAt(FilterIndex);
    endRemoveRows();

    emit rowCountChanged();
}

void FilterDateListModel::updateFilter(int FilterIndex, QString section, QString category, QString subcategory, QString tableName, QString colName, QString relation, QString slug, QString value, bool includeNull, bool exclude)
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
        mFilter[FilterIndex]->setValue(slug);
    if(value != "")
        mFilter[FilterIndex]->setValue(value);

    mFilter[FilterIndex]->setIncludeNull(includeNull);
    mFilter[FilterIndex]->setExclude(exclude);

    endResetModel();

    emit rowCountChanged();


}

void FilterDateListModel::callQueryModel(QString tmpSql)
{
    FilterDateList *filter;
    QString newWhereConditions;
    QString newQuery;
    QString existingWhereString;
    QString newValue;
    QString value;
    QString tmpValue;
    bool firstValue = true;

    QSet <QString> weekDays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

    mQuerySplitter.setQuery(tmpSql);
    newWhereConditions = mQuerySplitter.getWhereCondition();

    foreach(filter, mFilter){

        QString category = filter->category();

        if(category == "date.timeframe"){

            //QDate currentDate = QDate::currentDate();
            //int monthIndex = currentDate.month();
            //int weekDay = currentDate.dayOfWeek();

            QString subCategory = filter->subCategory();

            if(subCategory == "Year"){
                QString newValue = this->timeFrameMap[filter->value()].toString();
                QStringList yearValues = newValue.split(",");
                QString year;
                if(yearValues.length() <= 1){
                    foreach(year, yearValues){
                        if(firstValue){
                            firstValue = false;
                            newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), year + "%", filter->exclude(), filter->includeNull());
                        }
                        else{
                            newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), year + "%", filter->exclude(), filter->includeNull());
                        }

                    }
                }
                else{
                    if(firstValue){
                        firstValue = false;
                        newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), yearValues[0] + "%", filter->exclude(), filter->includeNull());
                    }
                    else{
                         newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), yearValues[0] + "%", filter->exclude(), filter->includeNull());
                    }
                    for(int i = 1; i < yearValues.length(); i++){
                        newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), yearValues[i] + "%", filter->exclude(), filter->includeNull());
                    }
                }
            }
            else if(subCategory == "Quarter"){

            }
            else if(subCategory == "Month"){
                QString newValue = this->timeFrameMap[filter->value()].toString();
                QStringList monthValues = newValue.split(",");
                QString month;
                if(monthValues.length() <= 1){
                    foreach(month, monthValues){
                        if(firstValue){
                            firstValue = false;
                            newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), month + "%", filter->exclude(), filter->includeNull());
                        }
                        else{
                            newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), month + "%", filter->exclude(), filter->includeNull());
                        }

                    }
                }
                else{
                    if(firstValue){
                        firstValue = false;
                        newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), monthValues[0] + "%", filter->exclude(), filter->includeNull());
                    }
                    else{
                         newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), monthValues[0] + "%", filter->exclude(), filter->includeNull());
                    }
                    for(int i = 1; i < monthValues.length(); i++){
                        newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), monthValues[i] + "%", filter->exclude(), filter->includeNull());
                    }
                }
            }
            else{
                QString newValue = this->timeFrameMap[filter->value()].toString();
                newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), newValue + "%", filter->exclude(), filter->includeNull());
            }
        }
        else if(category == "date.calendar"){

            QStringList dateRange = filter->value().split(" To ");
            QStringList tmpFromDate = dateRange[0].split("/");
            QString fromDate = tmpFromDate[2] + "-" + tmpFromDate[1] + "-" + tmpFromDate[0];
            tmpFromDate = dateRange[1].split("/");
            QString toDate  = tmpFromDate[2] + "-" + tmpFromDate[1] + "-" + tmpFromDate[0];
            QString newValue = fromDate + " AND " + toDate;
            newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), newValue, filter->exclude(), filter->includeNull());

        }
        else{
            if(filter->value().indexOf(',') > -1)
            {
                QStringList dateValue;
                dateValue = filter->value().split(',');

                if(weekDays.contains(dateValue[0]))
                {
                    for(int i = 0; i < dateValue.length() - 1; i += 2)
                    {
                        tmpValue = dateValue[i] + "," + dateValue[i+1];
                        tmpValue = this->getFilteredValue(tmpValue);

                        if(firstValue)
                        {
                            firstValue = false;
                            newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), tmpValue, filter->exclude(), filter->includeNull());
                        }
                        else if(filter->exclude() == false)
                            newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), tmpValue, filter->exclude(), filter->includeNull());
                        else
                            newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), tmpValue, filter->exclude(), filter->includeNull());
                    }
                }
                else
                {
                    foreach(newValue, dateValue)
                    {
                        tmpValue = this->getFilteredValue(newValue);

                        if(firstValue)
                        {
                            firstValue = false;
                            newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), tmpValue, filter->exclude(), filter->includeNull());
                        }
                        else if(filter->exclude() == false)
                            newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), tmpValue, filter->exclude(), filter->includeNull());
                        else
                            newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), tmpValue, filter->exclude(), filter->includeNull());
                    }
                }

            }
            else
            {
                value = this->getFilteredValue(filter->value());

                if(firstValue)
                {
                    firstValue = false;
                    newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), value, filter->exclude(), filter->includeNull());
                }
                else if(filter->exclude() == false)
                    newWhereConditions += " OR " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), value, filter->exclude(), filter->includeNull());
                else
                    newWhereConditions += " AND " + this->setRelation(filter->tableName(), filter->columnName(), filter->relation(), value, filter->exclude(), filter->includeNull());

            }
        }
    }

    // Replace the WHERE condition with the new one

    QRegularExpression whereListRegex(R"(\sWHERE\s+(.*?)(?:\s+(?:GROUP|ORDER|LIMIT)\b|\s*$))", QRegularExpression::CaseInsensitiveOption);

    QRegularExpressionMatch whereIterator = whereListRegex.match(tmpSql);
    existingWhereString = whereIterator.captured(1).trimmed();
    newQuery = tmpSql.replace(existingWhereString, newWhereConditions);

    qDebug() << newQuery << "FINAL QUERY";

    emit sendFilterQuery(newQuery);
}

void FilterDateListModel::setDateFormatMap(QVariantMap dateFormatMap)
{
    this->dateFormatMap = dateFormatMap;
}

void FilterDateListModel::setTimeFrameMap(QVariantMap timeFrameMap)
{
    this->timeFrameMap = timeFrameMap;
}


void FilterDateListModel::addFilterList(FilterDateList *filter)
{
    const int index = mFilter.size();
    beginInsertRows(QModelIndex(),index,index);
    mFilter.append(filter);
    endInsertRows();

    emit rowCountChanged();
}

QString FilterDateListModel::getFilteredValue(QString val)
{
    QString format = this->dateFormatMap[val].toString();

    QMap <QString, QString> monthToIndex;
    monthToIndex.insert("January", "01");
    monthToIndex.insert("February", "02");
    monthToIndex.insert("March", "03");
    monthToIndex.insert("April", "04");
    monthToIndex.insert("May", "05");
    monthToIndex.insert("June", "06");
    monthToIndex.insert("July", "07");
    monthToIndex.insert("August", "08");
    monthToIndex.insert("September", "09");
    monthToIndex.insert("October", "10");
    monthToIndex.insert("November", "11");
    monthToIndex.insert("December", "12");

    QString value = val;
    QStringList dateFormatList;

    if(format == "DD/MM/YYYY")
    {
        dateFormatList = value.split("/");
        value = dateFormatList[2] + "-" + dateFormatList[1] + "-" + dateFormatList[0] + "%";
    }
    else if(format == "DD MMMM YYYY")
    {
        dateFormatList = value.split(" ");
        value = dateFormatList[2] + "-" + monthToIndex[dateFormatList[1]] + "-" + dateFormatList[0] + "%";
    }
    else if(format == "D MMMM YYYY")
    {
        dateFormatList = value.split(" ");

        if(dateFormatList[0].length() == 1)
            value = dateFormatList[2] + "-" + monthToIndex[dateFormatList[1]] + "-" + "0" + dateFormatList[0] + "%";
        else
            value = dateFormatList[2] + "-" + monthToIndex[dateFormatList[1]] + "-" + dateFormatList[0] + "%";
    }
    else if(format == "dddd, D MMMM YYYY")
    {
        dateFormatList = value.split(" ");

        if(dateFormatList[1].length() == 1)
            value = dateFormatList[3] + "-" + monthToIndex[dateFormatList[2]] + "-" + "0" + dateFormatList[1] + "%";
        else
            value = dateFormatList[3] + "-" + monthToIndex[dateFormatList[2]] + "-" + dateFormatList[1] + "%";
    }
    else if(format == "dddd, DD MMMM YYYY")
    {
        dateFormatList = value.split(" ");
        value = dateFormatList[3] + "-" + monthToIndex[dateFormatList[2]] + "-" + dateFormatList[1] + "%";
    }
    else if(format == "DD/MM/YY")
    {
        dateFormatList = value.split("/");
        value = "%" + dateFormatList[2] + "-" + dateFormatList[1] + "-" + dateFormatList[0]+ "%";
    }
    else if(format == "D/M/YY")
    {
        dateFormatList = value.split("/");

        if(dateFormatList[0].length() == 1 && dateFormatList[1].length() == 1)
            value = "%" + dateFormatList[2] + "-" + "0" + dateFormatList[1] + "-" + "0" + dateFormatList[0]+ "%";
        else if(dateFormatList[0].length() == 1)
            value = "%" + dateFormatList[2] + "-" + dateFormatList[1] + "-" + "0" + dateFormatList[0]+ "%";
        else
            value = "%" + dateFormatList[2] + "-" + "0" + dateFormatList[1] + "-" + dateFormatList[0]+ "%";
    }
    else if(format == "D.M.YY")
    {
        dateFormatList = value.split(".");

        if(dateFormatList[0].length() == 1 && dateFormatList[1].length() == 1)
            value = "%" + dateFormatList[2] + "-" + "0" + dateFormatList[1] + "-" + "0" + dateFormatList[0]+ "%";
        else if(dateFormatList[0].length() == 1)
            value = "%" + dateFormatList[2] + "-" + dateFormatList[1] + "-" + "0" + dateFormatList[0]+ "%";
        else
            value = "%" + dateFormatList[2] + "-" + "0" + dateFormatList[1] + "-" + dateFormatList[0]+ "%";
    }
    else if(format == "YYYY-MM-DD")
    {
        dateFormatList = value.split("-");
        value = dateFormatList[0] + "-" + dateFormatList[1] + "-" + dateFormatList[2]+ "%";
    }
    else if(format == "MMMM YYYY")
    {
        dateFormatList = value.split(" ");
        value = dateFormatList[1] + "-" + monthToIndex[dateFormatList[0]] + "%";
    }
    else if(format == "D MMMM")
    {
        dateFormatList = value.split(" ");

        if(dateFormatList[0].length() == 1)
            value = "%-" + monthToIndex[dateFormatList[1]] + "-" + "0" + dateFormatList[0] + "%";
        else
            value = "%-" + monthToIndex[dateFormatList[1]] + "-" + dateFormatList[0] + "%";
    }
    else if(format == "YY")
    {
        value = "%" + value + "-" + "%";
    }
    else if(format == "YYYY")
    {
        value = value + "%";
    }
    else if(format == "DD/MM/YYYY hh:mm:ss")
    {
        dateFormatList = value.split(" ");
        QString newValue = dateFormatList[0];
        QStringList newDateFormatList = newValue.split("/");
        newValue = newDateFormatList[2] + "-" + newDateFormatList[1] + "-" + newDateFormatList[0];
        value = newValue + " " + dateFormatList[1] + "%";
    }
    else{}

    return value;
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

    if(relation.contains(",", Qt::CaseInsensitive)){
        relationList = relation.split(",");
        conditionList = conditions.split(",");

        foreach(tmpRelation, relationList){

            notSign = sqlComparisonOperators.contains(tmpRelation)? " !" : " NOT ";
            excludeCase = exclude ? tmpRelation.prepend(notSign) : tmpRelation;
            newCondition = tmpRelation.contains("in", Qt::CaseInsensitive) ? " ('" + conditionList[localCounter] + "')" : conditionList[localCounter] ;
            newIncludeNull = isNull == false ? "AND " + tableName + "." + columnName + " IS NOT NULL" : "";

            tmpWhereConditions = QString("%1.%2 %3 %4 %5")
                    .arg(tableName).arg(columnName).arg(excludeCase).arg(newCondition).arg(newIncludeNull);

            localCounter++;
        }

        localCounter = 0;

    } else{

        if(conditions.contains(" AND ")){

            conditionList = conditions.split(" AND ");
            concetantedCondition.append("'" + conditionList[0] + "'" + " AND "  + "'" + conditionList[1] + "'");

        }
        else{
            conditionList = conditions.split(",");

            foreach(individualCondition, conditionList){

                concetantedCondition.append("'" + individualCondition + "'");
            }
        }


        notSign = sqlComparisonOperators.contains(relation)? " !" : " NOT ";
        excludeCase = exclude ? relation.prepend(notSign) : relation;
        newCondition = relation.contains("in", Qt::CaseInsensitive) ? " (" + concetantedCondition+ ")" : concetantedCondition ;
        newIncludeNull = isNull == false ? " AND " + tableName + "." + columnName + " IS NOT NULL" : "";

        tmpWhereConditions = QString("%1.%2 %3 %4 %5")
                .arg(tableName).arg(columnName).arg(excludeCase).arg(newCondition).arg(newIncludeNull);
    }

    return tmpWhereConditions;
}


