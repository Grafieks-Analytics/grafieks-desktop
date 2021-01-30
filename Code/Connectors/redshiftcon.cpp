#include "redshiftcon.h"

RedshiftCon::RedshiftCon(QObject *parent) : QObject(parent)
{

}

QVariantMap RedshiftCon::RedshiftOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable(ODBCDRIVER)){
        // Redshift is almost Postgres db
        // Sample connection for Postgres
        // dbOdbc.setDatabaseName("DRIVER={PostgreSQL Unicode};Server=localhost;Database=pg_test;Trusted_Connection=True;"); // "WorkDatabase" is the name of the database we want


        QString dbString = "DRIVER={" + driver + "};" + "Database=" + db + ";Tusted_Connection=True";

        QSqlDatabase dbRedshiftOdbc = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::redshiftOdbcStrType);

        dbRedshiftOdbc.setDatabaseName(dbString);
        dbRedshiftOdbc.setPort(port);
        dbRedshiftOdbc.setHostName(host);
        dbRedshiftOdbc.setUserName(username);
        dbRedshiftOdbc.setPassword(password);

        if(!dbRedshiftOdbc.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbRedshiftOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::redshiftHost = host;
            Statics::redshiftDb = db;
            Statics::redshiftPort = port;
            Statics::redshiftUsername = username;
            Statics::redshiftPassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Postgres Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbRedshiftOdbc2 = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::redshiftOdbcStrQueryType);

            dbRedshiftOdbc2.setDatabaseName(dbString);
            dbRedshiftOdbc2.setHostName(host);
            dbRedshiftOdbc2.setPort(port);
            dbRedshiftOdbc2.setUserName(username);
            dbRedshiftOdbc2.setPassword(password);

            dbRedshiftOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

RedshiftCon::~RedshiftCon()
{
    QSqlDatabase dbRedshiftOdbc = QSqlDatabase::database(Constants::redshiftOdbcStrType);
    QSqlDatabase dbRedshiftOdbc2 = QSqlDatabase::database( Constants::redshiftOdbcStrQueryType);

    if(dbRedshiftOdbc.isOpen()) dbRedshiftOdbc.close();
    if(dbRedshiftOdbc2.isOpen()) dbRedshiftOdbc2.close();
}
