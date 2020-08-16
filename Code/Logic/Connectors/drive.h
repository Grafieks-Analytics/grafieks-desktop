#ifndef DRIVE_H
#define DRIVE_H

#include <QObject>

/*!
 * \brief Roles required for Google Drive API/Model
 * \details This document won't explain the individual Roles in detail. Basically, the class describes the Getter/Setter functions for the Roles
 * to be used in other classes.
 * \ingroup ConnectorScreen
 */

class Drive : public QObject
{
    Q_OBJECT
    QString m_id;
    QString m_name;
    QString m_modifiedTime;
    QString m_extension;
    QString m_kind;

public:
    explicit Drive(const QString & id,const QString & kind,const QString & name,const QString & modifiedTime,const QString & extension,QObject *parent = nullptr);

    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged);
    Q_PROPERTY(QString kind READ kind WRITE setKind NOTIFY kindChanged);
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged);
    Q_PROPERTY(QString modifiedTime READ modifiedTime WRITE setModifiedTime NOTIFY modifiedTimeChanged);
    Q_PROPERTY(QString extension READ extension WRITE setExtension NOTIFY extensionChanged)

    QString id() const;
    QString name() const;
    QString modifiedTime() const;
    QString extension() const;
    QString kind() const;

public slots:
    void setId(QString id);
    void setName(QString name);
    void setModifiedTime(QString modifiedTime);
    void setExtension(QString extension);
    void setKind(QString kind);

signals:

    void idChanged(QString id);
    void nameChanged(QString name);
    void modifiedTimeChanged(QString modifiedTime);
    void extensionChanged(QString extension);
    void kindChanged(QString kind);
};

#endif // DRIVE_H
