#include "box.h"

Box::Box(const QString &id, const QString &name, const QString &type, const QString &modifiedAt, const QString &extension, QObject *parent):
    QObject(parent),m_id(id),m_name(name),m_type(type),m_modifiedAt(modifiedAt),m_extension(extension)
{

}

QString Box::id() const
{
    return m_id;
}

QString Box::name() const
{
    return m_name;
}

QString Box::type() const
{
    return m_type;
}

QString Box::modifiedAt() const
{
    return m_modifiedAt;
}

QString Box::extension() const
{
    return m_extension;
}

void Box::setId(QString id)
{
    if (m_id == id)
        return;

    m_id = id;
    emit idChanged(m_id);
}

void Box::setName(QString name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged(m_name);
}

void Box::setType(QString type)
{
    if (m_type == type)
        return;

    m_type = type;
    emit typeChanged(m_type);
}

void Box::setModifiedAt(QString modifiedAt)
{
    if (m_modifiedAt == modifiedAt)
        return;

    m_modifiedAt = modifiedAt;
    emit modifiedAtChanged(m_modifiedAt);
}

void Box::setExtension(QString extension)
{
    if (m_extension == extension)
        return;

    m_extension = extension;
    emit extensionChanged(m_extension);
}

