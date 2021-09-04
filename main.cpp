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

#include "Code/Logic/DataModeller/querymodel.h"
#include "Code/Logic/DataModeller/querydatamodel.h"
#include "Code/Logic/DataModeller/dblistmodel.h"
#include "Code/Logic/DataModeller/querystatsmodel.h"
#include "Code/Logic/DataModeller/dsparamsmodel.h"
#include "Code/Logic/DataModeller/publishdatasourcemodel.h"
#include "Code/Logic/DataModeller/schedulerds.h"
#include "Code/Logic/DataModeller/schedulermodel.h"
#include "Code/Logic/DataModeller/filtercategoricallistmodel.h"
#include "Code/Logic/DataModeller/filterdatelistmodel.h"
#include "Code/Logic/DataModeller/filternumericallistmodel.h"
#include "Code/Logic/DataModeller/proxyfiltermodel.h"
#include "Code/Logic/DataModeller/duckdatamodel.h"
#include "Code/Logic/DataModeller/duckquerymodel.h"
#include "Code/Logic/DataModeller/forwardonlydatamodel.h"
#include "Code/Logic/DataModeller/forwardonlyquerymodel.h"
#include "Code/Logic/DataModeller/newtablelistmodel.h"
#include "Code/Logic/DataModeller/exceldatamodel.h"
#include "Code/Logic/DataModeller/excelquerymodel.h"
#include "Code/Logic/DataModeller/csvjsondatamodel.h"
#include "Code/Logic/DataModeller/csvjsonquerymodel.h"

#include "Code/Logic/Connectors/duckcon.h"
#include "Code/Logic/Connectors/odbcdriversmodel.h"
#include "Code/Logic/Connectors/dropboxds.h"
#include "Code/Logic/Connectors/dropboxmodel.h"
#include "Code/Logic/Connectors/driveds.h"
#include "Code/Logic/Connectors/drivemodel.h"
#include "Code/Logic/Connectors/boxds.h"
#include "Code/Logic/Connectors/boxmodel.h"
#include "Code/Logic/Connectors/sheetds.h"
#include "Code/Logic/Connectors/sheetmodel.h"
#include "Code/Logic/Connectors/githubds.h"
#include "Code/Logic/Connectors/githubmodel.h"

#include "Code/Logic/Dashboards/documenthandlermodel.h"
#include "Code/Logic/Dashboards/dashboardparamsmodel.h"
#include "Code/Logic/Dashboards/tablecolumnsmodel.h"

#include "Code/Logic/Reports/reportparamsmodel.h"
#include "Code/Logic/Reports/reportsdatamodel.h"

#include "Code/Logic/General/chartsmodel.h"
#include "Code/Logic/General/chartsthread.h"
#include "Code/Logic/General/generalparamsmodel.h"
#include "Code/Logic/General/tableschemamodel.h"
#include "Code/Logic/General/newtablecolumnsmodel.h"
#include "Code/Logic/General/querysplitter.h"

#include "Code/statics.h"

QString Statics::currentDbName;
int Statics::currentDbIntType;
QString Statics::currentDbStrType;
QString Statics::currentDbClassification;
int Statics::onlineStorageType;
QString Statics::driverName;
QString Statics::extractPath;
QString Statics::csvJsonPath;
QVariantMap Statics::changedHeaderTypes;
bool Statics::freeLimitExtractSizeExceeded;

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

QString Statics::acDb;
QString Statics::acUsername;
QString Statics::acPassword;

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

QString Statics::snowflakeHost;
QString Statics::snowflakeDb;
int Statics::snowflakePort;
QString Statics::snowflakeUsername;
QString Statics::snowflakePassword;

QString Statics::teradataHost;
QString Statics::teradataDb;
int Statics::teradataPort;
QString Statics::teradataUsername;
QString Statics::teradataPassword;

QString Statics::separator;

QString Statics::excelDb;

