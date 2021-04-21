#include "newtablelistmodel.h"

NewTableListModel::NewTableListModel(QObject *parent) : QObject(parent)
{

}

QStringList NewTableListModel::getTableList()
{
    QSqlDatabase dbCon;

    switch(Statics::currentDbIntType){

    // Check ForwardOnlyQueryModel for the following sql
    // Constants::redshiftIntType
    // Constants::snowflakeIntType
    // Constants::teraDataIntType

    case Constants::mysqlIntType:{
        dbCon = QSqlDatabase::database(Constants::mysqlStrType);
        break;
    }
    case Constants::mysqlOdbcIntType:{
        dbCon = QSqlDatabase::database(Constants::mysqlOdbcStrType);
        break;
    }
    case Constants::sqliteIntType:{
        dbCon = QSqlDatabase::database(Constants::sqliteStrType);
        break;
    }
    case Constants::postgresIntType:{
        dbCon = QSqlDatabase::database(Constants::postgresOdbcStrType);
        break;
    }
    case Constants::excelIntType:{
        dbCon = QSqlDatabase::database(Constants::excelStrType);
        break;
    }
    case Constants::mssqlIntType:{
        dbCon = QSqlDatabase::database(Constants::mssqlOdbcStrType);
        break;
    }
    case Constants::oracleIntType:{
        dbCon = QSqlDatabase::database(Constants::oracleOdbcStrType);
        break;
    }
    case Constants::mongoIntType:{
        dbCon = QSqlDatabase::database(Constants::mongoOdbcStrType);
        break;
    }
    case Constants::impalaIntType:{
        dbCon = QSqlDatabase::database(Constants::impalaOdbcStrType);
        break;
    }

    case Constants::hiveIntType:{
        dbCon = QSqlDatabase::database(Constants::hiveOdbcStrType);
        break;
    }
    case Constants::accessIntType:{
        dbCon = QSqlDatabase::database(Constants::accessOdbcStrType);
        break;
    }
    }

    this->tables = dbCon.tables();

    return this->tables;
}

QStringList NewTableListModel::filterTableList(QString keyword)
{
    return this->tables.filter(keyword);
}
