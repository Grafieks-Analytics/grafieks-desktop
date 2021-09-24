#include "saveextractqueryworker.h"

SaveExtractQueryWorker::SaveExtractQueryWorker(QString tmpSql, QVariantMap changedColumnTypes)
{
    this->tmpSql = tmpSql;
    this->changedColumnTypes = changedColumnTypes;
}

void SaveExtractQueryWorker::run()
{
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
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

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        connection = QSqlDatabase::addDatabase("QMYSQL", "mysqlQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);

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

        connection.open();
        break;
    }

    case Constants::sqliteIntType:{
        connection = QSqlDatabase::addDatabase("QSQLITE", "sqliteQ");
        connection.setDatabaseName(Statics::sqliteFile);
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

        connection.open();
        break;
    }

    case Constants::accessIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "accessQ");

        connection.setDatabaseName(Statics::acDb);
        connection.setUserName(Statics::acUsername);
        connection.setPassword(Statics::acPassword);

        connection.open();
        break;
    }

    }
    QSqlQuery query(this->tmpSql, connection);
    qDebug() << "QUERY" << this->tmpSql;
    QSqlRecord record = query.record();
    qDebug() << record;

    qDebug() << "QUERY PARAMS CHANGED TYOE" << generalParamsModel.getChangedColumnTypes();

    QString createTableQuery = "CREATE TABLE " + fileName + "(";

    for(int i = 0; i < record.count(); i++){
        QVariant fieldType = record.field(i).value();
        QString type = dataType.qVariantType(fieldType.typeName());
        QString fieldName = record.fieldName(i);
        QString tableName = record.field(i).tableName().toStdString().c_str();


        QString checkFieldName = tableName + "." + fieldName;
        qDebug() << "CHANGING" << checkFieldName << this->changedColumnTypes;
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
                type = "TIMESTAMP";
            }
        }

        createTableQuery += "\"" + fieldName + "\" " + type + ",";
        this->columnStringTypes.append(type);
    }

    createTableQuery.chop(1);
    createTableQuery += ")";
    qDebug() << createTableQuery;

    auto createT = con.Query(createTableQuery.toStdString());
    if(createT->success) {

        // Create a master table to refer the name of actual extract tableName
        // while running an extract later on

        QString tableCreateQuery = "CREATE TABLE " + Constants::masterExtractTable + "(tableName VARCHAR, app_version REAL, mode VARCHAR, extract_version INTEGER)";
        QString tableInserQuery = "INSERT INTO " + Constants::masterExtractTable + " VALUES ('" + fileName + "', '" + Constants::appVersion + "', '" + Constants::currentMode + "', '" + Constants::extractVersion + "')";

        auto x = con.Query(tableCreateQuery.toStdString());
        if(!x->success) qDebug() << x->error.c_str() << tableCreateQuery;
        auto z = con.Query(tableInserQuery.toStdString());
        if(!z->success) qDebug() << z->error.c_str() << tableInserQuery;

        // Start appending data in table
        duckdb::Appender appender(con, fileName.toStdString());

        int lineCounter = 0;

        while(query.next()){
            appender.BeginRow();
            for(int i = 0; i < record.count(); i++){
                QString columnType = this->columnStringTypes.at(i);

                if(columnType == "INTEGER"){
                    appender.Append(query.value(i).toInt());
                } else if(columnType == "BIGINT"){
                    appender.Append(query.value(i).toDouble());
                }  else if(columnType == "FLOAT") {
                    appender.Append(query.value(i).toFloat());
                } else if(columnType == "DOUBLE") {
                    appender.Append(query.value(i).toDouble());
                } else if(columnType == "DATE"){
                    QDate date = query.value(i).toDate();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender.Append(duckdb::Date::FromDate(year, month, day));
                } else if(columnType == "TIMESTAMP"){
                    QDate date = query.value(i).toDate();
                    QTime time = query.value(i).toDateTime().time();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender.Append(duckdb::Date::FromDate(year, month, day));
                    // The below code crashes in the release mode of duckdb
                    // Will need to check
                    //                appender.Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(0, 0, 0, 0)));
                    //                appender.Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));
                } else if(columnType == "VARCHAR") {
                    appender.Append(query.value(i).toString().toUtf8().constData());
                } else {
                    qDebug() << "UNDETECTED" << query.value(i).toString().toUtf8().constData();
                }


            }
            appender.EndRow();

            lineCounter++;

            if(lineCounter % Constants::flushExtractCount == 0){
                appender.Flush();
            }
        }
        appender.Close();


        //    auto query1 = con.Query("SELECT * FROM "+ fileName.toStdString());
        //    query1->Print();
    } else {
        errorMsg =  createT->error.c_str();
    }

    emit saveExtractComplete(errorMsg);
}


