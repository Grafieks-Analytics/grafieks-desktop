#include "reportsdatamodel.h"

ReportsDataModel::ReportsDataModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{

}

void ReportsDataModel::searchColumnNames(QString keyword)
{
    emit sendFilteredColumn(this->categoryList.filter(keyword, Qt::CaseInsensitive), this->numericalList.filter(keyword, Qt::CaseInsensitive), this->dateList.filter(keyword, Qt::CaseInsensitive));
}

QStringList ReportsDataModel::fetchColumnData(QString columnName, QString options)
{
    // Fetch data from duckdb
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    //    if(Statics::currentDbIntType == Constants::excelIntType || Statics::currentDbIntType == Constants::csvIntType || Statics::currentDbIntType == Constants::jsonIntType) {
    tableName = QFileInfo(tableName).baseName().toLower();
    tableName = tableName.remove(QRegularExpression("[^A-Za-z0-9]"));
    //    }

    QString joiner = "\"";
    QString query = "SELECT DISTINCT " + joiner + columnName + joiner + " FROM " + joiner + tableName + joiner;

    auto data = con.Query(query.toStdString());

    this->columnData.clear();

    if(data->error.empty()){
        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            QString fieldName =  data->GetValue(0, i).ToString().c_str();
            fieldName = fieldName.trimmed();
            this->columnData.append(fieldName);
        }
    } else {
        qDebug() << Q_FUNC_INFO << data->error.c_str();
    }

    emit columnDataChanged(this->columnData, options);

    return this->columnData;
}

QStringList ReportsDataModel::searchColumnData(QString keyword)
{
    QStringList searchResults;
    searchResults = this->columnData.filter(keyword, Qt::CaseInsensitive);
    return searchResults;
}

QStringList ReportsDataModel::fetchColumnDataLive(QString columnName, QString options)
{
    QString dbString;

    this->columnData.clear();

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:
    case Constants::sqliteIntType:
    case Constants::postgresIntType:
    case Constants::oracleIntType:
    case Constants::mssqlIntType:
    case Constants::accessIntType:
    case Constants::mongoIntType:{
        QString dbString;

        switch (Statics::currentDbIntType) {

        case Constants::mysqlIntType:
            dbString = Constants::mysqlStrQueryType;
            break;
        case Constants::mysqlOdbcIntType:
            dbString = Constants::mysqlOdbcStrQueryType;
            break;
        case Constants::sqliteIntType:
            dbString = Constants::sqliteStrQueryType;
            break;
        case Constants::postgresIntType:
            dbString = Constants::postgresOdbcStrQueryType;
            break;
        case Constants::oracleIntType:
            dbString = Constants::oracleOdbcStrQueryType;
            break;
        case Constants::mssqlIntType:
            dbString = Constants::mssqlOdbcStrQueryType;
            break;
        case Constants::accessIntType:
            dbString = Constants::accessOdbcStrQueryType;
            break;
        case Constants::mongoIntType:
            dbString = Constants::mongoOdbcStrQueryType;
            break;

        }
        qDebug() << "ALAC";

        QSqlDatabase dbCon = QSqlDatabase::database(dbString);
        QString queryString = "SELECT DISTINCT " + columnName + " FROM " + this->liveMasterTable + " " + this->liveJoinParams + " " + this->liveWhereParams;
        QSqlQuery query(queryString, dbCon);

        while(query.next()){
            this->columnData.append(query.value(0).toString());
        }

        break;
    }


    }

    emit columnDataChanged(this->columnData, options);
    return this->columnData;
}


void ReportsDataModel::clearData()
{

}

void ReportsDataModel::removeTmpChartData()
{

}

void ReportsDataModel::deleteReportData(int reportId, bool deleteAll)
{

    if(deleteAll == false){
        this->reportChartData.remove(reportId);
    } else {
        this->newChartData.clear();
        this->reportChartData.clear();
        this->newChartHeader.clear();

        this->numericalList.clear();
        this->categoryList.clear();
        this->dateList.clear();
    }
}



