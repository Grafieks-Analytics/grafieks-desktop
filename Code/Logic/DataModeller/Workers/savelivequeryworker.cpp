#include "savelivequeryworker.h"

SaveLiveQueryWorker::SaveLiveQueryWorker(QString tmpSql, QVariantMap changedColumnTypes, bool ifSavePassword)
{
    this->tmpSql = tmpSql;
    this->changedColumnTypes = changedColumnTypes;
//    this->ifSavePassword = ifSavePassword;
    this->ifSavePassword = true;

    querySplitter.setQuery(this->tmpSql);

}

void SaveLiveQueryWorker::run()
{

    QString livePath = Statics::livePath;
    QString tableName = Statics::currentDbName;

    // Remove live file if already exists
    QFile fileRemove(livePath);
    if(fileRemove.exists()) {
        QString tmpFile = livePath;
        tmpFile.append(".wal");

        QFile fileTmpRemove(tmpFile);

        fileTmpRemove.remove();
        fileRemove.remove();
    }

    duckdb::DuckDB db(livePath.toStdString());
    duckdb::Connection con(db);

    QString fileName = QFileInfo(tableName).baseName().toLower();
    fileName = fileName.remove(QRegularExpression("[^A-Za-z0-9]"));

    QString errorMsg =  "";
    QSqlDatabase connection;
    QString realDbName;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        connection = QSqlDatabase::addDatabase("QMYSQL", "mysqlQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);

        connection.open();

        realDbName = Statics::myRealDbName;
        break;
    }

    case Constants::mysqlOdbcIntType:{
        connection = QSqlDatabase::addDatabase("ODBC", "mysqlOQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);

        connection.open();

        realDbName = Statics::myRealDbName;
        break;
    }

    case Constants::sqliteIntType:{
        connection = QSqlDatabase::addDatabase("QSQLITE", "sqliteQ");
        connection.setDatabaseName(Statics::sqliteFile);
        connection.open();
        break;
    }
    case Constants::postgresIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "postgresQ");

        connection.setDatabaseName(Statics::postgresDb);
        connection.setHostName(Statics::postgresHost);
        connection.setPort(Statics::postgresPort);
        connection.setUserName(Statics::postgresUsername);
        connection.setPassword(Statics::postgresPassword);

        connection.open();

        realDbName = Statics::postgresRealDbName;
        break;
    }

    case Constants::mssqlIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "mssqlQ");

        connection.setDatabaseName(Statics::msDb);
        connection.setHostName(Statics::msHost);
        connection.setPort(Statics::msPort);
        connection.setUserName(Statics::msUsername);
        connection.setPassword(Statics::msPassword);

        connection.open();

        realDbName = Statics::msRealDbName;
        break;
    }

    case Constants::oracleIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "oracleQ");

        connection.setDatabaseName(Statics::oracleDb);
        connection.setHostName(Statics::oracleHost);
        connection.setPort(Statics::oraclePort);
        connection.setUserName(Statics::oracleUsername);
        connection.setPassword(Statics::oraclePassword);

        connection.open();

        realDbName = Statics::oracleRealDbName;
        break;
    }

    case Constants::mongoIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "mongoQ");

        connection.setDatabaseName(Statics::mongoDb);
        connection.setHostName(Statics::mongoHost);
        connection.setPort(Statics::mongoPort);
        connection.setUserName(Statics::mongoUsername);
        connection.setPassword(Statics::mongoPassword);

        connection.open();

        realDbName = Statics::mongoRealDbName;
        break;
    }

    }

    // Create a master table to refer the name of actual extract tableName
    // while running an extract later on

    // Current timestamp
    quint64 currentTimestamp = QDateTime::currentMSecsSinceEpoch();

    // This is to identify the live file irrespective of its filename
    // This will not change when updated
    GeneralParamsModel generalParamsModel;
    QString uniqueHash = generalParamsModel.randomStringGenerator();

    QString tableCreateQuery = "CREATE TABLE " + Constants::masterLiveTable + "(tableName VARCHAR, app_version VARCHAR, mode VARCHAR, extract_version INTEGER, unique_hash VARCHAR,  last_update VARCHAR)";
    QString tableInsertQuery = "INSERT INTO " + Constants::masterLiveTable + " VALUES ('" + fileName + "', '" + Constants::appVersion + "', '" + Constants::currentMode + "', '" + Constants::extractVersion + "', '" + uniqueHash + "',  '" + QString::number(currentTimestamp) + "')";

