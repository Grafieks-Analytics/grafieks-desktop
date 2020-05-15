#ifndef MYSQLCON_H
#define MYSQLCON_H

#include <QSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QtDebug>
#include <QObject>


#include "../Logic/General/constants.h"

class MysqlCon : public QObject
{
    Q_OBJECT


public:
    explicit MysqlCon(QObject *parent = nullptr);
    QVariantMap MysqlInstance(const QString & host, const QString & db, const int & port, const QString & username, const QString & password);

signals:

private:

    QVariantMap outputStatus;

};

#endif // MYSQLCON_H
