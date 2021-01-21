#include "qttest.h"

// All Sql test
// Dont use it for anything else please

QtTest::QtTest(QObject *parent) : QObject(parent)
{
    QString queryString;
    QSqlQueryModel model;

//    QSqlDatabase dbSqlite = QSqlDatabase::addDatabase("QSQLITE", Constants::sqliteStrType);
//    dbSqlite.setDatabaseName("/Users/mac/Downloads/Chinook_Sqlite.sqlite");

//    if(dbSqlite.open()){

//        queryString = "SELECT * FROM  Album";
//        model.setQuery(queryString, dbSqlite);

//        QString title = model.record(1).value("Title").toString();
//        qDebug() << title << "TANGO";
//    }
//    else{
//        qDebug() << "TANGO" << "NOT OPEN";
//    }
}

