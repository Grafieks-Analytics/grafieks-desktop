#include "qttest.h"

// All Sql test
// Dont use it for anything else please

QtTest::QtTest(QObject *parent) : QObject(parent)
{



}

void QtTest::calla()
{
//    qDebug() << "Snowflake CALLED";
//    QString dbStringRed = "DRIVER={Amazon Redshift (x64)};Server=redshift-cluster-1.cahcrqdskrvh.ap-south-1.redshift.amazonaws.com;Database=grafieks_rs;Tusted_Connection=True";
//    QSqlDatabase dbRedshiftOdbc2 = QSqlDatabase::addDatabase("QODBC", Constants::redshiftOdbcStrType);


//    QString dbString = "DRIVER={MongoDB ODBC 1.4.0 ANSI Driver};Server=localhost;Port=3307;Database=grafieks_mo";
//    QSqlDatabase dbMongoOdbc = QSqlDatabase::addDatabase("QODBC", Constants::mongoOdbcStrType);

    QString dbString = "DRIVER={SnowflakeDSIIDriver};Server=IS42979.ap-south-1.aws.snowflakecomputing.com;Port=443;Database=SNOWFLAKE_SAMPLE_DATA";
    QSqlDatabase dbMongoOdbc = QSqlDatabase::addDatabase("QODBC", Constants::snowflakeOdbcStrType);

    dbMongoOdbc.setDatabaseName(dbString);
    dbMongoOdbc.setPort(443);
    dbMongoOdbc.setHostName("IS42979.ap-south-1.aws.snowflakecomputing.com");
    dbMongoOdbc.setUserName("chilarai");
    dbMongoOdbc.setPassword("312@Barron");

    if(dbMongoOdbc.open()){

        QSqlQuery q("SHOW TABLES", dbMongoOdbc);
        qDebug() << "Snowflake";
        while (q.next()) {
                 qDebug() <<  q.value(0) << q.value(1) << q.value(2);
             }
    }



}

