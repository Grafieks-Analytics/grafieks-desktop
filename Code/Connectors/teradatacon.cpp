#include "teradatacon.h"

TeradataCon::TeradataCon(QObject *parent) : QObject(parent)
{

}

QVariantMap TeradataCon::TeradataOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap output;
    return output;
}

TeradataCon::~TeradataCon()
{

}
