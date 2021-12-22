#include "tableschemamodel.h"

TableSchemaModel::TableSchemaModel(QObject *parent) : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_networkReply(nullptr),
    m_dataBuffer(new QByteArray)
{
    this->fetchSettings();
}


/*!
 * \brief Accepts an SQL query parameter and emits a signal with list of information of individual column
 * \details Each signal object contains a list of  <b>tableName, fieldName,  fieldType, filterDataType</b>
 * \code
 * emit tableSchemaObtained(QList <QStringList> allList, QList <QStringList> allCategorical, QList <QStringList> allNumerical, QList <QStringList> allDates, QList <QStringList> allOthers,QStringList queriedColumnNames);
 * \endcode
 *
 */
void TableSchemaModel::showSchema(QString query)
{

    QString explainQueryString, describeQueryString;
    QStringList tableList;
    QVariantList outputDataList;

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

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);

        QSqlDatabase dbCon = QSqlDatabase::database(dbString);

        for(QString tableName: tablesList){

            tableName = tableName.replace(QRegularExpression("[\"`'\\[\\]]"), "");


            QSqlRecord record = dbCon.record(tableName);

            if(!record.isEmpty()){

                for(int i=0; i < record.count(); i++){

                    QString fieldName = record.fieldName(i);
                    QString fieldType = record.field(i).value().typeName();

                    // Get filter data type for QML
                    QString filterDataType = dataType.dataType(fieldType);
                    outputDataList << tableName << fieldName << fieldType << filterDataType;

                    // Output data according to Filter type

                    if(filterDataType == Constants::categoricalType){
                        allCategorical.append(outputDataList);
                    } else if(filterDataType == Constants::numericalType){
                        allNumerical.append(outputDataList);
                    } else if(filterDataType == Constants::dateType){
                        allDates.append(outputDataList);
                    } else{
                        allOthers.append(outputDataList);
                    }

                    // Append all data type to allList as well
                    allList.append(outputDataList);

                    outputDataList.clear();
                }
            }
        }
        break;
    }



    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);

        for(QString tableName: tablesList){
            describeQueryString = "select \"column\", type from pg_table_def where tablename = '" + tableName.replace(QRegularExpression("\""), "")  + "'";

            QSqlQuery describeQuery(describeQueryString, dbRedshift);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

                outputDataList << tableName << fieldName << fieldType << filterDataType;

                // Output data according to Filter type

                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            tableName = tableName.replace(QRegularExpression("[\"`']"), "");
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbImpala);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

                outputDataList << tableName << fieldName << fieldType << filterDataType;

                // Output data according to Filter type

                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);


        for(QString tableName: tablesList){
            tableName = tableName.replace(QRegularExpression("[\"`']"), "");
            describeQueryString = "SELECT column_name, data_type FROM user_tab_columns WHERE table_name = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbHive);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

                outputDataList << tableName << fieldName << fieldType << filterDataType;

                // Output data according to Filter type

                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::snowflakeIntType:{

        QSqlDatabase dbSnowflake = QSqlDatabase::database(Constants::snowflakeOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);


        for(QString tableName: tablesList){
            tableName = tableName.replace(QRegularExpression("[\"`']"), "");
            describeQueryString = "DESC TABLE " + tableName;

            QSqlQuery describeQuery(describeQueryString, dbSnowflake);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString();
                QString fieldType = describeQuery.value(1).toString();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

                outputDataList << tableName << fieldName << fieldType << filterDataType;

                // Output data according to Filter type

                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::teradataIntType:{

        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrQueryType);

        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);



        for(QString tableName: tablesList){
            tableName.remove("\"" + Statics::currentDbName + "\".");
            tableName.remove(Statics::currentDbName + ".");
            tableName.remove("\"");
            describeQueryString = "SELECT ColumnName, ColumnType FROM DBC.Columns WHERE DatabaseName = '" + Statics::currentDbName + "' AND TableName = '" + tableName + "'";

            QSqlQuery describeQuery(describeQueryString, dbTeradata);
            QSqlRecord rec = describeQuery.record();

            while(describeQuery.next()){


                QString fieldName = describeQuery.value(0).toString().trimmed();
                QString fieldType = describeQuery.value(1).toString().trimmed();

                // Remove characters after `(` and then trim whitespaces
                QString fieldTypeTrimmed = fieldType.mid(0, fieldType.indexOf("(")).trimmed();

                // Get filter data type for QML
                QString filterDataType = dataType.dataType(fieldTypeTrimmed);

                outputDataList << tableName << fieldName << fieldType << filterDataType;

                // Output data according to Filter type

                if(filterDataType == Constants::categoricalType){
                    allCategorical.append(outputDataList);
                } else if(filterDataType == Constants::numericalType){
                    allNumerical.append(outputDataList);
                } else if(filterDataType == Constants::dateType){
                    allDates.append(outputDataList);
                } else{
                    allOthers.append(outputDataList);
                }

                // Append all data type to allList as well
                allList.append(outputDataList);

                // Clear Stringlist for future
                outputDataList.clear();
            }
        }

        break;
    }

    case Constants::excelIntType:{
        querySplitter.setQueryForClasses(query);
        QStringList tablesList = querySplitter.getJoinTables();
        QString mainTable = querySplitter.getMainTable();
        tablesList.push_back(mainTable);

        QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelOdbcStrType);

        for(QString tableName: tablesList){

            QString dbQueryString = "SELECT TOP 1 * FROM "+tableName;

            QSqlQuery query(dbQueryString, dbExcel);
            QSqlRecord record = query.record();

            if(!record.isEmpty()){

                for(int i=0; i < record.count(); i++){

                    QString fieldName = record.fieldName(i).trimmed();
                    QString fieldType = record.field(i).value().typeName();

                    // Get filter data type for QML
                    QString filterDataType = dataType.dataType(fieldType);

                    outputDataList << tableName << fieldName << fieldType << filterDataType;

                    // Output data according to Filter type

                    if(filterDataType == Constants::categoricalType){
                        allCategorical.append(outputDataList);
                    } else if(filterDataType == Constants::numericalType){
                        allNumerical.append(outputDataList);
                    } else if(filterDataType == Constants::dateType){
                        allDates.append(outputDataList);
                    } else{
                        allOthers.append(outputDataList);
                    }

                    // Append all data type to allList as well
                    allList.append(outputDataList);

                    // Clear Stringlist for future
                    outputDataList.clear();
                }
            }
        }
        break;
    }
    case Constants::csvIntType:
    case Constants::jsonIntType:{

        QFile file(Statics::csvJsonPath);

        if(!file.open(QFile::ReadOnly | QFile::Text)) {
            qDebug() << "Cannot open file" << file.errorString();
        } else {
            int lineCounter = 0;
            while(lineCounter < 2){
                const QByteArray line = file.readLine().simplified();

                if(lineCounter == 0){
                    setHeaders(line, Statics::separator);
                } else {
                    QMap<QString, QList<QVariantList>> allColumns = detectHeaderTypes(line, Statics::separator, Statics::currentDbName);
                }
                lineCounter++;
            }
        }

        file.close();

        break;

    }

    }

    // Emit the signals here
    // For the slots to received the data
    // in QML (UI)

    emit tableSchemaObtained(allList, allCategorical, allNumerical, allDates, allOthers, queriedColumnNames);

    // Clear all stringlist for new values

    queriedColumnNames.clear();
    allCategorical.clear();
    allNumerical.clear();
    allDates.clear();
    allOthers.clear();
    allList.clear();

}

