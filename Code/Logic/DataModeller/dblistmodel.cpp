#include "dblistmodel.h"

/*!
 * \brief Constructor function for ColumnListModel
 * \param parent
 */
DBListModel::DBListModel(QObject *parent):
    QSqlQueryModel(parent)
{

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
        QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlOdbcStrType);

        if(queryString != ""){
            this->setQuery("SHOW DATABASES LIKE '%"+queryString+"%'", dbMysql);
        } else{
            this->setQuery("SHOW DATABASES", dbMysql);
        }

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
