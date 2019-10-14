#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtWebEngine>
#include <QDebug>

#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlError>
#include <QSqlQuery>

#include "Code/Headers/mysqlconnect.h"
#include "Code/Headers/qttest.h"
#include "Code/Headers/localstoragesqlite.h"


void createsqlite();

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    MysqlConnect mysqlconnect;
    QtTest qttest;
    LocalStorageSqlite localstoragesqlite;

    QtWebEngine::initialize();
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Default");

    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("QtTest", &qttest);
     engine.rootContext()->setContextProperty("LocalStorageSqlite", &localstoragesqlite);

    createsqlite();

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}




// Create Local Sqlite Storage starts

void createsqlite(){
    const QString DRIVER("QSQLITE");
    if(QSqlDatabase::isDriverAvailable(DRIVER)){

        QSqlDatabase db_sqlite = QSqlDatabase::addDatabase("QSQLITE");
        db_sqlite.setDatabaseName("grafieks.db");

        if(!db_sqlite.open())
            qWarning() << "ERROR: " << db_sqlite.lastError();

        QSqlQuery query;

        // Datasources table

        if(!query.exec("CREATE TABLE datasources ("
                       "id	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                       "db_type	TEXT NOT NULL,"
                       "connection_string	TEXT,"
                       "mode	TEXT NOT NULL,"
                       "datasource_name	TEXT NOT NULL,"
                       "description	TEXT,"
                       "image_link	TEXT,"
                       "owner_name	TEXT NOT NULL)"
                       ))
        {
            qDebug() << "datasources table could not be created";
        }

        // User table

        if(!query.exec("CREATE TABLE user ("
                       "id	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                       "user_id	INTEGER,"
                       "name	TEXT,"
                       "email	TEXT)"

                       ))
        {
            qDebug() << "user table could not be created";
        }
    }
}

// Create local sqlite storage ends
