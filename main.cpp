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

#include <QtQml/QQmlApplicationEngine>

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
#include "Code/Logic/DataModeller/columnlistmodel.h"
#include "Code/Logic/DataModeller/filtercategoricallistmodel.h"
#include "Code/Logic/DataModeller/filterdatelistmodel.h"
#include "Code/Logic/DataModeller/filternumericallistmodel.h"
#include "Code/Logic/DataModeller/proxyfiltermodel.h"
#include "Code/Logic/DataModeller/csvcolumnlistmodel.h"

#include "Code/Logic/Connectors/odbcdriversmodel.h"
#include "Code/Logic/Connectors/dropboxds.h"
#include "Code/Logic/Connectors/dropboxmodel.h"
#include "Code/Logic/Connectors/driveds.h"
#include "Code/Logic/Connectors/drivemodel.h"
#include "Code/Logic/Connectors/boxds.h"
#include "Code/Logic/Connectors/boxmodel.h"
#include "Code/Logic/Connectors/sheetds.h"
#include "Code/Logic/Connectors/sheetmodel.h"

#include "Code/Logic/Dashboards/documenthandlermodel.h"
#include "Code/Logic/Dashboards/dashboardparamsmodel.h"

#include "Code/Logic/Reports/reportparamsmodel.h"
#include "Code/Logic/Reports/reportmodellist.h"

#include "Code/Logic/General/generalparamsmodel.h"
#include "Code/Logic/General/tableschemamodel.h"
#include "Code/Logic/General/tablecolumnsmodel.h"
#include "Code/Logic/General/querysplitter.h"
#include "Code/Logic/General/qttest2.h"
#include "Code/Logic/General/qttest.h"

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

QString Statics::msHost;
QString Statics::msDb;
int Statics::msPort;
QString Statics::msUsername;
QString Statics::msPassword;

QString Statics::postgresHost;
QString Statics::postgresDb;
int Statics::postgresPort;
QString Statics::postgresUsername;
QString Statics::postgresPassword;

QString Statics::redshiftHost;
QString Statics::redshiftDb;
int Statics::redshiftPort;
QString Statics::redshiftUsername;
QString Statics::redshiftPassword;

QString Statics::oracleHost;
QString Statics::oracleDb;
int Statics::oraclePort;
QString Statics::oracleUsername;
QString Statics::oraclePassword;

QString Statics::mongoHost;
QString Statics::mongoDb;
int Statics::mongoPort;
QString Statics::mongoUsername;
QString Statics::mongoPassword;

QString Statics::impalaHost;
QString Statics::impalaDb;
int Statics::impalaPort;
QString Statics::impalaUsername;
QString Statics::impalaPassword;

QString Statics::hiveHost;
QString Statics::hiveDb;
int Statics::hivePort;
QString Statics::hiveUsername;
QString Statics::hivePassword;

QString Statics::separator;

// DuckDB
duckdb::DuckDB duckDb(nullptr);
duckdb::Connection duckConnection(duckDb);

/*! \mainpage Code Documentation
 *
 * \subsection tools Development tools
 * <a href="https://www.qt.io/">Qt SDK 5.15 (C++ & QML)</a>
 *
 * \subsection navigation Document Navigation
 * \details Before starting to read the code documentation, it is recommended to install all the dependencies and run the application.
 * Begin by reading the basic setup documents below:
 * <ul>
 * <li><a href="md__documentation__configuration__mac.html">Mac installation</a> or <a href="md__documentation__configuration__windows_10.html">Windows 10 installation</a></li>
 * <li><a href="md__documentation__mysql__installation.html">MySql installation</a></li>
 * <li><a href="md__r_e_a_d_m_e.html">General instructions</a></li>
 * <li><a href="md__documentation__layouts.html">Grafieks Layout Structure</a></li>
 * </ul>
 *
 * Code is categorized into various modules depending on the individual display screens in the application file. Access it by visiting the
 * <a href="file:///Users/mac/grafieks-desktop-windows/Documentation/html/modules.html"><b>Modules Link</b></a>. Rest of the files can be also accessed using <a href="annotated.html"><b>Classes</b></a>
 * or <a href="files.html"><b>Files</b></a> menu options
 *
 * \subsection convention File Naming Conventions
 * \details
 * <ul>
 * <li><b>`*model.h`, `*model.cpp`</b> files are the models for views in QtQuick</li>
 * <li><b>`*filter.h`, `*filter.cpp`</b> files are the proxy models for views in QtQuick. Basically, they help in search and sort.</li>
 * <li><b>`*ds.h`, `*ds.cpp`</b> files don't interact with views. They talk to internet based APIs</li>
 * <li><b>`*.h`, `*.cpp`</b> general class files</li>
 * </ul>
 */

