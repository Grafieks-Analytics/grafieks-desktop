#include "dashboardcontainermodel.h"

DashboardContainerModel::DashboardContainerModel(QObject *parent) : QObject(parent)
{

}

QString DashboardContainerModel::lastContainerType() const
{
    return m_lastContainerType;
}

int DashboardContainerModel::positionY() const
{
    return m_positionY;
}

int DashboardContainerModel::positionX() const
{
    return m_positionX;
}

int DashboardContainerModel::zIndex() const
{
    return m_zIndex;
}

void DashboardContainerModel::setLastContainerType(QString lastContainerType)
{
    if (m_lastContainerType == lastContainerType)
        return;

    m_lastContainerType = lastContainerType;
    emit lastContainerTypeChanged(m_lastContainerType);
}

void DashboardContainerModel::setPositionY(int positionY)
{
    if (m_positionY == positionY)
        return;

    m_positionY = positionY;
    emit positionYChanged(m_positionY);
}

void DashboardContainerModel::setPositionX(int positionX)
{
    if (m_positionX == positionX)
        return;

    m_positionX = positionX;
    emit positionXChanged(m_positionX);
}

void DashboardContainerModel::setZIndex(int zIndex)
{
    if (m_zIndex == zIndex)
        return;

    m_zIndex = zIndex;
    emit zIndexChanged(m_zIndex);
}
