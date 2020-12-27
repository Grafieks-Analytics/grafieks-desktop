#include "mssqlcon.h"

MSSqlCon::MSSqlCon(QObject *parent) : QObject(parent)
{

}

QVariantMap MSSqlCon::MSSqlInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    return outputStatus;
}

MSSqlCon::~MSSqlCon()
{

}
