#include "sqlitecon.h"

Sqlitecon::Sqlitecon(QObject *parent) : QObject(parent)
{
}

QVariantMap Sqlitecon::SqliteInstance(const QString &filename, const QString &username, const QString &password)
{

    if(QSqlDatabase::isDriverAvailable(DRIVER)){

        QSqlDatabase dbSqlite = QSqlDatabase::addDatabase(DRIVER);
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

Sqlitecon::~Sqlitecon()
{
    QSqlDatabase dbSqlite = QSqlDatabase::database();
    dbSqlite.close();
}

QVector<QStringList *> Sqlitecon::SqliteSelect(QString &sqlQuery)
{
    QSqlDatabase dbSqlite = QSqlDatabase::database();
    QSqlQuery query = dbSqlite.exec(sqlQuery);
    QSqlRecord rec = query.record();

    int totalCols = rec.count();


    if(query.exec())
    {
        while(query.next())
        {
            for(int i=0; i< totalCols; i++){
                outputResult << query.value(i).toString();
            }
            outputData.append(&outputResult);
            outputResult.clear();
        }

    }
    dbSqlite.close();

    return outputData;
}



QStringList Sqlitecon::SqliteTables()
{
    QSqlDatabase dbSqlite = QSqlDatabase::database();
    QSqlQuery query = dbSqlite.exec("SELECT name FROM sqlite_master WHERE type='table'");

    if(query.exec())
    {
        while(query.next())
        {
            tableList.append(query.value(0).toString());
        }

        outputStatus.insert("data", tableList);

    }

    dbSqlite.close();

    return tableList;
}

