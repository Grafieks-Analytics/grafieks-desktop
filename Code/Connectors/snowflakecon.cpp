#include "snowflakecon.h"

SnowflakeCon::SnowflakeCon(QObject *parent) : QObject(parent)
{

}

QVariantMap SnowflakeCon::SnowflakeOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap outputStatus;
    QSqlDatabase dbSnowflakeOdbc = QSqlDatabase::addDatabase("QODBC", Constants::snowflakeOdbcStrType);


    if(QSqlDatabase::isDriverAvailable("QODBC")){

        QString dbString = "driver={"+ driver +"};server="+ host +";database= "+ db;

        QSqlDatabase dbSnowflakeOdbc = QSqlDatabase::addDatabase("QODBC", Constants::snowflakeOdbcStrType);

        dbSnowflakeOdbc.setDatabaseName(dbString);
        dbSnowflakeOdbc.setPort(port);
        dbSnowflakeOdbc.setHostName(host);
        dbSnowflakeOdbc.setUserName(username);
        dbSnowflakeOdbc.setPassword(password);
        dbSnowflakeOdbc.open();


        if(!dbSnowflakeOdbc.isOpen()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbSnowflakeOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::snowflakeHost = host;
            Statics::snowflakeDb = dbString;
            Statics::snowflakePort = port;
            Statics::snowflakeUsername = username;
            Statics::snowflakePassword = password;
            Statics::snowflakeRealDbName = db;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Snowflake Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbSnowflakeOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::snowflakeOdbcStrQueryType);

            dbSnowflakeOdbc2.setDatabaseName(dbString);
            dbSnowflakeOdbc2.setHostName(host);
            dbSnowflakeOdbc2.setPort(port);
            dbSnowflakeOdbc2.setUserName(username);
            dbSnowflakeOdbc2.setPassword(password);

            dbSnowflakeOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

void SnowflakeCon::closeConnection()
{
    QSqlDatabase dbSnowflakeOdbc = QSqlDatabase::database(Constants::snowflakeOdbcStrType);
    QSqlDatabase dbSnowflakeOdbc2 = QSqlDatabase::database( Constants::snowflakeOdbcStrQueryType);

    if(dbSnowflakeOdbc.isOpen()) {
        dbSnowflakeOdbc.removeDatabase(Constants::snowflakeOdbcStrType);
        dbSnowflakeOdbc.close();
    }
    if(dbSnowflakeOdbc2.isOpen()) {
        dbSnowflakeOdbc2.removeDatabase(Constants::snowflakeOdbcStrQueryType);
        dbSnowflakeOdbc2.close();
    }

    Statics::snowflakeHost = "";
    Statics::snowflakeDb = "";
    Statics::snowflakePort = 0;
    Statics::snowflakeUsername = "";
    Statics::snowflakePassword = "";
    Statics::snowflakeRealDbName = "";

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}

SnowflakeCon::~SnowflakeCon()
{
}
