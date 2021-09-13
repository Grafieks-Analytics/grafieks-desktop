#include "saveextractexcelworker.h"

SaveExtractExcelWorker::SaveExtractExcelWorker(QString query)
{
    this->query = query;
}

void SaveExtractExcelWorker::run()
{
    QString extractPath = Statics::extractPath;
    QString tableName = Statics::currentDbName;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);

    QString fileName = QFileInfo(tableName).baseName().toLower();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));

    QStringList list;
    QString finalSqlInterPart;

    QSqlDatabase conExcel =  QSqlDatabase::addDatabase("QODBC", "excelQ");

    conExcel.setDatabaseName(Statics::excelDb);
    conExcel.open();

    QSqlQuery query(this->query, conExcel);
    QSqlRecord record = query.record();

    this->internalColCount = record.count();

    QString createTableQuery = "CREATE TABLE " + fileName + "(";

    for(int i = 0; i < this->internalColCount; i++){
        QVariant fieldType = record.field(i).value();
        QString type = dataType.qVariantType(fieldType.typeName());

        // lastIndexOf used here because the sheet name may itself contain `$` along with the $ used to name the excel sheet in sql query
        QString checkFieldName = record.field(i).tableName().left(record.field(i).tableName().lastIndexOf("$")) + "." + record.fieldName(i);
        if(Statics::changedHeaderTypes.value(checkFieldName).toString() != ""){
            type = Statics::changedHeaderTypes.value(checkFieldName).toString();

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

        createTableQuery += "\"" + record.fieldName(i) + "\" " + type + ",";
        this->columnStringTypes.append(type);
    }

    createTableQuery.chop(1);
    createTableQuery += ")";

    auto createT = con.Query(createTableQuery.toStdString());
    if(!createT->success) qDebug() <<Q_FUNC_INFO << "ERROR CREATE EXTRACT";

    // Create a master table to refer the name of actual extract tableName
    // while running an extract later on

    QString tableCreateQuery = "CREATE TABLE " + Constants::masterExtractTable + "(tableName VARCHAR)";
    QString tableInserQuery = "INSERT INTO " + Constants::masterExtractTable + " VALUES ('" + fileName + "')";
    QString tableSelectQuery = "SELECT * FROM " + Constants::masterExtractTable;

    auto x = con.Query(tableCreateQuery.toStdString());
    if(!x->success) qDebug() << x->error.c_str() << tableCreateQuery;
    auto z = con.Query(tableInserQuery.toStdString());
    if(!z->success) qDebug() << z->error.c_str() << tableInserQuery;

    auto y = con.Query(tableSelectQuery.toStdString());
    y->Print();
    qDebug() << y->GetValue(0,0).ToString().c_str();

    // Start appending data in table
    duckdb::Appender appender(con, fileName.toStdString());

    int lineCounter = 0;
    while(query.next()){
        appender.BeginRow();
        for(int i = 0; i < this->internalColCount; i++){

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
            } else if(columnType == "VARCHAR"){
                appender.Append(query.value(i).toString().toUtf8().constData());
            } else {
                qDebug() << "UNDETECTED" << query.value(i).toString().toUtf8().constData();
            }

        }
        appender.EndRow();
        list.clear();

        lineCounter++;

        if(lineCounter % Constants::flushExtractCount == 0){
            appender.Flush();
        }
    }

    appender.Close();

    emit saveExtractComplete();
}

