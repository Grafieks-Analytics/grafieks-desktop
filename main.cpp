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
#include "Code/Logic/Connectors/connectorfilter.h"
#include "Code/Logic/Datasources/datasourcemodel.h"
#include "Code/Logic/Datasources/datasourceds.h"

#include "Code/Connectors/mysqlcon.h"

int main(int argc, char *argv[])
{

    // Application basic initialization
    QtWebEngine::initialize();
    QQuickStyle::setStyle("Default");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Settings
    QCoreApplication::setOrganizationName("Grafieks Limited");
    QCoreApplication::setOrganizationDomain("grafieks.com");
    QCoreApplication::setApplicationName("Grafieks");

    // Initialize Objects
    QtTest2 qttest2;
    MysqlCon mysqlconnect;
    User user;
    ConnectorFilter connectorFilter;
    DatasourceModel datasourceModel;
    DatasourceDS * datasource = new DatasourceDS(&app);
    static MysqlCon myCon;


    // Call default functions
    datasourceModel.setDatasourceds(datasource);
//    qttest2.fetchPosts();

    myCon.MysqlInstance("localhost", "grafieks_my", 3306, "root", "123@312QQl");

    // Define singletons
    qmlRegisterSingletonType( QUrl("qrc:/Constants.qml"), "com.grafieks.singleton.constants", 1, 0, "Constants" );



    // Set contexts for QML
    engine.rootContext()->setContextProperty("QtTest2", &qttest2);
    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("User", &user);
    engine.rootContext()->setContextProperty("ConnectorFilter", &connectorFilter);
    engine.rootContext()->setContextProperty("DatasourceModel", &datasourceModel);
    engine.rootContext()->setContextProperty("DatasourceDS",datasource);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