void TableSchemaModel::generateSchemaForExtract()
{
    QString extractPath = Statics::extractPath;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    if(Constants::apiSwitch == true){
        qDebug() << "Extract schema should be called for API 2";
    } else {
        this->extractSchema(&con);
    }
}

void TableSchemaModel::generateSchemaForReader(duckdb::Connection *con)
{
    if(Constants::apiSwitch == true){
        qDebug() << "Extract schema should be called for API";
    } else {
        this->extractSchema(con);
    }
}

void TableSchemaModel::generateSchemaForApi()
{

    this->m_NetworkRequest.setUrl(this->baseUrl +"/fetch_table_columns");

    this->m_NetworkRequest.setHeader(QNetworkRequest::ContentTypeHeader,
                                     "application/x-www-form-urlencoded");
    this->m_NetworkRequest.setRawHeader("Authorization", this->sessionToken);

    QJsonObject obj;
    obj.insert("profileId", this->profileId);
    obj.insert("uniqueHash", "hash");
    obj.insert("dbType", "extract");
    obj.insert("dbPath", "c:/Users/chill/Desktop/orders1500.gadse");
    obj.insert("reportWhereConditions", this->reportWhereConditions);
    obj.insert("dashboardWhereConditions", this->dashboardWhereConditions);
    obj.insert("joinConditions", this->joinConditions);


    QJsonDocument doc(obj);
    QString strJson(doc.toJson(QJsonDocument::Compact));

    m_networkReply = m_networkAccessManager->post(this->m_NetworkRequest, strJson.toUtf8());

    connect(m_networkReply,&QIODevice::readyRead,this,&TableSchemaModel::dataReadyRead);
    connect(m_networkReply,&QNetworkReply::finished,this,&TableSchemaModel::dataReadFinished);
}

