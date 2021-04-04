#include "connectorsloginmodel.h"

/*!
 * \brief Constructor function
 * \param parent
 */
ConnectorsLoginModel::ConnectorsLoginModel(QObject *parent) : QObject(parent),
    mysqlcon(new MysqlCon)
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

    QVariantMap response = mysqlcon->MysqlInstance(host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::mysqlIntType, Constants::mysqlStrType);
    emit mysqlLoginStatus(response);
}


/*!
 * \brief Initiate connection with an Sqlite database
 * \param filename (database file)
 */
void ConnectorsLoginModel::sqliteLogin(QString filename)
{

    QVariantMap response = sqlitecon->SqliteInstance(filename);

    QFile sqliteFile(QUrl(filename).toLocalFile());
    QFileInfo fileInfo(sqliteFile.fileName());
    QString sqliteFileName = fileInfo.fileName();

    this->staticSetter(sqliteFileName, Constants::sqlType, Constants::sqliteIntType, Constants::sqliteStrType);
    emit sqliteLoginStatus(response);
}


void ConnectorsLoginModel::mysqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = mysqlcon->MysqlOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::mysqlOdbcIntType, Constants::mysqlOdbcStrType);
    emit mysqlLoginStatus(response);
}


void ConnectorsLoginModel::mssqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{

    QVariantMap response = mssqlcon->MSSqlOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::mssqlIntType, Constants::mssqlOdbcStrType);
    emit mssqlLoginStatus(response);
}

void ConnectorsLoginModel::postgresOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = postgrescon->PostgresOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::postgresIntType, Constants::postgresOdbcStrType);
    emit postgresLoginStatus(response);

}

void ConnectorsLoginModel::redshiftOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = redshiftcon->RedshiftOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::redshiftIntType, Constants::redshiftOdbcStrType);
    emit redshiftLoginStatus(response);
}

void ConnectorsLoginModel::oracleOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = oraclecon->OracleOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::oracleIntType, Constants::oracleOdbcStrType);
    emit postgresLoginStatus(response);
}

void ConnectorsLoginModel::mongoOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = mongocon->MongoOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::mongoIntType, Constants::mongoOdbcStrType);
    emit mongoLoginStatus(response);

}

void ConnectorsLoginModel::impalaOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = impalacon->ImpalaOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::impalaIntType, Constants::impalaOdbcStrType);
    emit impalaLoginStatus(response);
}

void ConnectorsLoginModel::hiveOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = hivecon->HiveOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::hiveIntType, Constants::hiveOdbcStrType);
    emit hiveLoginStatus(response);
}

void ConnectorsLoginModel::snowflakeOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = snowflakecon->SnowflakeOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::snowflakeIntType, Constants::snowflakeOdbcStrType);
    emit snowflakeLoginStatus(response);
}

void ConnectorsLoginModel::teradataOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = teradatacon->TeradataOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::teradataIntType, Constants::teradataOdbcStrType);
    emit teradataLoginStatus(response);
}

void ConnectorsLoginModel::accessOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    QVariantMap response = accesscon->AccessOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::accessIntType, Constants::accessOdbcStrType);
    emit accessLoginStatus(response);
}

void ConnectorsLoginModel::excelOdbcLogin(QString driver, QString filename)
{
    QVariantMap response = excelcon->ExcelOdbcInstance(driver, filename);
    this->staticSetter(filename, Constants::sqlType, Constants::excelIntType, Constants::excelOdbcStrType);
    emit excelLoginStatus(response, true);
}

void ConnectorsLoginModel::csvLogin(QString filename, bool directLogin, QString separator)
{
    QVariantMap response = csvcon->CSVInstance(filename);
    Statics::separator = separator;

    this->staticSetter(filename, Constants::duckType, Constants::csvIntType);
    emit csvLoginStatus(response, directLogin);
}

void ConnectorsLoginModel::jsonLogin(QString filename, bool directLogin)
{
    QVariantMap response = jsoncon->JsonInstance(filename);
    this->staticSetter(filename, Constants::duckType, Constants::jsonIntType);
    emit jsonLoginStatus(response, directLogin);
}

void ConnectorsLoginModel::excelLogin(QString filename, bool directLogin)
{
    QVariantMap response = excelcon->ExcelInstance(filename);
    this->staticSetter(filename, Constants::duckType, Constants::excelIntType);
    emit excelLoginStatus(response, directLogin);
}

void ConnectorsLoginModel::sqlLogout()
{

    switch(Statics::currentDbIntType){
    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:

        mysqlcon->~MysqlCon();
        break;

    case Constants::sqliteIntType:
        sqlitecon->~Sqlitecon();
        break;

    case Constants::mssqlIntType:
        mssqlcon->~MSSqlCon();
        break;

    case Constants::postgresIntType:
        postgrescon->~PostgresCon();
        break;

    case Constants::excelIntType:
        excelcon->~ExcelCon();
        break;

    case Constants::mongoIntType:
        mongocon->~MongoCon();
        break;

    case Constants::redshiftIntType:
        redshiftcon->~RedshiftCon();
        break;

    case Constants::hiveIntType:
        hivecon->~HiveCon();
        break;

    case Constants::csvIntType:
        csvcon->~CSVCon();
        break;

    case Constants::impalaIntType:
        impalacon->~ImpalaCon();
        break;

    case Constants::jsonIntType:
        jsoncon->~JsonCon();
        break;

    case Constants::accessIntType:
        accesscon->~AccessCon();
        break;

    case Constants::oracleIntType:
        oraclecon->~OracleCon();
        break;

    case Constants::snowflakeIntType:
        snowflakecon->~SnowflakeCon();
        break;

    case Constants::teradataIntType:
        teradatacon->~TeradataCon();
        break;
    }

    this->staticRemover();
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

        dataBase = QFileInfo(m_connectedDB).baseName();
        QString baseDb = "";
        for(int i = 0; i < dataBase.length(); i++){

            if(dataBase[i].isLetter() || dataBase[i].isDigit()){
                baseDb = baseDb + dataBase[i];
            }
        }
        dataBase = baseDb;
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

void ConnectorsLoginModel::staticSetter(QString dbName, QString classification, int intType, QString strType)
{
    Statics::currentDbName = dbName;
    Statics::currentDbClassification = classification;
    Statics::currentDbIntType = intType;
    Statics::currentDbStrType = strType;

    if(classification == Constants::duckType){
        QFileInfo fi(dbName);
        dbName = fi.baseName();

        emit sendDbName();
    }

    this->setConnectedDB(dbName);
    emit dSSelected(true);
    emit connectedDBType(classification);
}

void ConnectorsLoginModel::staticRemover()
{

    Statics::currentDbName = "";
    Statics::currentDbClassification = "";
    Statics::currentDbIntType = 0;
    Statics::currentDbStrType = "";

    emit dSSelected(false);
}

