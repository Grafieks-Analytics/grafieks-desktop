#include "saveextractqueryworker.h"

SaveExtractQueryWorker::SaveExtractQueryWorker(QString tmpSql, QVariantMap changedColumnTypes)
{
    this->tmpSql = tmpSql;
    this->changedColumnTypes = changedColumnTypes;
    this->ifSavePassword = true;

    querySplitter.setQuery(this->tmpSql);
}

void SaveExtractQueryWorker::run()
{
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;

    // Remove extract file if already exists
    QFile fileRemove(extractPath);
    if(fileRemove.exists()) {
        QString tmpFile = extractPath;
        tmpFile.append(".wal");

        QFile fileTmpRemove(tmpFile);

        fileTmpRemove.remove();
        fileRemove.remove();
    }

    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    QString fileName = QFileInfo(tableName).baseName().toLower();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));

    QStringList colInfo;
    QVariant fieldType;
    DataType dataType;

    QStringList tableHeaders;
    QMap<int, QStringList> sqlChartHeader;
    QHash<int, QByteArray> roleNames;
    QString errorMsg =  "";
    QSqlDatabase connection;
    QString realDbName;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        connection = QSqlDatabase::addDatabase("QMYSQL", "mysqlQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);
        realDbName = Statics::myRealDbName;

        connection.open();
        break;
    }

    case Constants::mysqlOdbcIntType:{
        connection = QSqlDatabase::addDatabase("ODBC", "mysqlOQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);
        realDbName = Statics::myRealDbName;

        connection.open();
        break;
    }

    case Constants::sqliteIntType:{
        connection = QSqlDatabase::addDatabase("QSQLITE", "sqliteQ");
        connection.setDatabaseName(Statics::sqliteFile);
        realDbName = "";
        connection.open();
        break;
    }
    case Constants::postgresIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "postgresQ");

        connection.setDatabaseName(Statics::postgresDb);
        connection.setHostName(Statics::postgresHost);
        connection.setPort(Statics::postgresPort);
        connection.setUserName(Statics::postgresUsername);
        connection.setPassword(Statics::postgresPassword);
        realDbName = Statics::postgresRealDbName;

        connection.open();
        break;
    }

    case Constants::mssqlIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "mssqlQ");

        connection.setDatabaseName(Statics::msDb);
        connection.setHostName(Statics::msHost);
        connection.setPort(Statics::msPort);
        connection.setUserName(Statics::msUsername);
        connection.setPassword(Statics::msPassword);
        realDbName = Statics::msRealDbName;

        connection.open();
        break;
    }

    case Constants::oracleIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "oracleQ");

        connection.setDatabaseName(Statics::oracleDb);
        connection.setHostName(Statics::oracleHost);
        connection.setPort(Statics::oraclePort);
        connection.setUserName(Statics::oracleUsername);
        connection.setPassword(Statics::oraclePassword);
        realDbName = Statics::oracleRealDbName;

        connection.open();
        break;
    }

    case Constants::mongoIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "mongoQ");

        connection.setDatabaseName(Statics::mongoDb);
        connection.setHostName(Statics::mongoHost);
        connection.setPort(Statics::mongoPort);
        connection.setUserName(Statics::mongoUsername);
        connection.setPassword(Statics::mongoPassword);
        realDbName = Statics::mongoRealDbName;

        connection.open();
        break;
    }

    case Constants::accessIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "accessQ");

        connection.setDatabaseName(Statics::acDb);
        connection.setUserName(Statics::acUsername);
        connection.setPassword(Statics::acPassword);
        realDbName = Statics::acRealDbName;

        connection.open();
        break;
    }

    }
    QSqlQuery query(this->tmpSql, connection);
    QSqlRecord record = query.record();
    this->colCount = record.count();


    QString createTableQuery = "CREATE TABLE " + fileName + "(";

    for(int i = 0; i < this->colCount; i++){
        QVariant fieldType = record.field(i).value();
        QString type = dataType.qVariantType(fieldType.typeName());
        QString fieldName = record.fieldName(i);
        QString tableName = record.field(i).tableName().toStdString().c_str();


        QString checkFieldName = tableName + "." + fieldName;
        if(this->changedColumnTypes.value(checkFieldName).toString() != ""){
            type = this->changedColumnTypes.value(checkFieldName).toString();

            if(type == Constants::categoricalType){
                type = "VARCHAR";
            } else if(type == Constants::numericalType){
                QString dataLen = record.field(i).value().toString();

                if(dataLen.toLower().contains("e-") || dataLen.toLower().contains("e+") || dataLen.toLower().contains(".")){
                    type = "DOUBLE";
                } else {
                    if(dataLen.length() <= 10 && dataLen.toInt() < 2147483647){
                        type = "INTEGER";
                    } else if(dataLen.length() <= 19 && dataLen.toLong() < 9223372036854775808) {
                        type = "BIGINT";
                    } else {
                        type = "HUGEINT";
                    }
                }
            } else {
                type = "DATE";
            }
        }

        createTableQuery += "\"" + fieldName + "\" " + type + " NULL,";
        this->columnStringTypes.append(type);
    }

    createTableQuery.chop(1);
    createTableQuery += ")";
    qDebug() << createTableQuery;

    auto createT = con.Query(createTableQuery.toStdString());
    if(createT->success) {

        // Create a master table to refer the name of actual extract tableName
        // while running an extract later on

        // Current timestamp
        quint64 currentTimestamp = QDateTime::currentMSecsSinceEpoch();

        // This is to identify the extract irrespective of its filename
        // This will not change when updated
        GeneralParamsModel generalParamsModel;
        QString uniqueHash = generalParamsModel.randomStringGenerator();

        QString tableCreateQuery = "CREATE TABLE " + Constants::masterExtractTable + "(tableName VARCHAR, app_version VARCHAR, mode VARCHAR, extract_version VARCHAR, unique_hash VARCHAR,  last_update VARCHAR)";
        QString tableInserQuery = "INSERT INTO " + Constants::masterExtractTable + " VALUES ('" + fileName + "', '" + Constants::appVersion + "', '" + Constants::currentMode + "', '" + Constants::extractVersion + "', '" + uniqueHash + "',  '" + QString::number(currentTimestamp) + "')";

        QString password = this->ifSavePassword ? connection.password() : "";
        int portTmp = connection.port();
        QString port = connection.port() == NULL ? "NULL" : QString::number(portTmp);
        QString credentialsCreateQuery = "CREATE TABLE " + Constants::masterCredentialsTable + "(username VARCHAR, password VARCHAR, host VARCHAR, port VARCHAR, database VARCHAR, db_type VARCHAR, real_db_name VARCHAR)";
        QString credentialsInsertQuery = "INSERT INTO " + Constants::masterCredentialsTable + " VALUES ('" + connection.userName() + "', '" + password + "', '" + connection.hostName() + "', '"+ port +"', '" + connection.databaseName() + "', '" + QString::number(Statics::currentDbIntType) + "', '" + realDbName + "')";

        QStringList selectParams = this->querySplitter.getSelectParams();
        QString selectParamsString;
        foreach(QString selectParam, selectParams){
            selectParamsString += selectParam + ", ";
        }
        selectParamsString.chop(2);

        QString whereConditions = this->querySplitter.getWhereCondition();
        QString joinConditions = this->querySplitter.getJoinConditions();
        QString masterTable = this->querySplitter.getMainTable();

        QString queryPartCreateQuery = "CREATE TABLE " + Constants::masterQueryPartExtractTable + "(select_params VARCHAR, where_params VARCHAR, join_params VARCHAR, master_table VARCHAR)";
        QString queryPartInsertQuery = "INSERT INTO " + Constants::masterQueryPartExtractTable + " VALUES ('" + selectParamsString + "', '" + whereConditions + "', '" + joinConditions + "', '" + masterTable + "')";


        auto x = con.Query(tableCreateQuery.toStdString());
        if(!x->success) qDebug() << x->error.c_str() << tableCreateQuery;
        auto z = con.Query(tableInserQuery.toStdString());
        if(!z->success) qDebug() << z->error.c_str() << tableInserQuery;

        auto credentialsCreate = con.Query(credentialsCreateQuery.toStdString());
        if(!credentialsCreate->success) qDebug() << credentialsCreate->error.c_str() << credentialsCreateQuery;
        auto credentialsInsert = con.Query(credentialsInsertQuery.toStdString());
        if(!credentialsInsert->success) qDebug() << credentialsInsert->error.c_str() << credentialsInsertQuery;

        auto queryPartCreate = con.Query(queryPartCreateQuery.toStdString());
        if(!queryPartCreate->success) qDebug() << queryPartCreate->error.c_str() << queryPartCreateQuery;
        auto queryPartInsert = con.Query(queryPartInsertQuery.toStdString());
        if(!queryPartInsert->success) qDebug() << queryPartInsert->error.c_str() << queryPartInsertQuery;

        qDebug() << "SPLITTER" << whereConditions << joinConditions << masterTable;

        // Start appending data in table
        duckdb::Appender appender(con, fileName.toStdString());

        appendExtractData(&appender, &query);
    } else {
        errorMsg =  createT->error.c_str();
    }

    emit saveExtractComplete(errorMsg);
}

