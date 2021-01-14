#include "oraclecon.h"

OracleCon::OracleCon(QObject *parent) : QObject(parent)
{

}

QVariantMap OracleCon::OracleOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap output;
    return output;
}

OracleCon::~OracleCon()
{

}
