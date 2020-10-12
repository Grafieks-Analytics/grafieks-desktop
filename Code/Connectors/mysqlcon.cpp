#include "mysqlcon.h"

/*!
 * \fn MysqlCon::MysqlCon
 * \brief Constructor function for Mysql connection
 * \param parent
 */

MysqlCon::MysqlCon(QObject *parent) : QObject(parent)
{

}

/*!
 * \fn MysqlCon::MysqlInstance
 * \brief Instantiates a Mysql connection to a given database
 * \details The function instantiates 2 MySql connections for General connections and one specially for DataQuery Modeller - query profiling.
 * Query profiling needs a separate connection because once enabled, it profiles all the queries which we don't want
 * \param QString &host
 * \param QString &db
 * \param int &port
 * \param QString &username
 * \param QString &password
 * \return QVariantMap {bool status, QString msg}
 */

QVariantMap MysqlCon::MysqlInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    if(QSqlDatabase::isDriverAvailable(DRIVER)){

        QSqlDatabase dbMysql = QSqlDatabase::addDatabase(DRIVER, Constants::mysqlStrType);
        dbMysql.setHostName(host);
        dbMysql.setPort(port);
        dbMysql.setDatabaseName(db);
        dbMysql.setUserName(username);
        dbMysql.setPassword(password);


        if(!dbMysql.open()){
            outputStatus.insert("status", false);
            outputStatus.insert("msg", dbMysql.lastError().text());

        } else{

            // Save static values to access it later on other objects
            // For automatic connection for other instances
            // If correct credentials inserted once

            Statics::myHost = host;
            Statics::myDb = db;
            Statics::myPort = port;
            Statics::myUsername = username;
            Statics::myPassword = password;

            outputStatus.insert("status", true);
            outputStatus.insert("msg", Messages::GeneralSuccessMsg);

            // Open another Mysql Connection
            // For Query/Data modeller
            // Else all the query statistics are listed in "Test Query" tab in Data-Query-Modeller

            QSqlDatabase dbMysql2 = QSqlDatabase::addDatabase(DRIVER, Constants::mysqlStrQueryType);
            dbMysql2.setHostName(host);
            dbMysql2.setPort(port);
            dbMysql2.setDatabaseName(db);
            dbMysql2.setUserName(username);
            dbMysql2.setPassword(password);

            dbMysql2.open();
        }

    } else{
        outputStatus.insert("status", false);
        outputStatus.insert("msg", Messages::GeneralNoDriver);
    }

    return outputStatus;
}

/*!
 * \fn MysqlCon::~MysqlCon
 * \brief Destructor function for Mysql connection
 * \details The function closes the two MySql open connections
 */

MysqlCon::~MysqlCon()
{
    QSqlDatabase dbMysql = QSqlDatabase::database(Constants::mysqlStrType);
    QSqlDatabase dbMysql2 = QSqlDatabase::database( Constants::mysqlStrQueryType);
    dbMysql.close();
    dbMysql2.close();
}