// DuckDB
//duckdb::DuckDB duckDb(nullptr);
//duckdb::Connection duckConnection(duckDb);

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

    // For Shape drawing antialiasing
    QSurfaceFormat format;
    format.setSamples(10);
    QSurfaceFormat::setDefaultFormat(format);

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

    // Static initializations Ends
    /***********************************************************************************************************************/
    Statics::freeLimitExtractSizeExceeded = false;
    /***********************************************************************************************************************/
    // Static initializations Ends

    /***********************************************************************************************************************/
    // OBJECT INITIALIZATION STARTS

    MysqlCon mysqlconnect;
    User User;
    ConnectorFilter connectorFilter;
    ConnectorsLoginModel connectorsLoginModel;
    QueryModel queryModel;
    QueryDataModel queryDataModel;
    QueryStatsModel queryStatsModel;
    DBListModel dblistModel;
    DSParamsModel dsParamsModel;
    PublishDatasourceModel publishDatasourceModel;
    ProxyFilterModel proxyModel;
    FilterCategoricalListModel filterCategoricalListModel;
    FilterDateListModel filterDateListModel;
    FilterNumericalListModel filterNumericalListModel;
    ODBCDriversModel odbcDriversModel;
    ChartsThread chartsThread;
    ChartsModel chartsModel(nullptr, &chartsThread);


    GeneralParamsModel generalParamsModel;
    QuerySplitter querySplitter;
    DashboardParamsModel dashboardParamsModel;
    ReportParamsModel reportParamsModel;
    ReportsDataModel reportsDataModel;
    ForwardOnlyDataModel forwardOnlyDataModel;
    ForwardOnlyQueryModel forwardOnlyQueryModel;
    NewTableListModel newTableListModel;
    TableColumnsModel tableColumnsModel;
    ExcelQueryModel excelQueryModel;
    ExcelDataModel excelDataModel;
    CSVJsonDataModel csvJsonDataModel;
    CSVJsonQueryModel csvJsonQueryModel;
    TableSchemaModel tableSchemaModel;
    NewTableColumnsModel newTableColumnsModel;

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

    // Github modal
    GithubModel githubModel;
    GithubDS *github = new GithubDS(&app);

    // Scheduler model
    SchedulerModel schedulerModel;
    SchedulerDS *scheduler = new SchedulerDS(&app);

    // Duck CRUD Model
//    DuckCon *duckCon = new DuckCon();

//    NewTableColumnsModel newTableColumnsModel(duckCon);
//    DuckDataModel *duckDataModel = new DuckDataModel(duckCon);
//    DuckQueryModel duckQueryModel(duckCon);

    // OBJECT INITIALIZATION ENDS
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/
    // SIGNAL & SLOTS STARTS
    // These signal and slots are for same threads
    // For multi threaded signal and slots, they are written inside individual classes

    QObject::connect(&proxyModel, &ProxyFilterModel::sendFilterQuery, &queryModel, &QueryModel::receiveFilterQuery);
//    QObject::connect(&connectorsLoginModel, &ConnectorsLoginModel::sendDbName, duckCon, &DuckCon::createTable);
//    QObject::connect(&connectorsLoginModel, &ConnectorsLoginModel::dropTables, duckCon, &DuckCon::dropTables);
    QObject::connect(&proxyModel, &ProxyFilterModel::sendCsvFilterQuery, &csvJsonQueryModel, &CSVJsonQueryModel::receiveCsvJsonFilterQuery);
    QObject::connect(&proxyModel, &ProxyFilterModel::sendExcelFilterQuery, &excelQueryModel, &ExcelQueryModel::receiveExcelFilterQuery);

    // Data and headers for reports
    QObject::connect(&queryModel, &QueryModel::chartDataChanged, &reportsDataModel, &ReportsDataModel::getChartData);
    QObject::connect(&queryModel, &QueryModel::chartHeaderChanged, &reportsDataModel, &ReportsDataModel::getChartHeader);
//    QObject::connect(&duckQueryModel, &DuckQueryModel::chartDataChanged, &reportsDataModel, &ReportsDataModel::getChartData);
//    QObject::connect(&duckQueryModel, &DuckQueryModel::chartHeaderChanged, &reportsDataModel, &ReportsDataModel::getChartHeader);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::chartDataChanged, &reportsDataModel, &ReportsDataModel::getChartData);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::chartHeaderChanged, &reportsDataModel, &ReportsDataModel::getChartHeader);

    // Data and Headers for Dashboards
    QObject::connect(&queryModel, &QueryModel::chartDataChanged, &tableColumnsModel, &TableColumnsModel::getChartData);
    QObject::connect(&queryModel, &QueryModel::chartHeaderChanged, &tableColumnsModel, &TableColumnsModel::getChartHeader);
