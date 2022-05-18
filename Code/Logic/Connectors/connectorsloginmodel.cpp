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

    response = sqlitecon->SqliteInstance(filename);

    QFile sqliteFile(QUrl(filename).toLocalFile());
    QFileInfo fileInfo(sqliteFile.fileName());
    QString sqliteFileName = fileInfo.fileName();

    this->staticSetter(sqliteFileName, Constants::sqlType, Constants::sqliteIntType, Constants::sqliteStrType);
    emit sqliteLoginStatus(response);
}


void ConnectorsLoginModel::mysqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = mysqlcon->MysqlOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::mysqlOdbcIntType, Constants::mysqlOdbcStrType, false, driver);
    emit mysqlLoginStatus(response);
}


void ConnectorsLoginModel::mssqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{

    response = mssqlcon->MSSqlOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::mssqlIntType, Constants::mssqlOdbcStrType, false, driver);
    emit mssqlLoginStatus(response);
}

void ConnectorsLoginModel::postgresOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = postgrescon->PostgresOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::postgresIntType, Constants::postgresOdbcStrType, false, driver);
    emit postgresLoginStatus(response);

}

void ConnectorsLoginModel::redshiftOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = redshiftcon->RedshiftOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::forwardType, Constants::redshiftIntType, Constants::redshiftOdbcStrType, false, driver);
    emit redshiftLoginStatus(response);
}

void ConnectorsLoginModel::oracleOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = oraclecon->OracleOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::oracleIntType, Constants::oracleOdbcStrType, false, driver);
    emit postgresLoginStatus(response);
}

void ConnectorsLoginModel::mongoOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = mongocon->MongoOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::mongoIntType, Constants::mongoOdbcStrType, false, driver);
    emit mongoLoginStatus(response);

}

void ConnectorsLoginModel::impalaOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = impalacon->ImpalaOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::impalaIntType, Constants::impalaOdbcStrType, false, driver);
    emit impalaLoginStatus(response);
}

void ConnectorsLoginModel::hiveOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = hivecon->HiveOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::sqlType, Constants::hiveIntType, Constants::hiveOdbcStrType, false, driver);
    emit hiveLoginStatus(response);
}

void ConnectorsLoginModel::snowflakeOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = snowflakecon->SnowflakeOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::forwardType, Constants::snowflakeIntType, Constants::snowflakeOdbcStrType, false, driver);
    emit snowflakeLoginStatus(response);
}

void ConnectorsLoginModel::teradataOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password)
{
    response = teradatacon->TeradataOdbcInstance(driver, host, db, port, username, password);
    this->staticSetter(db, Constants::forwardType, Constants::teradataIntType, Constants::teradataOdbcStrType, false, driver);
    emit teradataLoginStatus(response);
}

void ConnectorsLoginModel::accessOdbcLogin(QString driver, QString db, QString username, QString password)
{
    response = accesscon->AccessOdbcInstance(driver, db, username, password);

    QFileInfo fileInfo(db);
    QString accessFileName = fileInfo.fileName();


    this->staticSetter(accessFileName, Constants::accessType, Constants::accessIntType, Constants::accessOdbcStrType, false, driver);
    emit accessLoginStatus(response);
}

void ConnectorsLoginModel::excelOdbcLogin(QString driver, QString filename)
{
    response = excelcon->ExcelOdbcInstance(driver, filename);
    this->staticSetter(filename, Constants::excelType, Constants::excelIntType, Constants::excelOdbcStrType, false, driver);
    emit excelLoginOdbcStatus(response, true);
}

void ConnectorsLoginModel::csvLogin(QString filename, bool directLogin, QString separator)
{
    Statics::csvJsonPath = filename;
    response = csvcon->CSVInstance(filename);

    Statics::separator = separator;

    this->staticSetter(filename, Constants::csvType, Constants::csvIntType, NULL, directLogin);
    emit csvLoginStatus(response, directLogin);
}

void ConnectorsLoginModel::jsonLogin(QString filename, bool directLogin)
{
//    response = jsoncon->JsonInstance(filename);
//    this->staticSetter(filename, Constants::jsonType, Constants::jsonIntType, NULL, directLogin);
//    emit jsonLoginStatus(response, directLogin);
    qDebug() << "JSON FILE" <<  filename;

    response = jsonnewcon->JsonInstance(filename);
    this->staticSetter(filename, Constants::jsonType, Constants::jsonIntType, NULL, directLogin);
    emit jsonLoginStatus(response, directLogin);
}

void ConnectorsLoginModel::excelLogin(QStringList driversList, QString filename)
{
    // Try with driver at 0 position only for the time being
    // Later we will loop for other drivers, if the earlier fails
    // Till its sure that we cant login with any of the drivers, if it fails

    response = excelcon->ExcelOdbcInstance(driversList.at(0), filename);
    this->staticSetter(filename, Constants::excelType, Constants::excelIntType, Constants::excelOdbcStrType, false, driversList.at(0));
    emit excelLoginStatus(response, true);
}

void ConnectorsLoginModel::sqlLogout()
{

    switch(Statics::currentDbIntType){
    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:

        mysqlcon->closeConnection();
        break;

    case Constants::sqliteIntType:
        sqlitecon->closeConnection();
        break;

    case Constants::mssqlIntType:
        mssqlcon->closeConnection();
        break;

    case Constants::postgresIntType:
        postgrescon->closeConnection();
        break;

    case Constants::excelIntType:
        excelcon->closeConnection();
        emit dropTables();
        break;

    case Constants::mongoIntType:
        mongocon->closeConnection();
        break;

    case Constants::redshiftIntType:
        redshiftcon->closeConnection();
        break;

    case Constants::hiveIntType:
        hivecon->closeConnection();
        break;

    case Constants::csvIntType:
        csvcon->closeConnection();
        emit dropTables();
        break;

    case Constants::impalaIntType:
        impalacon->closeConnection();
        break;

    case Constants::jsonIntType:
        jsoncon->closeConnection();
        emit dropTables();
        break;

    case Constants::accessIntType:
        accesscon->closeConnection();
        break;

    case Constants::oracleIntType:
        oraclecon->closeConnection();
        break;

    case Constants::snowflakeIntType:
        snowflakecon->closeConnection();
        break;

    case Constants::teradataIntType:
        teradatacon->closeConnection();
        break;
    }

    this->staticRemover();
    emit logout();
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

void ConnectorsLoginModel::staticSetter(QString dbName, QString classification, int intType, QString strType, bool directLogin, QString driverName)
{
    Statics::currentDbName = dbName;
    Statics::currentDbClassification = classification;
    Statics::currentDbIntType = intType;
    Statics::currentDbStrType = strType;
    Statics::driverName = driverName;

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
    Statics::driverName = "";

    emit dSSelected(false);
}


