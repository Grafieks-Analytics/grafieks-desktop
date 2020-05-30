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
#include "Code/Logic/Connectors/connectorsloginmodel.h"
#include "Code/Logic/Datasources/datasourcemodel.h"
#include "Code/Logic/Datasources/datasourceds.h"
#include "Code/Logic/DataModeller/tablelistmodel.h"
#include "Code/Logic/DataModeller/querymodel.h"
#include "Code/Logic/DataModeller/dblistmodel.h"

#include "Code/statics.h"


QString Statics::myHost;
QString Statics::myDb;
int Statics::myPort;
QString Statics::myUsername;
QString Statics::myPassword;


int main(int argc, char *argv[])
{

    // Application basic initialization
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QtWebEngine::initialize();
    QQuickStyle::setStyle("Default");

    // Settings
    QCoreApplication::setOrganizationName("Grafieks Limited");
    QCoreApplication::setOrganizationDomain("grafieks.com");
    QCoreApplication::setApplicationName("Grafieks");

    // Initialize Objects
    QtTest2 qttest2;
    MysqlCon mysqlconnect;
    User user;
    ConnectorFilter connectorFilter;
    ConnectorsLoginModel connectorsLoginModel;
    DatasourceModel datasourceModel;
    DatasourceDS * datasource = new DatasourceDS(&app);
    TableListModel tableListModel;
    QueryModel queryModel;
    DBListModel dblistModel;


    // Call default functions
    datasourceModel.setDatasourceds(datasource);
//    qttest2.fetchPosts();


    // Define singletons
    qmlRegisterSingletonType( QUrl("qrc:/Constants.qml"), "com.grafieks.singleton.constants", 1, 0, "Constants" );


    // Set contexts for QML
    engine.rootContext()->setContextProperty("QtTest2", &qttest2);
    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("User", &user);
    engine.rootContext()->setContextProperty("ConnectorFilter", &connectorFilter);
    engine.rootContext()->setContextProperty("ConnectorsLoginModel", &connectorsLoginModel);
    engine.rootContext()->setContextProperty("DatasourceModel", &datasourceModel);
    engine.rootContext()->setContextProperty("DatasourceDS",datasource);
    engine.rootContext()->setContextProperty("TableListModel",&tableListModel);
    engine.rootContext()->setContextProperty("QueryModel",&queryModel);
    engine.rootContext()->setContextProperty("DBListModel",&dblistModel);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
