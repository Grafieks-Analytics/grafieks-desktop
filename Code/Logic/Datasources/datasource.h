#ifndef DATASOURCE_H
#define DATASOURCE_H

#include <QObject>

/*!
 * \brief Roles required for Datasource
 * \details This document won't explain the individual Roles in detail. Basically, the class describes the Getter/Setter functions for the Roles
 * to be used in other classes.
 * \ingroup Datasources
 */

class Datasource : public QObject
{
    Q_OBJECT

    int m_id;
    int m_connectedWorkbooksCount;
    int m_profileId;
    QString m_connectionType;
    QString m_datasourceName;
    QString m_databaseName;
    QString m_descriptions;
    QString m_sourceType;
    QString m_imageLink;
    QString m_downloadLink;
    QString m_createdDate;
    QString m_firstName;
    QString m_lastName;
    QString m_lastRun;
    bool m_downloadAllowed;
    bool m_connectAllowed;
    bool m_publishAllowed;

public:
    explicit Datasource(const int & id, const int & connectedWorkbooksCount, const int & profileId, const QString & connectionType, const QString & datasourceName, const QString & databaseName, const QString & descriptions, const QString & sourceType, const QString & imageLink, const QString & downloadLink, const QString & createdDate, const QString & firstName, const QString & lastName, const QString & lastRun, const bool & downloadAllowed, const bool & connectAllowed, const bool & publishAllowed, QObject *parent = nullptr);

    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(int connectedWorkbooksCount READ connectedWorkbooksCount WRITE setConnectedWorkbooksCount NOTIFY connectedWorkbooksCountChanged)
    Q_PROPERTY(int profileId READ profileId WRITE setProfileId NOTIFY profileIdChanged)
    Q_PROPERTY(QString connectionType READ connectionType WRITE setConnectionType NOTIFY connectionTypeChanged)
    Q_PROPERTY(QString datasourceName READ datasourceName WRITE setDatasourceName NOTIFY datasourceNameChanged)
    Q_PROPERTY(QString databaseName READ databaseName WRITE setDatabaseName NOTIFY databaseNameChanged)
    Q_PROPERTY(QString descriptions READ descriptions WRITE setDescriptions NOTIFY descriptionsChanged)
    Q_PROPERTY(QString sourceType READ sourceType WRITE setSourceType NOTIFY sourceTypeChanged)
    Q_PROPERTY(QString imageLink READ imageLink WRITE setImageLink NOTIFY imageLinkChanged)
    Q_PROPERTY(QString downloadLink READ downloadLink WRITE setDownloadLink NOTIFY downloadLinkChanged)
    Q_PROPERTY(QString createdDate READ createdDate WRITE setCreatedDate NOTIFY createdDateChanged)
    Q_PROPERTY(QString firstName READ firstName WRITE setFirstName NOTIFY firstNameChanged)
    Q_PROPERTY(QString lastName READ lastName WRITE setLastName NOTIFY lastNameChanged)
    Q_PROPERTY(QString lastRun READ lastRun WRITE setLastRun NOTIFY lastRunChanged)
    Q_PROPERTY(bool downloadAllowed READ downloadAllowed WRITE setDownloadAllowed NOTIFY downloadAllowedChanged)
    Q_PROPERTY(bool connectAllowed READ connectAllowed WRITE setConnectAllowed NOTIFY connectAllowedChanged)
    Q_PROPERTY(bool publishAllowed READ publishAllowed WRITE setPublishAllowed NOTIFY publishAllowedChanged)

    QString connectionType() const;
    QString datasourceName() const;
    QString databaseName() const;
    QString descriptions() const;
    QString imageLink() const;
    int id() const;
    int connectedWorkbooksCount() const;
    int profileId() const;
    QString sourceType() const;
    QString downloadLink() const;
    QString createdDate() const;
    QString firstName() const;
    QString lastName() const;
    QString lastRun() const;
    bool downloadAllowed() const;
    bool connectAllowed() const;
    bool publishAllowed() const;

public slots:
    void setConnectionType(QString connectionType);
    void setDatasourceName(QString datasourceName);
    void setDatabaseName(QString databaseName);
    void setDescriptions(QString descriptions);
    void setImageLink(QString imageLink);
    void setId(int id);
    void setConnectedWorkbooksCount(int connectedWorkbooksCount);
    void setProfileId(int profileId);
    void setSourceType(QString sourceType);
    void setDownloadLink(QString downloadLink);
    void setCreatedDate(QString createdDate);
    void setFirstName(QString firstName);
    void setLastName(QString lastName);
    void setLastRun(QString lastRun);
    void setDownloadAllowed(bool downloadAllowed);
    void setConnectAllowed(bool connectAllowed);
    void setPublishAllowed(bool publishAllowed);

signals:
    void connectionTypeChanged(QString connectionType);
    void datasourceNameChanged(QString datasourceName);
    void databaseNameChanged(QString databaseName);
    void descriptionsChanged(QString descriptions);
    void imageLinkChanged(QString imageLink);
    void idChanged(int id);
    void connectedWorkbooksCountChanged(int connectedWorkbooksCount);
    void profileIdChanged(int profileId);
    void sourceTypeChanged(QString sourceType);
    void downloadLinkChanged(QString downloadLink);
    void createdDateChanged(QString createdDate);
    void firstNameChanged(QString firstName);
    void lastNameChanged(QString lastName);
    void lastRunChanged(QString lastRun);
    void downloadAllowedChanged(bool downloadAllowed);
    void connectAllowedChanged(bool connectAllowed);
    void publishAllowedChanged(bool publishAllowed);
};

#endif // DATASOURCE_H
