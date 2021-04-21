#include "dblistmodel.h"

/*!
 * \brief Constructor function for ColumnListModel
 * \param parent
 */
DBListModel::DBListModel(QObject *parent):
    QSqlQueryModel(parent)
{

}

DBListModel::~DBListModel()
{
    m_roleNames.clear();
}

/*!
 * \brief Override QSqlQueryModel::setQuery (Overloaded)
 * \details Executes the query query for the given database connection db. If no database (or an invalid database) is specified,
 * the default connection is used.
 * \param query (sql query)
 * \param db (database)
 */
void DBListModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    if(QSqlQueryModel::lastError().type() != QSqlError::NoError)
        qWarning() << Q_FUNC_INFO << QSqlQueryModel::lastError();

    generateRoleNames();
}

/*!
 * \brief Override QSqlQueryModel::setQuery
 * \details Executes the query query for the given database connection db. If no database (or an invalid database) is specified,
 * the default connection is used.
 * \param query (sql query)
 */
void DBListModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    if(QSqlQueryModel::lastError().type() != QSqlError::NoError)
        qWarning() << Q_FUNC_INFO << QSqlQueryModel::lastError();

    generateRoleNames();
}

/*!
 * \brief Override QSqlQueryModel::data
 * \details Override method to return the data of the object for a given index
 * \param index (object index)
 * \param role (object role)
 * \return QVariant
 */
QVariant DBListModel::data(const QModelIndex &index, int role) const
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

/*!
 * \brief Override QSqlQueryModel::roleNames
 * \details Override method to tell the view the exact role names with which the value can be accessed from the object
 * \return QHash<int, QByteArray>
 */
QHash<int, QByteArray> DBListModel::roleNames() const
{
    return m_roleNames;
}

/*!
 * \brief Set a new select query for a given database name
 * \param queryString (database name for like query)
 */
void DBListModel::callQuery(QString queryString)
{

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);

        if(queryString != ""){
            this->setQuery("SHOW DATABASES LIKE '%"+queryString+"%'", dbMysql);
        } else{
            this->setQuery("SHOW DATABASES", dbMysql);
        }

        break;
    }

    case Constants::mysqlOdbcIntType:{
        QSqlDatabase dbMysqlOdbc = QSqlDatabase::database(Constants::mysqlOdbcStrType);

        if(queryString != ""){
            this->setQuery("SHOW DATABASES LIKE '%"+queryString+"%'", dbMysqlOdbc);
        } else{
            this->setQuery("SHOW DATABASES", dbMysqlOdbc);
        }

        break;
    }


    case Constants::sqliteIntType:{
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrType);


        if(queryString != ""){
            this->setQuery("PRAGMA database_list", dbSqlite);
        } else{
            this->setQuery("PRAGMA database_list", dbSqlite);
        }

        break;
    }

    case Constants::postgresIntType:{
        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);

        if(queryString != ""){
            this->setQuery("SELECT datname FROM pg_database WHERE datistemplate = false AND datname LIKE '%"+queryString+"%'", dbPostgres);
        } else{
            this->setQuery("SELECT datname FROM pg_database WHERE datistemplate = false", dbPostgres);
        }

        break;
    }

    case Constants::redshiftIntType:{
        QSqlDatabase dbRedshift = QSqlDatabase::database(Constants::redshiftOdbcStrType);

        if(queryString != ""){
            this->setQuery("SELECT datname FROM pg_database WHERE datistemplate = false AND datname LIKE '%"+queryString+"%'", dbRedshift);
        } else{
            this->setQuery("SELECT datname FROM pg_database WHERE datistemplate = false", dbRedshift);
        }

        break;
    }

    case Constants::mssqlIntType:{
        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::postgresOdbcStrType);

        if(queryString != ""){
            this->setQuery("SELECT name FROM master.sys.databases AND name LIKE '%"+queryString+"%'", dbMssql);
        } else{
            this->setQuery("SELECT name FROM master.sys.databases", dbMssql);
        }

        break;
    }

    case Constants::oracleIntType:{
        QSqlDatabase dbOracle = QSqlDatabase::database(Constants::oracleOdbcStrType);

        // No direct query available in Oracle db
        // Will need to devise a way out when the query is required later

        break;
    }

    case Constants::mongoIntType:{
        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::mongoOdbcStrType);

        // No direct query available in Mongo db
        // Will need to devise a way out when the query is required later

        break;
    }

    case Constants::impalaIntType:{
        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::impalaOdbcStrType);

        // No direct query available in Impala db
        // Will need to devise a way out when the query is required later

        break;
    }
    case Constants::hiveIntType:{
        QSqlDatabase dbMongo = QSqlDatabase::database(Constants::hiveOdbcStrType);

        // No direct query available in Hive db
        // Will need to devise a way out when the query is required later

        break;
    }

    case Constants::snowflakeIntType:{
        QSqlDatabase dbImpala = QSqlDatabase::database(Constants::snowflakeOdbcStrType);

        // No direct query available in Snowflake db
        // Will need to devise a way out when the query is required later

        break;
    }
    case Constants::teradataIntType:{
        QSqlDatabase dbTeradata = QSqlDatabase::database(Constants::teradataOdbcStrType);

        // No direct query available in Teradata db
        // Will need to devise a way out when the query is required later

        break;
    }

    case Constants::accessIntType:{
        QSqlDatabase dbAccess = QSqlDatabase::database(Constants::accessOdbcStrType);

        // No direct query available in Access db
        // Will need to devise a way out when the query is required later

        break;
    }

    }
}


/*!
 * \brief Override QSqlQueryModel::generateRoleNames
 * \details Override method to generate a new rolename
 */
void DBListModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "dbName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}
