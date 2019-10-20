#include "./Headers/mysqlconnect.h"

MysqlConnect::MysqlConnect(QObject *parent) : QObject(parent)
{
}

QString MysqlConnect::mysqlHost() const
{
    return m_mysqlHost;
}

QString MysqlConnect::mysqlUsername() const
{
    return m_mysqlUsername;
}

QString MysqlConnect::mysqlPassword() const
{
    return m_mysqlPassword;
}

QString MysqlConnect::mysqlPort() const
{
    return m_mysqlPort;
}

QString MysqlConnect::mysqlDatabase() const
{
    return m_mysqlDatabase;
}

QString MysqlConnect::startConnection()
{

    QSqlDatabase db_mysql = QSqlDatabase::addDatabase("QMYSQL", "mysql_handle");

    db_mysql.setHostName(mysqlHost());
    db_mysql.setUserName(mysqlUsername());
    db_mysql.setPort(mysqlPort().toInt());
    db_mysql.setPassword(mysqlPassword());
    db_mysql.setDatabaseName(mysqlDatabase());

    if(db_mysql.open()){

        QString connection_string = "host="+mysqlHost()+";db="+mysqlDatabase()+";port="+mysqlPort()+";user="+mysqlUsername()+";pass="+mysqlPassword();

        QSqlQuery query;
        query.exec("SELECT * FROM temp_connections");

        if(query.last() == false){
            query.prepare("INSERT INTO temp_connections(database_type, connection_string) VALUES (?, ?)");
            query.addBindValue("MYSQL");
            query.addBindValue(connection_string);
            query.exec();
        }
        else{
            query.prepare("UPDATE temp_connections database_type = ?, connection_string = ? WHERE id=1)");
            query.addBindValue("MYSQL");
            query.addBindValue(connection_string);
            query.exec();
        }

        return "Success";
    }
    else{
        return "Failed to connect." + db_mysql.lastError().text();
    }
}

void MysqlConnect::setMysqlHost(QString mysqlHost)
{
    if (m_mysqlHost == mysqlHost)
        return;

    m_mysqlHost = mysqlHost;
    emit mysqlHostChanged(m_mysqlHost);
}

void MysqlConnect::setMysqlUsername(QString mysqlUsername)
{
    if (m_mysqlUsername == mysqlUsername)
        return;

    m_mysqlUsername = mysqlUsername;
    emit mysqlUsernameChanged(m_mysqlUsername);
}

void MysqlConnect::setMysqlPassword(QString mysqlPassword)
{
    if (m_mysqlPassword == mysqlPassword)
        return;

    m_mysqlPassword = mysqlPassword;
    emit mysqlPasswordChanged(m_mysqlPassword);
}

void MysqlConnect::setMysqlPort(QString mysqlPort)
{
    if (m_mysqlPort == mysqlPort)
        return;

    m_mysqlPort = mysqlPort;
    emit mysqlPortChanged(m_mysqlPort);
}

void MysqlConnect::setMysqlDatabase(QString mysqlDatabase)
{
    if (m_mysqlDatabase == mysqlDatabase)
        return;

    m_mysqlDatabase = mysqlDatabase;
    emit mysqlDatabaseChanged(m_mysqlDatabase);
}

