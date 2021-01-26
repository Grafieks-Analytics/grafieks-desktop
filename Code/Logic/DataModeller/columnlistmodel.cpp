#include "columnlistmodel.h"

/*!
 * \brief Constructor function for ColumnListModel
 * \param parent
 */
ColumnListModel::ColumnListModel(QObject *parent) : QSqlQueryModel(parent)
{

}

/*!
 * \brief Override QSqlQueryModel::setQuery (Overloaded)
 * \details Executes the query query for the given database connection db. If no database (or an invalid database) is specified,
 * the default connection is used.
 * \param query (sql query)
 * \param db (database)
 */
void ColumnListModel::setQuery(const QString &query, const QSqlDatabase &db)
{
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

/*!
 * \brief Override QSqlQueryModel::setQuery
 * \details Executes the query query for the given database connection db. If no database (or an invalid database) is specified,
 * the default connection is used.
 * \param query (sql query)
 */
void ColumnListModel::setQuery(const QSqlQuery &query)
{
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

/*!
 * \brief Override QSqlQueryModel::data
 * \details Override method to return the data of the object for a given index
 * \param index (object index)
 * \param role (object role)
 * \return QVariant
 */
QVariant ColumnListModel::data(const QModelIndex &index, int role) const
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
QHash<int, QByteArray> ColumnListModel::roleNames() const
{
    return {{Qt::DisplayRole, "display"}};
}

/*!
 * \brief Set a new select query for a given column in table
 * \param columnName (name of the column in sql table)
 * \param tableName (table name)
 * \param pageNo (page number for limit query)
 */
void ColumnListModel::columnQuery(QString columnName, QString tableName, int pageNo)
{

    QString queryString;
    int lowerLimit = 0;
    int upperLimit = 0;
    int pageLimit = 1000;

    // Set the page limit
    // for the query

    if(pageNo == 0){
        lowerLimit = 0;
    } else{
        lowerLimit = pageNo * pageLimit;
    }

    upperLimit = lowerLimit + pageLimit;


    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    case Constants::mysqlOdbcIntType:{

        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    case Constants::sqliteIntType:{

        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrType);
        this->setQuery(queryString, dbSqlite);

        break;
    }

    case Constants::postgresIntType:{

        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);
        this->setQuery(queryString, dbPostgres);

        break;
    }

    case Constants::mssqlIntType:{

        queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " LIMIT " + QString::number(lowerLimit) + ", "+ QString::number(upperLimit);
        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrType);
        this->setQuery(queryString, dbMssql);

        break;
    }

    }
}

/*!
 * \brief Set a new select query for a given column on the basis of date format in table
 * \param columnName (name of the column in sql table)
 * \param tableName (table name)
 * \param value (type of date format)
 * \param pageNo (page number for limit query)
 */
void ColumnListModel::columnDateFormatQuery(QString columnName, QString tableName, int value, int pageNo)
{
    QString queryString;
    int lowerLimit = 0;
    int upperLimit = 0;
    int pageLimit = 1000;

    // Set the page limit
    // for the query

    if(pageNo == 0){
        lowerLimit = 0;
    } else{
        lowerLimit = pageNo * pageLimit;
    }

    upperLimit = lowerLimit + pageLimit;


    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        QString queryString = mysqlDateConversion.convertDateQuery(columnName, tableName, lowerLimit, upperLimit, value);
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    case Constants::mysqlOdbcIntType:{

        QString queryString = mysqlDateConversion.convertDateQuery(columnName, tableName, lowerLimit, upperLimit, value);
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    case Constants::sqliteIntType:{

        QString queryString = sqliteDateConversion.convertDateQuery(columnName, tableName, lowerLimit, upperLimit, value);
        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrType);
        this->setQuery(queryString, dbSqlite);

        break;
    }

    case Constants::postgresIntType:{

        QString queryString = postgresDateConversion.convertDateQuery(columnName, tableName, lowerLimit, upperLimit, value);
        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);
        this->setQuery(queryString, dbPostgres);

        break;
    }

    case Constants::mssqlIntType:{

        QString queryString = mssqlDateConversion.convertDateQuery(columnName, tableName, lowerLimit, upperLimit, value);
        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrType);
        this->setQuery(queryString, dbMssql);

        break;
    }

    }
}


/*!
 * \brief Set a new select query for a given column in table with select column values
 * \param columnName (name of the column in sql table)
 * \param tableName (table name)
 * \param fieldNames (comma separated values for a given column of sql table)
 */
