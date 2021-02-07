#include "teradatacon.h"

TeradataCon::TeradataCon(QObject *parent) : QObject(parent)
{

}

QVariantMap TeradataCon::TeradataOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable(ODBCDRIVER)){

        QString dbString = "DRIVER={" + driver + "};" + "Database=" + db + ";Tusted_Connection=True";

        QSqlDatabase dbTeradataOdbc = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::teradataOdbcStrType);

        dbTeradataOdbc.setDatabaseName(dbString);
        dbTeradataOdbc.setPort(port);
        dbTeradataOdbc.setHostName(host);
        dbTeradataOdbc.setUserName(username);
        dbTeradataOdbc.setPassword(password);

        if(!dbTeradataOdbc.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbTeradataOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::teradataHost = host;
            Statics::teradataDb = db;
            Statics::teradataPort = port;
            Statics::teradataUsername = username;
            Statics::teradataPassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Teradata Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbTeradataOdbc2 = QSqlDatabase::addDatabase(ODBCDRIVER, Constants::teradataOdbcStrQueryType);

            dbTeradataOdbc2.setDatabaseName(dbString);
            dbTeradataOdbc2.setHostName(host);
            dbTeradataOdbc2.setPort(port);
            dbTeradataOdbc2.setUserName(username);
            dbTeradataOdbc2.setPassword(password);

            dbTeradataOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

TeradataCon::~TeradataCon()
{

    QSqlDatabase dbTeradataOdbc = QSqlDatabase::database(Constants::teradataOdbcStrType);
    QSqlDatabase dbTeradataOdbc2 = QSqlDatabase::database( Constants::teradataOdbcStrQueryType);

    if(dbTeradataOdbc.isOpen()) dbTeradataOdbc.close();
    if(dbTeradataOdbc2.isOpen()) dbTeradataOdbc2.close();
}
