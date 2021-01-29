#include "querystatsmodel.h"

QueryStatsModel::QueryStatsModel(QObject *parent) : QSqlQueryModel(parent),
    m_profileStatus(false)
{

}

void QueryStatsModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void QueryStatsModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
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

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbMysql);

        } else{
            this->setQuery("SET profiling = 0", dbMysql);
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

    case Constants::postgresIntType:
    case Constants::redshiftIntType:{

        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        if(status == true){
            this->setQuery("SET profiling = 1", dbPostgres);

        } else{
            this->setQuery("SET profiling = 0", dbPostgres);
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

    }

}

void QueryStatsModel::resetProfiling()
{
    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery("SET profiling = 0", dbMysql);
        this->setQuery("SET profiling_history_size = 0", dbMysql);
        this->setQuery("SET profiling_history_size = 100", dbMysql);
        this->setQuery("SET profiling = 1", dbMysql);

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

    }
}

void QueryStatsModel::showStats()
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery("SHOW profiles", dbMysql);

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

    case Constants::mysqlIntType:
    case Constants::mysqlOdbcIntType:{

        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        QSqlQuery queryResult(query, dbMysql);
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
    }

    return message;
}
