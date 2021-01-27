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
 */
void ConnectorsLoginModel::sqliteLogin(QString filename)
{

    Sqlitecon sqlitecon;
    QVariantMap response = sqlitecon.SqliteInstance(filename);

    QFile sqliteFile(QUrl(filename).toLocalFile());
    QFileInfo fileInfo(sqliteFile.fileName());
    QString sqliteFileName = fileInfo.fileName();

    Statics::currentDbName = sqliteFileName;
    Statics::currentDbIntType = Constants::sqliteIntType;
    Statics::currentDbStrType = Constants::sqliteStrType;

    this->setConnectedDB(sqliteFileName);

    emit sqliteLoginStatus(response);
}


void ConnectorsLoginModel::mysqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    MysqlCon mysqlcon;
    QVariantMap response = mysqlcon.MysqlOdbcInstance(driver, host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::mysqlOdbcIntType;
    Statics::currentDbStrType = Constants::mysqlOdbcStrType;

    this->setConnectedDB(db);

    emit mysqlLoginStatus(response);
}


void ConnectorsLoginModel::mssqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{

    MSSqlCon mssqlcon;
    QVariantMap response = mssqlcon.MSSqlOdbcInstance(driver, host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::mssqlIntType;
    Statics::currentDbStrType = Constants::mssqlOdbcStrType;

    this->setConnectedDB(db);

    emit mssqlLoginStatus(response);
}

void ConnectorsLoginModel::postgresOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    PostgresCon postgrescon;
    QVariantMap response = postgrescon.PostgresOdbcInstance(driver, host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::postgresIntType;
    Statics::currentDbStrType = Constants::postgresOdbcStrType;

    this->setConnectedDB(db);

    emit postgresLoginStatus(response);

}

void ConnectorsLoginModel::oracleOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{

    OracleCon oraclecon;
    QVariantMap response = oraclecon.OracleOdbcInstance(driver, host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::oracleIntType;
    Statics::currentDbStrType = Constants::oracleOdbcStrType;

    this->setConnectedDB(db);

    emit postgresLoginStatus(response);
}

void ConnectorsLoginModel::mongoOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{

    MongoCon mongocon;
    QVariantMap response = mongocon.MongoOdbcInstance(driver, host, db, port, username, password);

    Statics::currentDbName = db;
    Statics::currentDbIntType = Constants::mongoIntType;
    Statics::currentDbStrType = Constants::mongoOdbcStrType;

    this->setConnectedDB(db);

    emit mongoLoginStatus(response);

}

void ConnectorsLoginModel::excelOdbcLogin(QString driver, QString filename)
{

    ExcelCon excelcon;
    QVariantMap response = excelcon.ExcelOdbcInstance(driver, filename);

    Statics::currentDbName = filename;
    Statics::currentDbIntType = Constants::excelIntType;
    Statics::currentDbStrType = Constants::excelOdbcStrType;

    this->setConnectedDB(filename);

    emit excelLoginStatus(response);
}

void ConnectorsLoginModel::csvLogin(QString filename)
{
    CSVCon csvcon;
    QVariantMap response = csvcon.CSVInstance(filename);

    Statics::currentDbName = filename;
    Statics::currentDbIntType = Constants::csvIntType;

    this->setConnectedDB(filename);

    emit csvLoginStatus(response);
}

QString ConnectorsLoginModel::urlToFilePath(const QUrl &url)
{
    QString path = url.toLocalFile();
    return path;
}

QString ConnectorsLoginModel::connectedDB() const
{
    QString dataBase = m_connectedDB;

    switch (Statics::currentDbIntType) {

    case Constants::csvIntType:{
        dataBase = QUrl(m_connectedDB).fileName();
        break;
    }
    }
    return dataBase;

}

void ConnectorsLoginModel::setConnectedDB(QString connectedDB)
{
    if (m_connectedDB == connectedDB)
        return;

    m_connectedDB = connectedDB;
    emit connectedDBChanged(m_connectedDB);
}

