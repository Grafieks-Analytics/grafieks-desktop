#include "calculatedfields.h"

CalculatedFields::CalculatedFields(QObject *parent) : QObject(parent)
{

}

bool CalculatedFields::addCalculatedField(QString name, QString query, QString source, QString mode)
{
    QStringList detailsList;
    QString masterSqlQuery;

    if(!this->calculatedFields.contains(name)){


        qDebug() << query;
        masterSqlQuery = calculatedFieldSyntax.CaseCondition(query, Statics::dsType);
//        getSqlQuery(query);

        detailsList << name << this->columnName << this->columnType << query << source << masterSqlQuery;
        this->calculatedFields.insert(name, detailsList);

        // Identify source of the db (extract/live)
        // Add calculated column table with field, table names, query (for live)
        // Add table for calculated fields with single result or Add Column fields with same number of rows
        // Fill values

        if(Statics::dsType == Constants::extractType){

            bool status = fetchExtractCalculatedValues(masterSqlQuery);
            if (!status){
                return false;
            }

        } else {

            bool status = fetchLiveCalculatedValues(masterSqlQuery);
            if (!status){
                return false;
            }
        }


        bool saveStatus = saveCalculatedFields(name, this->columnName, this->columnType, masterSqlQuery, source, mode, Statics::dsType);

        if (!saveStatus){
            return false;
        }
    }

    emit signalCalculatedFields(this->calculatedFields);
    return true;

}

void CalculatedFields::fetchCalculatedFields()
{
    qDebug() << "CALLED FETCH CALCULATED";
    emit signalCalculatedFields(this->calculatedFields);
}

void CalculatedFields::setCalculatedFieldName(QString columnName)
{
    this->columnName = columnName;
}

void CalculatedFields::setCalculatedFieldType(QString columnType)
{
    this->columnType = columnType;
}

void CalculatedFields::dispatchCalculatedField(duckdb::Connection *con)
{

    QString selectQuery = "SELECT * FROM " + Constants::masterCalculatedFieldsTable;
    auto data = con->Query(selectQuery.toStdString());

    if(data->error.empty()){
        int rows = data->collection.Count();


        for(int i = 0; i < rows; i++){
            QStringList values;
            QString key = data->GetValue(0, i).ToString().c_str();

            values.append( data->GetValue(0, i).ToString().c_str());
            values.append( data->GetValue(1, i).ToString().c_str());
            values.append( data->GetValue(2, i).ToString().c_str());
            values.append( data->GetValue(3, i).ToString().c_str());

            this->calculatedFields.insert(key, values);
        }
    } else{
        qWarning() << Q_FUNC_INFO << data->error.c_str();
    }


    emit signalCalculatedFields(this->calculatedFields);
}

void CalculatedFields::dispatchCalculatedFieldsWithoutConnection()
{
    // Fetch data from duckdb
    QString extractPath = Statics::extractPath;
    duckdb::DuckDB db(extractPath.toStdString());
    duckdb::Connection con(db);
    this->dispatchCalculatedField(&con);
}

QString CalculatedFields::getSqlQuery(QString stdQuery)
{
    QString masterQuery = stdQuery;
    masterQuery.replace("[", "");
    masterQuery.replace("]", "");



    return masterQuery;

}

bool CalculatedFields::saveCalculatedFields(QString name, QString colName, QString colType, QString masterSqlQuery, QString source, QString mode, QString datasourceType)
{
    QString dbPath;
    if (datasourceType == Constants::extractType) {
        dbPath = Statics::extractPath;
    } else {
        dbPath = Statics::livePath;
    }


    qDebug() << "SAVE EXTRACT/LIVE" << dbPath;

    try{
        duckdb::DuckDB db(dbPath.toStdString());
        duckdb::Connection con(db);

        QString queryCreateTable = "CREATE TABLE IF NOT EXISTS " + Constants::masterCalculatedFieldsTable + " (name VARCHAR, col_name VARCHAR, col_type VARCHAR, query_base64 VARCHAR, source VARCHAR)";

        auto createTable = con.Query(queryCreateTable.toStdString());
        if(!createTable->error.empty()){
            qDebug() << Q_FUNC_INFO << createTable->success << queryCreateTable << createTable->error.c_str();
            return false;
        }

        QString insertQuery = "INSERT INTO " + Constants::masterCalculatedFieldsTable + " VALUES ('" + name + "', '" + colName +"', '" + colType+ "','" + masterSqlQuery.toUtf8().toBase64() + "', '" + source +"')";

        auto insertQueryTable = con.Query(insertQuery.toStdString());
        if(!insertQueryTable->error.empty()){
            qDebug() << Q_FUNC_INFO << insertQueryTable->success << insertQuery << insertQueryTable->error.c_str();
            return false;
        }
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
        return false;
    }

    return true;
}

