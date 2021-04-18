#include "querystatsmodel.h"

QueryStatsModel::QueryStatsModel(QObject *parent) : QSqlQueryModel(parent),
    m_profileStatus(false)
{

}

void QueryStatsModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    if(QSqlQueryModel::lastError().type() != QSqlError::NoError)
        qWarning() << QSqlQueryModel::lastError();

    generateRoleNames();
}

void QueryStatsModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    if(QSqlQueryModel::lastError().type() != QSqlError::NoError)
        qWarning() << QSqlQueryModel::lastError();

    generateRoleNames();
}

QVariant QueryStatsModel::data(const QModelIndex &index, int role) const
{
    QVariant value;

    if(role < Qt::UserRole) {
        value = QSqlQueryModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }

    return value;
}

QHash<int, QByteArray> QueryStatsModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void QueryStatsModel::setProfiling(bool status)
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbMysql);

        } else{
            this->setQuery("SET profiling = 0", dbMysql);
        }

        break;
    }

    case Constants::mysqlOdbcIntType:{
        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbMysqlOdbc);

        } else{
            this->setQuery("SET profiling = 0", dbMysqlOdbc);
        }

        break;
    }


    case Constants::sqliteIntType:{
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        if(status == true){
            this->setQuery("sqlite3_profile(SET profiling = 1)", dbSqlite);

        } else{
            this->setQuery("SET profiling = 0", dbSqlite);
        }

        break;
    }

    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbPostgres);

        } else{
            this->setQuery("SET profiling = 0", dbPostgres);
        }

        break;
    }

    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbRedshift);

        } else{
            this->setQuery("SET profiling = 0", dbRedshift);
        }

        break;
    }
    case Constants::mssqlIntType:{

        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbMssql);

        } else{
            this->setQuery("SET profiling = 0", dbMssql);
        }

        break;
    }

    case Constants::oracleIntType:{

        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbOracle);

        } else{
            this->setQuery("SET profiling = 0", dbOracle);
        }

        break;
    }

    case Constants::mongoIntType:{

        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbMongo);

        } else{
            this->setQuery("SET profiling = 0", dbMongo);
        }

        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbImpala);

        } else{
            this->setQuery("SET profiling = 0", dbImpala);
        }

        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbHive);

        } else{
            this->setQuery("SET profiling = 0", dbHive);
        }

        break;
    }

    }

}

void QueryStatsModel::resetProfiling()
{
    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery("SET profiling = 0", dbMysql);
        this->setQuery("SET profiling_history_size = 0", dbMysql);
        this->setQuery("SET profiling_history_size = 100", dbMysql);
        this->setQuery("SET profiling = 1", dbMysql);

        break;
    }

    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        this->setQuery("SET profiling = 0", dbMysqlOdbc);
        this->setQuery("SET profiling_history_size = 0", dbMysqlOdbc);
        this->setQuery("SET profiling_history_size = 100", dbMysqlOdbc);
        this->setQuery("SET profiling = 1", dbMysqlOdbc);

        break;
    }


    case Constants::sqliteIntType:{

        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        this->setQuery("SET profiling = 0", dbSqlite);
        this->setQuery("SET profiling_history_size = 0", dbSqlite);
        this->setQuery("SET profiling_history_size = 100", dbSqlite);
        this->setQuery("SET profiling = 1", dbSqlite);

        break;
    }

    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        this->setQuery("SET profiling = 0", dbPostgres);
        this->setQuery("SET profiling_history_size = 0", dbPostgres);
        this->setQuery("SET profiling_history_size = 100", dbPostgres);
        this->setQuery("SET profiling = 1", dbPostgres);

        break;
    }

    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrQueryType);
        this->setQuery("SET profiling = 0", dbRedshift);
        this->setQuery("SET profiling_history_size = 0", dbRedshift);
        this->setQuery("SET profiling_history_size = 100", dbRedshift);
        this->setQuery("SET profiling = 1", dbRedshift);

        break;
    }

    case Constants::mssqlIntType:{

        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        this->setQuery("SET profiling = 0", dbMssql);
        this->setQuery("SET profiling_history_size = 0", dbMssql);
        this->setQuery("SET profiling_history_size = 100", dbMssql);
        this->setQuery("SET profiling = 1", dbMssql);

        break;
    }

    case Constants::oracleIntType:{

        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        this->setQuery("SET profiling = 0", dbOracle);
        this->setQuery("SET profiling_history_size = 0", dbOracle);
        this->setQuery("SET profiling_history_size = 100", dbOracle);
        this->setQuery("SET profiling = 1", dbOracle);

        break;
    }

    case Constants::mongoIntType:{

        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        this->setQuery("SET profiling = 0", dbMongo);
        this->setQuery("SET profiling_history_size = 0", dbMongo);
        this->setQuery("SET profiling_history_size = 100", dbMongo);
        this->setQuery("SET profiling = 1", dbMongo);

        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);
        this->setQuery("SET profiling = 0", dbImpala);
        this->setQuery("SET profiling_history_size = 0", dbImpala);
        this->setQuery("SET profiling_history_size = 100", dbImpala);
        this->setQuery("SET profiling = 1", dbImpala);

        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);
        this->setQuery("SET profiling = 0", dbHive);
        this->setQuery("SET profiling_history_size = 0", dbHive);
        this->setQuery("SET profiling_history_size = 100", dbHive);
        this->setQuery("SET profiling = 1", dbHive);

        break;
    }

    }
}

