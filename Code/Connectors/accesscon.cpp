#include "accesscon.h"

AccessCon::AccessCon(QObject *parent) : QObject(parent)
{

}

QVariantMap AccessCon::AccessOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap output;
    return output;
}

AccessCon::~AccessCon()
{

}
