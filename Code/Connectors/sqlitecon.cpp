#include "sqlitecon.h"

Sqlitecon::Sqlitecon(QObject *parent) : QObject(parent)
{
}

QVariantMap Sqlitecon::SqliteInstance(const QString &filename, const QString &username, const QString &password)
{

    const QString DRIVER("QSQLITE");

    if(QSqlDatabase::isDriverAvailable(DRIVER)){

        QSqlDatabase dbSqlite = QSqlDatabase::addDatabase("QSQLITE");
        dbSqlite.setDatabaseName(filename);

        if(username != "" && password != ""){
            dbSqlite.setUserName(username);
            dbSqlite.setPassword(password);
        }

        if(!dbSqlite.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbSqlite.lastError().text());

        } else{

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Constants::GeneralSuccessMsg);
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Constants::GeneralNoDriver);
    }

    return outputStatus;

}

void Sqlitecon::SqliteSelect(QString &sqlQuery)
{
    QSqlDatabase dbSqlite = QSqlDatabase::database();
    QSqlQuery query = dbSqlite.exec(sqlQuery);

    if(query.exec())
    {
        while(query.next())
        {
            qDebug()<<query.value(3).toString();
        }
    } else{
        qDebug()<<" error1: "<<query.lastError().text();
    }

    dbSqlite.close();

}



void Sqlitecon::SqliteTables()
{
    QSqlDatabase dbSqlite = QSqlDatabase::database();
    QSqlQuery query = dbSqlite.exec("SELECT name FROM sqlite_master WHERE type='table'");

    if(query.exec())
    {
        while(query.next())
        {
            qDebug()<<query.value(0).toString();
        }
    } else{
        qDebug()<<" error88: "<<query.lastError().text();
    }

    dbSqlite.close();
}