bool CalculatedFields::fetchExtractCalculatedValues(QString masterCalculatedFieldsTable)
{
    QString extractPath = Statics::extractPath;
    try{
        duckdb::DuckDB db(extractPath.toStdString());
        duckdb::Connection con(db);


        auto queryTable = con.Query(masterCalculatedFieldsTable.toStdString());
        if(!queryTable->error.empty()){
            qDebug() << Q_FUNC_INFO << queryTable->success << masterCalculatedFieldsTable << queryTable->error.c_str();
            return false;
        }
        queryTable->Print();
    } catch(std::exception &e){
        qWarning() << Q_FUNC_INFO << e.what();
        return false;
    }

    return true;
}

bool CalculatedFields::fetchLiveCalculatedValues(QString calculatedFieldQuery)
{
    QSqlDatabase connection;
    QStringList liveParams;
    QString whereCondition;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        connection = QSqlDatabase::addDatabase("QMYSQL", "mysqlQ");
        connection.setHostName(Statics::myHost);
        connection.setPort(Statics::myPort);
        connection.setDatabaseName(Statics::myDb);
        connection.setUserName(Statics::myUsername);
        connection.setPassword(Statics::myPassword);

        connection.open();
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
        break;
    }

    case Constants::redshiftIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "redshiftQ");

        connection.setDatabaseName(Statics::redshiftDb);
        connection.setHostName(Statics::redshiftHost);
        connection.setPort(Statics::redshiftPort);
        connection.setUserName(Statics::redshiftUsername);
        connection.setPassword(Statics::redshiftPassword);

        connection.open();
        break;
    }

    case Constants::teradataIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "teradataQ");

        connection.setDatabaseName(Statics::teradataDb);
        connection.setHostName(Statics::teradataHost);
        connection.setPort(Statics::teradataPort);
        connection.setUserName(Statics::teradataUsername);
        connection.setPassword(Statics::teradataPassword);

        connection.open();
        break;
    }

    case Constants::snowflakeIntType:{
        connection = QSqlDatabase::addDatabase("QODBC", "snowflakeQ");

        connection.setDatabaseName(Statics::snowflakeDb);
        connection.setHostName(Statics::snowflakeHost);
        connection.setPort(Statics::snowflakePort);
        connection.setUserName(Statics::snowflakeUsername);
        connection.setPassword(Statics::snowflakePassword);

        connection.open();
        break;
    }
    }

    liveParams = this->fetchLiveWhereJoinConditions();

    if(liveParams.at(0).length() > 0) {
        whereCondition = " WHERE " + liveParams.at(0);
    }

    calculatedFieldQuery += " " + liveParams.at(1) + whereCondition + " FROM " + liveParams.at(2);
    qDebug() << calculatedFieldQuery;
    QSqlQuery query(calculatedFieldQuery, connection);

    if(query.lastError().NoError){
        qDebug() << Q_FUNC_INFO << query.lastQuery() << query.lastError();
        return false;
    }

    return true;
}

QStringList CalculatedFields::fetchLiveWhereJoinConditions()
{
    QStringList output;
    QString livePath = Statics::livePath;
    QString queryWhereJoinParams = "SELECT * FROM " + Constants::masterQueryPartLiveTable;

    duckdb::DuckDB db(livePath.toStdString());
    duckdb::Connection con(db);

    auto data = con.Query(queryWhereJoinParams.toStdString());

    QString whereParams = data->GetValue(1, 0).ToString().c_str();
    QString joinParams = data->GetValue(2, 0).ToString().c_str();
    QString masterTable = data->GetValue(3, 0).ToString().c_str();

    output << whereParams << joinParams << masterTable;

    return output;
}

void CalculatedFields::listCalculatedFields()
{

}
