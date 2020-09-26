#include "dashboardcontainer.h"

DashboardContainer::DashboardContainer(QObject *parent) : QObject(parent)
{

}

QString DashboardContainer::lastContainerType() const
{
    return m_lastContainerType;
}

int DashboardContainer::positionY() const
{
    return m_positionY;
}

int DashboardContainer::positionX() const
{
    return m_positionX;
}

void DashboardContainer::setLastContainerType(QString lastContainerType)
{
    if (m_lastContainerType == lastContainerType)
        return;

    m_lastContainerType = lastContainerType;
    emit lastContainerTypeChanged(m_lastContainerType);
}

void DashboardContainer::setPositionY(int positionY)
{
    if (m_positionY == positionY)
        return;

    m_positionY = positionY;
    emit positionYChanged(m_positionY);
}

void DashboardContainer::setPositionX(int positionX)
{
    if (m_positionX == positionX)
        return;

    m_positionX = positionX;
    emit positionXChanged(m_positionX);
}
