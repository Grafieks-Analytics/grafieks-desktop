#ifndef GITHUB_H
#define GITHUB_H

#include <QObject>

class Github : public QObject
{
    Q_OBJECT
    QString m_id;
    QString m_name;
    QString m_kind;
    QString m_modifiedTime;
    QString m_extension;
    QString m_url;

public:
    explicit Github(const QString & id,const QString & kind,const QString & name,const QString & modifiedTime,const QString & extension, const QString &url, QObject *parent = nullptr);

    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged);
    Q_PROPERTY(QString kind READ kind WRITE setKind NOTIFY kindChanged);
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged);
    Q_PROPERTY(QString modifiedTime READ modifiedTime WRITE setModifiedTime NOTIFY modifiedTimeChanged);
    Q_PROPERTY(QString extension READ extension WRITE setExtension NOTIFY extensionChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)

    QString id() const;
    QString kind() const;
    QString name() const;
    QString modifiedTime() const;
    QString extension() const;
    QString url() const;

public slots:
    void setId(QString id);
    void setKind(QString kind);
    void setName(QString name);
    void setModifiedTime(QString modifiedTime);
    void setExtension(QString extension);
    void setUrl(QString url);

signals:

    void idChanged(QString id);
    void kindChanged(QString kind);
    void nameChanged(QString name);
    void modifiedTimeChanged(QString modifiedTime);
    void extensionChanged(QString extension);
    void urlChanged(QString url);
};

#endif // GITHUB_H
