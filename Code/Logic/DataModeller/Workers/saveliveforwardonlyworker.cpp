#include "saveliveforwardonlyworker.h"

SaveLiveForwardOnlyWorker::SaveLiveForwardOnlyWorker(QString tmpSql, QVariantMap changedColumnTypes, bool ifSavePassword)
{
    this->tmpSql = tmpSql;
    this->changedColumnTypes = changedColumnTypes;
//    this->ifSavePassword = ifSavePassword;
    this->ifSavePassword = true;

    querySplitter.setQuery(this->tmpSql);
}

void SaveLiveForwardOnlyWorker::run()
{
    QString livePath = Statics::livePath;
    QString tableName = Statics::currentDbName;

    // Remove extract file if already exists
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
    QSqlDatabase dbForward;
    QString realDbName;

    switch(Statics::currentDbIntType){

    case Constants::redshiftIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "redshiftQ");
        dbForward.setDatabaseName(Statics::redshiftDb);
        dbForward.setHostName(Statics::redshiftHost);
        dbForward.setPort(Statics::redshiftPort);
        dbForward.setUserName(Statics::redshiftUsername);
        dbForward.setPassword(Statics::redshiftPassword);
        dbForward.open();

        realDbName = Statics::redshiftRealDbName;

        break;

    case Constants::snowflakeIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "snowflakeQ");
        dbForward.setDatabaseName(Statics::snowflakeDb);
        dbForward.setHostName(Statics::snowflakeHost);
        dbForward.setPort(Statics::snowflakePort);
        dbForward.setUserName(Statics::snowflakeUsername);
        dbForward.setPassword(Statics::snowflakePassword);
        dbForward.open();

        realDbName = Statics::snowflakeRealDbName;

        break;

    case Constants::teradataIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "teradataQ");
        dbForward.setDatabaseName(Statics::teradataDb);
        dbForward.setHostName(Statics::teradataHost);
        dbForward.setPort(Statics::teradataPort);
        dbForward.setUserName(Statics::teradataUsername);
        dbForward.setPassword(Statics::teradataPassword);
        dbForward.open();

        realDbName = Statics::teradataRealDbName;

        break;
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

    simpleCrypt.setKey(Secret::simpleCryptHash);
    QString password = this->ifSavePassword ? simpleCrypt.encryptToString(dbForward.password()) : "";
    QString port = QString::number(dbForward.port());

    QString credentialsCreateQuery = "CREATE TABLE " + Constants::masterCredentialsTable + "(username VARCHAR, password VARCHAR, host VARCHAR, port INTEGER, database VARCHAR, db_type VARCHAR, real_db_name VARCHAR)";
    QString credentialsInsertQuery = "INSERT INTO " + Constants::masterCredentialsTable + " VALUES ('" + dbForward.userName() + "', '" + password + "', '" + dbForward.hostName() + "', '" + port + "', '" + dbForward.databaseName() + "', '" + QString::number(Statics::currentDbIntType) + "', '" + realDbName + "')";

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
