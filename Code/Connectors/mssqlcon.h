#ifndef MSSQLCON_H
#define MSSQLCON_H

#include <QObject>
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
 * \brief Handles the connection with MSSql database across the application
 * \ingroup Connectors
 */


class MSSqlCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString ODBCDRIVER = "QODBC";

public:
    explicit MSSqlCon(QObject *parent = nullptr);
    QVariantMap MSSqlInstance(const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    QVariantMap MSSqlOdbcInstance(const QString & driver, const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    void closeConnection();

    ~MSSqlCon();

signals:

};

#endif // MSSQLCON_H
