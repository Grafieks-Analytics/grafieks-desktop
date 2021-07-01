#include "reportsdatamodel.h"

ReportsDataModel::ReportsDataModel(QObject *parent) : QObject(parent)
{

}

void ReportsDataModel::searchColumnNames(QString keyword)
{
    emit sendFilteredColumn(this->categoryList.filter(keyword, Qt::CaseInsensitive), this->numericalList.filter(keyword, Qt::CaseInsensitive), this->dateList.filter(keyword, Qt::CaseInsensitive));
}

QStringList ReportsDataModel::fetchColumnData(QString columnName, QString options)
{
    // Fetch data here
    int key = newChartHeader.key( columnName );

    //    QStringList columnDataPointer = *newChartData.value(key);
    QStringList columnDataPointer = reportChartData.value(this->reportId).value(key);
    columnDataPointer.removeDuplicates();

    emit columnDataChanged(columnDataPointer, options);

    return columnDataPointer;
}

QStringList ReportsDataModel::searchColumnData(QString columnName, QString keyword)
{
    QStringList searchResults;
    int key = newChartHeader.key( columnName );

    QStringList columnDataPointer = *newChartData.value(key);
    columnDataPointer.removeDuplicates();
    searchResults = columnDataPointer.filter(keyword, Qt::CaseInsensitive);

    return searchResults;
}

void ReportsDataModel::clearData()
{

}

void ReportsDataModel::removeTmpChartData()
{

}

void ReportsDataModel::getChartData(QMap<int, QStringList *> chartData)
{
    this->newChartData = chartData;
}

void ReportsDataModel::getChartHeader(QMap<int, QStringList> chartHeader)
{

    //    this->chartHeaderDetails = chartHeader;
    qDebug() << "GOT CHART HEADER" << chartHeader;

    // Clear existing chart headers data
    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->newChartHeader.clear();

    // Update new data
    foreach(auto key, chartHeader.keys()){

        QString fullColumnName = chartHeader.value(key).at(0);

        if(chartHeader.value(key).at(1).contains(Constants::categoricalType)){
            this->categoryList.append(fullColumnName);
        } else if(chartHeader.value(key).at(1).contains(Constants::numericalType)){
            this->numericalList.append(fullColumnName);
        } else if(chartHeader.value(key).at(1).contains(Constants::dateType)){
            this->dateList.append(fullColumnName);
        } else{
            qDebug() << "OTHER UNDETECTED FIELD TYPE" <<   chartHeader.value(key).at(0);
        }

        this->newChartHeader.insert(key, fullColumnName);
    }

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);
    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);
}

