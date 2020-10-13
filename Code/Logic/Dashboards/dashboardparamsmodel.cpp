#include "dashboardparamsmodel.h"

DashboardParamsModel::DashboardParamsModel(QObject *parent) : QObject(parent)
{

}

bool DashboardParamsModel::createNewDashboard()
{

    return true;
}

bool DashboardParamsModel::destroyDashboard()
{
    return true;
}

QVariantMap DashboardParamsModel::fetchAllDashboards()
{
    QVariantMap output;

    return output;
}

QVariantList DashboardParamsModel::fetchReportsInDashboard(int dashboardId)
{
    Q_UNUSED(dashboardId);
    QVariantList output;

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportZOrder(int dashboardId)
{

    Q_UNUSED(dashboardId);
    QVariantMap output;

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportCoordinates(int dashboardId)
{
    Q_UNUSED(dashboardId);
    QVariantMap output;

    return output;

}

QVariantMap DashboardParamsModel::fetchAllReportUrls(int dashboardId)
{
    Q_UNUSED(dashboardId);
    QVariantMap output;

    return output;
}

QVariantMap DashboardParamsModel::fetchAllReportTypeMap(int dashboardId)
{

    Q_UNUSED(dashboardId);
    QVariantMap output;

    return output;
}

void DashboardParamsModel::addReportToDashboard(int dashboardId, int reportId)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
}

void DashboardParamsModel::deleteReportFromDashboard(int dashboardId, int reportId)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
}

void DashboardParamsModel::setReportZOrder(int dashboardId, int reportId, int zOrder)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
}

int DashboardParamsModel::getReportZOrder(int dashboardId, int reportId)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
    int output = 0;

    return output;
}

void DashboardParamsModel::setDashboardReportCoordinates(int dashboardId, int reportId, float x, float y)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
}

QVector<float> DashboardParamsModel::getDashboardReportCoordinates(int dashboardId, int reportId)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
    QVector<float> output;

    return output;
}

void DashboardParamsModel::setDashboardReportTypeMap(int dashboardId, int reportId, int reportType)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
}

int DashboardParamsModel::getDashboardReportTypeMap(int dashboardId, int reportId)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
    int output = 0;

    return output;
}

void DashboardParamsModel::setDashboardReportUrl(int dashboardId, int reportId, QUrl url)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(reportId);
}

QUrl DashboardParamsModel::getDashboardReportUrl(int dashboardId, QUrl url)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(url);
    QUrl output;

    return output;
}

void DashboardParamsModel::setDashboardName(int dashboardId, QString dashboardName)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(dashboardName);
}

QString DashboardParamsModel::getDashboardName(int dashboardId)
{

    Q_UNUSED(dashboardId);
    QString output;

    return output;
}

void DashboardParamsModel::setDashboardBackgroundColor(int dashboardId, QString color)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(color);
}

QString DashboardParamsModel::getDashboardBackgroundColor(int dashboardId)
{

    Q_UNUSED(dashboardId);
    QString output;

    return output;
}

void DashboardParamsModel::setDashboardLineColor(int dashboardId, QString color)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(color);
}

QString DashboardParamsModel::getDashboardLineColor(int dashboardId)
{

    Q_UNUSED(dashboardId);
    QString output;

    return output;
}

void DashboardParamsModel::setDashboardOpacity(int dashboardId, int percent)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(percent);
}

int DashboardParamsModel::getDashboardOpacity(int dashboardId)
{

    Q_UNUSED(dashboardId);
    int output = 0;

    return output;
}

void DashboardParamsModel::setDashboardGrid(int dashboardId, bool gridVisible)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(gridVisible);
}

bool DashboardParamsModel::getDashboardGrid(int dashboardId)
{

    Q_UNUSED(dashboardId);
    return true;
}

void DashboardParamsModel::setDashboardDimensions(int dashboardId, int height, int width)
{

    Q_UNUSED(dashboardId);
    Q_UNUSED(height);
    Q_UNUSED(width);
}

QVector<int> DashboardParamsModel::getDashboardDimensions(int dashboardId)
{
    Q_UNUSED(dashboardId);
    QVector<int> output;

    return output;

}

QString DashboardParamsModel::lastContainerType() const
{
    return m_lastContainerType;
}

int DashboardParamsModel::positionY() const
{
    return m_positionY;
}

int DashboardParamsModel::positionX() const
{
    return m_positionX;
}

int DashboardParamsModel::zIndex() const
{
    return m_zIndex;
}

void DashboardParamsModel::setLastContainerType(QString lastContainerType)
{
    if (m_lastContainerType == lastContainerType)
        return;

    m_lastContainerType = lastContainerType;
    emit lastContainerTypeChanged(m_lastContainerType);
}

void DashboardParamsModel::setPositionY(int positionY)
{
    if (m_positionY == positionY)
        return;

    m_positionY = positionY;
    emit positionYChanged(m_positionY);
}

void DashboardParamsModel::setPositionX(int positionX)
{
    if (m_positionX == positionX)
        return;

    m_positionX = positionX;
    emit positionXChanged(m_positionX);
}

void DashboardParamsModel::setZIndex(int zIndex)
{
    if (m_zIndex == zIndex)
        return;

    m_zIndex = zIndex;
    emit zIndexChanged(m_zIndex);
}
