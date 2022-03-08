#include "saveextractforwardonlyworker.h"

SaveExtractForwardOnlyWorker::SaveExtractForwardOnlyWorker(QString query, QVariantMap changedColumnTypes)
{
    this->query = query;
    this->changedColumnTypes = changedColumnTypes;
}

void SaveExtractForwardOnlyWorker::run()
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

    QStringList list;
    QString errorMsg = "";

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
    this->colCount = record.count();

    if(q.lastError().type() != QSqlError::NoError){
        qWarning() << Q_FUNC_INFO << q.lastError();
        errorMsg = q.lastError().text();
    } else{

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

            QString tableCreateQuery = "CREATE TABLE " + Constants::masterExtractTable + "(tableName VARCHAR, app_version VARCHAR, mode VARCHAR, extract_version INTEGER, unique_hash VARCHAR,  last_update VARCHAR)";
            QString tableInserQuery = "INSERT INTO " + Constants::masterExtractTable + " VALUES ('" + fileName + "', '" + Constants::appVersion + "', '" + Constants::currentMode + "', '" + Constants::extractVersion + "', '" + uniqueHash + "',  '" + QString::number(currentTimestamp) + "')";

            auto x = con.Query(tableCreateQuery.toStdString());
            if(!x->success) qDebug() << x->error.c_str() << tableCreateQuery;
            auto z = con.Query(tableInserQuery.toStdString());
            if(!z->success) qDebug() << z->error.c_str() << tableInserQuery;

            // Start appending data in table
            duckdb::Appender appender(con, fileName.toStdString());

            appendExtractData(&appender, &q);

        } else {
            errorMsg =  createT->error.c_str();
        }

    }

    emit saveExtractComplete(errorMsg);
}

void SaveExtractForwardOnlyWorker::appendExtractData(duckdb::Appender *appender, QSqlQuery *q)
{

    int lineCounter = 0;
    while(q->next()){

        appender->BeginRow();
        for(int i = 0; i < this->colCount; i++){
            QString columnType = this->columnStringTypes.at(i);

            if(columnType == "INTEGER"){
                appender->Append(q->value(i).toInt());
            } else if(columnType == "BIGINT"){
                appender->Append(q->value(i).toDouble());
            }  else if(columnType == "FLOAT") {
                appender->Append(q->value(i).toFloat());
            } else if(columnType == "DOUBLE") {
                appender->Append(q->value(i).toDouble());
            } else if(columnType == "DATE"){
                if(q->value(i).toDate().isValid()){
                    QDate date = q->value(i).toDate();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender->Append(duckdb::Date::FromDate(year, month, day));
                } else {
                    appender->Append(duckdb::Date::FromDate(1970, 1, 1));
                }
            } else if(columnType == "TIMESTAMP"){
                if(q->value(i).toDateTime().isValid()){
                    QDate date = q->value(i).toDate();
                    QTime time = q->value(i).toDateTime().time();
                    int32_t year = date.year();
                    int32_t month = date.month();
                    int32_t day = date.day();
                    appender->Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(year, month, day), duckdb::Time::FromTime(time.hour(), time.minute(), time.second(), 0)));
                } else {
                    appender->Append(duckdb::Timestamp::FromDatetime(duckdb::Date::FromDate(1970, 1, 1), duckdb::Time::FromTime(0, 0, 0, 5476)));
                }
            } else if(columnType == "VARCHAR") {
                appender->Append(q->value(i).toString().toUtf8().constData());
            } else {
                qDebug() << "UNDETECTED" << q->value(i).toString().toUtf8().constData();
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