void TableSchemaModel::dataReadyRead()
{
    m_dataBuffer->clear();
    m_dataBuffer->append(m_networkReply->readAll());
}

void TableSchemaModel::dataReadFinished()
{
    //Parse the JSON
    qDebug() << "x1xqx";
    if( m_networkReply->error()){

        qDebug() << "There was some error : " << m_networkReply->errorString();
    }else{

        QJsonDocument resultJson = QJsonDocument::fromJson(*m_dataBuffer);
        QJsonObject resultObj = resultJson.object();

        QJsonDocument dataDoc =  QJsonDocument::fromJson(resultObj["data"].toString().toUtf8());
        QString msg = resultObj["msg"].toString();
        int code = resultObj["code"].toInt();

        QJsonObject dataDocObj = dataDoc.object();

        if(code != 200){
            qDebug() << "Error code" << code << ": " << msg;
        } else {
            qDebug() << "OSM" << dataDocObj["categorical"].toArray();

            QJsonArray value = dataDocObj.value("all").toArray();

            foreach(QJsonValue data, value){
                QJsonArray finalValue = data.toArray();

                qDebug() << value.at(1).toString() << "VALUE";

                if(finalValue.at(3).toString() == "categorical"){
                    this->allCategorical.append(value.toVariantList());
                } else if(finalValue.at(3).toString() == "numerical"){
                    this->allNumerical.append(value.toVariantList());
                } else if(finalValue.at(3).toString() == "dateformat"){
                    this->allDates.append(value.toVariantList());
                }

//                this->newChartHeader.insert(i, finalValue.at(1).toString());
//                i++;
            }
            // apiSchemaObtained(QList<QStringList> allList, QList<QStringList> allCategorical, QList<QStringList> allNumerical, QList<QStringList> allDates, QList<QStringList> allOthers);
        }
    }
}

void TableSchemaModel::clearSchema()
{
    // Clear all stringlist for new values
    queriedColumnNames.clear();
    allCategorical.clear();
    allNumerical.clear();
    allDates.clear();
    allOthers.clear();
    allList.clear();


    emit tableSchemaCleared();

}

void TableSchemaModel::setHeaders(const QByteArray line, QString delimiter)
{

    this->csvHeaderDataFinal = line.split(*delimiter.toStdString().c_str());
    this->csvHeaderLength = this->csvHeaderDataFinal.length();

    if (this->csvHeaderDataFinal.at(0).contains("\xEF\xBB\xBF")){
        this->csvHeaderDataFinal[0] =  this->csvHeaderDataFinal.at(0).right(this->csvHeaderDataFinal.at(0).length() - 3);
    }
}

