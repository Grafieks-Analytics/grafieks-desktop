#include "mssqlcon.h"

MSSqlCon::MSSqlCon(QObject *parent) : QObject(parent)
{

}

QVariantMap MSSqlCon::MSSqlInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    Q_UNUSED(host);
    Q_UNUSED(db);
    Q_UNUSED(port);
    Q_UNUSED(username);
    Q_UNUSED(password);

    QVariantMap outputStatus;
    return outputStatus;
}

QVariantMap MSSqlCon::MSSqlOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable("QODBC")){

        // Fetching from MSSQL database
        // Windows Authentication for localservver
        // For remote server, server ip, username and password required
        // Sample connection below

        // dbOdbc.setDatabaseName("DRIVER={SQL Server};Server=DESKTOP-NSN20CD\\SQLEXPRESS;Database=mssql-test;Trusted_Connection=True;"); // "WorkDatabase" is the name of the database we want
        // dbOdbc.setUserName("DESKTOP-NSN20\\vishal");

        QString dbString = "DRIVER={" + driver + "};Server="+ host +";Database=" + db + ";Tusted_Connection=True";

        QSqlDatabase dbMssqlOdbc = QSqlDatabase::addDatabase("QODBC", Constants::mssqlOdbcStrType);

        dbMssqlOdbc.setDatabaseName(dbString);
        dbMssqlOdbc.setPort(port);
        dbMssqlOdbc.setHostName(host);
        dbMssqlOdbc.setUserName(username);
        dbMssqlOdbc.setPassword(password);
        dbMssqlOdbc.open();

        if(!dbMssqlOdbc.isOpen()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbMssqlOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::msHost = host;
            Statics::msDb = db;
            Statics::msPort = port;
            Statics::msUsername = username;
            Statics::msPassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Mssql Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbMssqlOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::mssqlOdbcStrQueryType);

            dbMssqlOdbc2.setDatabaseName(dbString);
            dbMssqlOdbc2.setHostName(host);
            dbMssqlOdbc2.setPort(port);
            dbMssqlOdbc2.setUserName(username);
            dbMssqlOdbc2.setPassword(password);

            dbMssqlOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

void MSSqlCon::closeConnection()
{
    QSqlDatabase dbMssqlOdbc = QSqlDatabase::database(Constants::mssqlOdbcStrType);
    QSqlDatabase dbMssqlOdbc2 = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);

    if(dbMssqlOdbc.isOpen()) {
        dbMssqlOdbc.removeDatabase(Constants::mssqlOdbcStrType);
        dbMssqlOdbc.close();
    }
    if(dbMssqlOdbc2.isOpen()) {
        dbMssqlOdbc2.removeDatabase(Constants::mssqlOdbcStrQueryType);
        dbMssqlOdbc2.close();
    }

    Statics::msHost = "";
    Statics::msDb = "";
    Statics::msPort = 0;
    Statics::msUsername = "";
    Statics::msPassword = "";

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}

MSSqlCon::~MSSqlCon()
{

}
