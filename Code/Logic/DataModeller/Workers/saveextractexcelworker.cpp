#include "saveextractexcelworker.h"

SaveExtractExcelWorker::SaveExtractExcelWorker(QString query, QVariantMap changedColumnTypes)
{
    this->query = query;
    this->changedColumnTypes = changedColumnTypes;
}

void SaveExtractExcelWorker::run()
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

    QString finalSqlInterPart;
    QString errorMsg = "";

    QDateTime d = QDateTime::currentDateTime();
    QString connectionName = "excelQ" + d.toString();

    QSqlDatabase conExcel =  QSqlDatabase::addDatabase("QODBC", connectionName);
    conExcel.setConnectOptions("SQL_ATTR_ACCESS_MODE=SQL_MODE_READ_ONLY");

    conExcel.setDatabaseName(Statics::excelDb);

    if(conExcel.open()){

        QSqlQuery query(this->query, conExcel);
        if(query.lastError().text().length() <= 0){
            QSqlRecord record = query.record();

            this->internalColCount = record.count();

            QString createTableQuery = "CREATE TABLE " + fileName + "(";

            for(int i = 0; i < this->internalColCount; i++){
                QVariant fieldType = record.field(i).value();
                QString type = dataType.qVariantType(fieldType.typeName());
                QString fieldName = record.fieldName(i);
                QString tableName = record.field(i).tableName().left(record.field(i).tableName().lastIndexOf("$"));

                // lastIndexOf used here because the sheet name may itself contain `$` along with the $ used to name the excel sheet in sql query
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

                QString tableCreateQuery = "CREATE TABLE " + Constants::masterExtractTable + "(tableName VARCHAR, app_version VARCHAR, mode VARCHAR, extract_version VARCHAR,  unique_hash VARCHAR, last_update VARCHAR)";
                QString tableInserQuery = "INSERT INTO " + Constants::masterExtractTable + " VALUES ('" + fileName + "', '" + Constants::appVersion + "', '" + Constants::currentMode + "', '" + Constants::extractVersion + "', '" + uniqueHash + "',  '" + QString::number(currentTimestamp) + "')";


                auto x = con.Query(tableCreateQuery.toStdString());
                if(!x->success) qDebug() << x->error.c_str() << tableCreateQuery;
                auto z = con.Query(tableInserQuery.toStdString());
                if(!z->success) qDebug() << z->error.c_str() << tableInserQuery;

                // Start appending data in table
                duckdb::Appender appender(con, fileName.toStdString());

                appendExtractData(&appender, &query);
            } else {
                errorMsg = createT->error.c_str();
            }
        } else {
            errorMsg = query.lastError().text();
        }
    } else {
        errorMsg = Constants::connectionOpenError;
        conExcel.close();
        conExcel.removeDatabase(connectionName);

    }

    emit saveExtractComplete(errorMsg);
}

void SaveExtractExcelWorker::appendExtractData(duckdb::Appender *appender, QSqlQuery *query)
{
    int lineCounter = 0;
    QStringList list;

    while(query->next()){
        appender->BeginRow();
        for(int i = 0; i < this->internalColCount; i++){

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
            } else if(columnType == "VARCHAR"){
                appender->Append(query->value(i).toString().toUtf8().constData());
            } else {
                qDebug() << "UNDETECTED" << query->value(i).toString().toUtf8().constData();
            }

        }
        appender->EndRow();
        list.clear();

        lineCounter++;

        if(lineCounter % Constants::flushExtractCount == 0){
            appender->Flush();
        }
    }

    appender->Close();
}

