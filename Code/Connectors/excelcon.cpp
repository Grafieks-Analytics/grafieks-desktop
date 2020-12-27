#include "excelcon.h"

ExcelCon::ExcelCon(QObject *parent) : QObject(parent)
{

}

QVariantMap ExcelCon::ExcelInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    return outputStatus;
}

ExcelCon::~ExcelCon()
{

}
