#include "mongocon.h"

MongoCon::MongoCon(QObject *parent) : QObject(parent)
{

}

QVariantMap MongoCon::MongoInstance(const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    return outputStatus;
}

QVariantMap MongoCon::MongoOdbcInstance(const QString &driver, const QString &host, const QString &db, const int &port, const QString &username, const QString &password)
{
    QVariantMap outputStatus;

    QSqlDatabase dbOdbc = QSqlDatabase::addDatabase("QODBC", "mongo_conn");
    // Fetching from Mongo database
    //     dbOdbc.setDatabaseName("DRIVER={MongoDB ODBC 1.4.2 ANSI Driver};Server={cluster0.bdrhj.mongodb.net};Port=27015;Database=mongo_test");
    dbOdbc.setDatabaseName("DRIVER={MongoDB ODBC 1.4.2 ANSI Driver};Server=127.0.0.1;Port=3307;Database=mongo_test");
    //    dbOdbc.setHostName("cluster0.bdrhj.mongodb.net");
    //    dbOdbc.setPort(27015);
    //    dbOdbc.setUserName("mongouser");
    //    dbOdbc.setPassword("Test@312");


    if( dbOdbc.open()){
        qDebug() << "Connected MongoDb SQL";

        QSqlQuery query("select * from test_collection",dbOdbc);
        while (query.next())
        {
            QString column1= query.value(0).toString();
            QString column2= query.value(1).toString();
            QString column3= query.value(2).toString();
            qDebug() << column1 << column2 << column3;
        }

    } else{
        qDebug() << dbOdbc.lastError().text() << "ERROR";
    }

    return outputStatus;
}

MongoCon::~MongoCon()
{

}
