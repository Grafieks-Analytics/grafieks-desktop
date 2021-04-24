#ifndef TERADATACON_H
#define TERADATACON_H

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

class TeradataCon : public QObject
{
    Q_OBJECT
    QVariantMap outputStatus;
    const QString ODBCDRIVER = "QODBC";

public:
    explicit TeradataCon(QObject *parent = nullptr);
    QVariantMap TeradataOdbcInstance(const QString & driver, const QString & host, const QString & db, const int & port, const QString & username, const QString & password);
    void closeConnection();

    ~TeradataCon();

signals:

};

#endif // TERADATACON_H
