#include "tablelist.h"

TableList::TableList(QObject *parent) : QObject(parent)
{

}

TableList::TableList(const QString &name, QObject *parent): QObject(parent),m_tableName(name)
{

}

QString TableList::tableName() const
{
    return m_tableName;
}

void TableList::setTableName(QString tableName)
{
    if (m_tableName == tableName)
        return;

    m_tableName = tableName;
    emit tableNameChanged(m_tableName);
}
