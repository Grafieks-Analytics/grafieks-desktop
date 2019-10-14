#include <QtDebug>
#include "./Headers/mysqlconnect.h"

MysqlConnect::MysqlConnect(QObject *parent) : QObject(parent)
{
}

void MysqlConnect::startConnection(QString host, QString username, QString password, QString database)
{

    QSqlDatabase db_mysql = QSqlDatabase::addDatabase("QMYSQL", "mysql_handle");
        db_mysql.setHostName(host);
        db_mysql.setUserName(username);
        db_mysql.setPassword(password);
        db_mysql.setDatabaseName(database);
        if(db_mysql.open()){
            emit connectStatus("Success ");
        }
        else{
            QString error_string = db_mysql.lastError().text();
            emit connectStatus(error_string);
        }
}
