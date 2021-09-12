#include "connector.h"

Connector::Connector(QObject *parent) : QObject(parent)
{

}

Connector::Connector(const QString &name, const QString &imageLink, const QString &category, const bool &isEnabled, QObject *parent):
    QObject(parent),m_name(name), m_imageLink(imageLink), m_category(category), m_isEnabled(isEnabled)
{

}

QString Connector::category() const
{
    return m_category;
}

QString Connector::imageLink() const
{
    return m_imageLink;
}

QString Connector::name() const
{
    return m_name;
}

bool Connector::isEnabled() const
{
    return m_isEnabled;
}

void Connector::setCategory(QString category)
{
    if (m_category == category)
        return;

    m_category = category;
    emit categoryChanged(m_category);
}

void Connector::setImageLink(QString imageLink)
{
    if (m_imageLink == imageLink)
        return;

    m_imageLink = imageLink;
    emit imageLinkChanged(m_imageLink);
}

void Connector::setName(QString name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged(m_name);
}

void Connector::setIsEnabled(bool isEnabled)
{
    if (m_isEnabled == isEnabled)
        return;

    m_isEnabled = isEnabled;
    emit isEnabledChanged(m_isEnabled);
}
