#include "postgrescon.h"

PostgresCon::PostgresCon(QObject *parent) : QObject(parent)
{

}

QVariantMap PostgresCon::PostgresInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    Q_UNUSED(host);
    Q_UNUSED(db);
    Q_UNUSED(port);
    Q_UNUSED(username);
    Q_UNUSED(password);

    QVariantMap outputStatus;
    return outputStatus;
}

QVariantMap PostgresCon::PostgresOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable(ODBCDRIVER)){
        //        Sample connection for Postgres
        //        dbOdbc.setDatabaseName("DRIVER={PostgreSQL Unicode};Server=localhost;Database=pg_test;Trusted_Connection=True;"); // "WorkDatabase" is the name of the database we want


        QString dbString = "DRIVER={" + driver + "};" + "Database=" + db + ";Tusted_Connection=True";

        QSqlDatabase dbPostgresOdbc = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::postgresOdbcStrType);

        dbPostgresOdbc.setDatabaseName(dbString);
        dbPostgresOdbc.setPort(port);
        dbPostgresOdbc.setHostName(host);
        dbPostgresOdbc.setUserName(username);
        dbPostgresOdbc.setPassword(password);

        if(!dbPostgresOdbc.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbPostgresOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::postgresHost = host;
            Statics::postgresDb = db;
            Statics::postgresPort = port;
            Statics::postgresUsername = username;
            Statics::postgresPassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Postgres Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbPostgresOdbc2 = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::postgresOdbcStrQueryType);

            dbPostgresOdbc2.setDatabaseName(dbString);
            dbPostgresOdbc2.setHostName(host);
            dbPostgresOdbc2.setPort(port);
            dbPostgresOdbc2.setUserName(username);
            dbPostgresOdbc2.setPassword(password);

            dbPostgresOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

PostgresCon::~PostgresCon()
{
    QSqlDatabase dbPostgresOdbc = QSqlDatabase::database(Constants::postgresOdbcStrType);
    QSqlDatabase dbPostgresOdbc2 = QSqlDatabase::database( Constants::postgresOdbcStrQueryType);

    if(dbPostgresOdbc.isOpen()) dbPostgresOdbc.close();
    if(dbPostgresOdbc2.isOpen()) dbPostgresOdbc2.close();
}
