#include "saveliveforwardonlyworker.h"

SaveLiveForwardOnlyWorker::SaveLiveForwardOnlyWorker(bool ifSavePassword)
{
    this->ifSavePassword = ifSavePassword;
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

    switch(Statics::currentDbIntType){

    case Constants::redshiftIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "redshiftQ");
        dbForward.setDatabaseName(Statics::redshiftDb);
        dbForward.setHostName(Statics::redshiftHost);
        dbForward.setPort(Statics::redshiftPort);
        dbForward.setUserName(Statics::redshiftUsername);
        dbForward.setPassword(Statics::redshiftPassword);
        dbForward.open();

        break;

    case Constants::snowflakeIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "snowflakeQ");
        dbForward.setDatabaseName(Statics::snowflakeDb);
        dbForward.setHostName(Statics::snowflakeHost);
        dbForward.setPort(Statics::snowflakePort);
        dbForward.setUserName(Statics::snowflakeUsername);
        dbForward.setPassword(Statics::snowflakePassword);
        dbForward.open();

        break;

    case Constants::teradataIntType:
        dbForward = QSqlDatabase::addDatabase("QODBC", "teradataQ");
        dbForward.setDatabaseName(Statics::teradataDb);
        dbForward.setHostName(Statics::teradataHost);
        dbForward.setPort(Statics::teradataPort);
        dbForward.setUserName(Statics::teradataUsername);
        dbForward.setPassword(Statics::teradataPassword);
        dbForward.open();

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
    QString tableInserQuery = "INSERT INTO " + Constants::masterLiveTable + " VALUES ('" + fileName + "', '" + Constants::appVersion + "', '" + Constants::currentMode + "', '" + Constants::extractVersion + "', '" + uniqueHash + "',  '" + QString::number(currentTimestamp) + "')";

    QString password = this->ifSavePassword ? dbForward.password() : "";
    QString credentialsCreateQuery = "CREATE TABLE " + Constants::masterCredentialsTable + "(username VARCHAR, password VARCHAR, host VARCHAR, port INTEGER, database VARCHAR)";
    QString credentialsInsertQuery = "INSERT INTO " + Constants::masterCredentialsTable + " VALUES ('" + dbForward.userName() + "', '" + password + "', '" + dbForward.hostName() + "', '" + dbForward.port() + "', '" + dbForward.databaseName() + "')";

    auto tableCreate = con.Query(tableCreateQuery.toStdString());
    if(!tableCreate->success) qDebug() << tableCreate->error.c_str() << tableCreateQuery;
    auto tableInsert = con.Query(tableInserQuery.toStdString());
    if(!tableInsert->success) qDebug() << tableInsert->error.c_str() << tableInserQuery;

    auto credentialsCreate = con.Query(tableCreateQuery.toStdString());
    if(!credentialsCreate->success) qDebug() << credentialsCreate->error.c_str() << credentialsCreateQuery;
    auto credentialsInsert = con.Query(tableInserQuery.toStdString());
    if(!credentialsInsert->success) qDebug() << credentialsInsert->error.c_str() << credentialsInsertQuery;
}
