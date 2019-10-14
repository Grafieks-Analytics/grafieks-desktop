#ifndef LOCALSTORAGESQLITE_H
#define LOCALSTORAGESQLITE_H


#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlError>
#include <QDebug>
#include <QSqlQuery>

#include <QVariantList>

#include <QObject>

class LocalStorageSqlite : public QObject
{
    Q_OBJECT
public:
    explicit LocalStorageSqlite(QObject *parent = nullptr);

    Q_INVOKABLE void tempMysqlCredentials(QString host, QString database, QString port, QString username, QString password);
    Q_INVOKABLE QVariantList mysqlCredentials();

signals:
    void newUserStatus(QString userstatus);
    void fetchUserStatus(QString name, QString email);
    void newMysqlSourceStatus(QString datasourcestatus);
    void fetchDataSourceStatus(QString db_type, QString connection_string, QString mode, QString datasource_name, QString description, QString image_link, QString owner_name);
    void listDataSourceStatus(int id, QString db_type, QString connection_string, QString mode, QString datasource_name, QString description, QString image_link, QString owner_name);

public slots:
    void newUser(QString name, QString email);
    void fetchUser();
    void newMysqlSource(QString mode, QString datasource_name, QString description, QString image_link, QString owner_name, QString host, QString username, QString password, QString port, QString database_name);
    void fetchDataSource(int datasource_id);
    void listDataSources();

private:
    QString mysql_host, mysql_database, mysql_port, mysql_username, mysql_password;
};

#endif // LOCALSTORAGESQLITE_H
