#include "postgrescon.h"

PostgresCon::PostgresCon(QObject *parent) : QObject(parent)
{

}

QVariantMap PostgresCon::PostgresInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    return outputStatus;
}

PostgresCon::~PostgresCon()
{

}
