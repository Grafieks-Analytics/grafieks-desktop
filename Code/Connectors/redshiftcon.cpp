#include "redshiftcon.h"

RedshiftCon::RedshiftCon(QObject *parent) : QObject(parent)
{

}

QVariantMap RedshiftCon::RedshiftOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{

    QVariantMap output;
    return output;
}

RedshiftCon::~RedshiftCon()
{

}
