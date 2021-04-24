#ifndef ORACLECON_H
#define ORACLECON_H

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
 * \brief Handles the connection with Oracle database across the application
 * \ingroup Connectors
 */

class OracleCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString ODBCDRIVER = "QODBC";

public:
    explicit OracleCon(QObject *parent = nullptr);
    QVariantMap OracleOdbcInstance(const QString & driver, const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    void closeConnection();

    ~OracleCon();

signals:

};

#endif // ORACLECON_H
