#ifndef DATASOURCES_H
#define DATASOURCES_H

#include <QSqlQuery>
#include <QSqlError>
#include <QtDebug>

#include <QVariantMap>
#include <QVariantList>
#include <QtDebug>
#include <QObject>


class Datasources : public QObject
{
    Q_OBJECT


public:
    explicit Datasources(QObject *parent = nullptr);

    Q_INVOKABLE int saveDataSources(int my_datasource_id, QString source_type, QString datasource_name, QString description, QString image_link, QString owner_name);
    Q_INVOKABLE QVariantList fetchDatasources();

    Q_PROPERTY(QString dsName READ dsName WRITE setDsName NOTIFY dsNameChanged)
    Q_PROPERTY(QString dsDescription READ dsDescription WRITE setDsDescription NOTIFY dsDescriptionChanged)
    Q_PROPERTY(QString dsImage READ dsImage WRITE setDsImage NOTIFY dsImageChanged)
    Q_PROPERTY(QString dsOwner READ dsOwner WRITE setDsOwner NOTIFY dsOwnerChanged)
    Q_PROPERTY(QString sourceType READ sourceType WRITE setSourceType NOTIFY sourceTypeChanged)

    QString dsName() const;
    QString dsDescription() const;
    QString dsImage() const;
    QString dsOwner() const;
    QString sourceType() const;

signals:

    void dsNameChanged(QString dsName);
    void dsDescriptionChanged(QString dsDescription);
    void dsImageChanged(QString dsImage);
    void dsOwnerChanged(QString dsOwner);
    void sourceTypeChanged(QString sourceType);

public slots:
    void setDsName(QString dsName);
    void setDsDescription(QString dsDescription);
    void setDsImage(QString dsImage);
    void setDsOwner(QString dsOwner);
    void setSourceType(QString sourceType);

private:
    QString m_dsName;
    QString m_dsDescription;
    QString m_dsImage;
    QString m_dsOwner;
    QString m_sourceType;


    bool saveMappings(int datasource_id, int connection_id);
    int saveConnections();
};

#endif // DATASOURCES_H
