#ifndef ODBCCON_H
#define ODBCCON_H

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
 * \brief Handles the connection with ODBC database across the application
 * \ingroup Connectors
 */
class OdbcCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString DRIVER = "QODBC";

public:
    explicit OdbcCon(QObject *parent = nullptr);
    QVariantMap OdbcInstance(const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    void closeConnection();

    ~OdbcCon();

signals:

};

#endif // ODBCCON_H
