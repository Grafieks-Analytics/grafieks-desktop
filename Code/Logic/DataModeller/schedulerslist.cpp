#include "schedulerslist.h"

SchedulersList::SchedulersList(const int & schedulerId, const QString & schedulerName, QObject *parent) : QObject(parent),
    m_schedulerId(schedulerId),
    m_schedulerName(schedulerName)
{

}

int SchedulersList::schedulerId() const
{
    return m_schedulerId;
}

QString SchedulersList::schedulerName() const
{
    return m_schedulerName;
}

void SchedulersList::setSchedulerId(int schedulerId)
{
    if (m_schedulerId == schedulerId)
        return;

    m_schedulerId = schedulerId;
    emit schedulerIdChanged(m_schedulerId);
}

void SchedulersList::setSchedulerName(QString schedulerName)
{
    if (m_schedulerName == schedulerName)
        return;

    m_schedulerName = schedulerName;
    emit schedulerNameChanged(m_schedulerName);
}
