#include "datasource.h"

Datasource::Datasource(const int & id, const int & connectedWorkbooksCount, const int & profileId, const QString & connectionType, const QString & datasourceName, const QString & description, const QString & sourceType, const QString & imageLink, const QString & downloadLink, const QString & createdDate, const QString & firstName, const QString & lastName, QObject *parent) :

    QObject(parent),m_id(id), m_connectedWorkbooksCount(connectedWorkbooksCount), m_profileId(profileId), m_connectionType(connectionType), m_datasourceName(datasourceName), m_description(description), m_sourceType(sourceType), m_imageLink(imageLink), m_downloadLink(downloadLink), m_createdDate(createdDate), m_firstName(firstName), m_lastName(lastName)
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

QString Datasource::description() const
{
    return m_description;
}

QString Datasource::imageLink() const
{
    return m_imageLink;
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

void Datasource::setDescription(QString description)
{
    if (m_description == description)
        return;

    m_description = description;
    emit descriptionChanged(m_description);
}

void Datasource::setImageLink(QString imageLink)
{
    if (m_imageLink == imageLink)
        return;

    m_imageLink = imageLink;
    emit imageLinkChanged(m_imageLink);
}

