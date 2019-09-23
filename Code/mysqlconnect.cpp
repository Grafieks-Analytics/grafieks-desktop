#include <QtDebug>
#include "./Headers/mysqlconnect.h"

MysqlConnect::MysqlConnect(QObject *parent) : QObject(parent)
{
}

void MysqlConnect::startConnection(QString host, QString username, QString password, QString database)
{

    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        db.setHostName(host);
        db.setUserName(username);
        db.setPassword(password);
        db.setDatabaseName(database);
        if(db.open()){
            emit connectStatus("Success ");
        }
        else{
            QString error_string = db.lastError().text();
            emit connectStatus(error_string);
        }
}
