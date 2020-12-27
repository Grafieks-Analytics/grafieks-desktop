#include "mssqlcon.h"

MSSqlCon::MSSqlCon(QObject *parent) : QObject(parent)
{

}

QVariantMap MSSqlCon::MSSqlInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    return outputStatus;
}

QVariantMap MSSqlCon::MSSqlOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;
    QSqlDatabase dbOdbc = QSqlDatabase::addDatabase("QODBC", "mssql_conn");
    // Fetching from MYSQL database
    // Windows Authentication for localservver
    // For remote server, server ip, username and password required
    dbOdbc.setDatabaseName("DRIVER={SQL Server};Server=DESKTOP-NSN20CD\\SQLEXPRESS;Database=mssql-test;Trusted_Connection=True;"); // "WorkDatabase" is the name of the database we want
    dbOdbc.setUserName("DESKTOP-NSN20\\vishal");

    bool ok = dbOdbc.open();
    if(ok){
        qDebug() << "Connected MS SQL";

        QSqlQuery q1;

        // Fetch data from TABLE
        q1.prepare("SELECT * FROM test_table");

        if(q1.exec()){
            while(q1.next()){
                qDebug() << q1.value(0).toString() << q1.value(1).toString() << q1.value(2).toString()  ;
            }
        }else{
            qDebug() << q1.lastError().text();
        }

    } else{
        qDebug() << dbOdbc.lastError().text() << "ERROR";
    }

    return outputStatus;
}

MSSqlCon::~MSSqlCon()
{

}
