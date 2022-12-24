/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Global Constants file
**
****************************************************************************/

pragma Singleton
import QtQuick 2.15

QtObject {

    // Menu Indexes
    property int initialIndex: 3
    property int dataDesignerIndex: 3
    property int dashboardDesignerIndex: 6
    property int newReportIndex: 7

    property string gaugePointerLabel: 'Pointer/Actual';

    property string liveDS : qsTr("live")
    property string extractDS : qsTr("extract")

    property string liveFileExt: "gads"
    property string extractFileExt: "gadse"
    property string workbookFileExt: "gawb"

    property int tooltipShowTime: 1000
    property int tooltipHideTime: 5000

    // DB Classification
    property string duckType: "DUCK"
    property string sqlType: "SQL"
    property string forwardType: "FORWARD"
    property string csvType: "CSV"
    property string jsonType: "JSON"
    property string excelType: "EXCEL"
    property string accessType: "ACCESS"

    // ODBC Driver matching names
    property string mysqlOdbc: qsTr("MySQL")
    property string postgresOdbc: qsTr("PostgreSQL")
    property string accessOdbc: qsTr("access")
    property string excelOdbc: qsTr("excel")
    property string hiveOdbc: qsTr("hive")
    property string impalaOdbc: qsTr("Apache Impala")
    property string mongoOdbc: qsTr("mongo")
    property string mssqlOdbc: qsTr("SQL Server")
    property string oracleOdbc: qsTr("oracle")
    property string redshiftOdbc: qsTr("redshift")
    property string sqliteOdbc: qsTr("SQLite")
    property string snowflakeOdbc: qsTr("snowflake")
    property string teradataOdbc: qsTr("Teradata")

    // Online Storage Types
    // These values are matched with Constants.h file
    property int driveType: 18
    property int githubType: 10
    property int sheetType: 20
    property int boxType: 19
    property int dropBoxType: 17

    property string driveString : "Google Drive"
    property string githubString : "Github"
    property string sheetString : "Google Sheet"
    property string boxString : "Box"
    property string dropBoxString : "Dropbox"


    // Theme Colors

    property color themeColor : "#F3F3F4"
    property color hoverThemeColor : "#E4E4E7"
    property color darkThemeColor : "#CCCCCC"
    property color greenThemeColor : "#A1D99B"
    property color redThemeColor : "#FB8072"
    property color borderBlueColor : "#BCE0FD"
    //    property color lightThemeColor : "#F5F5F5"
    property color leftDarkColor: "#E2E2E4"
    property color lightThemeColor: "#E2E2E4"
    property color buttonBorderColor : "#009B8F"
    property color buttonHoverColor : "#009B8F"
    property color whiteColor : "#FFFFFF"
    property color grayColor : "#707070"
    property color blackColor : "#000000"
    property color redColor: "#ff0000"
    property color grafieksGreen: "#009B8F"
    property color grafieksGreenColor: "#009B8F"
    property color grafieksLightGreenColor: "#0dd1c2"
    property color scrollBarColor: "#CCCCCC"
    property color dataModelBorderColor: "#66009b8f"

    property color dropHighlightColor: "ivory"
    property color dropIneligibleHighlightColor: "#ffdfdb"

    property color lightGrayTextColor: "#454545"
    property color dropAreaHighlightColor: "ivory"
    property color dashboardDefaultBackgroundColor: "white"

    property color defaultDroppedRectangleColor:"#fdb462"

    property color defaultColorDialogColor: "#000000"
    property var d3ColorPalette : [ "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf" ]


    // Standard Font Sizes

    property font fontDefault : Qt.font({family : "verdana"})
    property int fontHeader : 20
    property int fontSubHeader : 18
    property int fontCategoryHeader : 16
    property int fontCategoryHeaderMedium : 14
    property int fontCategoryHeaderSmall : 12
    property int fontReading: 10

    //font.pointSize: Constants.fontReading = font.pixelSize: Constants.fontCategoryHeader
    //font.pointSize: Constants.fontCategoryHeader = font.pixelSize: Constants.fontHeader

    //Constant Widths
    property int leftMenubarWidth: 49
    property int subMenuWidth: 31


    // Constant Height
    property int defaultElementHeight: 30

    // Menu option
    property int dataDesignerMenu : 0
    property int dashboardDesignerMenu : 1
    property int dataModellerTab: 0
    property int queryModellerTab: 1

    // Radio Size
    property int defaultRadioDimension: 16
    property int defaultRadius: 4

    // Checbox Size
    property int defaultCheckBoxDimension: 16

    // ODBC Driver url starts
    property string hiveDriverUrl: ""
    property string impalaDriverUrl: "https://www.cloudera.com/downloads/connectors/impala/odbc/2-6-11.html"
    property string mongodbDriverUrl: "https://github.com/mongodb/mongo-odbc-driver/releases/tag/v1.0.0"
    property string mssqlDriverUrl: "https://www.microsoft.com/en-in/download/details.aspx?id=36434"
    property string mysqlDriverUrl: "https://dev.mysql.com/downloads/connector/odbc/"
    property string oracleDriverUrl: "https://www.oracle.com/database/technologies/instant-client/downloads.html"
    property string postgresDriverUrl: "https://www.postgresql.org/ftp/odbc/versions"
    property string redshiftDriverUrl: "https://docs.aws.amazon.com/redshift/latest/mgmt/configure-odbc-connection.html"
    property string snowflakeDriverUrl: "https://sfc-repo.snowflakecomputing.com/odbc/index.html"
    property string teradataDriverUrl: "https://downloads.teradata.com/tag/odbc"

    // ODBC Driver url ends

    // SQL Relations
    property string likeRelation: "LIKE"
    property string notLikeRelation: "NOT LIKE"
    property string inRelation: "IN"
    property string equalRelation: "="
    property string notEqualRelation: "!="
    property string betweenRelation: "BETWEEN"
    property string smallerThanRelation: "<"
    property string greaterThanRelation: ">"
    property string smallerThanEqualRelation: "<="
    property string greaterThanEqualRelation: ">="

    // SQL Relation Slugs
    property string slugLikeRelation: "Like"
    property string slugNotLikeRelation: "Not Like"
    property string slugInRelation: "In"
    property string slugEqualRelation: "Equal"
    property string slugNotEqualRelation: "Not Equal"
    property string slugBetweenRelation: "Between"
    property string slugSmallerThanRelation: "Less Than"
    property string slugGreaterThanRelation: "Greater Than"
    property string slugSmallerThanEqualRelation: "Less Than Equal To"
    property string slugGreaterThanEqualRelation: "Greater Than Equal To"

    property string innerJoin: "INNER JOIN"
    property string fullJoin: "FULL JOIN"
    property string leftJoin: "LEFT JOIN"
    property string rightJoin: "RIGHT JOIN"


    // FILTERS starts
    // Tab Bar Open Constants- Section

    property string categoricalTab: "categorical"
    property string dateTab: "dateformat"
    property string numericalTab: "numerical"
    property string groupTab: "group"

    property double borderWidth: 1.3
    property int radiusNumber: 4

    // Main Category
    property string categoryMainListType: "categorical.list"
    property string categoryMainWildCardType: "categorical.wildcard"
    property string categoryMainTopType: "categorical.top"

    property string dateMainListType: "date.list"
    property string dateMainCalendarType: "date.calendar"
    property string dateMainTimeFrameType: "date.timeframe"

    property string numericalCatType: "numerical.category"

    // Sub Categories
    property string categorySubMulti: "multiple"
    property string categorySubSingle: "single"

    property string dateSubYear: "year"
    property string dateSubQuarter: "quarter"
    property string dateSubMonth: "month"
    property string dateSubDay: "day"

    property string numericalSubMain: "numerical.subCategory"


    // Mode
    property string modeCreate: "create"
    property string modeEdit: "edit"

    // FILTERS ends


    // DASHBOARD starts

    property int defaultDroppedReportWidth : 500
    property int defaultDroppedReportHeight : 300

    property int dropActiveBorderWidth: 2
    property int dropEligibleBorderWidth: 1
    property int dropInActiveBorderWidth: 0

    property int reportTypeBlank : 0
    property int reportTypeText: 1
    property int reportTypeImage: 2
    property int reportTypeChart : 3

    property var filterCategoricalTypes: ["dataListMulti", "dataListSingle", "dataDropdownSingle", "dataDropdownMulti"]
    property var filterNumericalTypes: ["dataRange","dataEqual","dataNotEqual","dataSmaller","dataGreater","dataEqualOrSmaller","dataEqualOrGreater","dataBetween"]
    property var filterDateTypes: ["dataListMulti", "dataListSingle", "dataDropdownSingle", "dataDropdownMulti","dataDateRange", "dataDateBefore", "dataDateAfter", "dataDateRelative"]

    property var filterDateUnits: ["Days", "Weeks", "Months", "Quarters", "Years"]
    property var filterComparators: ["Last"]
    // DASHBOARD ends


    // Reports Starts

    property string xAxisName: "X Axis"
    property string yAxisName: "Y Axis"
    property string row3Name: "row3Name"
    property string axisSettingText: "Axis Setting"
    property string reportEditColorPopup: "Edit Color"
    property string reportCalculatedFieldPopup: "Calculated Field"
    property string reportToolTipPopupTitle: "Tool Tip"




    property color defaultCategoricalColor: "#6CD7A1"
    property color defaultNumericalColor: "#BADCFF"

    property color defaultXAxisColor: "#6CD7A1"
    property color defaultYAxisColor: "#BADCFF"

    property color defaultXAxisTickColor: "#000000"
    property color defaultYAxisTickColor: "#000000"
    property color defaultXAxisLabelColor: "#000000"
    property color defaultYAxisLabelColor: "#000000"
    property color defaultDataLabelColor: "#000000"
    property color defaultDataValueColor: "#000000"
    
    property string categoricalItemType: "categorical"
    property string numericalItemType: "numerical"
    property string dateItemType: "dateformat"

    // Report Ends


    // Charts Start

    property string chartsBaseUrl: "qrc:/Source/Charts/build/index.html"

    property string barChartTitle: "Bar Chart"
    property string pieChartTitle: "Pie Chart"
    property string donutChartTitle:"Donut Chart"
    property string funnelChartTitle:"Funnel Chart"
    property string gaugeChartTitle: "Gauge Chart"
    property string scatterChartTitle: "Scatter Plot"
    property string stackedBarChartTitle: "Stacked Bar Chart"
    property string groupBarChartTitle: "Grouped Bar Chart"
    property string geoChartTitle: "Map"
    property string treeChartTitle: "Tree Chart"
    property string treeMapChartTitle: "Tree Map"
    property string combinationChartTitle: "Combination"
    property string radarChartTitle: "Radar"
    property string heatMapChartTitle: "Heat Map"
    property string sunburstChartTitle: "Sunburst"
    property string waterfallChartTitle: "Waterfall"
    property string kpiTitle: "KPI"
    property string tableTitle: "Table"
    property string pivotTitle: "Pivot"
    property string lineBarTitle: "Line Bar"
    property string sankeyChartTitle: "Sankey"
    property string stackedAreaChartTitle: "Stacked Area Chart"
    property string horizontalStackedAreaChartTitle: "Horizontal Stacked Area Chart"
    property string horizontalBarChartTitle: "Horizontal Bar Chart"
    property string horizontalStackedBarChartTitle: "Horizontal Stack Bar Chart"
    property string horizontalBarGroupedChartTitle: "Horizontal Bar Grouped Chart"
    property string lineChartTitle: "Line Chart"
    property string horizontalLineChartTitle: "Horizontal Line Chart"
    property string multiLineChartTitle: "Multi Line"
    property string horizontalMultiLineChartTitle: "Horizontal Multi Line"
    property string areaChartTitle:"Area Chart"
    property string horizontalAreaChartTitle: "Horizontal Area Chart"
    property string multipleAreaChartTitle: "Multiple Area Chart"
    property string multipleHorizontalAreaChartTitle: "Multiple Horizontal Area Chart"

    // Chart Urls
    property string baseChartUrl: "qrc:/Source/Charts/build/index.html";
    property string waterfallChartUrl: "WaterfallChart.html"
    property string stackedBarChartUrl: "StackedBarChart.html"
    property string stackedAreaChartUrl: "StackedAreaChart.html"
    property string horizontalStackedAreaChartUrl: "HorizontalMultipleAreaChart.html"
    property string horizontalBarChartUrl: "HorizontalBarChart.html"
    property string horizontalStackedBarChartUrl: "HorizontalStackBarChart.html"
    property string horizontalBarGroupedChartUrl: "HorizontalBarGroupedChart.html"
    property string barGroupedChartUrl: "BarGroupedChart.html";
    property string barChartUrl: "BarChartArrayInput.html";
    property string lineChartUrl: "LineChart.html";
    property string horizontalLineChartUrl: "HorizontalLineChart.html"
    property string multiLineChartUrl: "MultipleLineChart.html";
    property string horizontalMultiLineChartUrl: "HorizontalMultipleLineChart.html";
    property string areaChartUrl: "AreaChart.html";
    property string horizontalAreaChartUrl: "HorizontalAreaChart.html"
    property string multipleAreaChartUrl: "MultipleAreaChart.html"
    property string multipleHorizontalAreaChartUrl: "HorizontalMultipleAreaChart.html"
    property string pieChartUrl:"PieChart.html";
    property string donutChartUrl:"DoughnutChart.html";
    property string radarChartUrl:"RadarChart.html";
    property string sunburstChartUrl:"SunburstChart.html";
    property string funnelChartUrl:"FunnelChart.html";
    property string treeChartUrl: "TreeChart.html";
    property string sankeyChartUrl: "SankeyChart.html";
    property string scatterChartUrl: "ScatterChart.html";
    property string heatMapChartUrl: "HeatmapChart.html";
    property string gaugeChartUrl: "GaugeChart.html";
    property string pivotTableUrl: "PivotTable.html";
    property string tableChartUrl: "TableChart.html";
    property string kpiChartUrl : "KPI.html";


    // Charts ends

    //data modeller table Scale
    property real scaleTable:1
    // ends
    property real newPosition:1


    // Data modeller
    property int joinBoxWidth: 30
    property int joinBoxHeight: 30
    property int joinBoxRadius: 25
    property int droppedRectBufferWidth: 250

    // Current Screen Types
    property var homeScreen : 0;
    property var grsScreen : 1;
    property var connectorScreen : 2;
    property var modelerScreen : 3;
    property var dashboardScreen : 4;
    property var reportScreen : 5;

    // Date Formats
    property var yearFormat: "%Y";
    property var dayFormat: "%d";
    property var monthFormat: "%b";
    property var dayMonthYearFormat: "%d %b %Y";
    property var monthYearFormat: "%b %Y";
    
    property var defaultCustomizationsAvailable: "Properties,Reference Line,Legend,Axis Size";
    property var defaultSubMenuCustomizationsAvailable: "color by,tool tip,size,data label,grid line";
    
    // Dashboard Constasts
    property var defaultDashboardHeight: 800;
    property var defaultDashboardWidth: 1280;

    property var tempGrafieksValue: "grafieks_false_temp";

    // Free tier limits
    property var dashboardPerWorkbook : 2
    property var reportsPerWorkbook : 10

    property var dashboardScreenName: "Dashboard"
    property var reportScreenName: "Report"
    // Calculated Fileld Editor
    property string calculatedFieldEditorUrl: "qrc:/Source/Reports/calculatedFieldEditor.html"
    property string createCustomField: "Create Custom Field"
    property string name: "Name"
    property string calculation: "Calculation"
    property string functionName: "Function"
    property string syntax: "Syntax"
    
}
