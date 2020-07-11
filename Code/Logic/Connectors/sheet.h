#ifndef SHEET_H
#define SHEET_H

#include <QObject>

class Sheet : public QObject
{
    Q_OBJECT
    QString m_id;
    QString m_name;
    QString m_modifiedTime;
    QString m_extension;
    QString m_kind;

public:
    explicit Sheet(const QString & id,const QString & kind,const QString & name,const QString & modifiedTime,const QString & extension,QObject *parent = nullptr);

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

#endif // SHEET_H
