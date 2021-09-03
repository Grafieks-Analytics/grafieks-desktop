#include "saveextractqueryworker.h"

SaveExtractQueryWorker::SaveExtractQueryWorker(QString tmpSql)
{
    this->tmpSql = tmpSql;
}

void SaveExtractQueryWorker::run()
{
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    QStringList colInfo;
    QVariant fieldType;
    DataType dataType;

    QStringList tableHeaders;
    QMap<int, QStringList> sqlChartHeader;
    QHash<int, QByteArray> roleNames;
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
    QSqlRecord record = query.record();

    QString createTableQuery = "CREATE TABLE " + tableName + "(";

    for(int i = 0; i < record.count(); i++){
        QVariant fieldType = record.field(i).value();
        QString type = dataType.qVariantType(fieldType.typeName());

        QString checkFieldName = record.field(i).tableName() + "." + record.fieldName(i);
        if(Statics::changedHeaderTypes.value(checkFieldName).toString() != ""){
            type = Statics::changedHeaderTypes.value(checkFieldName).toString();

            if(type == Constants::categoricalType){
                type = "VARCHAR";
            } else if(type == Constants::numericalType){
                type = "INTEGER";
            } else {
                type = "TIMESTAMP";
            }
        }

        createTableQuery += "\"" + record.fieldName(i) + "\" " + type + ",";
        this->columnStringTypes.append(type);
    }

    createTableQuery.chop(1);
    createTableQuery += ")";
    qDebug() << createTableQuery;

    auto createT = con.Query(createTableQuery.toStdString());
    if(!createT->success) qDebug() <<Q_FUNC_INFO << "ERROR CREATE EXTRACT" << createT->error.c_str();

    duckdb::Appender appender(con, tableName.toStdString());

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
                appender.Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));
            }else {
                appender.Append(query.value(i).toString().toUtf8().constData());
            }


        }
        appender.EndRow();

        lineCounter++;

        if(lineCounter % Constants::flushExtractCount == 0){
            appender.Flush();
        }
    }
    appender.Close();

//    auto query1 = con.Query("SELECT * FROM "+ tableName.toStdString());
//    query1->Print();

    emit saveExtractComplete(&con);
}


