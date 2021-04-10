#include "qttest.h"

// All Sql test
// Dont use it for anything else please

QtTest::QtTest(QObject *parent) : QObject(parent)
{



}

void QtTest::calla()
{
    qDebug() << "Mongo CALLED";
//    QString dbStringRed = "DRIVER={Amazon Redshift (x64)};Server=redshift-cluster-1.cahcrqdskrvh.ap-south-1.redshift.amazonaws.com;Database=grafieks_rs;Tusted_Connection=True";
//    QSqlDatabase dbRedshiftOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::redshiftOdbcStrType);


    QString dbString = "DRIVER={MongoDB ODBC 1.4.0 ANSI Driver};Server=localhost;Port=3307;Database=grafieks_mo";
    QSqlDatabase dbMongoOdbc = QSqlDatabase::addDatabase("QODBC", Constants::mongoOdbcStrType);

    dbMongoOdbc.setDatabaseName(dbString);
    dbMongoOdbc.setPort(3307);
    dbMongoOdbc.setHostName("redshift-cluster-1.cahcrqdskrvh.ap-south-1.redshift.amazonaws.com");
    dbMongoOdbc.setUserName("awsuser");
    dbMongoOdbc.setPassword("AwsR312sp");

    if(dbMongoOdbc.open()){

        QSqlQuery q("SHOW TABLES", dbMongoOdbc);
        qDebug() << "Mongo";
        while (q.next()) {
                 qDebug() <<  q.value(0);
             }
    }
}