void ReportsDataModel::updateFilterData(QMap<int, QVariantMap> masterReportFilters, int reportId)
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

    // Where conditions
    QString joiner = "\"";
    this->whereConditions = "";

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
                    this->whereConditions += joiner + columnName + joiner + " LIKE '%" + tmpValues.at(0) + "%' AND ";
                } else if(subCategory == Constants::dateSubDay){
                    QDate dt1 = QDate::fromString(tmpValues.at(0), "yyyy-MM-dd");
                    this->whereConditions += "strftime(DATE, " +joiner + columnName + joiner +", %Y-%m-%d) = " + dt1.toString() + " AND ";
                } else {
                    this->whereConditions += " AND ";
                }

            } else{

                if(filterValueList.at(0) == "%"){
                    this->whereConditions += " AND ";
                }
            }
        }

        // 2. Not like relation
        // Categorical & Date only
        else if(filterSlug == Constants::slugNotLikeRelation){

            qDebug() << "FILTER HERE" << filterSlug<< "NOT LIKE REL 2";
            this->whereConditions += joiner + columnName + joiner + " NOT LIKE % AND ";
        }

        // 3. In array relation
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugInRelation){

            qDebug() << "FILTER HERE" << filterSlug << "IN REL 3" << includeExclude;
            QString values;

            if(section == Constants::dateType){

                foreach(QString tmpVal, actualDateValues.at(0).split(",")){

                    if(tmpList.indexOf(tmpVal) < 0) {
                        tmpList.append(tmpVal);

                        // insert keys
                        values += "'" + tmpVal + "',";
                    }
                }
            } else{
                foreach(QString tmpVal, filterValueList){

                    if(tmpList.indexOf(tmpVal) < 0) {
                        tmpList.append(tmpVal);

                        // insert keys
                        values += "'" + tmpVal.replace("'", "''") + "',";
                    }
                }
            }
            values.chop(1);
            qDebug() << "IN VALUES" << values;

            QString notRelationString = includeExclude == true ? " NOT " : "";
            whereConditions += joiner + columnName + joiner + notRelationString + " IN (" + values + ") AND ";
        }

        // 4. Equal to comparison
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "EQUAL REL 4";

            if(section == Constants::dateType){
                whereConditions += joiner + columnName + joiner + " = '" + actualDateValues.at(0) + "' AND ";
            } else{
                QString param = filterValueList.at(0);
                whereConditions += joiner + columnName + joiner + " = '" + param.replace("'", "''") + "' AND ";
            }

        }

        // 5. Not equal comparison
        // Numerical, Categorical & Date
        else if(filterSlug == Constants::slugNotEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "NOT EQUAL REL 5";
            QString param = filterValueList.at(0);
            whereConditions += joiner + columnName + joiner + " != '" + param.replace("'", "''") + "' AND ";

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

                whereConditions += joiner + columnName + joiner + " BETWEEN '" + dt1.toString() + "' AND '" + dt1.toString() + "' AND ";

            } else{

                tmpValues = filterValueList.at(0).split(" And ");
                whereConditions += joiner + columnName + joiner + " BETWEEN " + tmpValues.at(0).toDouble() + " AND " + tmpValues.at(1).toDouble() + " AND ";
            }

        }

        // 7. For smaller than relation
        // Numerical only
        else if(filterSlug == Constants::slugSmallerThanRelation){

            qDebug() << "FILTER HERE" << filterSlug << "SMALLER THAN REL 7" << filterValueList.at(0).toFloat();
            whereConditions += joiner + columnName + joiner + " < " + filterValueList.at(0).toStdString().c_str() + " AND ";
        }

        // 8. For greater than relation
        // Numerical only
        else if(filterSlug == Constants::slugGreaterThanRelation){

            qDebug() << "FILTER HERE" << filterSlug << "GREATER THAN REL 8";
            whereConditions += joiner + columnName + joiner + " > " + filterValueList.at(0).toStdString().c_str() + " AND ";
        }

        // 9. For smaller than and equal to relation
        // Numerical only
        else if(filterSlug == Constants::slugSmallerThanEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "SMALLER THAN EQUAL REL 9";
            whereConditions += joiner + columnName + joiner + " <= " + filterValueList.at(0).toStdString().c_str() + " AND ";
        }

        // 10. For greater than and equal to relation
        // Numerical only
        else if(filterSlug == Constants::slugGreaterThanEqualRelation){

            qDebug() << "FILTER HERE" << filterSlug << "GREATER THAN EQUAL REL 10";
            whereConditions += joiner + columnName + joiner + " >= " + filterValueList.at(0).toStdString().c_str() + " AND ";

        }

        // 11. For containig relation
        // Categorical
        else if(filterSlug == Constants::slugContainingRelation){

            qDebug() << "FILTER HERE" << filterSlug << "CONTAINING REL 11";

            QString tmpVal = filterValueList.at(0);
            whereConditions += joiner + columnName + joiner + " LIKE '" + tmpVal.replace("'", "''") + "' AND ";
        }

        // 12. For Ends With relation
        // Categorical
        else if(filterSlug == Constants::slugEndsWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "ENDS With REL 12";

            QString tmpVal = filterValueList.at(0);
            whereConditions += joiner + columnName + joiner + " LIKE '" + tmpVal.replace("'", "''") + "' AND ";
        }

        // 13. For Doesnt Start With relation
        // Categorical
        else if(filterSlug == Constants::slugDoesntStartWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "Doenst start with REL 13";

            QString tmpVal = filterValueList.at(0);
            whereConditions += joiner + columnName + joiner + " NOT LIKE '" + tmpVal.replace("'", "''")  + "' AND ";
        }

        // 14. For Doesnt End With relation
        // Categorical
        else if(filterSlug == Constants::slugDoesntEndWithRelation){

            qDebug() << "FILTER HERE" << filterSlug << "Doenst end with REL 14";

            QString tmpVal = filterValueList.at(0);
            whereConditions += joiner + columnName + joiner + " NOT LIKE '" + tmpVal.replace("'", "''")  + "' AND ";
        }

        // 15. Filter
        else{

            qDebug() << "FILTER HERE" << filterSlug << "UNKNOWN REL";

            qDebug() << "Else Filter values obtained"
                        <<filterId << section << category << subCategory << columnName << actualDateValues << dateFormat
                       << filterRelation << filterSlug << filterValueList << includeExclude << includeNull << selectAll;
        }
    }

    // Remove trailing ' AND '
    this->whereConditions.chop(5);
    emit reportWhereConditions(this->whereConditions, reportId);
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

