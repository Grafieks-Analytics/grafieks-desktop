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

int DBList::dbId() const
{
    return m_dbId;
}

void DBList::setDbName(QString dbName)
{
    if (m_dbName == dbName)
        return;

    m_dbName = dbName;
    emit dbNameChanged(m_dbName);
}

void DBList::setDbId(int dbId)
{
    if (m_dbId == dbId)
        return;

    m_dbId = dbId;
    emit dbIdChanged(m_dbId);
}
