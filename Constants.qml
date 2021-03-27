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

    // General Strings

    property string applicationName : qsTr("Grafieks")
    property string signInText : qsTr("Sign In")
    property string signOutText : qsTr("Sign Out")
    property string openFileText : qsTr("Open")
    property string dataDesignerText : qsTr("Data Designer")
    property string dashboardDesignerText : qsTr("Dashboard Designer")

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

    // ODBC Driver matching names
    property string mysqlOdbc: qsTr("mysql")
    property string postgresOdbc: qsTr("postgres")
    property string accessOdbc: qsTr("access")
    property string excelOdbc: qsTr("excel")
    property string hiveOdbc: qsTr("hive")
    property string impalaOdbc: qsTr("impala")
    property string mongoOdbc: qsTr("mongo")
    property string mssqlOdbc: qsTr("sql server")
    property string oracleOdbc: qsTr("oracle")
    property string redshiftOdbc: qsTr("redshift")
    property string sqliteOdbc: qsTr("sqlite")
    property string snowflakeOdbc: qsTr("snowflake")
    property string teradataOdbc: qsTr("teradata")


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

    property color lightGrayTextColor: "#454545"
    property color dropAreaHighlightColor: "ivory"
    property color dashboardDefaultBackgroundColor: "white"

    property color defaultColorDialogColor: "#000000"


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

    property string innerJoin: "INNER JOIN"
    property string fullJoin: "FULL JOIN"
    property string leftJoin: "LEFT JOIN"
    property string rightJoin: "RIGHT JOIN"


    // FILTERS starts
    // Tab Bar Open Constants- Section

    property string categoricalTab: "categorical"
    property string dateTab: "date"
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

    // Sub Categories
    property string categorySubMulti: "multiple"
    property string categorySubSingle: "single"

    // Mode
    property string modeCreate: "create"
    property string modeEdit: "edit"

    // FILTERS ends

    // DASHBOARD starts

    property int defaultDroppedReportWidth : 300
    property int defaultDroppedReportHeight : 200

    property int dropActiveBorderWidth: 2
    property int dropEligibleBorderWidth: 1
    property int dropInActiveBorderWidth: 0

    property int reportTypeBlank : 0
    property int reportTypeText: 1
    property int reportTypeImage: 2
    property int reportTypeChart : 3

    // DASHBOARD ends


    // Reports Starts

    property string xAxisName: "X Axis"
    property string yAxisName: "Y Axis"
    property string axisSettingText: "Axis Setting"
    property string reportEditColorPopup: "Edit Color"
    property string reportCalculatedFieldPopup: "Calculated Field"
    property string reportToolTipPopupTitle: "Tool Tip"



    property color defaultXAxisColor: "#6CD7A1"
    property color defaultYAxisColor: "#BADCFF"
    
    property string categoricalItemType: "categorical"
    property string numericalItemType: "numerical"

    // Report Ends


    // Charts Start


    property string barChartTitle: "Bar Chart"
    property string areaChartTitle:"Area Chart"
    property string lineChartTitle: "Line Chart"
    property string headMapChartTitle:"Heat Map"
    property string pieChartTitle: "Pie Chart"
    property string donutChartTitle:"Donut Chart"
    property string funnelChartTitle:"Funnel Chart"
    property string gaugeChartTitle: "Gauge Chart"
    property string scatterChartTitle: "Scatter Plot"
    property string stackedBarChartTitle: "Stacked Bar Chart"
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

    // Charts ends

    //data modeller table Scale
    property real scaleTable:1
    // ends
    property real newPosition:1
}
