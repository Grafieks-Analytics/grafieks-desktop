#include "Headers/localstoragesqlite.h"

LocalStorageSqlite::LocalStorageSqlite(QObject *parent) : QObject(parent),
    mysql_host(""),
    mysql_database(""),
    mysql_port(""),
    mysql_username(""),
    mysql_password("")
{

}

void LocalStorageSqlite::tempMysqlCredentials(QString host, QString database, QString port, QString username, QString password)
{
    mysql_host = host;
    mysql_database = database;
    mysql_port = port;
    mysql_username = username;
    mysql_password = password;
}

QVariantList LocalStorageSqlite::mysqlCredentials()
{
    QVariantList my_credentials;
    my_credentials << mysql_host << mysql_database << mysql_port << mysql_username << mysql_password;
    return my_credentials;
}

void LocalStorageSqlite::newUser(QString name, QString email)
{

    QSqlQuery query;

    if(query.exec("INSERT INTO user (name, email) VALUES ('"+name+"', '"+email+"')"))
    {
        emit newUserStatus("Saved user");
    }
    else{
        emit newUserStatus("Could not save user");
    }

}

void LocalStorageSqlite::fetchUser()
{

    QSqlQuery query;

    if(query.exec("SELECT name, email FROM user WHERE id=1"))
    {
        while(query.next())
        {
            emit fetchUserStatus(query.value(0).toString(), query.value(1).toString());
        }
    }
    else{
        qWarning()<< "Error fetching user info";
    }

}

void LocalStorageSqlite::newMysqlSource(QString mode, QString datasource_name, QString description, QString image_link, QString owner_name, QString host, QString username, QString password, QString port, QString database_name)
{

    QString type = "mysql";
    QString connection_string = "host="+host+";username="+username+";password="+password+";port="+port+";database="+database_name;

    QSqlQuery query;

    if(query.exec("INSERT INTO datasources (db_type, connection_string, mode, datasource_name, description, image_link, owner_name)"
                  "VALUES ('"+type+"', '"+connection_string+"', '"+mode+"', '"+datasource_name+"', '"+description+"', '"+image_link+"', '"+owner_name+"')"
                  ))
    {
        emit newMysqlSourceStatus("Saved record");
    }
    else{
        emit newMysqlSourceStatus("Could not save record");
    }
}

void LocalStorageSqlite::fetchDataSource(int datasource_id)
{

    QSqlQuery query;

    if(query.exec("SELECT * FROM datasources WHERE id="+QString::number(datasource_id)))
    {
        while(query.next())
        {
            emit fetchDataSourceStatus(query.value(1).toString(), query.value(2).toString(), query.value(3).toString(), query.value(4).toString(), query.value(5).toString(), query.value(6).toString(), query.value(7).toString());
        }
    }
    else{
        qWarning()<< "Error fetching user info";
    }
}



void LocalStorageSqlite::listDataSources()
{

    QSqlQuery query;

    if(query.exec("SELECT * FROM datasources WHERE id = 1"))
    {
        while(query.next())
        {
            emit listDataSourceStatus(query.value(0).toInt(), query.value(1).toString(), query.value(2).toString(), query.value(3).toString(), query.value(4).toString(), query.value(5).toString(), query.value(6).toString(), query.value(7).toString());

        }

    }
    else{
        qWarning()<< "Error fetching data list";
    }
}
