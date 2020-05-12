#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtWebEngine>
#include <QSettings>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QtQml>

#include "Code/Models/General/qttest2.h"
#include "Code/Datasources/mysqlcon.h"
#include "Code/Models/Menu/user.h"
#include "Code/Models/Datasources/datasources.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Grafieks Limited");
    QCoreApplication::setOrganizationDomain("grafieks.com");
    QCoreApplication::setApplicationName("Grafieks");

    QtTest2 qttest2;
    MysqlCon mysqlconnect;
    Datasources dsparams;
    User user;

    qmlRegisterSingletonType( QUrl("qrc:/Constants.qml"), "com.grafieks.singleton.constants", 1, 0, "Constants" );


    QtWebEngine::initialize();
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Default");

    engine.rootContext()->setContextProperty("QtTest2", &qttest2);
    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("Datasources", &dsparams);
    engine.rootContext()->setContextProperty("User", &user);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
