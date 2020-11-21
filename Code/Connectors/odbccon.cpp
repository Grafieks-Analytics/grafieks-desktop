#include "odbccon.h"

/*!
 * \fn OdbcCon::OdbcCon
 * \brief Constructor function for Mysql connection
 * \param parent
 */
OdbcCon::OdbcCon(QObject *parent) : QObject(parent)
{

}

/*!
 * \fn OdbcCon::OdbcInstance
 * \brief Instantiates a ODBC connection to a given database
 * \details The function instantiates 2 ODBC connections for General connections and one specially for DataQuery Modeller - query profiling.
 * Query profiling needs a separate connection because once enabled, it profiles all the queries which we don't want
 * \param QString &host
 * \param QString &db
 * \param int &port
 * \param QString &username
 * \param QString &password
 * \return QVariantMap {bool status, QString msg}
 */
QVariantMap OdbcCon::OdbcInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap output;


    return output;
}

/*!
 * \fn OdbcCon::~OdbcCon
 * \brief Destructor function for ODBC connection
 * \details The function closes the two ODBC open connections
 */
OdbcCon::~OdbcCon()
{

}
