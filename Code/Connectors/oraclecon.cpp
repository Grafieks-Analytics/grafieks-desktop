#include "oraclecon.h"

OracleCon::OracleCon(QObject *parent) : QObject(parent)
{

}

QVariantMap OracleCon::OracleOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable(ODBCDRIVER)){

        // Fetching from Oracle database

        QString dbString = "DRIVER={" + driver + "};Server="+ host +"Database=" + db + ";Tusted_Connection=True";

        QSqlDatabase dbOracleOdbc = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::mssqlOdbcStrType);

        dbOracleOdbc.setDatabaseName(dbString);
        dbOracleOdbc.setPort(port);
        dbOracleOdbc.setUserName(username);
        dbOracleOdbc.setPassword(password);

        if(!dbOracleOdbc.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbOracleOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::oracleHost = host;
            Statics::oracleDb = db;
            Statics::oraclePort = port;
            Statics::oracleUsername = username;
            Statics::oraclePassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Oracle Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbOracleOdbc2 = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::mssqlOdbcStrQueryType);

            dbOracleOdbc2.setDatabaseName(dbString);
            dbOracleOdbc2.setHostName(host);
            dbOracleOdbc2.setPort(port);
            dbOracleOdbc2.setUserName(username);
            dbOracleOdbc2.setPassword(password);

            dbOracleOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

OracleCon::~OracleCon()
{

    QSqlDatabase dbOracleOdbc = QSqlDatabase::database(Constants::oracleOdbcStrType);
    QSqlDatabase dbOracleOdbc2 = QSqlDatabase::database( Constants::oracleOdbcStrQueryType);

    if(dbOracleOdbc.isOpen()) dbOracleOdbc.close();
    if(dbOracleOdbc2.isOpen()) dbOracleOdbc2.close();
}