void ReportsDataModel::getReportId(int reportId)
{
    this->reportId = reportId;
    QMap<int, QStringList> copiedChartData;

    QList<int> keys = newChartData.keys();
    foreach(int key, keys){
        copiedChartData.insert(key, *newChartData.value(key));
    }
    this->reportChartData.insert(this->reportId, copiedChartData);

}

void ReportsDataModel::generateColumnsForExtract()
{
    // Fetch data from duckdb
    QString extractPath = Statics::extractPath;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    // GCS Bugfixes -- Fix Keyword
    // if condition is fictitious and needs fixing
    if(Constants::apiSwitch == true){
        this->generateColumnsFromAPI();
    } else {
        this->generateColumns(&con);
    }

}

void ReportsDataModel::generateColumnsForLive(QMap<int, QStringList> sqlHeaders)
{

    // Clear existing chart headers data
    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->newChartHeader.clear();

    int i = 0;
    foreach(QStringList headers, sqlHeaders){

        if(headers.at(1).contains(Constants::categoricalType)){
            this->categoryList.append(headers.at(0));
        } else if(headers.at(1).contains(Constants::numericalType)){
            this->numericalList.append(headers.at(0));
        } else if(headers.at(1).contains(Constants::dateType)){
            this->dateList.append(headers.at(0));
        } else{
            qDebug() << "OTHER UNDETECTED FIELD TYPE" << headers.at(0);
        }

        this->newChartHeader.insert(i, headers.at(0));
        i++;
    }

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);

    // Update new data

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);
    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);
}

void ReportsDataModel::generateColumnsForReader(duckdb::Connection *con)
{
    // GCS Bugfixes -- Fix Keyword
    // if condition is fictitious and needs fixing
    if(Constants::apiSwitch == true){
        this->generateColumnsFromAPI();
    } else {
        this->generateColumns(con);
    }
}

void ReportsDataModel::receiveOriginalConditions(QString selectParams, QString whereParams, QString joinParams, QString masterTable)
{
    this->liveSelectParams = selectParams;
    this->liveMasterTable = masterTable;
    this->liveWhereParams = whereParams;
    this->liveJoinParams = joinParams;
}

void ReportsDataModel::dataReadyRead()
{
    m_dataBuffer->append(m_networkReply->readAll());
}

