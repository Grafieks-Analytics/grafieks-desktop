#include "mysqlcon.h"

MysqlCon::MysqlCon(QObject *parent) : QObject(parent)
{


}

QVariantMap MysqlCon::MysqlInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    if(QSqlDatabase::isDriverAvailable(DRIVER)){

        QSqlDatabase dbMysql = QSqlDatabase::addDatabase(DRIVER);
        dbMysql.setHostName(host);
        dbMysql.setPort(port);
        dbMysql.setDatabaseName(db);
        dbMysql.setUserName(username);
        dbMysql.setPassword(password);


        if(!dbMysql.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbMysql.lastError().text());

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

void MysqlCon::MysqlSelect(QString &sqlQuery)
{

    QSqlDatabase dbMysql = QSqlDatabase::database();
    QSqlQuery query = dbMysql.exec(sqlQuery);

    if(query.exec())
    {
        while(query.next())
        {

            qDebug()<<query.value(3).toString();
        }
    } else{
        qDebug()<<" error1: "<<query.lastError().text();
    }

    dbMysql.close();


}

void MysqlCon::MysqlListDbs()
{

    QSqlDatabase dbMysql = QSqlDatabase::database();
    QSqlQuery query = dbMysql.exec("SHOW DATABASES");

    if(query.exec())
    {
        while(query.next())
        {
            qDebug()<<query.value(0).toString();
        }
    } else{
        qDebug()<<" error1: "<<query.lastError().text();
    }

    dbMysql.close();
}

void MysqlCon::MysqlListTables(QString &db)
{

    QSqlDatabase dbMysql = QSqlDatabase::database();
    dbMysql.exec("USE "+ db);
    QSqlQuery query = dbMysql.exec("SHOW TABLES");

    if(query.exec())
    {
        while(query.next())
        {
            qDebug()<<query.value(0).toString();
        }
    } else{
        qDebug()<<" error1: "<<query.lastError().text();
    }

    dbMysql.close();
}
