#ifndef CONNECTOR_H
#define CONNECTOR_H

#include <QObject>

/*!
 * \brief Roles required for Connector Screen grid items
 * \details This document won't explain the individual Roles in detail. Basically, the class describes the Getter/Setter functions for the Roles
 * to be used in other classes.
 * \ingroup ConnectorScreen
 */

class Connector : public QObject
{
    Q_OBJECT
    QString m_name;
    QString m_imageLink;
    QString m_category;

public:
    explicit Connector(QObject *parent = nullptr);
    Connector(const QString &name, const QString &imageLink,const QString &category , QObject * parent = nullptr);

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString imageLink READ imageLink WRITE setImageLink NOTIFY imageLinkChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)

    QString category() const;
    QString imageLink() const;
    QString name() const;

public slots:
    void setCategory(QString category);
    void setImageLink(QString imageLink);
    void setName(QString name);

signals:

    void categoryChanged(QString category);
    void imageLinkChanged(QString imageLink);
    void nameChanged(QString name);
};

#endif // CONNECTOR_H
