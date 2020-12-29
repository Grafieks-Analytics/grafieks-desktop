#ifndef MONGOCON_H
#define MONGOCON_H

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
 * \brief Handles the connection with Mongo database across the application
 * \ingroup Connectors
 */

class MongoCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString ODBCDRIVER = "QODBC";

public:
    explicit MongoCon(QObject *parent = nullptr);
    QVariantMap MongoInstance(const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    QVariantMap MongoOdbcInstance(const QString & driver, const QString & host, const QString & db, const int & port, const QString & username, const QString & password);

    ~MongoCon();

signals:

};

#endif // MONGOCON_H
