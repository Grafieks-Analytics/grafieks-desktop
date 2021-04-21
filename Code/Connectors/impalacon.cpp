#include "impalacon.h"

ImpalaCon::ImpalaCon(QObject *parent) : QObject(parent)
{

}

QVariantMap ImpalaCon::ImpalaOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable("QODBC")){

        // Fetching from Impala database

        QString dbString = "DRIVER={" + driver + "};Server="+ host +"Database=" + db + ";Tusted_Connection=True";

        QSqlDatabase dbImpalaOdbc = QSqlDatabase::addDatabase("QODBC", Constants::impalaOdbcStrType);

        dbImpalaOdbc.setDatabaseName(dbString);
        dbImpalaOdbc.setPort(port);
        dbImpalaOdbc.setUserName(username);
        dbImpalaOdbc.setPassword(password);
        dbImpalaOdbc.open();

        if(!dbImpalaOdbc.isOpen()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbImpalaOdbc.lastError().text());

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

            QSqlDatabase dbImpalaOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::impalaOdbcStrQueryType);

            dbImpalaOdbc2.setDatabaseName(dbString);
            dbImpalaOdbc2.setHostName(host);
            dbImpalaOdbc2.setPort(port);
            dbImpalaOdbc2.setUserName(username);
            dbImpalaOdbc2.setPassword(password);

            dbImpalaOdbc2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

void ImpalaCon::closeConnection()
{
    QSqlDatabase dbImpalaOdbc = QSqlDatabase::database(Constants::impalaOdbcStrType);
    QSqlDatabase dbImpalaOdbc2 = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);

    if(dbImpalaOdbc.isOpen()) {
        dbImpalaOdbc.removeDatabase(Constants::impalaOdbcStrType);
        dbImpalaOdbc.close();
    }
    if(dbImpalaOdbc2.isOpen()) {
        dbImpalaOdbc2.removeDatabase(Constants::impalaOdbcStrQueryType);
        dbImpalaOdbc2.close();
    }

    Statics::impalaHost = "";
    Statics::impalaDb = "";
    Statics::impalaPort = 0;
    Statics::impalaUsername = "";
    Statics::impalaPassword = "";

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = -1;
    Statics::currentDbStrType = "";
}

ImpalaCon::~ImpalaCon()
{  
}