void ReportsDataModel::updateFilterData(QMap<int, QVariantMap> masterReportFilters, QString reportId)
{
    // Copy newChartData to reportChartData before begining operations
    this->reportId = reportId;
    QMap<int, QStringList> copiedChartData;

    QList<int> chartKeys = newChartData.keys();

    foreach(int key, chartKeys){
        copiedChartData.insert(key, *newChartData.value(key));
    }
    this->reportChartData.insert(this->reportId, copiedChartData);

    QList<int> keys = masterReportFilters.keys();

    int i = 0;
    foreach(QVariantMap filters, masterReportFilters){

        int filterId = keys[i];
        QString section = filters.value("section").toString();
        QString category = filters.value("category").toString();
        QString subCategory = filters.value("subCategory").toString();
        QString columnName = filters.value("columnName").toStringList().at(0);
        QString tableName = filters.value("columnName").toStringList().at(1);

        QStringList actualDateValues = filters.value("actualDateValues").toStringList();
        int dateFormat = filters.value("dateFormat").toInt();

        QString filterRelation = filters.value("filterRelation").toString();
        QString filterSlug = filters.value("filterSlug").toString();
        bool includeExclude = filters.value("includeExclude").toBool();
        bool includeNull = filters.value("includeNull").toBool();
        bool selectAll = filters.value("selectAll").toBool();

        QVariantList filterValue = filters.value("filterValue").toList();
        QStringList filterValueList =  filterValue.at(0).toString().split(",");

        i++;

        // Start the filter operations here
        QStringList columnData;
        QStringList tmpList;
        QVector<int> indexes;

        // Fetch data here
        int newKey = newChartHeader.key( columnName );
        columnData = reportChartData.value(reportId).value(newKey);

        // 1. For like relation
        // For date and categorical only
        if(filterSlug == Constants::slugLikeRelation){

            qDebug() << "FILTER HERE" << filterSlug << "LIKE REL 1";

            QStringList tmpValues;

            if(section == Constants::dateType){

                tmpValues = actualDateValues;
                if(subCategory == Constants::dateSubYear){

                    tmpList = columnData.filter(tmpValues.at(0));

                    // Keys of the filtered values
                    // To be later used to fetch parallel column data
                    int i = 0;
                    foreach(QString val, tmpList){
                        indexes.append(columnData.indexOf(val, i));
                        i++;
                    }

                } else if(subCategory == Constants::dateSubDay){

                    QDate dt1 = QDate::fromString(tmpValues.at(0), "yyyy-MM-dd");

                    int i = 0;
                    foreach(QString tmpVal, columnData){

                        QDate dt = this->convertToDateFormatTimeFromString(tmpVal).toDate();
                        if(dt == dt1){
                            tmpList = columnData.filter(tmpVal);

                            // insert keys
                            indexes.append(i);
                        }
                        i++;
                    }
                } else {
                    tmpList = columnData;

                    // for keys
                    for(int i = 0; i < columnData.length(); i++){
                        indexes.append(i);
                    }
                }

            } else{

                if(filterValueList.at(0) == "%"){

                    tmpList = columnData;

                    // for keys
                    for(int i = 0; i < columnData.length(); i++){
                        indexes.append(i);
                    }
                }
            }

            columnData = tmpList;
        }

        // 2. Not like relation
        // Categorical & Date only
        else if(filterSlug == Constants::slugNotLikeRelation){

            qDebug() << "FILTER HERE" << filterSlug<< "NOT LIKE REL 2";

            if(filterValueList.at(0) == "%"){
                columnData.clear();
                indexes.clear();
            }
        }

        // 3. In array relation
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugInRelation){

            qDebug() << "FILTER HERE" << filterSlug << "IN REL 3" << includeExclude;
            bool firstInteration = true;

            if(section == Constants::dateType){

                foreach(QString tmpVal, actualDateValues.at(0).split(",")){

                    // If exclude is false
                    // else
                    if(includeExclude == false){
                        if(tmpList.indexOf(tmpVal) < 0) {
                            tmpList.append(tmpVal);

                            // insert keys
                            indexes.append(columnData.indexOf(tmpVal));
                        }
                    } else{
                        if(firstInteration == true){
                            tmpList = columnData;

                            int i = 0;
                            foreach(QString val, tmpList){
                                indexes.append(columnData.indexOf(val, i));
                                i++;
                            }

                            firstInteration = false;
                        }

                        indexes.remove(columnData.indexOf(tmpVal));
                        columnData.removeAt(columnData.indexOf(tmpVal));
                    }
                }
            } else{
                foreach(QString tmpVal, filterValueList){

                    // If exclude is false
                    // else
                    if(includeExclude == false){
                        if(tmpList.indexOf(tmpVal) < 0) {
                            tmpList.append(tmpVal);

                            // insert keys
                            indexes.append(columnData.indexOf(tmpVal));
                        }
                    }
                    else{
                        if(firstInteration == true){
                            tmpList = columnData;

                            int i = 0;
                            foreach(QString val, tmpList){
                                indexes.append(columnData.indexOf(val, i));
                                i++;
                            }

                            firstInteration = false;
                        }

                        indexes.remove(columnData.indexOf(tmpVal));
                        columnData.removeAt(columnData.indexOf(tmpVal));
                        tmpList = columnData;
                    }
                }
            }
            columnData = tmpList;

        }

        // 4. Equal to comparison
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "EQUAL REL 4";

            QString tmp = filterValueList.at(0);

            if(section == Constants::dateType){
                tmp = actualDateValues.at(0);

                int i = 0;
                foreach(QString tmpVal, columnData){
                    if(tmpVal == tmp) {
                        tmpList.append(tmp);

                        // insert keys
                        indexes.append(columnData.indexOf(tmp, i));
                    }
                    i++;
                }
            } else{
                tmp = filterValueList.at(0);
                int i = 0;
                foreach(QString tmpVal, columnData){
                    if(tmpVal == tmp) {
                        tmpList.append(tmp);

                        // insert keys
                        indexes.append(columnData.indexOf(tmp, i));
                    }
                    i++;
                }
            }
            columnData = tmpList;


        }

        // 5. Not equal comparison
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugNotEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "NOT EQUAL REL 5";

            // for keys
            for(int i = 0; i < columnData.length(); i++){
                if(columnData.value(i) != filterValueList.at(0))
                    indexes.append(i);
            }

            columnData.removeAll(filterValueList.at(0));
        }

        // 6. Between relation
        // This condition is only for numerical and date
        else if(filterSlug == Constants::slugBetweenRelation){

            QStringList tmpValues;

            qDebug() << "FILTER HERE" << filterSlug << "BETWEEN REL 6";

            if(section == Constants::dateType){

                QDateTime dt1;
                QDateTime dt2;

                if(category == Constants::dateMainCalendarType){
                    tmpValues = filterValue.at(0).toString().split(",");
                    dt1 = QDateTime::fromString(tmpValues.at(0), "dd/MM/yyyy");
                    dt2 = QDateTime::fromString(tmpValues.at(1), "dd/MM/yyyy");
                } else{
                    tmpValues = actualDateValues.at(0).split(",");

                    dt1 = QDateTime::fromString(tmpValues.at(0), "yyyy-MM-dd");
                    dt2 = QDateTime::fromString(tmpValues.at(1), "yyyy-MM-dd");
                }

                int i = 0;
                foreach(QString tmpVal, columnData){

                    QDateTime dt = this->convertToDateFormatTimeFromString(tmpVal).toDateTime();

                    if(dt > dt1 && dt < dt2){
                        tmpList.append(tmpVal);

                        // insert keys
                        indexes.append(i);
                    }

                    i++;
                }

            } else{

                tmpValues = filterValueList.at(0).split(" And ");

                int i = 0;
                foreach(QString tmpVal, columnData){
                    if(tmpVal.toDouble() > tmpValues.at(0).toDouble() && tmpVal.toDouble() < tmpValues.at(1).toDouble()){
                        if(tmpList.indexOf(columnData.filter(tmpVal)[0]) < 0) {
                            tmpList.append(tmpVal);

                            // insert keys
                            indexes.append(i);
                        }
                    }
                    i++;
                }
            }

            columnData = tmpList;

        }

        // 7. For smaller than relation
        // Numerical only
        else if(filterSlug == Constants::slugSmallerThanRelation){

            qDebug() << "FILTER HERE" << filterSlug << "SMALLER THAN REL 7";

            int i = 0;
            foreach(QString tmpVal, columnData){
                if(tmpVal.toFloat() < filterValueList.at(0).toFloat()){
                    if(tmpList.indexOf(columnData.filter(tmpVal)[0]) < 0) {
                        tmpList.append(tmpVal);

                        // insert keys
                        indexes.append(i);
                    }
                }
                i++;
            }

            columnData = tmpList;
        }

        // 8. For greater than relation
        // Numerical only
        else if(filterSlug == Constants::slugGreaterThanRelation){

            qDebug() << "FILTER HERE" << filterSlug << "GREATER THAN REL 8";

            int i = 0;
            foreach(QString tmpVal, columnData){
                if(tmpVal.toFloat() > filterValueList.at(0).toFloat()){
                    if(tmpList.indexOf(tmpVal) < 0) {
                        tmpList.append(tmpVal);

                        // insert keys
                        indexes.append(i);
                    }
                }
                i++;
            }

            columnData = tmpList;
        }

        // 9. For smaller than and equal to relation
        // Numerical only
        else if(filterSlug == Constants::slugSmallerThanEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "SMALLER THAN EQUAL REL 9";

            int i = 0;
            foreach(QString tmpVal, columnData){
                if(tmpVal.toFloat() <= filterValueList.at(0).toFloat()){
                    if(tmpList.indexOf(tmpVal) < 0) {
                        tmpList.append(tmpVal);

                        //insert keys
                        indexes.append(i);
                    }
                }

                i++;
            }

            columnData = tmpList;
        }

        // 10. For greater than and equal to relation
        // Numerical only
        else if(filterSlug == Constants::slugGreaterThanEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "GREATER THAN EQUAL REL 10";

            int i = 0;
            foreach(QString tmpVal, columnData){
                if(tmpVal.toFloat() >= filterValueList.at(0).toFloat()){
                    if(tmpList.indexOf(tmpVal) < 0) {
                        tmpList.append(tmpVal);

                        // insert keys
                        indexes.append(i);
                    }
                }
                i++;
            }

            columnData = tmpList;

        }

        // 11. For containig relation
        // Categorical
        else if(filterSlug == Constants::slugContainingRelation){

            qDebug() << "FILTER HERE" << filterSlug << "CONTAINING REL 11";

            QString tmpVal = filterValueList.at(0);
            tmpVal.remove(0,1); // remove first "%"
            tmpVal.chop(1); // remove last "%"

            tmpList = columnData.filter(tmpVal, Qt::CaseInsensitive);

            // Keys of the filtered values
            // To be later used to fetch parallel column data
            int i = 0;
            foreach(QString val, tmpList){
                indexes.append(columnData.indexOf(val, i));
                i++;
            }


            columnData = tmpList;

        }

        // 12. For Ends With relation
        // Categorical
        else if(filterSlug == Constants::slugEndsWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "ENDS With REL 12";

            QString tmp = filterValueList.at(0);
            tmp.remove(0,1); // remove first "%"

            int i = 0;
            foreach(QString tmpVal, columnData){

                if(tmpVal.endsWith(tmp, Qt::CaseInsensitive)){
                    tmpList.append(tmpVal);

                    // insert keys
                    indexes.append(i);
                }
                i++;
            }
            columnData = tmpList;
        }

        // 13. For Doesnt Start With relation
        // Categorical
        else if(filterSlug == Constants::slugDoesntStartWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "Doenst start with REL 13";

            QString tmp = filterValueList.at(0);
            tmp.chop(1); // remove last "%"

            int i = 0;
            foreach(QString tmpVal, columnData){

                if(tmpVal.startsWith(tmp, Qt::CaseInsensitive) == false){
                    tmpList.append(tmpVal);

                    // insert keys
                    indexes.append(i);
                }
                i++;
            }
            columnData = tmpList;
        }

        // 14. For Doesnt End With relation
        // Categorical
        else if(filterSlug == Constants::slugDoesntEndWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "Doenst end with REL 14";

            QString tmp = filterValueList.at(0);
            tmp.remove(0,1); // remove first "%"

            int i = 0;
            foreach(QString tmpVal, columnData){

                if(tmpVal.endsWith(tmp, Qt::CaseInsensitive) == false){
                    tmpList.append(tmpVal);

                    // insert keys
                    indexes.append(i);
                }
                i++;
            }
            columnData = tmpList;
        }

        // 15. Filter
        else{

            qDebug() << "FILTER HERE" << filterSlug << "UNKNOWN REL";

            qDebug() << "Else Filter values obtained"
                        <<filterId << section << category << subCategory << columnName << actualDateValues << dateFormat
                       << filterRelation << filterSlug << filterValueList << includeExclude << includeNull << selectAll;
        }


        QMap<int, QStringList> tmpColData;
        QStringList tmp;

        foreach(int internalKey, chartKeys){
            if(internalKey == newKey){
                tmpColData.insert(newKey, columnData);
            } else{

                // for each selected key values
                foreach(int internalIndex, indexes){
                    if(internalIndex >= 0){
                        tmp.append(reportChartData.value(reportId).value(internalKey).at(internalIndex));
                        tmpColData.insert(internalKey, tmp);
                    }
                }
                tmp.clear();
            }
        }

        reportChartData.insert(reportId, tmpColData);
        //        qDebug() << "TMP COL DATA" << tmpColData;

        emit reportDataChanged(this->reportChartData, reportId);
    }
}

