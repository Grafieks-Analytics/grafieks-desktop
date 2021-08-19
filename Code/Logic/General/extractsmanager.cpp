#include "extractsmanager.h"

ExtractsManager::ExtractsManager(QObject *parent) : QObject(parent)
{
}

void ExtractsManager::createTable(QList<QByteArray> columnNames, QVector<int> columnIntTypes, QStringList columnStringTypes, QString tableName)
{
    QString dbPath = Statics::extractPath;
    duckdb::DuckDB db(dbPath.toStdString());
    duckdb::Connection con(db);

    this->columnNames = columnNames;
    this->columnIntTypes = columnIntTypes;
    this->columnStringTypes = columnStringTypes;
    this->tableName = tableName;

    QString query;

    query = "CREATE TABLE " + tableName + "(";
    for(int i = 0; i < columnNames.length(); i++){
        query.append( columnNames.at(i)+ " " + columnStringTypes.at(i) + ",");
    }

    query.chop(1);
    query.append(")");

    auto x = con.Query(query.toStdString());
    if(!x->success)
        qDebug() << "Error creating extract db" << x->error.c_str();

    db.~DuckDB();
}

void ExtractsManager::uploadCSVData(QFile *csvFile, char delimiter)
{
    QString dbPath = Statics::extractPath;
    duckdb::DuckDB db(dbPath.toStdString());
    duckdb::Connection con(db);
    duckdb::Appender appender(con, this->tableName.toStdString());
    auto x1 = con.Query("SELECT * FROM "+ this->tableName.toStdString());
    x1->Print();

    int columnsLength = this->columnNames.length();

    while(!csvFile->atEnd()){
        QByteArray line = csvFile->readLine().simplified();
        QList<QByteArray>byteData = line.split(delimiter);
        qDebug() << "COL LENGTH" << columnsLength << byteData;

        appender.BeginRow();
        for(int i = 0; i < columnsLength; i++){
            qDebug() << "COL TYPE" << this->columnIntTypes.at(i) << byteData.at(i);

            switch(this->columnIntTypes.at(i)){

            case Constants::blobIntType:
            case Constants::varcharIntType:{
                appender.Append(byteData.at(i).toBase64().constData());
                break;
            }
            case Constants::smallIntIntType:
            case Constants::tinyIntIntType:{
                appender.Append(byteData.at(i).toShort());
                break;
            }

            case Constants::intIntType:{
                appender.Append(byteData.at(i).toInt());
                break;
            }

            case Constants::bigIntIntType:
            case Constants::hugeIntIntType:{
                appender.Append(byteData.at(i).toLongLong());
                break;
            }
            case Constants::doubleIntType:
            case Constants::realIntType:{
                appender.Append(byteData.at(i).toDouble());
                break;
            }
            default:{
                appender.Append(byteData.at(i).toStdString().c_str());
                break;
            }
            }

        }
        appender.EndRow();
    }
    appender.Close();

    db.~DuckDB();
}

void ExtractsManager::uploadQueryData(QSqlQuery *query)
{
        QString dbPath = Statics::extractPath;
        duckdb::DuckDB db(dbPath.toStdString());
        duckdb::Connection con(db);
        auto x1 = con.Query("SELECT * FROM "+ this->tableName.toStdString());
        x1->Print();

        duckdb::Appender appender(con, this->tableName.toStdString());

        int columnsLength = this->columnNames.length();

        while(query->next()){

            appender.BeginRow();
            for(int i = 0; i < columnsLength; i++){

                switch(this->columnIntTypes.at(i)){

                case Constants::blobIntType:
                case Constants::varcharIntType:{
                    appender.Append(query->value(i).toString().toUtf8().constData());
                    break;
                }
                case Constants::smallIntIntType:
                case Constants::tinyIntIntType:
                case Constants::intIntType:{
                    appender.Append(query->value(i).toInt());
                    break;
                }

                case Constants::bigIntIntType:
                case Constants::hugeIntIntType:{
                    appender.Append(query->value(i).toLongLong());
                    break;
                }
                case Constants::doubleIntType:
                case Constants::realIntType:{
                    appender.Append(query->value(i).toDouble());
                    break;
                }
                default:{
                    qDebug() << query->value(i).toDate().toString().toUtf8().constData();
//                    appender.Append(duckdb::Date::FromDate(1992, 1, 1));
//                    appender.Append(duckdb::Date::FromString(query->value(i).toDate().toString().toUtf8().constData()));
                    break;
                }
                }
            }
            appender.EndRow();
        }

        appender.Close();
}
