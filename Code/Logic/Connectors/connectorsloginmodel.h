#ifndef MYSQLLOGINMODEL_H
#define MYSQLLOGINMODEL_H

#include <QObject>
#include <QtDebug>
#include <QFile>
#include <QFileInfo>

#include "../../Connectors/allconnectors.h"
#include "../../statics.h"
#include "../../constants.h"

/*!
 * \brief Initiates connection to a datasource from the view
 * \details Accepts login credentials from the view and calls the Connectors class
 * \ingroup ConnectorScreen
 */
class ConnectorsLoginModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString connectedDB READ connectedDB WRITE setConnectedDB NOTIFY connectedDBChanged)


    QString m_connectedDB;

public:
    explicit ConnectorsLoginModel(QObject *parent = nullptr);
    Q_INVOKABLE void mysqlLogin(QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void sqliteLogin(QString filename);
    Q_INVOKABLE void csvLogin(QString filename, QString separator);
    Q_INVOKABLE void jsonLogin(QString filename);
    Q_INVOKABLE void excelLogin(QString filename);
    Q_INVOKABLE QString urlToFilePath(const QUrl &url);

    // ODBC
    Q_INVOKABLE void mysqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void mssqlOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void postgresOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void redshiftOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void oracleOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void mongoOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void impalaOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void hiveOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void snowflakeOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void teradataOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void accessOdbcLogin(QString driver, QString host, QString db, int port, QString username, QString password);
    Q_INVOKABLE void excelOdbcLogin(QString driver, QString filename);

    QString connectedDB() const;
    void setConnectedDB(QString connectedDB);

signals:
    void mysqlLoginStatus(QVariantMap status);
    void sqliteLoginStatus(QVariantMap status);
    void odbcLoginStatus(QVariantMap status);
    void mssqlLoginStatus(QVariantMap status);
    void postgresLoginStatus(QVariantMap status);
    void redshiftLoginStatus(QVariantMap status);
    void oracleLoginStatus(QVariantMap status);
    void mongoLoginStatus(QVariantMap status);
    void impalaLoginStatus(QVariantMap status);
    void hiveLoginStatus(QVariantMap status);
    void snowflakeLoginStatus(QVariantMap status);
    void teradataLoginStatus(QVariantMap status);
    void excelLoginStatus(QVariantMap status);
    void jsonLoginStatus(QVariantMap status);
    void csvLoginStatus(QVariantMap status);
    void accessLoginStatus(QVariantMap status);
    void connectedDBChanged(QString connectedDB);
    void connectedDBType(QString conType);
    void sendDbName();
};

#endif // MYSQLLOGINMODEL_H
