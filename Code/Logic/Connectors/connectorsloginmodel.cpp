#include "connectorsloginmodel.h"

ConnectorsLoginModel::ConnectorsLoginModel(QObject *parent) : QObject(parent)
{

}

void ConnectorsLoginModel::mysqlLogin(QString host, QString db, int port, QString username, QString password)
{

    MysqlCon mysqlcon;
    QVariantMap response = mysqlcon.MysqlInstance(host, db, port, username, password);

    emit mysqlLoginStatus(response);
}

void ConnectorsLoginModel::sqliteLogin(QString filename, QString username, QString password)
{

    Sqlitecon sqlitecon;
    QVariantMap response = sqlitecon.SqliteInstance(filename, username, password);

    emit sqliteLoginStatus(response);
}
