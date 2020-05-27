#include "connectorsloginmodel.h"

ConnectorsLoginModel::ConnectorsLoginModel(QObject *parent) : QObject(parent)
{

}

void ConnectorsLoginModel::mysqlLogin(QString host, QString db, int port, QString username, QString password)
{

    MysqlCon mysqlcon;
    QVariantMap response = mysqlcon.MysqlInstance(host, db, port, username, password);

//    qDebug() << response << this;

    emit mysqlLoginStatus(response);
}
