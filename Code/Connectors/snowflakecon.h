#ifndef SNOWFLAKECON_H
#define SNOWFLAKECON_H

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
 * \brief Handles the connection with Impala database across the application
 * \ingroup Connectors
 */

class SnowflakeCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString ODBCDRIVER = "QODBC";
public:
    explicit SnowflakeCon(QObject *parent = nullptr);
    QVariantMap SnowflakeOdbcInstance(const QString & driver, const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    void closeConnection();

    ~SnowflakeCon();

signals:

};

#endif // SNOWFLAKECON_H
