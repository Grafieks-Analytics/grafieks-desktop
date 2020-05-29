#include "connectorsloginmodel.h"

ConnectorsLoginModel::ConnectorsLoginModel(QObject *parent) : QObject(parent)
{
}

void ConnectorsLoginModel::mysqlLogin(QString host, QString db, int port, QString username, QString password)
{

    MysqlCon mysqlcon;
    QVariantMap response = mysqlcon.MysqlInstance(host, db, port, username, password);

    this->setCurrentDbName(db);
    this->setCurrentDbType("Mysql");

    emit mysqlLoginStatus(response);
}

void ConnectorsLoginModel::sqliteLogin(QString filename, QString username, QString password)
{

    Sqlitecon sqlitecon;
    QVariantMap response = sqlitecon.SqliteInstance(filename, username, password);

    this->setCurrentDbName(filename);
    this->setCurrentDbType("Sqlite");

    emit sqliteLoginStatus(response);
}

QString ConnectorsLoginModel::currentDbName() const
{
    return m_currentDbName;
}

QString ConnectorsLoginModel::currentDbType() const
{
    return m_currentDbType;
}

void ConnectorsLoginModel::setCurrentDbName(QString currentDbName)
{
    if (m_currentDbName == currentDbName)
        return;

    m_currentDbName = currentDbName;
    emit currentDbNameChanged(m_currentDbName);
}

void ConnectorsLoginModel::setCurrentDbType(QString currentDbType)
{
    if (m_currentDbType == currentDbType)
        return;

    m_currentDbType = currentDbType;
    emit currentDbTypeChanged(m_currentDbType);
}

