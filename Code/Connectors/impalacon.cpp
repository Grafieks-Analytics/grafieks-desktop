#include "impalacon.h"

ImpalaCon::ImpalaCon(QObject *parent) : QObject(parent)
{

}

QVariantMap ImpalaCon::ImpalaOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap output;
    return output;
}

ImpalaCon::~ImpalaCon()
{

}
