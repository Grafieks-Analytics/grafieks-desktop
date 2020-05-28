#include "dblist.h"

DBList::DBList(QObject *parent) : QObject(parent)
{

}

DBList::DBList(const QString &name, QObject *parent):QObject(parent),m_dbName(name)
{

}

QString DBList::dbName() const
{
    return m_dbName;
}

void DBList::setDbName(QString dbName)
{
    if (m_dbName == dbName)
        return;

    m_dbName = dbName;
    emit dbNameChanged(m_dbName);
}

