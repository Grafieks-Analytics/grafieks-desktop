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

#include "Code/Logic/Menu/user.h"
#include "Code/Logic/Connectors/connectorfilter.h"
#include "Code/Logic/Connectors/connectorsloginmodel.h"

#include "Code/Logic/Datasources/datasourcemodel.h"
#include "Code/Logic/Datasources/datasourceds.h"

#include "Code/Logic/DataModeller/tablelistmodel.h"
#include "Code/Logic/DataModeller/querymodel.h"
#include "Code/Logic/DataModeller/dblistmodel.h"
#include "Code/Logic/DataModeller/querystatsmodel.h"
#include "Code/Logic/DataModeller/dsparamsmodel.h"
#include "Code/Logic/DataModeller/publishdatasourcemodel.h"
#include "Code/Logic/DataModeller/schedulerds.h"
#include "Code/Logic/DataModeller/schedulermodel.h"

#include "Code/Logic/Connectors/dropboxds.h"
#include "Code/Logic/Connectors/dropboxmodel.h"
#include "Code/Logic/Connectors/driveds.h"
#include "Code/Logic/Connectors/drivemodel.h"
#include "Code/Logic/Connectors/boxds.h"
#include "Code/Logic/Connectors/boxmodel.h"
#include "Code/Logic/Connectors/sheetds.h"
#include "Code/Logic/Connectors/sheetmodel.h"

#include "Code/Logic/General/tableschemamodel.h"
#include "Code/Logic/General/qttest2.h"



#include "Code/statics.h"

QString Statics::currentDbName;
int Statics::currentDbIntType;
QString Statics::currentDbStrType;

QString Statics::myHost;
QString Statics::myDb;
int Statics::myPort;
QString Statics::myUsername;
QString Statics::myPassword;

QString Statics::sqliteFile;
QString Statics::sqliteUsername;
QString Statics::sqlitePassword;


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
    User User;
    ConnectorFilter connectorFilter;
    ConnectorsLoginModel connectorsLoginModel;
    DatasourceModel datasourceModel;
    DatasourceDS * datasource = new DatasourceDS(&app);
    TableListModel tableListModel;
    QueryModel queryModel;
    QueryStatsModel queryStatsModel;
    DBListModel dblistModel;
    TableSchemaModel tableSchemaModel;
    DSParamsModel dsParamsModel;
    PublishDatasourceModel publishDatasourceModel;

    SchedulerModel schedulerModel;
    SchedulerDS * scheduler = new SchedulerDS(&app);


    // Datasource Connector Initializations
    DropboxModel dropboxModel;
    DropboxDS * dropbox = new DropboxDS(&app);

    // Google Drive modal
    DriveModel driveModel;
    DriveDS * drive = new DriveDS(&app);

    // Box modal
    BoxModel boxModel;
    BoxDS * box = new BoxDS(&app);

    // Google sheet modal
    SheetModel sheetModel;
    SheetDS * sheet = new SheetDS(&app);


    // Call default functions
    datasourceModel.setDatasourceds(datasource);

    dropboxModel.setDropboxds(dropbox);
    driveModel.setDriveds(drive);
    boxModel.setBoxds(box);
    sheetModel.setSheetds(sheet);
    schedulerModel.setScheduler(scheduler);


    // Define singletons
    qmlRegisterSingletonType( QUrl("qrc:/Constants.qml"), "com.grafieks.singleton.constants", 1, 0, "Constants" );

    // Set contexts for QML
    engine.rootContext()->setContextProperty("QtTest2", &qttest2);
    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("User", &User);
    engine.rootContext()->setContextProperty("ConnectorFilter", &connectorFilter);
    engine.rootContext()->setContextProperty("ConnectorsLoginModel", &connectorsLoginModel);
    engine.rootContext()->setContextProperty("DatasourceModel", &datasourceModel);
    engine.rootContext()->setContextProperty("DatasourceDS",datasource);
    engine.rootContext()->setContextProperty("TableListModel",&tableListModel);
    engine.rootContext()->setContextProperty("QueryModel",&queryModel);
    engine.rootContext()->setContextProperty("DBListModel",&dblistModel);
    engine.rootContext()->setContextProperty("QueryStatsModel",&queryStatsModel);
    engine.rootContext()->setContextProperty("DropboxModel",&dropboxModel);
    engine.rootContext()->setContextProperty("DropboxDS",dropbox);
    engine.rootContext()->setContextProperty("DriveModel",&driveModel);
    engine.rootContext()->setContextProperty("DriveDS",drive);
    engine.rootContext()->setContextProperty("BoxModel",&boxModel);
    engine.rootContext()->setContextProperty("BoxDS",box);
    engine.rootContext()->setContextProperty("SheetModel",&sheetModel);
    engine.rootContext()->setContextProperty("SheetDS",sheet);
    engine.rootContext()->setContextProperty("TableSchemaModel", &tableSchemaModel);
    engine.rootContext()->setContextProperty("DSParamsModel",&dsParamsModel);
    engine.rootContext()->setContextProperty("PublishDatasourceModel", &publishDatasourceModel);

    engine.rootContext()->setContextProperty("SchedulerModel",&schedulerModel);
    engine.rootContext()->setContextProperty("SchedulerDS",scheduler);



    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
