#include "querymodel.h"


QueryModel::QueryModel(QObject *parent): QSqlQueryModel(parent)
{

}

void QueryModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void QueryModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

QVariant QueryModel::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> QueryModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

void QueryModel::callSql(QString tmpSql)
{

    this->executeQuery(tmpSql);
}


void QueryModel::receiveFilterQuery(QString &filteredQuery)
{
    this->executeQuery(filteredQuery);
}

void QueryModel::generateRoleNames()
{
    m_roleNames.clear();
    for( int i = 0; i < record().count(); i ++) {
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}

void QueryModel::executeQuery(QString &query)
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrQueryType);
        this->setQuery(query, dbMysql);

        break;
    }

    case Constants::mysqlOdbcIntType:{
        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrQueryType);
        this->setQuery(query, dbMysqlOdbc);

        break;
    }

    case Constants::sqliteIntType:{
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrQueryType);
        this->setQuery(query, dbSqlite);

        break;
    }
    case Constants::postgresIntType:{
        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrQueryType);
        this->setQuery(query, dbPostgres);

        break;
    }

    case Constants::redshiftIntType:{
        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrQueryType);
        this->setQuery(query, dbRedshift);

        break;
    }

    case Constants::excelIntType:{
        QSqlDatabase dbExcel = QSqlDatabase::database(Constants::excelStrQueryType);
        this->setQuery(query, dbExcel);

        break;
    }
    case Constants::mssqlIntType:{
        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrQueryType);
        this->setQuery(query, dbMssql);

        break;
    }

    case Constants::oracleIntType:{
        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrQueryType);
        this->setQuery(query, dbOracle);

        break;
    }

    case Constants::mongoIntType:{
        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrQueryType);
        this->setQuery(query, dbMongo);

        break;
    }

    case Constants::impalaIntType:{
        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrQueryType);
        this->setQuery(query, dbImpala);

        break;
    }

    case Constants::hiveIntType:{
        QSqlDatabase dbHive = QSqlDatabase::database(Constants::hiveOdbcStrQueryType);
        this->setQuery(query, dbHive);

        break;
    }

    case Constants::snowflakeIntType:{
        QSqlDatabase dbSnowflake = QSqlDatabase::database(Constants::snowflakeOdbcStrQueryType);
        this->setQuery(query, dbSnowflake);

        break;
    }

    case Constants::teradataIntType:{
        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrQueryType);
        this->setQuery(query, dbTeradata);

        break;
    }

    case Constants::accessIntType:{
        QSqlDatabase dbAccess = QSqlDatabase::database(Constants::accessOdbcStrQueryType);
        this->setQuery(query, dbAccess);

        break;
    }

    }
}