//    SimpleCrypt crypto(Q_UINT64_C(0x0c2ad4a4acb9f023));
    simpleCrypt.setKey(Secret::simpleCryptHash);
    QString password = this->ifSavePassword ? simpleCrypt.encryptToString(connection.password()) : "";
    int portTmp = connection.port();
    QString port = connection.port() == NULL ? "NULL" : QString::number(portTmp);
    QString credentialsCreateQuery = "CREATE TABLE " + Constants::masterCredentialsTable + "(username VARCHAR, password VARCHAR, host VARCHAR, port VARCHAR, database VARCHAR, db_type VARCHAR, real_db_name VARCHAR)";
    QString credentialsInsertQuery = "INSERT INTO " + Constants::masterCredentialsTable + " VALUES ('" + connection.userName() + "', '" + password + "', '" + connection.hostName() + "', '"+ port +"', '" + connection.databaseName() + "', '" + QString::number(Statics::currentDbIntType) + "', '" + realDbName + "')";


    QStringList selectParams = this->querySplitter.getSelectParams();
    QString selectParamsString;
    foreach(QString selectParam, selectParams){
        selectParamsString += selectParam + ", ";
    }
    selectParamsString.chop(2);

    QString whereConditions = this->querySplitter.getWhereCondition();
    QString joinConditions = this->querySplitter.getJoinConditions();
    QString masterTable = this->querySplitter.getMainTable();

    if(whereConditions.contains("\'")){
        whereConditions.replace(R"(')", R"('')");
    }

    QString queryPartCreateQuery = "CREATE TABLE " + Constants::masterQueryPartLiveTable + "(select_params VARCHAR, where_params VARCHAR, join_params VARCHAR, master_table VARCHAR)";
    QString queryPartInsertQuery = "INSERT INTO " + Constants::masterQueryPartLiveTable + " VALUES ('" + selectParamsString + "', '" + whereConditions + "', '" + joinConditions + "', '" + masterTable + "')";


    auto tableCreate = con.Query(tableCreateQuery.toStdString());
    if(!tableCreate->success) qDebug() << tableCreate->error.c_str() << tableCreateQuery;
    auto tableInsert = con.Query(tableInsertQuery.toStdString());
    if(!tableInsert->success) qDebug() << tableInsert->error.c_str() << tableInsertQuery;

    auto credentialsCreate = con.Query(credentialsCreateQuery.toStdString());
    if(!credentialsCreate->success) qDebug() << credentialsCreate->error.c_str() << credentialsCreateQuery;
    auto credentialsInsert = con.Query(credentialsInsertQuery.toStdString());
    if(!credentialsInsert->success) qDebug() << credentialsInsert->error.c_str() << credentialsInsertQuery;

    auto queryPartCreate = con.Query(queryPartCreateQuery.toStdString());
    if(!queryPartCreate->success) qDebug() << queryPartCreate->error.c_str() << queryPartCreateQuery;
    auto queryPartInsert = con.Query(queryPartInsertQuery.toStdString());
    if(!queryPartInsert->success) qDebug() << queryPartInsert->error.c_str() << queryPartInsertQuery;

    if(tableCreate->success && tableInsert->success && credentialsCreate->success && credentialsInsert->success && queryPartCreate->success && queryPartInsert->success){
        emit saveLiveComplete("", selectParamsString, whereConditions, joinConditions, masterTable);
    } else {
        emit saveLiveComplete("Some error occured while saving live file", "", "", "", "");
    }

}