QMap<QString, QList<QVariantList>> TableSchemaModel::detectHeaderTypes(const QByteArray line, QString delimiter, QString tableName)
{
    QList<QByteArray> lineData = line.split(*delimiter.toStdString().c_str());

    QStringList output;
    QString fieldName;
    QString fieldType;
    QVariantList outputDataList;
    QMap<QString, QList<QVariantList>> allColumns;

    QString fileName = QFileInfo(tableName).baseName().toLower();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));

    for(int i = 0; i < this->csvHeaderLength; i++){

        fieldName = this->csvHeaderDataFinal.at(i);
        fieldType = dataType.variableType(QString(lineData.at(i))).at(0);

        // Output data according to Filter type
        outputDataList << fileName << fieldName << fieldType << fieldType;

        if(fieldType == Constants::categoricalType){
            allCategorical.append(outputDataList);
        } else if(fieldType == Constants::numericalType){
            allNumerical.append(outputDataList);
        } else if(fieldType == Constants::dateType){
            allDates.append(outputDataList);
        } else{
            allOthers.append(outputDataList);
        }

        // Append all data type to allList as well
        allList.append(outputDataList);

        // Clear Stringlist for future
        outputDataList.clear();

    }

    allColumns.insert("categorical", allCategorical);
    allColumns.insert("numerical", allNumerical);
    allColumns.insert("dates", allDates);
    allColumns.insert("others", allOthers);
    allColumns.insert("allList", allList);

    return allColumns;
}

void TableSchemaModel::extractSchema(duckdb::Connection *con)
{
    QVariantList outputDataList;
    QString tableName = Statics::currentDbName;

    //    if(Statics::currentDbIntType == Constants::excelIntType || Statics::currentDbIntType == Constants::csvIntType || Statics::currentDbIntType == Constants::jsonIntType || Statics::currentDbIntType == Constants::accessIntType) {
    tableName = QFileInfo(tableName).baseName().toLower();
    tableName = tableName.remove(QRegularExpression("[^A-Za-z0-9]"));
    //    }

    auto data = con->Query("PRAGMA table_info('"+ tableName.toStdString() +"')");

    if(data->error.empty()){
        int totalRows = data->collection.Count();


        for(int i = 0; i < totalRows; i++){
            QString fieldName =  data->GetValue(1, i).ToString().c_str();
            fieldName = fieldName.trimmed();
            QString fieldType = data->GetValue(2, i).ToString().c_str();


            // Get filter data type for QML
            QString filterDataType = dataType.dataType(fieldType);

            outputDataList << tableName << fieldName << fieldType << filterDataType;

            // Output data according to Filter type

            if(filterDataType == Constants::categoricalType){
                extractAllCategorical.append(outputDataList);
            } else if(filterDataType == Constants::numericalType){
                extractAllNumerical.append(outputDataList);
            } else if(filterDataType == Constants::dateType){
                extractAllDates.append(outputDataList);
            } else{
                extractAllOthers.append(outputDataList);
            }

            // Append all data type to allList as well
            extractAllList.append(outputDataList);

            // Clear Stringlist for future
            outputDataList.clear();
        }
    } else {
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    }

    emit extractSchemaObtained(extractAllList, extractAllCategorical, extractAllNumerical, extractAllDates, extractAllOthers);

    // Clear all stringlist for new values

    extractAllCategorical.clear();
    extractAllNumerical.clear();
    extractAllDates.clear();
    extractAllOthers.clear();
    extractAllList.clear();
}


void TableSchemaModel::fetchSettings()
{
    // Fetch value from settings
    QSettings settings;
    this->baseUrl = settings.value("general/chartsUrl").toString();
    this->sessionToken = settings.value("user/sessionToken").toByteArray();
    this->profileId = settings.value("user/profileId").toInt();
}
