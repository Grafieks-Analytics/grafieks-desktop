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

QVariantMap Sqlitecon::SqliteInstance(const QString &filename)
{
     QVariantMap outputStatus;

    if(QSqlDatabase::isDriverAvailable("QSQLITE")){

        QSqlDatabase dbSqlite = QSqlDatabase::addDatabase("QSQLITE", Constants::sqliteStrType);
        dbSqlite.setDatabaseName(QUrl(filename).toLocalFile());
        dbSqlite.open();

        if(!dbSqlite.isOpen()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbSqlite.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::sqliteFile = QUrl(filename).toLocalFile();
            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);


            // Open another Sqlite Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbSqlite2 = QSqlDatabase::addDatabase("QSQLITE", Constants::sqliteStrQueryType);
            dbSqlite2.setDatabaseName(QUrl(filename).toLocalFile());
            dbSqlite2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;

}

QVariantMap Sqlitecon::SqliteOdbcInstance(const QString &driver, const QString &filepath)
{
    Q_UNUSED(driver);
    Q_UNUSED(filepath);

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
