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


void ConnectorsLoginModel::mysqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{

}


void ConnectorsLoginModel::mssqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{

    MSSqlCon mssqlcon;
    QVariantMap response = mssqlcon.MSSqlInstance(host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::mysqlIntType;
    Statics::currentDbStrType = Constants::mysqlStrType;

    this->setConnectedDB(db);

    emit mssqlLoginStatus(response);
}

void ConnectorsLoginModel::postgresOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    PostgresCon postgrescon;
    QVariantMap response = postgrescon.PostgresInstance(host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::mysqlIntType;
    Statics::currentDbStrType = Constants::mysqlStrType;

    this->setConnectedDB(db);

    emit postgresLoginStatus(response);

}

void ConnectorsLoginModel::mongoOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{

    MongoCon mongocon;
    QVariantMap response = mongocon.MongoInstance(host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::mysqlIntType;
    Statics::currentDbStrType = Constants::mysqlStrType;

    this->setConnectedDB(db);

    emit mongoLoginStatus(response);

}

void ConnectorsLoginModel::excelOdbcLogin(QString driver, QString filename)
{

    ExcelCon excelcon;
    QVariantMap response = excelcon.ExcelOdbcInstance(driver, filename);

    Statics::currentDbName = filename;
    Statics::currentDbIntType = Constants::mysqlIntType;
    Statics::currentDbStrType = Constants::mysqlStrType;

    this->setConnectedDB(filename);

    emit excelLoginStatus(response);
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

