#ifndef MYSQLCONNECT_H
#define MYSQLCONNECT_H

#include <QSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QtDebug>
#include <QObject>


class MysqlConnect : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString mysqlHost READ mysqlHost WRITE setMysqlHost NOTIFY mysqlHostChanged)
    Q_PROPERTY(QString mysqlUsername READ mysqlUsername WRITE setMysqlUsername NOTIFY mysqlUsernameChanged)
    Q_PROPERTY(QString mysqlPassword READ mysqlPassword WRITE setMysqlPassword NOTIFY mysqlPasswordChanged)
    Q_PROPERTY(QString mysqlPort READ mysqlPort WRITE setMysqlPort NOTIFY mysqlPortChanged)
    Q_PROPERTY(QString mysqlDatabase READ mysqlDatabase WRITE setMysqlDatabase NOTIFY mysqlDatabaseChanged)

public:
    explicit MysqlConnect(QObject *parent = nullptr);

    QString mysqlHost() const;
    QString mysqlUsername() const;
    QString mysqlPassword() const;
    QString mysqlPort() const;
    QString mysqlDatabase() const;

    Q_INVOKABLE QString startConnection();

signals:

    void mysqlHostChanged(QString mysqlHost);
    void mysqlUsernameChanged(QString mysqlUsername);
    void mysqlPasswordChanged(QString mysqlPassword);
    void mysqlPortChanged(QString mysqlPort);
    void mysqlDatabaseChanged(QString mysqlDatabase);

public slots:

    void setMysqlHost(QString mysqlHost);
    void setMysqlUsername(QString mysqlUsername);
    void setMysqlPassword(QString mysqlPassword);
    void setMysqlPort(QString mysqlPort);
    void setMysqlDatabase(QString mysqlDatabase);

private:
    QSqlDatabase db_mysql;
    QString m_mysqlHost;
    QString m_mysqlUsername;
    QString m_mysqlPassword;
    QString m_mysqlPort;
    QString m_mysqlDatabase;

};

#endif // MYSQLCONNECT_H
