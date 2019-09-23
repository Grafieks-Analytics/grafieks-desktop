#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtWebEngine>
#include <QDebug>

#include "Code/Headers/mysqlconnect.h"
#include "Code/Headers/qttest.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    MysqlConnect mysqlconnect;
    QtTest qttest;

    QtWebEngine::initialize();
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Default");

    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("QtTest", &qttest);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
