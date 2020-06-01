#include "connectorsloginmodel.h"

ConnectorsLoginModel::ConnectorsLoginModel(QObject *parent) : QObject(parent)
{
}

void ConnectorsLoginModel::mysqlLogin(QString host, QString db, int port, QString username, QString password)
{

    MysqlCon mysqlcon;
    QVariantMap response = mysqlcon.MysqlInstance(host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::mysqlIntType;
    Statics::currentDbStrType = Constants::mysqlStrType;

    emit mysqlLoginStatus(response);
}

void ConnectorsLoginModel::sqliteLogin(QString filename, QString username, QString password)
{

    Sqlitecon sqlitecon;
    QVariantMap response = sqlitecon.SqliteInstance(filename, username, password);

    Statics::currentDbName = filename;
    Statics::currentDbIntType = Constants::sqliteIntType;
    Statics::currentDbStrType = Constants::sqliteStrType;

    emit sqliteLoginStatus(response);
}

