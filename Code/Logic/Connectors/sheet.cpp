#include "sheet.h"

Sheet::Sheet(const QString &id, const QString &name,const QString &kind, const QString &modifiedTime, const QString &extension, QObject *parent):
    QObject(parent),m_id(id),m_name(name),m_kind(kind),m_modifiedTime(modifiedTime),m_extension(extension)
{

}

QString Sheet::id() const
{
    return m_id;
}

QString Sheet::name() const
{
    return m_name;
}

QString Sheet::modifiedTime() const
{
    return m_modifiedTime;
}

QString Sheet::extension() const
{
    return m_extension;
}

QString Sheet::kind() const
{
    return m_kind;
}

void Sheet::setId(QString id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Sheet::setName(QString name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged(m_name);
}

void Sheet::setModifiedTime(QString modifiedTime)
{
    if (m_modifiedTime == modifiedTime)
        return;

    m_modifiedTime = modifiedTime;
    emit modifiedTimeChanged(m_modifiedTime);
}

void Sheet::setExtension(QString extension)
{
    if (m_extension == extension)
        return;

    m_extension = extension;
    emit extensionChanged(m_extension);
}

void Sheet::setKind(QString kind)
{
    if (m_kind == kind)
        return;

    m_kind = kind;
    emit kindChanged(m_kind);
}