//    QObject::connect(&duckQueryModel, &DuckQueryModel::chartDataChanged, &tableColumnsModel, &TableColumnsModel::getChartData);
//    QObject::connect(&duckQueryModel, &DuckQueryModel::chartHeaderChanged, &tableColumnsModel, &TableColumnsModel::getChartHeader);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::chartDataChanged, &tableColumnsModel, &TableColumnsModel::getChartData);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::chartHeaderChanged, &tableColumnsModel, &TableColumnsModel::getChartHeader);

    QObject::connect(&queryModel, &QueryModel::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumns);
    QObject::connect(&csvJsonQueryModel, &CSVJsonQueryModel::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumns);
    QObject::connect(&excelQueryModel, &ExcelQueryModel::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumns);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumns);

    // Dashboards
    QObject::connect(&tableColumnsModel, &TableColumnsModel::columnNamesChanged, &dashboardParamsModel, &DashboardParamsModel::getColumnNames);
    QObject::connect(&dashboardParamsModel, &DashboardParamsModel::filterValuesChanged, &tableColumnsModel, &TableColumnsModel::getFilterValues);

    // Reports
    QObject::connect(&reportParamsModel, &ReportParamsModel::reportFilterChanged, &reportsDataModel, &ReportsDataModel::updateFilterData);
    QObject::connect(&reportParamsModel, &ReportParamsModel::reportIdChanged, &reportsDataModel, &ReportsDataModel::getReportId);

    QObject::connect(&queryModel, &QueryModel::generateReports, &reportsDataModel, &ReportsDataModel::generateColumns);
    QObject::connect(&csvJsonQueryModel, &CSVJsonQueryModel::generateReports, &reportsDataModel, &ReportsDataModel::generateColumns);
    QObject::connect(&excelQueryModel, &ExcelQueryModel::generateReports, &reportsDataModel, &ReportsDataModel::generateColumns);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::generateReports, &reportsDataModel, &ReportsDataModel::generateColumns);

    QObject::connect(&queryModel, &QueryModel::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForExtract);
    QObject::connect(&csvJsonQueryModel, &CSVJsonQueryModel::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForExtract);
    QObject::connect(&excelQueryModel, &ExcelQueryModel::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForExtract);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForExtract);

    // Charts
    //filterValuesChanged Headers for charts
    QObject::connect(&queryModel, &QueryModel::chartHeaderChanged, &chartsThread, &ChartsThread::receiveHeaders);
