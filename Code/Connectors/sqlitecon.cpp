#include "sqlitecon.h"

Sqlitecon::Sqlitecon(QObject *parent) : QObject(parent)
{
}

QVariantMap Sqlitecon::SqliteInstance(const QString &filename, const QString &username, const QString &password)
{

    if(QSqlDatabase::isDriverAvailable(DRIVER)){

        QSqlDatabase dbSqlite = QSqlDatabase::addDatabase(DRIVER, Constants::sqliteStrType);
        dbSqlite.setDatabaseName(filename);

        if(username != "" && password != ""){
            dbSqlite.setUserName(username);
            dbSqlite.setPassword(password);
        }

        if(!dbSqlite.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbSqlite.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::sqliteFile = filename;
            Statics::sqliteUsername = username;
            Statics::sqlitePassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Constants::GeneralSuccessMsg);
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Constants::GeneralNoDriver);
    }

    return outputStatus;

}

Sqlitecon::~Sqlitecon()
{
    QSqlDatabase dbSqlite = QSqlDatabase::database();
    dbSqlite.close();
}
