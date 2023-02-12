#include "accesscon.h"

AccessCon::AccessCon(QObject *parent) : QObject(parent)
{

}

QVariantMap AccessCon::AccessOdbcInstance(const QString &driver, const QString &db, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable("QODBC")){

        // Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq=C:\mydatabase.accdb;Uid=Admin;Pwd=;

        QString dbString = "DRIVER={" + driver + "}" + ";Dbq=" + db;

        QSqlDatabase dbAccessOdbc = QSqlDatabase::addDatabase("QODBC", Constants::accessOdbcStrType);

        dbAccessOdbc.setDatabaseName(dbString);
        dbAccessOdbc.setUserName(username);
        dbAccessOdbc.setPassword(password);
        dbAccessOdbc.open();

        if(!dbAccessOdbc.isOpen()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbAccessOdbc.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::acDb = dbString;
            Statics::acUsername = username;
            Statics::acPassword = password;
            Statics::acRealDbName = db;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Access Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbAccessOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::accessOdbcStrQueryType);

            dbAccessOdbc2.setDatabaseName(dbString);
            dbAccessOdbc2.setUserName(username);
            dbAccessOdbc2.setPassword(password);

            dbAccessOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

void AccessCon::closeConnection()
{
    QSqlDatabase dbAccessOdbc = QSqlDatabase::database(Constants::accessOdbcStrType);
    QSqlDatabase dbAccessOdbc2 = QSqlDatabase::database( Constants::accessOdbcStrQueryType);

    if(dbAccessOdbc.isOpen()){
        dbAccessOdbc.removeDatabase(Constants::accessOdbcStrType);
        dbAccessOdbc.close();
    }

    if(dbAccessOdbc2.isOpen()){
        dbAccessOdbc2.removeDatabase(Constants::accessOdbcStrQueryType);
        dbAccessOdbc2.close();
    }

    Statics::acDb = "";
    Statics::acUsername = "";
    Statics::acPassword = "";
    Statics::acRealDbName = "";

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}

AccessCon::~AccessCon()
{
}
