#include "mongocon.h"

MongoCon::MongoCon(QObject *parent) : QObject(parent)
{

}

QVariantMap MongoCon::MongoInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    return outputStatus;
}

MongoCon::~MongoCon()
{

}
