#ifndef HIVECON_H
#define HIVECON_H

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
 * \brief Handles the connection with Hive database across the application
 * \ingroup Connectors
 */


class HiveCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString ODBCDRIVER = "QODBC";

public:
    explicit HiveCon(QObject *parent = nullptr);
    QVariantMap HiveOdbcInstance(const QString & driver, const QString & host, const QString & db, const int & port, const QString & username, const QString & password);

    ~HiveCon();

signals:

};

#endif // HIVECON_H
