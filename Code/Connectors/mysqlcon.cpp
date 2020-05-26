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

QVector<QStringList> MysqlCon::MysqlSelect(QString &sqlQuery)
{

    QSqlDatabase dbMysql = QSqlDatabase::database();
    QSqlQuery query = dbMysql.exec(sqlQuery);
    QSqlRecord rec = query.record();

    int totalCols = rec.count();

    if(query.exec())
    {
        while(query.next())
        {
            for(int i=0; i< totalCols; i++){
                outputResult << query.value(i).toString();
            }
            outputData.append(outputResult);
            outputResult.clear();
        }

    }
    dbMysql.close();

    return outputData;


}

QStringList MysqlCon::MysqlListDbs()
{
    QSqlDatabase dbMysql = QSqlDatabase::database();
    QSqlQuery query = dbMysql.exec("SHOW DATABASES");

    if(query.exec())
    {
        while(query.next())
        {
            qDebug()<<query.value(0).toString();
            tableList.append(query.value(0).toString());
        }
    }

    dbMysql.close();
    return tableList;
}

QStringList MysqlCon::MysqlListTables(QString &db)
{

    QSqlDatabase dbMysql = QSqlDatabase::database();
    dbMysql.exec("USE "+ db);
    QSqlQuery query = dbMysql.exec("SHOW TABLES");

    if(query.exec())
    {
        while(query.next())
        {
            qDebug()<<query.value(0).toString();
            tableList.append(query.value(0).toString());
        }
    }

    dbMysql.close();
    return tableList;
}
