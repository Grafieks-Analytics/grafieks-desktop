#ifndef SQLITECON_H
#define SQLITECON_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>

#include "../Logic/General/constants.h"

class Sqlitecon : public QObject
{
    Q_OBJECT

public:
    explicit Sqlitecon(QObject *parent = nullptr);
    QVariantMap SqliteInstance(const QString & filepath, const QString & username, const QString & password);

signals:

private:

    QVariantMap outputStatus;

};

#endif // SQLITECON_H
