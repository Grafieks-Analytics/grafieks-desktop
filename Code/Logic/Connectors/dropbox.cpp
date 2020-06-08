#include "dropbox.h"

Dropbox::Dropbox(const QString &id, const QString &tag, const QString &name, const QString &pathLower, const QString &clientModified,const QString &extension, QObject *parent):
    QObject(parent),m_id(id),m_tag(tag),m_name(name),m_pathLower(pathLower),m_clientModified(clientModified),m_extension(extension)
{

}

QString Dropbox::id() const
{
    return m_id;
}

QString Dropbox::tag() const
{
    return m_tag;
}

QString Dropbox::name() const
{
    return m_name;
}

QString Dropbox::clientModified() const
{
    return m_clientModified;
}

QString Dropbox::pathLower() const
{
    return m_pathLower;
}

QString Dropbox::extension() const
{
    return m_extension;
}

void Dropbox::setId(QString id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Dropbox::setTag(QString tag)
{
    if (m_tag == tag)
        return;

    m_tag = tag;
    emit tagChanged(m_tag);
}

void Dropbox::setName(QString name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged(m_name);
}

void Dropbox::setClientModified(QString clientModified)
{
    if (m_clientModified == clientModified)
        return;

    m_clientModified = clientModified;
    emit clientModifiedChanged(m_clientModified);
}

void Dropbox::setPathLower(QString pathLower)
{
    if (m_pathLower == pathLower)
        return;

    m_pathLower = pathLower;
    emit pathLowerChanged(m_pathLower);
}

void Dropbox::setExtension(QString extension)
{
    if (m_extension == extension)
        return;

    m_extension = extension;
    emit extensionChanged(m_extension);
}
