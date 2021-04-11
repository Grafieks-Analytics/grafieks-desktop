/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard
** New Report
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtWebEngine 1.7

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"
import "./SubComponents"

Page {

    id: report_desiner_page
    width: parent.width
    property int menu_width: 60

    property int spacingColorList: 5
    property int colorBoxHeight: 20
    property int colorListTopMargin: 5
    property int editImageSize: 16
    property bool xaxisActive: ReportParamsModel.xAxisActive
    property bool yaxisActive: ReportParamsModel.yAxisActive

    property bool yAxisVisible: true
    property bool xAxisVisible: true
    property bool row4Visible: false
    property bool lineTypeChartVisible: false

    property bool row3Visible: false
    property bool pivotThemeVisible: false


    property string yAxisLabelName: Constants.yAxisName
    property string xAxisLabelName: Constants.xAxisName
    property string valuesLabelName: 'Values'

    property string reportChart:ReportParamsModel.chartType;
    property string reportId:ReportParamsModel.reportId;

    property string chartUrl: 'BarChartArrayInput.html';
    property string chartTitle: Constants.barChartTitle;
    property var customizationsAvailable: "Properties,Legend";


    property var d3PropertyConfig: ({});

    onChartTitleChanged: {

        switch(chartTitle){
        case Constants.stackedBarChartTitle:
            chartUrl=Constants.stackedBarChartUrl
            webEngineView.url = Constants.chartsBaseUrl+Constants.stackedBarChartUrl;
            xAxisVisible = true
            yAxisVisible = true
            row3Visible = false
            row4Visible = false
            break;
        case Constants.stackedAreaChartTitle:
            chartUrl=Constants.stackedAreaChartUrl;
            webEngineView.url = Constants.chartsBaseUrl+Constants.stackedAreaChartUrl;
            xAxisVisible = true
            yAxisVisible = true
            row3Visible = false
            row4Visible = false
            break;
        case Constants.pivotTitle:
            row3Visible =  true;
            xAxisVisible = true
            yAxisVisible = true
            row4Visible = false
            pivotThemeVisible=true
            break;
        case Constants.tableTitle:
            yAxisVisible = false
            xAxisVisible = true
            row3Visible = false
            row4Visible = false
            break;
        case Constants.gaugeChartTitle:
            row4Visible = true
            xAxisVisible =  false
            yAxisVisible =  false
            row3Visible =  false
            break;
        default:
            xAxisVisible = true
            yAxisVisible = true
            row3Visible = false
            row4Visible = false
        }

    }

    onReportChartChanged: {
        chartTitle = reportChart;
    }


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: xAxisListModel
    }

    ListModel{
        id: yAxisListModel
    }

    ListModel{
        id: valuesListModel
    }

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


    Connections {
        target: ReportModelList
        function onSendData(xAxis,yAxis){
            const dataValues = JSON.stringify([xAxis,yAxis]);
            var scriptValue = 'window.addEventListener("resize", function () {
                    d3.selectAll("#my_dataviz").html("");
                    drawChart('+dataValues+');
                });';
            webEngineView.runJavaScript('drawChart('+dataValues+'); '+scriptValue);
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {

        // Connect signal and slots
        ReportParamsModel.xAxisActive = false;
        ReportParamsModel.yAxisActive = false;
        ReportParamsModel.colorByActive = false;

        if(!reportId){
            var newReportId = generateReportId();
            ReportParamsModel.setReportId(newReportId);
        }

        ReportParamsModel.setXAxisColumns([]);
        ReportParamsModel.setYAxisColumns([]);

        xAxisListModel.clear();
        yAxisListModel.clear();

    }


    onXaxisActiveChanged: {
        if(xaxisActive){
            xAxisRectangle.border.color = Constants.grafieksLightGreenColor;
            xAxisRectangle.border.width = Constants.dropEligibleBorderWidth;
        }else{
            xAxisRectangle.border.color = "transparent";
            xAxisRectangle.border.width = Constants.dropInActiveBorderWidth;
        }
    }

    onYaxisActiveChanged: {
        if(yaxisActive){
            yAxisRectangle.border.color = Constants.grafieksLightGreenColor;
            yAxisRectangle.border.width = Constants.dropEligibleBorderWidth;
        }else{
            yAxisRectangle.border.width = Constants.dropInActiveBorderWidth;
        }
    }


    // generate Report Id
    function generateReportId(){
        return Qt.btoa(new Date().getTime());
    }

    // Slot Function
    // For changing the chart on clicking chart icons

    function reDrawChart(){
        drawChart();

    }

    // Load New Chart
    function changeChart(chartname){
        webEngineView.url = chartname;
    }

    function addReport(){
        // Add report to dashboard
        stacklayout_home.currentIndex = Constants.dashboardDesignerIndex
    }

    function cancelReport(){
        // Back to dashboard
        stacklayout_home.currentIndex = Constants.dashboardDesignerIndex
    }

    function focusReportTitle(){
        report_title_text.readOnly= false
        report_title_text.focus = true;
    }

    function onDropAreaEntered(element){
        element.border.width = Constants.dropActiveBorderWidth
    }

    function onDropAreaExited(element){
        element.border.width = Constants.dropEligibleBorderWidth
    }

    function alreadyExists(elementsList,element){
        if(elementsList.includes(element)){
            return true;
        }
        return false;
    }

    function xAxisDropEligible(itemName){
        var xAxisColumns  = ReportParamsModel.xAxisColumns;
        const multiChart = true;
        if(multiChart){
            return true;
        }
        return false;
    }

    function yAxisDropEligible(itemName){
        var yAxisColumns  = ReportParamsModel.yAxisColumns;
        const multiChart = true;
        if(multiChart){
            return true;
        }
        return false;
    }

    function onDropAreaDropped(element,axis){

        element.border.width = Constants.dropEligibleBorderWidth
        element.border.color = Constants.themeColor

        var itemName = ReportParamsModel.itemName;
        var xAxisColumns = ReportParamsModel.xAxisColumns;

        var yAxisColumns = ReportParamsModel.yAxisColumns;
        var valuesColumns = [];

        if(axis === Constants.xAxisName){

            if(!xAxisDropEligible(itemName)){
                return;
            }

            xAxisListModel.append({itemName: itemName})
            xAxisColumns.push(itemName);
            ReportParamsModel.setXAxisColumns(xAxisColumns);

        }else if(axis === Constants.yAxisName){
            if(!yAxisDropEligible(itemName)){
                return;
            }
            yAxisListModel.append({itemName: itemName})
            yAxisColumns.push(itemName);
            ReportParamsModel.setYAxisColumns(yAxisColumns);
        }else{
            if(!yAxisDropEligible(itemName)){
                return;
            }
            valuesListModel.append({itemName: itemName});
            valuesColumns.push(itemName);
        }


        if(ReportParamsModel.xAxisColumns.length > 1 && yAxisColumns.length && (chartTitle === Constants.barChartTitle  || chartTitle === Constants.stackedBarChartTitle)){
            console.log('Make Grouped Bar Chart')
            webEngineView.url = 'qrc:/Source/Charts/BarGroupedChart.html';
            chartTitle = Constants.groupBarChartTitle;
            chartUrl = 'BarGroupedChart.html';
        }

        drawChart();

    }

    function onChartLoaded(loadRequest){

        if(loadRequest.status === WebEngineLoadRequest.LoadFailedStatus){
            console.log('Page Loading Failed')
            console.log('Error',JSON.stringify(loadRequest))
            return;
        }

        console.log(webEngineView.location)
        drawChart();
    }

    function drawChart(){

        var xAxisColumns = ReportParamsModel.xAxisColumns;
        var yAxisColumns = ReportParamsModel.yAxisColumns;

        if(xAxisColumns.length && yAxisColumns.length){

            var xAxisColumnNamesArray = [];
            for(var i=0;i<xAxisColumns.length;i++){
                xAxisColumnNamesArray.push(xAxisColumns[i]);
            }

            var dataValues = null;
            console.log('Chart Title',chartTitle)

            switch(chartTitle){
            case Constants.barChartTitle:
                console.log("BAR CLICKED", xAxisColumns[0])
                // Bar - xAxis(String), yAxis(String)
                dataValues =  ChartsModel.getBarChartValues(xAxisColumns[0],yAxisColumns[0]);

                // Stacked Bar - xAxis(String), yAxis(String), Split(String)
                // dataValues = ChartsModel.getStackedBarChartValues("country","population","state")

                // Grouped Bar - xAxis(String), yAxis(String), Split(String)
                // dataValues = ChartsModel.getGroupedBarChartValues("country","population", "state")

                break;
            case Constants.stackedBarChartTitle:
                console.log('Stacked bar chart!');
                dataValues =  ChartsModel.getStackedBarChartValues(ReportParamsModel.itemName,yAxisColumns[0], xAxisColumns[0]);
                break;
            case Constants.groupBarChartTitle:
                console.log('Grouped bar chart!');
                dataValues =  ChartsModel.getGroupedBarChartValues(xAxisColumns[1],yAxisColumns[0], xAxisColumns[0]);
                break;
            case Constants.areaChartTitle:
                console.log("AREA CLICKED")
                // Area - xAxis(String), yAxis(String)
                dataValues =  ChartsModel.getAreaChartValues(xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.stackedAreaChartTitle:
                console.log('Stacked Area Chart')
                dataValues =  ChartsModel.getStackedAreaChartValues(ReportParamsModel.itemName,yAxisColumns[0],xAxisColumns[0]);
                break;
            case Constants.lineChartTitle:
                console.log("LINE CLICKED")
                // Line - xAxis(String), yAxis(String)
                dataValues =  ChartsModel.getLineChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');

                // Line Bar - xAxis(String), yAxis(String)
                //                dataValues =  ChartsModel.getLineBarChartValues("state", "id", "population");
                break;
            case Constants.pieChartTitle:
            case Constants.donutChartTitle:
                console.log("DONUT/PIE CLICKED")
                dataValues = ChartsModel.getPieChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.funnelChartTitle:
                console.log("FUNNEL CLICKED")
                dataValues = ChartsModel.getFunnelChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.radarChartTitle:
                console.log("RADAR CLICKED")
                dataValues = ChartsModel.getRadarChartValues(xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.scatterChartTitle:
                console.log("SCATTER CLICKED")
                dataValues = ChartsModel.getScatterChartValues(xAxisColumns[0],yAxisColumns[0],yAxisColumns[1]);
                break;
            case Constants.treeChartTitle:
                console.log("TREECHART CLICKED")
                dataValues = ChartsModel.getTreeChartValues(xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.treeMapChartTitle:
                dataValues = ChartsModel.getTreeMapChartValues(xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                console.log(dataValues);
                break;
            case Constants.heatMapChartTitle:
                console.log("HEATMAP CLICKED")
                dataValues = ChartsModel.getHeatMapChartValues(xAxisColumns[0],yAxisColumns[0], ReportParamsModel.itemName);
                break;
            case Constants.sunburstChartTitle:
                console.log("SUNBURST CLICKED");
                dataValues = ChartsModel.getSunburstChartValues(xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.waterfallChartTitle:
                console.log("WATERFALL CLICKED")
                dataValues = ChartsModel.getWaterfallChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                console.log('Waterfall Data values',dataValues);
                break;
            case Constants.gaugeChartTitle:
                console.log("GAUGE CLICKED")
                dataValues = ChartsModel.getGaugeChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.sankeyChartTitle:
                console.log("SANKEY CLICKED")
                dataValues = ChartsModel.getSankeyChartValues(xAxisColumns[0],  xAxisColumns[1], yAxisColumns[0] );
                break;
            case Constants.kpiTitle:
                console.log("KPI CLICKED")
                dataValues = ChartsModel.getKPIChartValues(xAxisColumns[0]);
                break;
            case Constants.tableTitle:
                console.log("TABLE CLICKED")
                dataValues = ChartsModel.getTableChartValues(["state", "city", "district"], ["population", "id"],'Sum');
                break;
            case Constants.pivotTitle:
                console.log("PIVOT CLICKED")
                //                dataValues = ChartsModel.getPivotChartValues(["state", "district"],xAxisColumns[0],'Sum');
                dataValues = ChartsModel.getTableChartValues(["state", "district"], "population",'Sum');
                break;
            }
            if(!dataValues){
                return;
            }


            console.log(dataValues);
            console.log(webEngineView.loading);
            console.log(report_desiner_page.chartTitle)
            console.log(report_desiner_page.chartUrl)
            console.log("color final "+JSON.stringify(d3PropertyConfig))

            //            need to initialise only once
            console.log('Starting to plot');
            console.log('Data Values',dataValues);
            console.log('Chart Url',report_desiner_page.chartUrl)

            var scriptValue = 'window.addEventListener("resize", function () {
                    d3.selectAll("#my_dataviz").html("");
                    drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+');
            });';

            webEngineView.runJavaScript('drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+'); '+scriptValue);

        }

    }

    function openYAxisSettings(){
        yAxisSettingsPopup.visible = true
    }

    function exportReport(){
        console.log('Export Report')
    }

    function updateReportTitle(){
        ReportParamsModel.setReportTitle(report_title_text.text);
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    YAxisSettingPopup{
        id: yAxisSettingsPopup
    }

    EditColorPopup{
        id: editColorPopup
    }

    CalculatedFieldPopup{
        id: calculatedFieldPopup
    }

    ToolTipPopup{
        id: toolTipPopup
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Row{
        id: title_menu
        anchors.top: parent.top
        height: implicitHeight
        width: implicitWidth

        Rectangle{
            id: customize_title
            width: left_menubar_reports.width + chartFilters1.width
            height: 30
            color: Constants.themeColor

            Text{
                text: "Customize"
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
            }
        }

        Rectangle{
            id: report_title
            width: report_desiner_page.width - left_menubar_reports.width - chartFilters1.width - column_querymodeller.width

            height: 30

            TextField{
                id: report_title_text
                placeholderText: "Add Report Title"
                width:250
                height: 40
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
                verticalAlignment:TextEdit.AlignVCenter
                Keys.onReturnPressed: report_title_text.focus = false
                onTextChanged: updateReportTitle()
                background: Rectangle{
                    color: "transparent"
                    border.color: "transparent"
                }
            }

            Image {
                source: "/Images/icons/Edit.png"
                height: 20
                width: 20
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: focusReportTitle()
                }
            }
        }


    }

    // Seperator lines
    Row{
        id: seperator_title_bar
        anchors.top:title_menu.bottom
        width: parent.width

        // Seperator for Left Menu
        Rectangle {
            id: customize_title_bar
            width: customize_title.width
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }

        // Seperator for Center Panel and Title
        Rectangle {
            id: report_title_bar
            width: report_title.width
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }
    }

    // Left Menu Chart Icons Starts
    LeftMenuBarReports{
        id: left_menubar_reports
        anchors.top: seperator_title_bar.bottom
        Component.onCompleted: {

            loadchart.connect(report_desiner_page.changeChart)
        }

    }
    // Left Menu Chart Icons Ends

    ToolSeparator{
        id: tool_sep_leftmenubarreports
        anchors.left: left_menubar_reports.right
        anchors.top: seperator_title_bar.bottom
        anchors.leftMargin: 0
        height:parent.height
        padding: 0

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }
    }


    // Left Menu Customization Items
    ReportCustomizations{
        id: chartFilters1
        anchors.left: tool_sep_leftmenubarreports.right
        anchors.top: seperator_title_bar.bottom
        anchors.leftMargin: 0
        z:1
    }

    ToolSeparator{
        id: tool_sep_chartFilters
        anchors.left: chartFilters1.right
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.topMargin: -3
        height:parent.height
        padding: 0
        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }
    }


    // Center Panel Starts

    Rectangle{

        id: axis
        height: row4Visible ? 42 : (row3Visible ? 123 : 82)
        width: parent.width - chartFilters1.width - left_menubar_reports.width - column_querymodeller.width

        anchors.left: tool_sep_chartFilters.right
        anchors.top: seperator_title_bar.bottom

        // Xaxis starts
        Rectangle{
            id: xaxis
            height: 40
            width: parent.width
            anchors.left: parent.left
            visible: xAxisVisible


            Rectangle{
                id: xaxisText
                width: 100
                height: parent.height
                Text {
                    text: xAxisLabelName
                    anchors.centerIn: parent
                }
                z:1
            }

            ToolSeparator{
                orientation: Qt.Vertical
                anchors.left: xaxisText.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.SizeVerCursor
                    width: parent.width

                    onPositionChanged: {

                        onDragPanel(mouse)

                    }

                }
            }


            Rectangle{
                id: xAxisRectangle
                height: parent.height
                width: parent.width - xaxisText.width - 4
                anchors.left: xaxisText.right
                anchors.leftMargin: 1

                DropArea{
                    id: xaxisDropArea
                    anchors.fill: parent
                    onEntered:  onDropAreaEntered(parent,Constants.xAxisName)
                    onExited:  onDropAreaExited(parent,Constants.xAxisName)
                    onDropped: onDropAreaDropped(parent,Constants.xAxisName)
                }

                ListView{

                    height: parent.height
                    width: parent.width - xAxisSettings.width - this.x
                    x:5
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    model: xAxisListModel
                    orientation: Qt.Horizontal
                    spacing: spacingColorList
                    delegate: AxisDroppedRectangle{
                        textValue: itemName
                        color: Constants.defaultXAxisColor
                    }
                }

                Rectangle{

                    id: xAxisSettings

                    color: "#ffffff"
                    height: parent.height - 4
                    anchors.right: parent.right
                    anchors.rightMargin: 1
                    width: 50
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        source: "/Images/icons/customize.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.centerIn: parent
                        height: 20
                        width: 20
                        MouseArea{
                            anchors.fill: parent
                            onClicked: openYAxisSettings()
                        }
                    }

                }
            }

        }
        // xaxis ends

        //
        ToolSeparator{
            id: seperatorAxis
            visible: xAxisVisible
            height: 1
            anchors.top: xaxis.bottom
            width: parent.width
            background: Rectangle{
                color: Constants.darkThemeColor
            }
        }

        Rectangle{
            id: yaxis
            height: 40
            anchors.top: seperatorAxis.bottom
            anchors.left: parent.left
            width: parent.width
            visible: yAxisVisible

            Rectangle{
                id: yaxisText
                width: 100
                height: parent.height
                Text {
                    text: yAxisLabelName
                    anchors.centerIn: parent
                }
                z:1
            }

            ToolSeparator{
                orientation: Qt.Vertical
                anchors.left: yaxisText.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }

            Rectangle{
                id: yAxisRectangle
                height: parent.height
                width: parent.width - yaxisText.width - 4
                anchors.left: yaxisText.right
                anchors.leftMargin: 1

                DropArea{
                    id: yaxisDropArea
                    anchors.fill: parent
                    onEntered:  onDropAreaEntered(parent,Constants.yAxisName)
                    onExited:  onDropAreaExited(parent,Constants.yAxisName)
                    onDropped: onDropAreaDropped(parent,Constants.yAxisName)
                }

                ListView{

                    height: parent.height
                    width: parent.width - yAxisSettings.width - 2*this.x
                    x:5
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    model: yAxisListModel
                    orientation: Qt.Horizontal
                    spacing: spacingColorList
                    delegate: AxisDroppedRectangle{
                        textValue: itemName
                        color: Constants.defaultYAxisColor
                    }
                }

                Rectangle{

                    id: yAxisSettings

                    color: "#ffffff"
                    height: parent.height - 4
                    anchors.right: parent.right
                    anchors.rightMargin: 1
                    width: 50
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        source: "/Images/icons/customize.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.centerIn: parent
                        height: 20
                        width: 20
                        MouseArea{
                            anchors.fill: parent
                            onClicked: openYAxisSettings()
                        }
                    }

                }

            }

        }


        ToolSeparator{
            id: axisChartSeperator
            height: 1
            anchors.top: yaxis.bottom
            width: parent.width
            background: Rectangle{
                color: Constants.darkThemeColor
            }
            visible: yAxisVisible
        }

        Rectangle{
            id: row3
            height: 40
            anchors.top: axisChartSeperator.bottom
            anchors.left: parent.left
            width: parent.width
            visible: row3Visible

            Rectangle{
                id: row3Text
                width: 100
                height: parent.height
                Text {
                    text: valuesLabelName
                    anchors.centerIn: parent
                }
                z:1
            }

            ToolSeparator{
                orientation: Qt.Vertical
                anchors.left: row3Text.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }

            Rectangle{
                id: row3DropAreaRectangle
                height: parent.height
                width: parent.width - row3Text.width - 4
                anchors.left: row3Text.right
                anchors.leftMargin: 1

                DropArea{
                    id: row3DropArea
                    anchors.fill: parent
                    onEntered:  onDropAreaEntered(parent,Constants.row3Name)
                    onExited:  onDropAreaExited(parent,Constants.row3Name)
                    onDropped: onDropAreaDropped(parent,Constants.row3Name)
                }

                ListView{

                    height: parent.height
                    width: parent.width
                    x:5
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    model: valuesListModel
                    orientation: Qt.Horizontal
                    spacing: spacingColorList
                    delegate: AxisDroppedRectangle{
                        textValue: itemName
                        color: Constants.defaultYAxisColor
                    }
                }

                Rectangle{

                    id: valuesSettings

                    color: "#ffffff"
                    height: parent.height - 4
                    anchors.right: parent.right
                    anchors.rightMargin: 1
                    width: 50
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        source: "/Images/icons/customize.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.centerIn: parent
                        height: 20
                        width: 20
                        MouseArea{
                            anchors.fill: parent
                            onClicked: openYAxisSettings()
                        }
                    }

                    visible: false

                }

            }

        }


        //
        ToolSeparator{
            id: axisSeperator3
            height: 1
            anchors.top: row3.bottom
            width: parent.width
            background: Rectangle{
                color: Constants.darkThemeColor
            }
            visible: row3Visible
        }


        Rectangle{
            id: row4
            height: 40
            anchors.top: axis.top
            anchors.left: parent.left
            width: parent.width
            visible: row4Visible

            Rectangle{
                id: row4Text
                width: 100
                height: parent.height
                Text {
                    text: Constants.gaugePointerLabel
                    anchors.centerIn: parent
                }
                z:1
            }

            ToolSeparator{
                orientation: Qt.Vertical
                anchors.left: row4Text.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }

            Rectangle{
                id: row4DropAreaRectangle
                height: parent.height
                width: 204
                anchors.left: row4Text.right
                anchors.leftMargin: 1

                DropArea{
                    id: row4DropArea
                    anchors.fill: parent
                    onEntered:  onDropAreaEntered(parent,Constants.gaugePointerLabel)
                    onExited:  onDropAreaExited(parent,Constants.gaugePointerLabel)
                    onDropped: onDropAreaDropped(parent,Constants.gaugePointerLabel)
                }

                ListView{
                    id: pointerValueList
                    height: parent.height
                    width: 100
                    x:5
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    model: valuesListModel
                    orientation: Qt.Horizontal
                    spacing: spacingColorList
                    delegate: AxisDroppedRectangle{
                        textValue: itemName
                        color: Constants.defaultYAxisColor
                    }
                }

            }

            ToolSeparator{
                id: row4Valueseparator
                orientation: Qt.Vertical
                anchors.left: row4DropAreaRectangle.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }

            Rectangle{
                id: row4TextInput1Label
                width: 100
                height: parent.height
                anchors.left: row4Valueseparator.right
                Text {
                    id: input1Label
                    text: 'Max/Green'
                    anchors.centerIn: parent
                }
                z:1
            }

            ToolSeparator{
                id: row4Valueseparator2
                orientation: Qt.Vertical
                anchors.left: row4TextInput1Label.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }

            Rectangle{
                id: row4TextInput1
                width: 200
                height: parent.height
                anchors.left: row4Valueseparator2.right
                border.color: Constants.borderBlueColor

                TextEdit {
                    leftPadding: 10
                    rightPadding: 10
                    width: parent.width
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                }
                z:1
            }


            ToolSeparator{
                id: row4Valueseparator3
                orientation: Qt.Vertical
                anchors.left: row4TextInput1.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }



            Rectangle{
                id: row4TextInput2Label
                width: 200
                height: parent.height
                anchors.left: row4Valueseparator3.right

                Text{
                    text: 'Yellow'
                    width: parent.width
                    anchors.centerIn: parent
                }
                z:1
            }

            ToolSeparator{
                id: row4Valueseparator4
                orientation: Qt.Vertical
                anchors.left: row4TextInput2Label.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }

            Rectangle{
                id: row4TextInput2
                width: 200
                height: parent.height
                anchors.left: row4Valueseparator4.right
                border.color: Constants.borderBlueColor

                TextEdit {
                    leftPadding: 10
                    rightPadding: 10
                    width: parent.width
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                }
                z:1
            }


            ToolSeparator{
                id: row4Valueseparator5
                orientation: Qt.Vertical
                anchors.left: row4TextInput2.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }


            Rectangle{
                id: row4TextInput3Label
                width: 100
                height: parent.height
                anchors.left: row4Valueseparator5.right

                Text{
                    text: 'Red'
                    width: parent.width
                    anchors.leftMargin: 20
                    anchors.centerIn: parent
                }
                z:1
            }

            ToolSeparator{
                id: row4Valueseparator6
                orientation: Qt.Vertical
                anchors.left: row4TextInput3Label.right
                width: 1
                height: parent.height
                background: Rectangle{
                    color: Constants.darkThemeColor
                }
            }

            Rectangle{
                id: row4TextInput3
                width: 200
                height: parent.height
                anchors.left: row4Valueseparator6.right
                border.color: Constants.borderBlueColor

                TextEdit {
                    leftPadding: 10
                    rightPadding: 10
                    width: parent.width
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                }
                z:1
            }


        }


        //
        ToolSeparator{
            id: axisSeperator4
            height: 1
            anchors.top: row4.bottom
            width: parent.width
            background: Rectangle{
                color: Constants.darkThemeColor
            }
            visible: row4Visible
        }

    }

    WebEngineView {
        id: webEngineView
        height:parent.height - axis.height -100
        width: parent.width - chartFilters1.width - left_menubar_reports.width - column_querymodeller.width - 100
        url: "../Charts/BarChartArrayInput.html"
        onLoadingChanged: onChartLoaded(loadRequest)
        anchors.left: tool_sep_chartFilters.right
        anchors.leftMargin: 100
        anchors.top: axis.bottom
    }

    // Center Panel ends

    ToolSeparator{
        id: toolsep2
        height:parent.height + 6
        anchors.right:parent.right
        anchors.top: parent.top
        anchors.rightMargin: 194
        anchors.topMargin: -5
    }

    // Right Panel Starts

    Column{
        id: column_querymodeller

        height:parent.height
        width: 200
        anchors.right:parent.right
        spacing: 50


        Rectangle{
            id: rectangle_querymodeller_right_col
            color:Constants.themeColor
            width: parent.width
            height: parent.height

            // Cancel and Add report Buttons Starts
            Rectangle{
                id: tabbarQuerymodeller
                width:parent.width
                height: 31
                Button{
                    anchors.left: parent.left
                    width: parent.width/2-0.5
                    text:"Cancel"
                    height: parent.height
                    background: Rectangle{
                        color: Constants.grafieksLightGreenColor
                        opacity: parent.hovered ? 0.42 : 1
                    }
                    contentItem: Text{
                        text: parent.text
                        color:  Constants.blackColor
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: cancelReport()
                }

                Button{
                    text:"Add"
                    height: parent.height
                    anchors.right: parent.right
                    width: parent.width/2-0.5
                    onClicked: addReport()
                    background: Rectangle {
                        color: Constants.grafieksLightGreenColor
                        opacity: parent.hovered ? 0.42 : 1
                    }
                    contentItem: Text{
                        text: parent.text
                        color:  Constants.blackColor
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: exportReport()
                    }
                }
            }
            // Cancel and Add report Buttons Ends

            // Dashboard Name Starts

            Rectangle{
                id: dashboardNameRectangle

                anchors.top: tabbarQuerymodeller.bottom
                anchors.topMargin: 2

                height:50
                width: parent.width

                Text{
                    text: "Data Source Name"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
            }

            // Dashboard Name Ends

            // Search starts

            Rectangle{
                id: searchRectangle

                anchors.top: dashboardNameRectangle.bottom
                anchors.topMargin: 2
                height:50
                width: parent.width

                Row{

                    id: searchBarRow
                    TextField{
                        width: parent.parent.width - search_icon.width - 5
                        height:30
                        cursorVisible: true
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        placeholderText: "Search"
                        background: Rectangle{
                            border.width: 0
                        }
                    }

                    Image{
                        id:search_icon
                        source:"/Images/icons/iconmonstr-search-thin.svg"
                        height:20
                        width:20
                        anchors.top: parent.top
                        anchors.topMargin: 10
                    }
                }

                ToolSeparator{
                    orientation: Qt.Horizontal
                    width: parent.width - 10
                    anchors.top: searchBarRow.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 5
                }

            }

            // Search Ends

            // Data Pane Starts
            Rectangle{
                anchors.top: searchRectangle.bottom
                height: parent.height - (searchRectangle.height + dashboardNameRectangle.height + tabbarQuerymodeller.height)
                width: parent.width

                RightDataColumn{}

            }
            // Data Pane Ends

        }

    }

    // Right Panel Ends
}