/*!
 *  \defgroup Connectors
 *  \brief Database connections
 *
 *  \defgroup Logic
 *  \brief Rest of all the classes for the application
 *
 * \defgroup ConnectorScreen
 * \ingroup Logic
 * \brief Classes related to Connectors screen
 *
 * \defgroup DataModeller
 * \ingroup Logic
 * \brief Classes related to Modelling Screen. Both Query and Data modeller
 *
 * \defgroup Datasources
 * \ingroup Logic
 * \brief Classes related to Datasources
 *
 * \defgroup General
 * \ingroup Logic
 * \brief All other General classes
 *
 * \defgroup Reports
 * \ingroup Logic
 * \brief Classes related to Reports
 *
 * \defgroup Dashboards
 * \ingroup Logic
 * \brief Classes related to Dashboard designing
 */

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

    // Random session token for tmp file writing purposes
    QSettings settings;
    settings.setValue("general/fileToken", QDateTime::currentMSecsSinceEpoch());

    // Delete existing tmp folder storing dashboard files
    QString tmpFilePath = QCoreApplication::applicationDirPath() + "/" + "tmp/";
    QDir(tmpFilePath).removeRecursively();

    /***********************************************************************************************************************/
    // OBJECT INITIALIZATION STARTS

    QtTest2 qttest2;
    QtTest qttest;


    MysqlCon mysqlconnect;
    User User;
    ConnectorFilter connectorFilter;
    ConnectorsLoginModel connectorsLoginModel;
    TableListModel tableListModel;
    QueryModel queryModel;
    QueryStatsModel queryStatsModel;
    DBListModel dblistModel;
    TableSchemaModel tableSchemaModel;
    TableColumnsModel tableColumnsModel;
    DSParamsModel dsParamsModel;
    PublishDatasourceModel publishDatasourceModel;
    ColumnListModel columnListModel;
    ProxyFilterModel proxyModel;
    FilterCategoricalListModel filterCategoricalListModel;
    FilterDateListModel filterDateListModel;
    FilterNumericalListModel filterNumericalListModel;
    ODBCDriversModel odbcDriversModel;
    CsvColumnListModel csvColListModel;

    GeneralParamsModel generalParamsModel;
    QuerySplitter querySplitter;
    DashboardParamsModel dashboardParamsModel;
    ReportParamsModel reportParamsModel;
    ReportModelList reportModelList;

    // Datasource Connector Initializations
    DatasourceModel datasourceModel;
    DatasourceDS *datasource = new DatasourceDS(&app);

    // Dropbox modal
    DropboxModel dropboxModel;
    DropboxDS *dropbox = new DropboxDS(&app);

    // Google Drive modal
    DriveModel driveModel;
    DriveDS *drive = new DriveDS(&app);

    // Box modal
    BoxModel boxModel;
    BoxDS *box = new BoxDS(&app);

    // Google sheet modal
    SheetModel sheetModel;
    SheetDS *sheet = new SheetDS(&app);

    // Scheduler model
    SchedulerModel schedulerModel;
    SchedulerDS *scheduler = new SchedulerDS(&app);

    // OBJECT INITIALIZATION ENDS
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/
    // SIGNAL & SLOTS STARTS

    //    QObject::connect(&filterCategoricalListModel, &FilterCategoricalListModel::sendFilterQuery, &queryModel, &QueryModel::receiveFilterQuery);
    //    QObject::connect(&filterDateListModel, &FilterDateListModel::sendFilterQuery, &queryModel, &QueryModel::receiveFilterQuery);
    //    QObject::connect(&filterNumericalListModel, &FilterNumericalListModel::sendFilterQuery, &queryModel, &QueryModel::receiveFilterQuery);
    QObject::connect(&proxyModel, &ProxyFilterModel::sendFilterQuery, &queryModel, &QueryModel::receiveFilterQuery);
    QObject::connect(&proxyModel, &ProxyFilterModel::sendCsvFilterQuery, &csvColListModel, &CsvColumnListModel::receiveCsvFilterQuery);


    // Name of the columns
    // Actual data

    // SIGNAL & SLOTS ENDS
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/
    // DEFAULT FUNCTION STARTS

    datasourceModel.setDatasourceds(datasource);
    dropboxModel.setDropboxds(dropbox);
    driveModel.setDriveds(drive);
    boxModel.setBoxds(box);
    sheetModel.setSheetds(sheet);
    schedulerModel.setScheduler(scheduler);


    // DEFAULT FUNCTION ENDS
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/
    // CONTEXT PROPERTY STARTS

    // Define singletons
    qmlRegisterSingletonType(QUrl("qrc:/Constants.qml"), "com.grafieks.singleton.constants", 1, 0, "Constants");
    qmlRegisterType<DocumentHandlerModel>("io.qt.examples.texteditor", 1, 0, "DocumentHandlerModel");

    // Set contexts for QML
    engine.rootContext()->setContextProperty("ReportParamsModel", &reportParamsModel);
    engine.rootContext()->setContextProperty("ReportModelList", &reportModelList);
    engine.rootContext()->setContextProperty("DashboardParamsModel", &dashboardParamsModel);
    engine.rootContext()->setContextProperty("QtTest2", &qttest2);
    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("User", &User);
    engine.rootContext()->setContextProperty("ConnectorFilter", &connectorFilter);
    engine.rootContext()->setContextProperty("ConnectorsLoginModel", &connectorsLoginModel);
    engine.rootContext()->setContextProperty("DatasourceModel", &datasourceModel);
    engine.rootContext()->setContextProperty("DatasourceDS", datasource);
    engine.rootContext()->setContextProperty("TableListModel", &tableListModel);
    engine.rootContext()->setContextProperty("QueryModel", &queryModel);
    engine.rootContext()->setContextProperty("DBListModel", &dblistModel);
    engine.rootContext()->setContextProperty("QueryStatsModel", &queryStatsModel);
    engine.rootContext()->setContextProperty("DropboxModel", &dropboxModel);
    engine.rootContext()->setContextProperty("DropboxDS", dropbox);
    engine.rootContext()->setContextProperty("DriveModel", &driveModel);
    engine.rootContext()->setContextProperty("DriveDS", drive);
    engine.rootContext()->setContextProperty("BoxModel", &boxModel);
    engine.rootContext()->setContextProperty("BoxDS", box);
    engine.rootContext()->setContextProperty("SheetModel", &sheetModel);
    engine.rootContext()->setContextProperty("SheetDS", sheet);
    engine.rootContext()->setContextProperty("TableSchemaModel", &tableSchemaModel);
    engine.rootContext()->setContextProperty("TableColumnsModel", &tableColumnsModel);
    engine.rootContext()->setContextProperty("DSParamsModel", &dsParamsModel);
    engine.rootContext()->setContextProperty("PublishDatasourceModel", &publishDatasourceModel);
    engine.rootContext()->setContextProperty("ColumnListModel", &columnListModel);
    engine.rootContext()->setContextProperty("SchedulerModel", &schedulerModel);
    engine.rootContext()->setContextProperty("SchedulerDS", scheduler);
    engine.rootContext()->setContextProperty("ProxyFilterModel", &proxyModel);
    engine.rootContext()->setContextProperty("FilterCategoricalListModel", &filterCategoricalListModel);
    engine.rootContext()->setContextProperty("FilterDateListModel",&filterDateListModel);
    engine.rootContext()->setContextProperty("FilterNumericalListModel",&filterNumericalListModel);
    engine.rootContext()->setContextProperty("QuerySplitter", &querySplitter);
    engine.rootContext()->setContextProperty("GeneralParamsModel", &generalParamsModel);
    engine.rootContext()->setContextProperty("ODBCDriversModel", &odbcDriversModel);
    engine.rootContext()->setContextProperty("CsvColumnListModel", &csvColListModel);

    // CONTEXT PROPERTY  ENDS
    /***********************************************************************************************************************/

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
