#ifndef MYSQLCON_H
#define MYSQLCON_H

#include <QSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlError>
#include <QtDebug>
#include <QObject>


#include "../constants.h"
#include "../Messages.h"
#include "../statics.h"

/*!
 * \brief Handles the connection with MySql database across the application
 * \ingroup Connectors
 */

class MysqlCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString DRIVER = "QMYSQL";
    const QString ODBCDRIVER = "QODBC";



public:
    explicit MysqlCon(QObject *parent = nullptr);
    QVariantMap MysqlInstance(const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    Q_INVOKABLE QVariantMap MysqlOdbcInstance(const QString & driver, const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    void closeConnection();

    ~MysqlCon();

signals:



};

#endif // MYSQLCON_H
