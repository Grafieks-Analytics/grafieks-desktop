#include "scheduler.h"

Scheduler::Scheduler(const int & schedulerId, const QString & schedulerName, QObject *parent) :
    QObject(parent),m_schedulerId(schedulerId), m_schedulerName(schedulerName)
{

}

int Scheduler::schedulerId() const
{
    return m_schedulerId;
}

QString Scheduler::schedulerName() const
{
    return m_schedulerName;
}

void Scheduler::setSchedulerId(int schedulerId)
{
    if (m_schedulerId == schedulerId)
        return;

    m_schedulerId = schedulerId;
    emit schedulerIdChanged(m_schedulerId);
}

void Scheduler::setSchedulerName(QString schedulerName)
{
    if (m_schedulerName == schedulerName)
        return;

    m_schedulerName = schedulerName;
    emit schedulerNameChanged(m_schedulerName);
}
