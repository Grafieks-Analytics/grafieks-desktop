#include "connectorsloginmodel.h"

/*!
 * \brief Constructor function
 * \param parent
 */
ConnectorsLoginModel::ConnectorsLoginModel(QObject *parent) : QObject(parent)
{
}

/*!
 * \brief Initiate connection with a MySql database
 * \param host (database server host)
 * \param db (database name)
 * \param port
 * \param username
 * \param password
 */
void ConnectorsLoginModel::mysqlLogin(QString host, QString db, int port, QString username, QString password)
{

    MysqlCon mysqlcon;
    QVariantMap response = mysqlcon.MysqlInstance(host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::mysqlIntType;
    Statics::currentDbStrType = Constants::mysqlStrType;

    this->setConnectedDB(db);

    emit mysqlLoginStatus(response);
}


/*!
 * \brief Initiate connection with an Sqlite database
 * \param filename (database file)
 * \param username
 * \param password
 */
void ConnectorsLoginModel::sqliteLogin(QString filename, QString username, QString password)
{

    Sqlitecon sqlitecon;
    QVariantMap response = sqlitecon.SqliteInstance(filename, username, password);

    Statics::currentDbName = filename;
    Statics::currentDbIntType = Constants::sqliteIntType;
    Statics::currentDbStrType = Constants::sqliteStrType;

    this->setConnectedDB(filename);

    emit sqliteLoginStatus(response);
}

void ConnectorsLoginModel::odbcLogin(QString filename, QString username, QString password)
{

}

QString ConnectorsLoginModel::connectedDB() const
{
    return m_connectedDB;
}

void ConnectorsLoginModel::setConnectedDB(QString connectedDB)
{
    if (m_connectedDB == connectedDB)
        return;

    m_connectedDB = connectedDB;
    emit connectedDBChanged(m_connectedDB);
}

