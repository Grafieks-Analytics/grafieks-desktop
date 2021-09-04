#include "saveextractforwardonlyworker.h"

SaveExtractForwardOnlyWorker::SaveExtractForwardOnlyWorker(QString query)
{
    this->query = query;
}

void SaveExtractForwardOnlyWorker::run()
{

    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);
    QStringList list;

    QSqlDatabase dbForward;

    switch(Statics::currentDbIntType){

    case Constants::redshiftIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "redshiftQ");
        dbForward.setDatabaseName(Statics::redshiftDb);
        dbForward.setHostName(Statics::redshiftHost);
        dbForward.setPort(Statics::redshiftPort);
        dbForward.setUserName(Statics::redshiftUsername);
        dbForward.setPassword(Statics::redshiftPassword);
        dbForward.open();

        break;

    case Constants::snowflakeIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "snowflakeQ");
        dbForward.setDatabaseName(Statics::snowflakeDb);
        dbForward.setHostName(Statics::snowflakeHost);
        dbForward.setPort(Statics::snowflakePort);
        dbForward.setUserName(Statics::snowflakeUsername);
        dbForward.setPassword(Statics::snowflakePassword);
        dbForward.open();

        break;

    case Constants::teradataIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "teradataQ");
        dbForward.setDatabaseName(Statics::teradataDb);
        dbForward.setHostName(Statics::teradataHost);
        dbForward.setPort(Statics::teradataPort);
        dbForward.setUserName(Statics::teradataUsername);
        dbForward.setPassword(Statics::teradataPassword);
        dbForward.open();

        break;
    }

    QSqlQuery q(this->query, dbForward);
    QSqlRecord record = q.record();
    if(q.lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << q.lastError();
    } else{

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
        if(!createT->success) qDebug() <<Q_FUNC_INFO << "ERROR CREATE EXTRACT";

        duckdb::Appender appender(con, tableName.toStdString());


        int lineCounter = 0;
        while(q.next()){

            appender.BeginRow();
            for(int i = 0; i < this->internalColCount; i++){
                QString columnType = this->columnStringTypes.at(i);

                if(columnType == "INTEGER"){
                    appender.Append(q.value(i).toInt());
                } else if(columnType == "BIGINT"){
                    appender.Append(q.value(i).toDouble());
                }  else if(columnType == "FLOAT") {
                    appender.Append(q.value(i).toFloat());
                } else if(columnType == "DOUBLE") {
                    appender.Append(q.value(i).toDouble());
                } else if(columnType == "DATE"){
                    QDate date = q.value(i).toDate();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender.Append(duckdb::Date::FromDate(year, month, day));
                } else if(columnType == "TIMESTAMP"){
                    QDate date = q.value(i).toDate();
                    QTime time = q.value(i).toDateTime().time();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender.Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));
                }else {
                    appender.Append(q.value(i).toString().toUtf8().constData());
                }
            }

            appender.EndRow();

            lineCounter++;

            if(lineCounter % Constants::flushExtractCount == 0){
                appender.Flush();
            }
        }

        appender.Close();
    }

    emit saveExtractComplete();
}
