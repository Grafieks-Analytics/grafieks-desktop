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

#include "Code/Headers/qttest.h"
#include "Code/Headers/mysqlconnect.h"
#include "Code/Headers/user.h"
#include "Code/Headers/datasources.h"


void createsqlite();

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    createsqlite();

    QtTest qttest;
    MysqlConnect mysqlconnect;
    Datasources dsparams;
    User user;

    QtWebEngine::initialize();
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Default");

    engine.rootContext()->setContextProperty("QtTest", &qttest);
    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("Datasources", &dsparams);
    engine.rootContext()->setContextProperty("User", &user);


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
                       "id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                       "my_datasource_id INTEGER NOT NULL,"
                       "source_type TEXT NOT NULL,"
                       "datasource_name TEXT NOT NULL,"
                       "description TEXT,"
                       "image_link TEXT,"
                       "owner_name TEXT NOT NULL)"
                       ))
        {
            qDebug() << "Datasources table already exists";
        }

        // Connections table
        if(!query.exec("CREATE TABLE connections ("
                       "id	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                       "database_type	TEXT NOT NULL,"
                       "connection_string	TEXT NOT NULL)"
                   ))
        {
            qDebug() << "Connections table already exists" << query.lastError();
        }

        // Temporary Connections table
        if(!query.exec("CREATE TABLE temp_connections ("
                       "id	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                       "database_type	TEXT NOT NULL,"
                       "connection_string	TEXT NOT NULL)"
                   ))
        {
            qDebug() << "Connections table already exists" << query.lastError();
        }

        // Datasource Connection Mappings table
        if(!query.exec("CREATE TABLE datasource_connections ("
                       "id	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                       "datasource_id	INTEGER NOT NULL,"
                       "connection_id	INTEGER NOT NULL)"
                   ))
        {
            qDebug() << "Datasource Connections table already exists";
        }


        // User table
        if(!query.exec("CREATE TABLE user ("
                       "id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
                       "profile_id INTEGER NOT NULL,"
                       "session_hash TEXT NOT NULL,"
                       "firstname TEXT NOT NULL,"
                       "lastname TEXT,"
                       "photo_link TEXT)"
                       ))
        {
            qDebug() << "User table already exists";
        }
    }
}

// Create local sqlite storage ends