void ReportsDataModel::dataReadFinished()
{
    //Parse the JSON
    if( m_networkReply->error()){

        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{


        QJsonDocument resultJson = QJsonDocument::fromJson(* m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonDocument dataDoc =  QJsonDocument::fromJson(resultObj["data"].toString().toUtf8());

        // Clear existing chart headers data
        this->numericalList.clear();
        this->categoryList.clear();
        this->dateList.clear();
        this->newChartHeader.clear();

        QJsonObject json = dataDoc.object();
        int i = 0;
        QJsonArray value = json.value("all").toArray();

        foreach(QJsonValue data, value){
            QJsonArray finalValue = data.toArray();


            if(finalValue.at(3).toString() == "categorical"){
                this->categoryList.append(finalValue.at(1).toString());
            } else if(finalValue.at(3).toString() == "numerical"){
                this->numericalList.append(finalValue.at(1).toString());
            } else if(finalValue.at(3).toString() == "dateformat"){
                this->dateList.append(finalValue.at(1).toString());
            }

            this->newChartHeader.insert(i, finalValue.at(1).toString());
            i++;
        }


        this->categoryList.sort(Qt::CaseInsensitive);
        this->numericalList.sort(Qt::CaseInsensitive);
        this->dateList.sort(Qt::CaseInsensitive);
        emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);
    }
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

void ReportsDataModel::generateColumns(duckdb::Connection *con)
{
    QMap<int, QStringList> chartHeader;
    QMap<QString, QString> colTypeMap;

    // Fetch data from duckdb
    QString tableName = Statics::currentDbName;

    //    if(Statics::currentDbIntType == Constants::excelIntType || Statics::currentDbIntType == Constants::csvIntType || Statics::currentDbIntType == Constants::jsonIntType) {
    tableName = QFileInfo(tableName).baseName().toLower();
    tableName = tableName.remove(QRegularExpression("[^A-Za-z0-9]"));
    //    }

    // Clear existing chart headers data
    this->numericalList.clear();
    this->categoryList.clear();
    this->dateList.clear();
    this->newChartHeader.clear();


    auto data = con->Query("PRAGMA table_info('"+ tableName.toStdString() +"')");

    if(data->error.empty()){
        int rows = data->collection.Count();

        for(int i = 0; i < rows; i++){
            QString fieldName =  data->GetValue(1, i).ToString().c_str();
            fieldName = fieldName.trimmed();
            QString fieldType = data->GetValue(2, i).ToString().c_str();
            colTypeMap.insert(fieldName, fieldType);


            if(dataType.dataType(fieldType).contains(Constants::categoricalType)){
                this->categoryList.append(fieldName);
            } else if(dataType.dataType(fieldType).contains(Constants::numericalType)){
                this->numericalList.append(fieldName);
            } else if(dataType.dataType(fieldType).contains(Constants::dateType)){
                this->dateList.append(fieldName);
            } else{
                qDebug() << "OTHER UNDETECTED FIELD TYPE" <<   fieldName;
            }

            this->newChartHeader.insert(i, fieldName);
        }
    } else{
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    }

    // Update new data

    this->categoryList.sort(Qt::CaseInsensitive);
    this->numericalList.sort(Qt::CaseInsensitive);
    this->dateList.sort(Qt::CaseInsensitive);
    emit sendFilteredColumn(this->categoryList, this->numericalList, this->dateList);
}

void ReportsDataModel::generateColumnsFromAPI()
{
    // Fetch value from settings
    QSettings settings;
    // GCS Bugfixes -- Fix Keyword
    // charts url to be replaced with actual base url
    QString chartsUrl = settings.value("general/chartsUrl").toString();
    QByteArray sessionToken = settings.value("user/sessionToken").toByteArray();
    int profileId = settings.value("user/profileId").toInt();

    QNetworkRequest m_NetworkRequest;
    m_NetworkRequest.setUrl(chartsUrl+"/fetch_table_columns");

    m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                               "application/x-www-form-urlencoded");
    m_NetworkRequest.setRawHeader("Authorization", sessionToken);

    // GCS Bugfixes -- Fix Keyword
    // unique hash, dbPath
    QJsonObject obj;
    obj.insert("profileId", profileId);
    obj.insert("dbType", "extract");
    obj.insert("uniqueHash", "hash");
    obj.insert("dbPath", "C:/Users/chill/Desktop/orders1500.gadse");

    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&ReportsDataModel::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&ReportsDataModel::dataReadFinished);

    emit generateFiltersForAPI();

}
