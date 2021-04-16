#ifndef ACCESSCON_H
#define ACCESSCON_H

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

class AccessCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString ODBCDRIVER = "QODBC";
public:
    explicit AccessCon(QObject *parent = nullptr);
    QVariantMap AccessOdbcInstance(const QString &driver, const QString &db, const QString &username, const QString &password);

    ~AccessCon();

signals:

};

#endif // ACCESSCON_H
