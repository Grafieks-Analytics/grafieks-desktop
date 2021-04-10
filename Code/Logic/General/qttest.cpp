#include "qttest.h"

// All Sql test
// Dont use it for anything else please

QtTest::QtTest(QObject *parent) : QObject(parent)
{



}

void QtTest::calla()
{
    qDebug() << "REDSHIFT CALLED";
    QString dbString1 = "DRIVER={Amazon Redshift (x64)};Server=redshift-cluster-1.cahcrqdskrvh.ap-south-1.redshift.amazonaws.com;Database=grafieks_rs;Tusted_Connection=True";

    QSqlDatabase dbRedshiftOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::redshiftOdbcStrType);

    dbRedshiftOdbc2.setDatabaseName(dbString1);
    dbRedshiftOdbc2.setPort(5439);
    dbRedshiftOdbc2.setHostName("redshift-cluster-1.cahcrqdskrvh.ap-south-1.redshift.amazonaws.com");
    dbRedshiftOdbc2.setUserName("awsuser");
    dbRedshiftOdbc2.setPassword("AwsR312sp");

    if(dbRedshiftOdbc2.open()){

        QSqlQuery q("SELECT * FROM genre", dbRedshiftOdbc2);
        qDebug() << "REDSHIFT";
        while (q.next()) {
                 qDebug() <<  q.value(0) << q.value(1);
             }
    }
}

