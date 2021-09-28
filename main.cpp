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
#include <QFileInfo>
#include <QStandardPaths>

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
#include "Code/Logic/DataModeller/forwardonlydatamodel.h"
#include "Code/Logic/DataModeller/forwardonlyquerymodel.h"
#include "Code/Logic/DataModeller/newtablelistmodel.h"
#include "Code/Logic/DataModeller/exceldatamodel.h"
#include "Code/Logic/DataModeller/excelquerymodel.h"
#include "Code/Logic/DataModeller/csvjsondatamodel.h"
#include "Code/Logic/DataModeller/csvjsonquerymodel.h"

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

#include "Code/Logic/Readers/extractprocessor.h"
#include "Code/Logic/Readers/liveprocessor.h"
#include "Code/Logic/Readers/workbookprocessor.h"

#include "Code/Logic/Reports/reportparamsmodel.h"
#include "Code/Logic/Reports/reportsdatamodel.h"

#include "Code/Logic/General/chartsmodel.h"
#include "Code/Logic/General/chartsthread.h"
#include "Code/Logic/General/generalparamsmodel.h"
#include "Code/Logic/General/tableschemamodel.h"
#include "Code/Logic/General/newtablecolumnsmodel.h"
#include "Code/Logic/General/querysplitter.h"

#include "Code/OS/odbcdriversmodel.h"
#include "Code/OS/osentries.h"

#include "Code/statics.h"

int Statics::isFreeTier;
QString Statics::tmpIconPath;
bool Statics::editMode;

QString Statics::currentDbName;
int Statics::currentDbIntType;
QString Statics::currentDbStrType;
QString Statics::currentDbClassification;
int Statics::onlineStorageType;
QString Statics::driverName;
QString Statics::extractPath;
QString Statics::csvJsonPath;
bool Statics::freeLimitExtractSizeExceeded;
bool Statics::modeProcessReader;
QString Statics::dsType;

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

    // Static initializations Ends
    /***********************************************************************************************************************/
    Statics::freeLimitExtractSizeExceeded = false;
    Statics::isFreeTier = 1; // 1 = true (Free Tier); 0 = false (Pro)
    Statics::tmpIconPath = "C:\\Users\\chill\\Downloads\\grs_gIn_icon.ico";
    Statics::editMode = false;
    /***********************************************************************************************************************/
    // Static initializations Ends

    // SETTINS STARTS
    /***********************************************************************************************************************/
    QCoreApplication::setOrganizationName("Grafieks Limited");
    QCoreApplication::setOrganizationDomain("grafieks.com");
    QCoreApplication::setApplicationName(Constants::appName);

    // Random session token for tmp file writing purposes
    QSettings settings;
    settings.setValue("general/fileToken", QDateTime::currentMSecsSinceEpoch());

    // Delete existing tmp folder storing dashboard files
    QString tmpFilePath = QCoreApplication::applicationDirPath() + "/" + "tmp/";
    QDir(tmpFilePath).removeRecursively();

    // Registry entries
#ifdef Q_OS_WIN
  OsEntries osEntries;
  osEntries.witeToWindowsRegistry();
#elif Q_OS_MACX
  qDebug() << "Mac & Linux versions not supported yet";
