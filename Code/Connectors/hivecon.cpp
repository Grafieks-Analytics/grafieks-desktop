#include "hivecon.h"

HiveCon::HiveCon(QObject *parent) : QObject(parent)
{

}

QVariantMap HiveCon::HiveOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap output;
    return output;
}

HiveCon::~HiveCon()
{

}