void ColumnListModel::columnEditQuery(QString columnName, QString tableName, QString fieldNames, QString category)
{

    QString queryString;
    QString finalSearchFields;
    QStringList pieces;

    // This step is only required for Categorical-List type
    // For the rest, we dont have to do anything as the value is not a list from database

    if(category == Constants::categoryMainListType){

        switch(Statics::currentDbIntType){

        case Constants::mysqlIntType:{

            pieces = fieldNames.split(",");

            if(pieces.length() > 1){
                finalSearchFields = pieces.join("','");
            }else{
                finalSearchFields = fieldNames;
            }

            finalSearchFields = "'" + finalSearchFields + "'";

            queryString = "SELECT " + columnName + " FROM "+ tableName + " WHERE "+ columnName + " IN (" + finalSearchFields + ")";

            QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
            this->setQuery(queryString, dbMysql);


            break;
        }

        case Constants::mysqlOdbcIntType:{

            pieces = fieldNames.split(",");

            if(pieces.length() > 1){
                finalSearchFields = pieces.join("','");
            }else{
                finalSearchFields = fieldNames;
            }

            finalSearchFields = "'" + finalSearchFields + "'";

            queryString = "SELECT " + columnName + " FROM "+ tableName + " WHERE "+ columnName + " IN (" + finalSearchFields + ")";

            QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrType);
            this->setQuery(queryString, dbMysql);


            break;
        }

        case Constants::sqliteIntType:{

            pieces = fieldNames.split(",");

            if(pieces.length() > 1){
                finalSearchFields = pieces.join("','");
            }else{
                finalSearchFields = fieldNames;
            }

            finalSearchFields = "'" + finalSearchFields + "'";

            queryString = "SELECT " + columnName + " FROM "+ tableName + " WHERE "+ columnName + " IN (" + finalSearchFields + ")";

            QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrType);
            this->setQuery(queryString, dbSqlite);


            break;
        }

        case Constants::postgresIntType:{

            pieces = fieldNames.split(",");

            if(pieces.length() > 1){
                finalSearchFields = pieces.join("','");
            }else{
                finalSearchFields = fieldNames;
            }

            finalSearchFields = "'" + finalSearchFields + "'";

            queryString = "SELECT " + columnName + " FROM "+ tableName + " WHERE "+ columnName + " IN (" + finalSearchFields + ")";

            QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);
            this->setQuery(queryString, dbPostgres);


            break;
        }

        case Constants::mssqlIntType:{

            pieces = fieldNames.split(",");

            if(pieces.length() > 1){
                finalSearchFields = pieces.join("','");
            }else{
                finalSearchFields = fieldNames;
            }

            finalSearchFields = "'" + finalSearchFields + "'";

            queryString = "SELECT " + columnName + " FROM "+ tableName + " WHERE "+ columnName + " IN (" + finalSearchFields + ")";

            QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrType);
            this->setQuery(queryString, dbMssql);


            break;
        }
        }
    }

    emit editCalled();
}


/*!
 * \brief Select query for a given column in table with select column fields with similar values
 * \param columnName (table column name)
 * \param tableName (table name)
 * \param searchString (value to match in like query)
 */
void ColumnListModel::likeColumnQuery(QString columnName, QString tableName, QString searchString)
{
    QString queryString;

    switch(Statics::currentDbIntType){

    case Constants::mysqlIntType:{

        if (searchString != ""){
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " WHERE " + columnName + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName;
        }


        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    case Constants::mysqlOdbcIntType:{

        if (searchString != ""){
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " WHERE " + columnName + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName;
        }


        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrType);
        this->setQuery(queryString, dbMysql);

        break;
    }

    case Constants::sqliteIntType:{

        if (searchString != ""){
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " WHERE " + columnName + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName;
        }


        QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrType);
        this->setQuery(queryString, dbSqlite);

        break;
    }

    case Constants::postgresIntType:{

        if (searchString != ""){
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " WHERE " + columnName + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName;
        }


        QSqlDatabase dbPostgres = QSqlDatabase::database(Constants::postgresOdbcStrType);
        this->setQuery(queryString, dbPostgres);

        break;
    }

    case Constants::mssqlIntType:{

        if (searchString != ""){
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName + " WHERE " + columnName + " LIKE '%"+searchString+"%'";
        } else{
            queryString = "SELECT DISTINCT " + columnName + " FROM "+ tableName;
        }


        QSqlDatabase dbMssql = QSqlDatabase::database(Constants::mssqlOdbcStrType);
        this->setQuery(queryString, dbMssql);

        break;
    }

    }
}

/*!
 * \brief Override QSqlQueryModel::generateRoleNames
 * \details Override method to generate a new rolename
 */
void ColumnListModel::generateRoleNames()
{
    m_roleNames.clear();
    QString roleName = "tableName";
    m_roleNames.insert(Qt::UserRole + 1, roleName.toUtf8());
}