#else
#error "We don't support that version yet..."
#endif

    /***********************************************************************************************************************/
    // SETTINS ENDS

    /***********************************************************************************************************************/
    // OBJECT INITIALIZATION STARTS

    MysqlCon mysqlconnect;
    User User;
    ConnectorFilter connectorFilter;
    ConnectorsLoginModel connectorsLoginModel;
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
    NewTableListModel newTableListModel;
    TableColumnsModel tableColumnsModel;
    ExcelDataModel excelDataModel;
    CSVJsonDataModel csvJsonDataModel;
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

    // Processor model
    ExtractProcessor extractProcessor(&generalParamsModel, &dsParamsModel);
    LiveProcessor liveProcessor(&generalParamsModel, &dsParamsModel);
    WorkbookProcessor workbookProcessor(&generalParamsModel);

    // Data Modeler
    QueryModel queryModel(&generalParamsModel);
    ForwardOnlyQueryModel forwardOnlyQueryModel(&generalParamsModel);
    ExcelQueryModel excelQueryModel(&generalParamsModel);
    CSVJsonQueryModel csvJsonQueryModel(&generalParamsModel);


    // OBJECT INITIALIZATION ENDS
    /***********************************************************************************************************************/
    /***********************************************************************************************************************/
    // SIGNAL & SLOTS STARTS
    // These signal and slots are for same threads
    // For multi threaded signal and slots, they are written inside individual classes

    QObject::connect(&proxyModel, &ProxyFilterModel::sendFilterQuery, &queryModel, &QueryModel::receiveFilterQuery);
    QObject::connect(&proxyModel, &ProxyFilterModel::sendFilterQuery, &forwardOnlyQueryModel, &ForwardOnlyQueryModel::receiveFilterQuery);
    QObject::connect(&proxyModel, &ProxyFilterModel::sendExcelFilterQuery, &excelQueryModel, &ExcelQueryModel::receiveExcelFilterQuery);

    QObject::connect(&queryModel, &QueryModel::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumnsForExtract);
    QObject::connect(&csvJsonQueryModel, &CSVJsonQueryModel::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumnsForExtract);
    QObject::connect(&excelQueryModel, &ExcelQueryModel::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumnsForExtract);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumnsForExtract);
    QObject::connect(&extractProcessor, &ExtractProcessor::generateReports, &tableColumnsModel, &TableColumnsModel::generateColumnsForReader);

    // Dashboards
    QObject::connect(&tableColumnsModel, &TableColumnsModel::columnNamesChanged, &dashboardParamsModel, &DashboardParamsModel::getColumnNames);
    QObject::connect(&dashboardParamsModel, &DashboardParamsModel::filterValuesChanged, &tableColumnsModel, &TableColumnsModel::getFilterValues);

    // Reports
    QObject::connect(&reportParamsModel, &ReportParamsModel::reportFilterChanged, &reportsDataModel, &ReportsDataModel::updateFilterData);
    QObject::connect(&reportParamsModel, &ReportParamsModel::reportIdChanged, &reportsDataModel, &ReportsDataModel::getReportId);

    QObject::connect(&queryModel, &QueryModel::generateReports, &reportsDataModel, &ReportsDataModel::generateColumnsForExtract);
    QObject::connect(&csvJsonQueryModel, &CSVJsonQueryModel::generateReports, &reportsDataModel, &ReportsDataModel::generateColumnsForExtract);
    QObject::connect(&excelQueryModel, &ExcelQueryModel::generateReports, &reportsDataModel, &ReportsDataModel::generateColumnsForExtract);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::generateReports, &reportsDataModel, &ReportsDataModel::generateColumnsForExtract);
    QObject::connect(&extractProcessor, &ExtractProcessor::generateReports, &reportsDataModel, &ReportsDataModel::generateColumnsForReader);

    QObject::connect(&queryModel, &QueryModel::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForExtract);
    QObject::connect(&csvJsonQueryModel, &CSVJsonQueryModel::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForExtract);
    QObject::connect(&excelQueryModel, &ExcelQueryModel::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForExtract);
    QObject::connect(&forwardOnlyQueryModel, &ForwardOnlyQueryModel::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForExtract);
    QObject::connect(&extractProcessor, &ExtractProcessor::generateReports, &tableSchemaModel, &TableSchemaModel::generateSchemaForReader);

    // Charts
    // Data for charts
    QObject::connect(&reportsDataModel, &ReportsDataModel::reportWhereConditions, &chartsModel, &ChartsModel::receiveReportConditions);
    QObject::connect(&tableColumnsModel, &TableColumnsModel::dashboardWhereConditions, &chartsModel, &ChartsModel::receiveDashboardConditions);

    QObject::connect(&proxyModel, &ProxyFilterModel::sendModels, &csvJsonQueryModel, &CSVJsonQueryModel::getAllFilters);

    // Save & Restore Workbooks
    QObject::connect(&reportParamsModel, &ReportParamsModel::sendReportParams, &workbookProcessor, &WorkbookProcessor::getReportParams);
    QObject::connect(&dashboardParamsModel, &DashboardParamsModel::sendDashboardParams, &workbookProcessor, &WorkbookProcessor::getDashboardParams);
    QObject::connect(&tableColumnsModel, &TableColumnsModel::signalSaveTableColumns, &workbookProcessor, &WorkbookProcessor::getTableColumns);
    QObject::connect(&chartsModel, &ChartsModel::sendWhereParams, &workbookProcessor, &WorkbookProcessor::getWhereParams);
    QObject::connect(&workbookProcessor, &WorkbookProcessor::sendExtractReportParams, &reportParamsModel, &ReportParamsModel::getExtractReportParams);
    QObject::connect(&workbookProcessor, &WorkbookProcessor::sendExtractTableColumns, &tableColumnsModel, &TableColumnsModel::getExtractTableColumns);
    QObject::connect(&workbookProcessor, &WorkbookProcessor::sendExtractDashboardParams, &dashboardParamsModel, &DashboardParamsModel::getExtractDashboardParams);
    QObject::connect(&workbookProcessor, &WorkbookProcessor::sendExtractWhereParams, &chartsModel, &ChartsModel::getExtractWhereParams);
    QObject::connect(&workbookProcessor, &WorkbookProcessor::processExtractFromWorkbook, &extractProcessor, &ExtractProcessor::setArgumentsFromWorkbook);

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
    qmlRegisterSingletonType(QUrl("qrc:/Source/Constants.qml"), "com.grafieks.singleton.constants", 1, 0, "Constants");
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
    engine.rootContext()->setContextProperty("TableSchemaModel", &tableSchemaModel);
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
    engine.rootContext()->setContextProperty("ExtractProcessor", &extractProcessor);
    engine.rootContext()->setContextProperty("WorkbookProcessor", &workbookProcessor);

    // CONTEXT PROPERTY  ENDS
    /***********************************************************************************************************************/

    // OPEN Extracts/Live/Workbook files STARTS
    /***********************************************************************************************************************/

    QStringList arguments = QCoreApplication::arguments();
    if(arguments.length()>1){

        QString fileToRead = arguments.at(1);
        QFileInfo fi(fileToRead);
        QString extension = fi.suffix();

        if(extension == Constants::extractExt){
            extractProcessor.setArgumentsByFile(fileToRead);
        } else if(extension == Constants::liveExt){
//            liveProcessor.setArgumentsByFile(fileToRead);
        } else if(extension == Constants::workbookExt){
            workbookProcessor.setArgumentsByFile(fileToRead);

        } else {
            qDebug() << "Unknown file";
        }
    }
    /***********************************************************************************************************************/
    // OPEN Extracts/Live/Workbook files ENDS

    engine.load(QUrl(QStringLiteral("qrc:/Source/Splash.qml")));
    engine.load(QUrl(QStringLiteral("qrc:/Source/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
