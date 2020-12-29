#include "sqlitecon.h"

/*!
 * \fn Sqlitecon::Sqlitecon
 * \brief Constructor function for Sqlite connection
 * \param parent
 */
Sqlitecon::Sqlitecon(QObject *parent) : QObject(parent)
{
}


/*!
 * \fn Sqlitecon::SqliteInstance
 * \brief Instantiates an Sqlite connection
 * \details The function instantiates 2 Sqlite connections for General connections and one specially for DataQuery Modeller - query profiling.
 * Query profiling needs a separate connection because once enabled, it profiles all the queries which we don't want
 * \param QString &filename
 * \param QString &username
 * \param QString &password
 * \return QVariantMap {bool status, QString msg}
 */

QVariantMap Sqlitecon::SqliteInstance(const QString &filename, const QString &username, const QString &password)
{

    if(QSqlDatabase::isDriverAvailable(DRIVER)){

        QSqlDatabase dbSqlite = QSqlDatabase::addDatabase(DRIVER, Constants::sqliteStrType);
        dbSqlite.setDatabaseName(filename);

        if(username != "" && password != ""){
            dbSqlite.setUserName(username);
            dbSqlite.setPassword(password);
        }

        if(!dbSqlite.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbSqlite.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::sqliteFile = filename;
            Statics::sqliteUsername = username;
            Statics::sqlitePassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);


            // Open another Sqlite Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbSqlite2 = QSqlDatabase::addDatabase(DRIVER, Constants::sqliteStrQueryType);
            dbSqlite2.setDatabaseName(filename);

            if(username != "" && password != ""){
                dbSqlite2.setUserName(username);
                dbSqlite2.setPassword(password);
            }

            dbSqlite2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;

}

QVariantMap Sqlitecon::SqliteOdbcInstance(const QString &driver, const QString &filepath, const QString &username, const QString &password)
{
    QVariantMap outputStatus;
    return outputStatus;
}

/*!
 * \fn Sqlitecon::~Sqlitecon
 * \brief Destructor function for Sqlite connection
 * \details The function closes the two Sqlite open connections
 */
Sqlitecon::~Sqlitecon()
{
    QSqlDatabase dbSqlite = QSqlDatabase::database(Constants::sqliteStrType);
    QSqlDatabase dbSqlite2 = QSqlDatabase::database(Constants::sqliteStrQueryType);

    if(dbSqlite.isOpen()) dbSqlite.close();
    if(dbSqlite2.isOpen()) dbSqlite2.close();
}