//    QObject::connect(&duckQueryModel, &DuckQueryModel::chartHeaderChanged, &chartsThread, &ChartsThread::receiveHeaders);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::chartHeaderChanged, &chartsThread, &ChartsThread::receiveHeaders);

    // Data for charts
    QObject::connect(&reportsDataModel, &ReportsDataModel::reportDataChanged, &chartsThread, &ChartsThread::receiveReportData);
    QObject::connect(&tableColumnsModel, &TableColumnsModel::dashboardDataChanged, &chartsThread, &ChartsThread::receiveDashboardData);


    QObject::connect(&proxyModel, &ProxyFilterModel::sendModels, &csvJsonQueryModel, &CSVJsonQueryModel::getAllFilters);


    // SIGNAL & SLOTS ENDS
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/
    // DEFAULT FUNCTION STARTS

    datasourceModel.setDatasourceds(datasource);
    dropboxModel.setDropboxds(dropbox);
    driveModel.setDriveds(drive);
    boxModel.setBoxds(box);
    sheetModel.setSheetds(sheet);
    githubModel.setGithubds(github);
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
    engine.rootContext()->setContextProperty("ReportsDataModel", &reportsDataModel);
    engine.rootContext()->setContextProperty("DashboardParamsModel", &dashboardParamsModel);
    engine.rootContext()->setContextProperty("MysqlConnect", &mysqlconnect);
    engine.rootContext()->setContextProperty("User", &User);
    engine.rootContext()->setContextProperty("ConnectorFilter", &connectorFilter);
    engine.rootContext()->setContextProperty("ConnectorsLoginModel", &connectorsLoginModel);
    engine.rootContext()->setContextProperty("DatasourceModel", &datasourceModel);
    engine.rootContext()->setContextProperty("DatasourceDS", datasource);
    engine.rootContext()->setContextProperty("QueryModel", &queryModel);
    engine.rootContext()->setContextProperty("QueryDataModel", &queryDataModel);
    engine.rootContext()->setContextProperty("DBListModel", &dblistModel);
    engine.rootContext()->setContextProperty("QueryStatsModel", &queryStatsModel);
    engine.rootContext()->setContextProperty("DropboxModel", &dropboxModel);
    engine.rootContext()->setContextProperty("DropboxDS", dropbox);
    engine.rootContext()->setContextProperty("DriveModel", &driveModel);
    engine.rootContext()->setContextProperty("DriveDS", drive);
    engine.rootContext()->setContextProperty("GithubModel", &githubModel);
    engine.rootContext()->setContextProperty("GithubDS", github);
    engine.rootContext()->setContextProperty("BoxModel", &boxModel);
    engine.rootContext()->setContextProperty("BoxDS", box);
    engine.rootContext()->setContextProperty("SheetModel", &sheetModel);
    engine.rootContext()->setContextProperty("SheetDS", sheet);
    engine.rootContext()->setContextProperty("NewTableColumnsModel", &newTableColumnsModel);
    engine.rootContext()->setContextProperty("DSParamsModel", &dsParamsModel);
    engine.rootContext()->setContextProperty("PublishDatasourceModel", &publishDatasourceModel);
    engine.rootContext()->setContextProperty("SchedulerModel", &schedulerModel);
    engine.rootContext()->setContextProperty("SchedulerDS", scheduler);
    engine.rootContext()->setContextProperty("ProxyFilterModel", &proxyModel);
    engine.rootContext()->setContextProperty("FilterCategoricalListModel", &filterCategoricalListModel);
    engine.rootContext()->setContextProperty("FilterDateListModel",&filterDateListModel);
    engine.rootContext()->setContextProperty("FilterNumericalListModel",&filterNumericalListModel);
    engine.rootContext()->setContextProperty("QuerySplitter", &querySplitter);
    engine.rootContext()->setContextProperty("GeneralParamsModel", &generalParamsModel);
    engine.rootContext()->setContextProperty("ODBCDriversModel", &odbcDriversModel);
//    engine.rootContext()->setContextProperty("DuckCon", duckCon);
    engine.rootContext()->setContextProperty("TableSchemaModel", &tableSchemaModel);
//    engine.rootContext()->setContextProperty("DuckDataModel", duckDataModel);
//    engine.rootContext()->setContextProperty("DuckQueryModel", &duckQueryModel);
    engine.rootContext()->setContextProperty("ChartsModel", &chartsModel);
    engine.rootContext()->setContextProperty("ChartsThread", &chartsThread);
    engine.rootContext()->setContextProperty("ForwardOnlyDataModel", &forwardOnlyDataModel);
    engine.rootContext()->setContextProperty("ForwardOnlyQueryModel", &forwardOnlyQueryModel);
    engine.rootContext()->setContextProperty("NewTableListModel", &newTableListModel);
    engine.rootContext()->setContextProperty("TableColumnsModel", &tableColumnsModel);
    engine.rootContext()->setContextProperty("ExcelQueryModel", &excelQueryModel);
    engine.rootContext()->setContextProperty("ExcelDataModel", &excelDataModel);
    engine.rootContext()->setContextProperty("CSVJsonQueryModel", &csvJsonQueryModel);
    engine.rootContext()->setContextProperty("CSVJsonDataModel", &csvJsonDataModel);

    // CONTEXT PROPERTY  ENDS
    /***********************************************************************************************************************/

    engine.load(QUrl(QStringLiteral("qrc:/Splash.qml")));
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
