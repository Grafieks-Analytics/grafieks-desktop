#include "extractsmanager.h"

ExtractsManager::ExtractsManager(QObject *parent) : QObject(parent)
{
}

void ExtractsManager::createTable(QList<QByteArray> columnNames, QStringList columnTypes, QString tableName)
{
    QString dbPath = Statics::extractPath;
    duckdb::DuckDB db(dbPath.toStdString());
    duckdb::Connection con(db);

    this->columnNames = columnNames;
    this->columnTypes = columnTypes;
    this->tableName = tableName;

    QString query;

    query = "CREATE TABLE " + tableName + "(";
    for(int i = 0; i < columnNames.length(); i++){
        QString colName = columnNames.at(i).toBase64().constData();
        query.append( colName+ " " + columnTypes.at(i) + ",");
    }

    query.chop(1);
    query.append(")");

    con.Query(query.toStdString());
    db.~DuckDB();
}

void ExtractsManager::uploadCSVData(QFile *csvFile, char delimiter)
{
//    QString dbPath = Statics::extractPath;
//    duckdb::DuckDB db(dbPath.toStdString());
//    duckdb::Connection con(db);
//    duckdb::Appender appender(con, this->tableName.toStdString());

//    int columnsLength = this->columnNames.length();

//    while(!csvFile->atEnd()){
//        QByteArray line = csvFile->readLine().simplified();
//        QList<QByteArray>strings = line.split(delimiter);

//        appender.BeginRow();
//        for(int i = 0; i < columnsLength; i++){

//            if(this->columnTypes.at(i) == Constants::categoricalType){
//                appender.Append(strings.at(i).toBase64().constData());
//            } else {
//                appender.Append(strings.at(i));
//            }

//        }
//        appender.EndRow();
//    }
//    appender.Close();

//    db.~DuckDB();
}

void ExtractsManager::uploadQueryData(QSqlQuery *query)
{
//    QString dbPath = Statics::extractPath;
//    duckdb::DuckDB db(dbPath.toStdString());
//    duckdb::Connection con(db);
//    duckdb::Appender appender(con, this->tableName.toStdString());

//    int columnsLength = this->columnNames.length();

//    while(query->next()){

//        for(int i = 0; i < columnsLength; i++){
//            appender.Append(query->value(i));
//        }
//    }

//    appender.Close();
}
