#include "drive.h"

Drive::Drive(const QString &id, const QString &name,const QString &kind, const QString &modifiedTime, const QString &extension, QObject *parent):
    QObject(parent),m_id(id),m_name(name),m_kind(kind),m_modifiedTime(modifiedTime),m_extension(extension)
{

}

QString Drive::id() const
{
    return m_id;
}

QString Drive::name() const
{
    return m_name;
}

QString Drive::modifiedTime() const
{
    return m_modifiedTime;
}

QString Drive::extension() const
{
    return m_extension;
}

QString Drive::kind() const
{
    return m_kind;
}

void Drive::setId(QString id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Drive::setName(QString name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged(m_name);
}

void Drive::setModifiedTime(QString modifiedTime)
{
    if (m_modifiedTime == modifiedTime)
        return;

    m_modifiedTime = modifiedTime;
    emit modifiedTimeChanged(m_modifiedTime);
}

void Drive::setExtension(QString extension)
{
    if (m_extension == extension)
        return;

    m_extension = extension;
    emit extensionChanged(m_extension);
}

void Drive::setKind(QString kind)
{
    if (m_kind == kind)
        return;

    m_kind = kind;
    emit kindChanged(m_kind);
}
