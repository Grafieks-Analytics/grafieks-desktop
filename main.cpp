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

#include "Code/Connectors/mysqlcon.h"
#include "Code/Logic/General/qttest2.h"
#include "Code/Logic/Menu/user.h"
#include "Code/Logic/Datasources/connectorfilter.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Grafieks Limited");
    QCoreApplication::setOrganizationDomain("grafieks.com");
    QCoreApplication::setApplicationName("Grafieks");

    QtTest2 qttest2;
    MysqlCon mysqlconnect;
    User user;
    ConnectorFilter connectorFilter;

    qmlRegisterSingletonType( QUrl("qrc:/Constants.qml"), "com.grafieks.singleton.constants", 1, 0, "Constants" );

    QtWebEngine::initialize();
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Default");

    engine.rootContext()->setContextProperty("QtTest2", &qttest2);
    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("User", &user);
    engine.rootContext()->setContextProperty("ConnectorFilter", &connectorFilter);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