void QueryStatsModel::showStats()
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery("SHOW profiles", dbMysql);

        break;
    }

    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        this->setQuery("SHOW profiles", dbMysqlOdbc);

        break;
    }

    case Constants::sqliteIntType:{

        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        this->setQuery("SHOW profiles", dbSqlite);

        break;
    }
    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        this->setQuery("SHOW profiles", dbPostgres);

        break;
    }

    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrQueryType);
        this->setQuery("SHOW profiles", dbRedshift);

        break;
    }

    case Constants::mssqlIntType:{

        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        this->setQuery("SHOW profiles", dbMssql);

        break;
    }

    case Constants::oracleIntType:{

        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        this->setQuery("SHOW profiles", dbOracle);

        break;
    }

    case Constants::mongoIntType:{

        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        this->setQuery("SHOW profiles", dbMongo);

        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);
        this->setQuery("SHOW profiles", dbImpala);

        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);
        this->setQuery("SHOW profiles", dbHive);

        break;
    }
    }
}


bool QueryStatsModel::profileStatus() const
{
    return m_profileStatus;
}

void QueryStatsModel::setProfileStatus(bool profileStatus)
{
    if (m_profileStatus == profileStatus)
        return;

    m_profileStatus = profileStatus;
    emit profileStatusChanged(m_profileStatus);
}


void QueryStatsModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "tableName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}

QVariant QueryStatsModel::showErrorMessage(const QString &query)
{
    QVariant message;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        QSqlQuery queryResult(query, dbMysql);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        QSqlQuery queryResult(query, dbMysqlOdbc);
        message = queryResult.lastError().text();
        break;
    }


    case Constants::sqliteIntType:{

        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        QSqlQuery queryResult(query, dbSqlite);
        message = queryResult.lastError().text();
        break;
    }
    case Constants::postgresIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        QSqlQuery queryResult(query, dbPostgres);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::redshiftIntType:{

        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrQueryType);
        QSqlQuery queryResult(query, dbRedshift);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::mssqlIntType:{

        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        QSqlQuery queryResult(query, dbMssql);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::oracleIntType:{

        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        QSqlQuery queryResult(query, dbOracle);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::mongoIntType:{

        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        QSqlQuery queryResult(query, dbMongo);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::impalaIntType:{

        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);
        QSqlQuery queryResult(query, dbImpala);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::hiveIntType:{

        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);
        QSqlQuery queryResult(query, dbHive);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::snowflakeIntType:{

        QSqlDatabase dbSnowflake = QSqlDatabase::database(Constants::snowflakeOdbcStrQueryType);
        QSqlQuery queryResult(query, dbSnowflake);
        message = queryResult.lastError().text();
        break;
    }

    case Constants::teradataIntType:{

        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrQueryType);
        QSqlQuery queryResult(query, dbTeradata);
        message = queryResult.lastError().text();
        break;
    }
    }

    return message;
}
