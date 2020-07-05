#ifndef BOX_H
#define BOX_H

#include <QObject>

class Box : public QObject
{
    Q_OBJECT
    QString m_id;
    QString m_name;
    QString m_type;
    QString m_modifiedAt;
    QString m_extension;

public:
    explicit Box(const QString & id,const QString & name,const QString & type,const QString & modifiedAt,const QString & extension,QObject *parent = nullptr);

    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged);
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged);
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged);
    Q_PROPERTY(QString modifiedAt READ modifiedAt WRITE setModifiedAt NOTIFY modifiedAtChanged);
    Q_PROPERTY(QString extension READ extension WRITE setExtension NOTIFY extensionChanged);

    QString id() const;
    QString name() const;
    QString type() const;
    QString modifiedAt() const;
    QString extension() const;

public slots:
    void setId(QString id);
    void setName(QString name);
    void setType(QString type);
    void setModifiedAt(QString modifiedAt);
    void setExtension(QString extension);

signals:

    void idChanged(QString id);
    void nameChanged(QString name);
    void typeChanged(QString type);
    void modifiedAtChanged(QString modifiedAt);
    void extensionChanged(QString extension);
};

#endif // BOX_H