void SaveExtractQueryWorker::appendExtractData(duckdb::Appender *appender, QSqlQuery *query)
{
    int lineCounter = 0;

    while(query->next()){
        appender->BeginRow();
        for(int i = 0; i < this->colCount; i++){
            QString columnType = this->columnStringTypes.at(i);

            if(columnType == "INTEGER"){
                appender->Append(query->value(i).toInt());
            } else if(columnType == "BIGINT"){
                appender->Append(query->value(i).toDouble());
            }  else if(columnType == "FLOAT") {
                appender->Append(query->value(i).toFloat());
            } else if(columnType == "DOUBLE") {
                appender->Append(query->value(i).toDouble());
            } else if(columnType == "DATE"){
                if(query->value(i).toDate().isValid()){
                    QDate date = query->value(i).toDate();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender->Append(duckdb::Date::FromDate(year, month, day));
                } else {
                    appender->Append(duckdb::Date::FromDate(1970, 1, 1));
                }
            } else if(columnType == "TIMESTAMP"){
                if(query->value(i).toDateTime().isValid()){
                    QDate date = query->value(i).toDate();
                    QTime time = query->value(i).toDateTime().time();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender->Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));
                } else {
                    appender->Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(1970, 1, 1), duckdb::Time::FromTime(0, 0, 0, 5476)));
                }
            } else if(columnType == "VARCHAR") {
                appender->Append(query->value(i).toString().toUtf8().constData());
            } else {
                qDebug() << "UNDETECTED" << query->value(i).toString().toUtf8().constData();
            }


        }
        appender->EndRow();

        lineCounter++;

        if(lineCounter % Constants::flushExtractCount == 0){
            appender->Flush();
        }
    }
    appender->Close();
}


