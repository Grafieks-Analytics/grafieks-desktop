#include "queryjoiner.h"

QueryJoiner::QueryJoiner(QObject *parent) : QObject(parent)
{

}

QString QueryJoiner::getQueryJoiner(int dbType)
{
    QString joiner;
    switch(dbType){

    case Constants::mysqlIntType:
        joiner = "`";
        break;

    case Constants::mongoIntType:
        joiner = "\"";
        break;

    case Constants::postgresIntType:
        joiner = "\"";
        break;

    case Constants::oracleIntType:
        joiner = "'";
        break;

    case Constants::mssqlIntType:
        joiner = "\"";
        break;

    case Constants::accessIntType:
        joiner = "\"";
        break;
    case Constants::sqliteIntType:
        joiner = "`";
        break;
    }

    return joiner;

}
