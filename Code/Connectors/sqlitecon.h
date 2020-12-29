#ifndef SQLITECON_H
#define SQLITECON_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>

#include "../statics.h"
#include "../constants.h"
#include "../Messages.h"

/*!
 * \brief Handles the connection with Sqlite database across the application
 * \ingroup Connectors
 */

class Sqlitecon : public QObject
{
    Q_OBJECT

    QVariantMap outputStatus;
    const QString DRIVER = "QSQLITE";
    const QString ODBCDRIVER = "QODBC";

public:
    explicit Sqlitecon(QObject *parent = nullptr);
    QVariantMap SqliteInstance(const QString & filepath, const QString & username, const QString & password);
    QVariantMap SqliteOdbcInstance(const QString & driver, const QString & filepath, const QString & username, const QString & password);

    ~Sqlitecon();

signals:

};

#endif // SQLITECON_H