void ReportsDataModel::currentScreenChanged(int currentScreen)
{
    switch(currentScreen){
    case Constants::dashboardScreen:
        break;

    case Constants::reportScreen:
        break;

    default:
        break;
    }
}

void ReportsDataModel::getReportId(QString reportId)
{
    this->reportId = reportId;
    QMap<int, QStringList> copiedChartData;

    QList<int> keys = newChartData.keys();
    foreach(int key, keys){
        copiedChartData.insert(key, *newChartData.value(key));
    }
    this->reportChartData.insert(this->reportId, copiedChartData);

    emit reportDataChanged(this->reportChartData, this->reportId);

}

QVariant ReportsDataModel::convertToDateFormatTimeFromString(QString stringDateFormat)
{
    QStringList dateFormats;
    QDateTime dateTime;
    QVariant out;
    bool status = false;

    // Custom formats
    dateFormats.append("yy");                           // 21
    dateFormats.append("yyyy");                         // 2012
    dateFormats.append("yyyy-MM-dd");                   // 2012-12-30
    dateFormats.append("dd.MM.yyyy");                   // 20.07.1969
    dateFormats.append("dd/MM/yyyy");                   // 20/07/69
    dateFormats.append("dd/MM/yyyy");                   // 20/07/1969
    dateFormats.append("ddd MMMM d yy");                // Sun July 20 69
    dateFormats.append("dddd");                         // Sunday

    // Other datetime parsing formats
    // Ref: https://help.sumologic.com/03Send-Data/Sources/04Reference-Information-for-Sources/Timestamps%2C-Time-Zones%2C-Time-Ranges%2C-and-Date-Formats
    dateFormats.append("hh:mm:ss");                     // 21:15:51
    dateFormats.append("yyyy-MM-dd hh:mm:ss");          // 2012-12-30 12:22:51
    dateFormats.append("yyyy-MM-ddThh:mm:ss");          // 2012-12-30T12:22:51
    dateFormats.append("yyyy-MM-ddThh:mm:ss.zzz");      // 2012-12-30T12:22:51.000
    dateFormats.append("yyyy-MM-ddThh:mm:ss.zzzZ");     // 2012-12-30T12:22:51.000


    foreach(QString format, dateFormats){

        if(QDateTime::fromString(stringDateFormat, format).isValid()){
            dateTime = QDateTime::fromString(stringDateFormat, format);
            status = true;
            out = dateTime;
        }

    }

    if(status == false){
        qDebug() << Q_FUNC_INFO << "Date conversion failed" << stringDateFormat;
    }

    return out;
}
