#include "datasource.h"

Datasource::Datasource(const int & id, const int & connectedWorkbooksCount, const int & profileId, const QString & connectionType, const QString & datasourceName, const QString &databaseName, const QString & descriptions, const QString & sourceType, const QString & imageLink, const QString & downloadLink, const QString & createdDate, const QString & firstName, const QString & lastName, const QString &lastRun, const bool &downloadAllowed, const bool &connectAllowed, const bool &publishAllowed, QObject *parent) :

    QObject(parent),m_id(id), m_connectedWorkbooksCount(connectedWorkbooksCount), m_profileId(profileId), m_connectionType(connectionType), m_datasourceName(datasourceName), m_databaseName(databaseName), m_descriptions(descriptions), m_sourceType(sourceType), m_imageLink(imageLink), m_downloadLink(downloadLink), m_createdDate(createdDate), m_firstName(firstName), m_lastName(lastName), m_lastRun(lastRun), m_downloadAllowed(downloadAllowed), m_connectAllowed(connectAllowed), m_publishAllowed(publishAllowed)
{

}


QString Datasource::connectionType() const
{
    return m_connectionType;
}

QString Datasource::datasourceName() const
{
    return m_datasourceName;
}

QString Datasource::databaseName() const
{
    return m_databaseName;
}

QString Datasource::descriptions() const
{
    return m_descriptions;
}

QString Datasource::imageLink() const
{
    return m_imageLink;
}

int Datasource::id() const
{
    return m_id;
}

int Datasource::connectedWorkbooksCount() const
{
    return m_connectedWorkbooksCount;
}

int Datasource::profileId() const
{
    return m_profileId;
}

QString Datasource::sourceType() const
{
    return m_sourceType;
}

QString Datasource::downloadLink() const
{
    return m_downloadLink;
}

QString Datasource::createdDate() const
{
    return m_createdDate;
}

QString Datasource::firstName() const
{
    return m_firstName;
}

QString Datasource::lastName() const
{
    return m_lastName;
}

QString Datasource::lastRun() const
{
    return m_lastRun;
}

bool Datasource::downloadAllowed() const
{
    return m_downloadAllowed;
}

bool Datasource::connectAllowed() const
{
    return m_connectAllowed;
}

bool Datasource::publishAllowed() const
{
    return m_publishAllowed;
}

void Datasource::setConnectionType(QString connectionType)
{
    if (m_connectionType == connectionType)
        return;

    m_connectionType = connectionType;
    emit connectionTypeChanged(m_connectionType);
}

void Datasource::setDatasourceName(QString datasourceName)
{
    if (m_datasourceName == datasourceName)
        return;

    m_datasourceName = datasourceName;
    emit datasourceNameChanged(m_datasourceName);
}

void Datasource::setDatabaseName(QString databaseName)
{
    if (m_databaseName == databaseName)
        return;

    m_databaseName = databaseName;
    emit databaseNameChanged(m_databaseName);
}

void Datasource::setDescriptions(QString descriptions)
{
    if (m_descriptions == descriptions)
        return;

    m_descriptions = descriptions;
    emit descriptionsChanged(m_descriptions);
}

void Datasource::setImageLink(QString imageLink)
{
    if (m_imageLink == imageLink)
        return;

    m_imageLink = imageLink;
    emit imageLinkChanged(m_imageLink);
}

void Datasource::setId(int id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Datasource::setConnectedWorkbooksCount(int connectedWorkbooksCount)
{
    if (m_connectedWorkbooksCount == connectedWorkbooksCount)
        return;

    m_connectedWorkbooksCount = connectedWorkbooksCount;
    emit connectedWorkbooksCountChanged(m_connectedWorkbooksCount);
}

void Datasource::setProfileId(int profileId)
{
    if (m_profileId == profileId)
        return;

    m_profileId = profileId;
    emit profileIdChanged(m_profileId);
}

void Datasource::setSourceType(QString sourceType)
{
    if (m_sourceType == sourceType)
        return;

    m_sourceType = sourceType;
    emit sourceTypeChanged(m_sourceType);
}

void Datasource::setDownloadLink(QString downloadLink)
{
    if (m_downloadLink == downloadLink)
        return;

    m_downloadLink = downloadLink;
    emit downloadLinkChanged(m_downloadLink);
}

void Datasource::setCreatedDate(QString createdDate)
{
    if (m_createdDate == createdDate)
        return;

    m_createdDate = createdDate;
    emit createdDateChanged(m_createdDate);
}

void Datasource::setFirstName(QString firstName)
{
    if (m_firstName == firstName)
        return;

    m_firstName = firstName;
    emit firstNameChanged(m_firstName);
}

void Datasource::setLastName(QString lastName)
{
    if (m_lastName == lastName)
        return;

    m_lastName = lastName;
    emit lastNameChanged(m_lastName);
}

void Datasource::setLastRun(QString lastRun)
{
    if (m_lastRun == lastRun)
        return;

    m_lastRun = lastRun;
    emit lastRunChanged(m_lastRun);
}

void Datasource::setDownloadAllowed(bool downloadAllowed)
{
    if (m_downloadAllowed == downloadAllowed)
        return;

    m_downloadAllowed = downloadAllowed;
    emit downloadAllowedChanged(m_downloadAllowed);
}

void Datasource::setConnectAllowed(bool connectAllowed)
{
    if (m_connectAllowed == connectAllowed)
        return;

    m_connectAllowed = connectAllowed;
    emit connectAllowedChanged(m_connectAllowed);
}

void Datasource::setPublishAllowed(bool publishAllowed)
{
    if (m_publishAllowed == publishAllowed)
        return;

    m_publishAllowed = publishAllowed;
    emit publishAllowedChanged(m_publishAllowed);
}

