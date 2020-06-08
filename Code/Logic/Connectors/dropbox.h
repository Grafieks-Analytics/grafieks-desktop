#ifndef DROPBOX_H
#define DROPBOX_H

#include <QObject>

class Dropbox : public QObject
{
    Q_OBJECT

    QString m_id;
    QString m_tag;
    QString m_name;
    QString m_pathLower;
    QString m_clientModified;
    QString m_extension;

public:
    explicit Dropbox(const QString & id,const QString & tag,const QString & name,const QString & pathLower,const QString & clientModified,const QString & extension,QObject *parent = nullptr);

    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString tag READ tag WRITE setTag NOTIFY tagChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString pathLower READ pathLower WRITE setPathLower NOTIFY pathLowerChanged)
    Q_PROPERTY(QString clientModified READ clientModified WRITE setClientModified NOTIFY clientModifiedChanged)
    Q_PROPERTY(QString extension READ extension WRITE setExtension NOTIFY extensionChanged)

    QString id() const;
    QString tag() const;
    QString name() const;
    QString clientModified() const;
    QString pathLower() const;
    QString extension() const;

public slots:
    void setId(QString id);
    void setTag(QString tag);
    void setName(QString name);
    void setClientModified(QString clientModified);
    void setPathLower(QString pathLower);
    void setExtension(QString extension);

signals:

    void idChanged(QString id);
    void tagChanged(QString tag);
    void nameChanged(QString name);
    void clientModifiedChanged(QString clientModified);
    void pathLowerChanged(QString pathLower);
    void extensionChanged(QString extension);
};

#endif // DROPBOX_H
