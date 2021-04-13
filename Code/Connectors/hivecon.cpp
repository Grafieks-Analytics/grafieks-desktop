#include "hivecon.h"

HiveCon::HiveCon(QObject *parent) : QObject(parent)
{

}

QVariantMap HiveCon::HiveOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable("QODBC")){

        // Fetching from Hive database

        QString dbString = "DRIVER={" + driver + "};Server="+ host +"Database=" + db + ";Tusted_Connection=True";

        QSqlDatabase dbHiveOdbc = QSqlDatabase::addDatabase("QODBC", Constants::hiveOdbcStrType);

        dbHiveOdbc.setDatabaseName(dbString);
        dbHiveOdbc.setPort(port);
        dbHiveOdbc.setUserName(username);
        dbHiveOdbc.setPassword(password);
        dbHiveOdbc.open();

        if(!dbHiveOdbc.isOpen()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbHiveOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::impalaHost = host;
            Statics::impalaDb = db;
            Statics::impalaPort = port;
            Statics::impalaUsername = username;
            Statics::impalaPassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Mssql Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbHiveOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::hiveOdbcStrQueryType);

            dbHiveOdbc2.setDatabaseName(dbString);
            dbHiveOdbc2.setHostName(host);
            dbHiveOdbc2.setPort(port);
            dbHiveOdbc2.setUserName(username);
            dbHiveOdbc2.setPassword(password);

            dbHiveOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

HiveCon::~HiveCon()
{
    QSqlDatabase dbHiveOdbc = QSqlDatabase::database(Constants::hiveOdbcStrType);
    QSqlDatabase dbHiveOdbc2 = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);

    if(dbHiveOdbc.isOpen()) dbHiveOdbc.close();
    if(dbHiveOdbc2.isOpen()) dbHiveOdbc2.close();
}
