#include "snowflakecon.h"

SnowflakeCon::SnowflakeCon(QObject *parent) : QObject(parent)
{

}

QVariantMap SnowflakeCon::SnowflakeOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap output;
    return output;
}

SnowflakeCon::~SnowflakeCon()
{

}
