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
import QtQml.Models 2.15

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../MainSubComponents"
import "./SubComponents"
import "./reports.js" as Reports
import "./reportUtils.js" as ReportUtils
import "./dataPanesDropHandlers.js" as DataPanesDropHandler
import "./chartsConfig.js" as ChartsConfig
import "./colorPalleteHandler.js" as ColorPalleteHandler
import "./chartsWebViewHandlers.js" as ChartsWebViewHandler
import "./drawChartUtils.js" as DrawChartUtils

/*
    How a chart is drawn:
    - Load /build/index.html in webengine view and wait for it to load
    - onGrafieksChartPageLoaded => Redraw chart function is called
    = onElementDrop:
        1. Check if the chart has horizontal orientation functionality -> horizontal bar chart | horitaontal line charts
            - Condition to check isHorizontal is based on data panes dropped on the x-y axis
            - onIsHorizontalGraphChanged =>
                - Change allowedXAxisDataPanes to 1
                - Change allowedYAxisDataPanes to 2
                - switch chart title as per the loaded current chart. Eg: If line chart was loaded and horizotal grapsh is switched -> then load horizontal line chart
        2 .
*/

Page {

    id: report_desiner_page
    width: parent.width
    background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }
    
    // property int menu_width: 60

    property int dataPanesSpacing: 5    // spacing between data panes dropped on x axis, y axis, values and other droppable areas
    // property int colorBoxHeight: 20
    // property int colorListTopMargin: 5

    property var errMsg: ""
    property var mode: ""

    property int editImageSize: 16      // Edit icon size

    property bool addReportClicked: false    // This toggle is used to check if add report is clicked or not. This prevents in calling reDrawChart on title Changed

    property bool xaxisActive: false    // X axis is active => Green color the data pane droppable zone
    property bool yaxisActive: false    // Y axis is active => Green color the data pane droppable zone
    property bool row3Active: null      // Row 3 is active => Green color the data pane droppable zone
    property bool row4Active: null      // Row 4 is active => Green color the data pane droppable zone

    property bool xAxisVisible: true    // X axis is visible ==> Hide the axis row
    property bool yAxisVisible: true    // Y axis is visible ==> Hide the axis row
    property bool row3Visible: false    // Row 3 is visible  ==> Hide the row
    property bool row4Visible: false    // Row 4 is visible ==> Hide the row

    property string xAxisLabelName: Constants.xAxisName     // X axis label name
    property string yAxisLabelName: Constants.yAxisName     // Y axis label name
    property string valuesLabelName: 'Values'               // Label for row3/row4

    property var maxDropOnXAxis: 1      // How many data panes are allowed to be dropped on X axis
    property var maxDropOnYAxis: 1      // How many data panes are allowed to be dropped on Y axis

    property bool lineTypeChartVisible: false       // Line type chart is visible || line chart is selected
    property bool pivotThemeVisible: false          // Pivot theme is visible || pivot chart is selected

    property string reportChart:ReportParamsModel.chartType;        // TODO: Check what is Chart type
    property int reportIdMain:ReportParamsModel.reportId;

    // Initial Chart Config
    property string chartUrl: '';                               // TODO: Remove chartUrl ==> Because this will be same everywhere
    property string chartTitle: Constants.barChartTitle;        // Initial chart will be bar chart
    property string previousChartTitle: "";                     // Previous chart title is used to clear values of data panes

    property var customizationsAvailable: "Properties,Reference Line,Legend,Axis Size";                 // Customizations Menu shown as per charts => Handled on chart change by list model
    property var subMenuCustomizationsAvailable: "color by,tool tip,size,data label,grid line";         // Sub menu in Customizations Menu shown as per charts => Handled on chart change by list model

    // This contains all the customizable config and is passed to drawChart function
    // In draw chart we take out these config; If config is empty => We have default config for it.
    property var d3PropertyConfig: ({});
    property var qmlChartConfig: ({}); // TODO: Check if qml charts config can be removed

    // todo: move these tables config to tables qml file
    // Table Customization values
    property bool alternateRowsCheckStatus: true
    property bool searchCheckStatus: true
    property bool compactStatusCheckStatus: false

    // table total customization
    property bool tableGrandTotalCheckStatus: false
    property bool totalSubTotalCheckStatus: false
    property bool totalRowTotalCheckStatus: false

    // axis settings value
    property bool xAxisLabelStatus: true
    property bool yAxisLabelStatus: true

    // KPI Values!!
    property bool boldCheckKPILabelStatus: false
    property bool italicCheckKPILabelStatus: false
    property bool underlineCheckKPILabelStatus:false

    property var dataLabelDialogKpiColor: '#000000'
    property var dataLabelKpiColorBoxColor: '#000000'

    property bool boldCheckKPIValueStatus: false
    property bool italicCheckKPIValueStatus: false
    property bool underlineCheckKPIValueStatus:false

    property var dataValueDialogKpiColor: '#000000'
    property var dataValueKpiColorBoxColor: '#000000'

    property var lastDataValues: ([])

    // This object will contain all the extra param models
    // TODO: Check if this is an additional dependancy and can be removed
    /*
        {
            chartName: { param1: value1, param2: value2 }
        }
    */
    property var optionalParams: ({});

    property var lastPickedDataPaneElementProperties: ({});     //  Store the last picked data pane element properties
    property var reportDataPanes: ({});                         //  Report Data Panes Object

    property var dragActiveObject: ({});                        // Store the last picked data pane element properties

    property var allChartsMapping: ({});
    // An array having item type and name of the spilt by value
    // Colour By Data is filled
    // 1. saved colour values -> CPP (Report Properties)
    // 2. when it is dropped -> (PropertiesFilter.qml)
    property var colorByData: [];

    property var allowedXAxisDataPanes: 0;
    property var allowedYAxisDataPanes: 0;
    property var allowedRow3AxisDataPanes: 0;

    property var reportTitleName: "";

    // Flag for horizontal graph
    // Changes when numerical value is added on X axis
    // Or Categorical Value is added on Y axis
    // On Change we update the graph title
    property bool isHorizontalGraph: false;

    property var colorData:[];

    // Edit Report Flag
    property bool editReportFlag: false;
    property var dataValues : null;
    property int activeChartIndex: 0;

    // Array List -> This will contain all the charts which can be converted to horizontal
    property var horizontalChartList: [
        Constants.barChartTitle,
        Constants.stackedBarChartTitle,
        Constants.groupBarChartTitle,
        Constants.horizontalBarChartTitle,
        Constants.horizontalStackedBarChartTitle,
        Constants.horizontalBarGroupedChartTitle,
        Constants.lineChartTitle,
        Constants.horizontalLineChartTitle,
        Constants.multiLineChartTitle,
        Constants.horizontalMultiLineChartTitle,
        Constants.areaChartTitle,
        Constants.horizontalAreaChartTitle,
        Constants.multipleAreaChartTitle,
        Constants.multipleHorizontalAreaChartTitle
    ];

    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    // Colour By Drop List
    ListModel{
        id: colorListModel
    }

    // X Axis Bar => Used for all charts where 2 axis are requied
    ListModel{
        id: xAxisListModel
    }

    // Y Axis Bar => Used for all charts where 2 axis are requied
    ListModel{
        id: yAxisListModel
    }

    // Value Bar => Used miscellaneous graphs like Sanky
    ListModel{
        id: valuesListModel
    }

    // Colour By Data Item List => d3colorPallete
    ListModel{
        id: dataItemList
    }

    // *** Temp Models to be refactored
    // *** Models used in tooltips
    ListModel{
        id: tempXModel
    }
    ListModel{
        id: tempYModel
    }
    ListModel{
        id: tempColorByModel
    }

    ListModel{
        id: allCharts
    }

    ListModel {
        id: functionModel
        ListElement {
            name: "IF"
            syntax:"if(5> 10,100,3) = 3"
            mode: "map"
        }
        ListElement {
            name: "If Case"
            syntax:"Returns the 'returnValue' if the given column satisfied with 'matchExpr'."
            mode: "map"
        }
        ListElement {
            name: "Ifnull"
            syntax:"ifnull(null,10) = 10"
            mode: "map"
        }
        ListElement {
            name: "Is Empty"
            syntax:"isempty(null) = 1"
            mode: "map"
        }
        ListElement {
            name: "isnul"
            syntax:"isnull(null)- 1"
            mode: "map"
        }
        ListElement {
            name: "SUM (single value)"
            syntax:"Some dummy syntax"
            mode: "reduce"
        }


    }

    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: ReportParamsModel

        function onEditReportToggleChanged(reportId){
            if(reportId=="-1"){
                DashboardParamsModel.setReportBackgroundColor(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentReport, DashboardParamsModel.getReportBackgroundColor(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentReport))
                return;
            }
            if(reportId != "false"){
                addReportButton.text = Messages.updateBtnTxt;
                editReportFlag = true;
                Reports.setValuesOnEditReport(reportId);
            }else{
                addReportButton.text = Messages.addBtnTxt;
                ReportParamsModel.setChartType(Constants.barChartTitle);
                ReportParamsModel.setChartTitle(Constants.barChartTitle);
            }
        }

        function onReportIdChanged(reportIdValue){
            // Todo
            // Tag: Check
            console.log('DEBUG::: Report id value',reportIdValue);
            if(!reportIdValue){
                Reports.clearValuesOnAddNewReport();
            }
            report_desiner_page.reportIdMain = reportIdValue;
            ReportParamsModel.restoreMasterReportFilters(reportIdValue)
        }

        function onClearScreenSignal(){
            Reports.clearValuesOnAddNewReport();
        }

    }

    Connections{
        target: ChartsModel

        // TODO: Emit a single signal for all the charts
        // If single signal is not emitted, we will have to append each function here. again and again
        // Also same this is there in dropped report.qml => we can elimate this
        function onSignalBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }

        function onSignalStackedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalGroupedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalNewGroupedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalAreaChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalLineChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalLineBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalPieChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalFunnelChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalRadarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalScatterChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalHeatMapChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalSunburstChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalWaterfallChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalGaugeChartValues(output, reportId, dashboardId, chartSource){
            console.log('DEBUG::: Gauge chart values',output);
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalSankeyChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalTreeChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalTreeMapChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalKPIChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalTableChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalPivotChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalStackedAreaChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
        function onSignalMultiLineChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                DrawChartUtils.drawChartAfterReceivingSignal(output);
        }
    }



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: ReportUtils.onNewReportComponentLoad()

    // TODO: Add comments what happens here
    onIsHorizontalGraphChanged: ReportUtils.onIsHorizontalGraphChanged();

    // TODO: Add comments what happens here
    onChartTitleChanged: ReportUtils.onChartTitleChanged();

    // Signal fired when drop is hovered on X Axis
    onXaxisActiveChanged: ReportUtils.checkAndMakeElementDropEligible(xaxisActive, xAxisRectangle);

    // Signal fired when drop is hovered on Y Axis
    onYaxisActiveChanged: ReportUtils.checkAndMakeElementDropEligible(yaxisActive, yAxisRectangle);
    
    // Signal fired when drop is hovered on Y Axis
    onRow3ActiveChanged: ReportUtils.checkAndMakeElementDropEligible(row3Active, row3DropAreaRectangle);

    // Signal fired when drop is hovered on Y Axis
    onRow4ActiveChanged: ReportUtils.checkAndMakeElementDropEligible(row4Active, row4DropAreaRectangle);

    function getLastDataValues(){
        return lastDataValues;
    }

    function updateChart() {
        if (chartTitle == Constants.gaugeChartTitle){
            reDrawChart();
            return;
        }
        ChartsWebViewHandler.updateChart(d3PropertyConfig)
    }

    function exportPivotChart() {
        webEngineView.runJavaScript("exportToExcel()");
    }

    //
    function clearColorByList() {
        var clearFlag = true;
        var lastColorByValueItemType =
                (colorByData.length && colorByData[0].itemType) || "";
        switch (chartTitle) {
        case Constants.barChartTitle:
        case Constants.lineChartTitle:
        case Constants.areaChartTitle:
        case Constants.multiLineChartTitle:
        case Constants.multipleAreaChartTitle:
        case Constants.groupBarChartTitle:
        case Constants.stackedBarChartTitle:
        case Constants.horizontalBarChartTitle:
        case Constants.horizontalLineChartTitle:
        case Constants.horizontalAreaChartTitle:
        case Constants.horizontalBarGroupedChartTitle:
        case Constants.multipleHorizontalAreaChartTitle:
        case Constants.horizontalMultiLineChartTitle:
        case Constants.horizontalStackedBarChartTitle:
        case Constants.scatterChartTitle:
            if (lastColorByValueItemType.toLowerCase() == "categorical") {
                clearFlag = false;
            }
            break;
        case Constants.heatMapChartTitle:
            if (lastColorByValueItemType.toLowerCase() == "numerical") {
                clearFlag = false;
            }
            break;
        }

        if (clearFlag) {
            colorListModel.clear();
            colorByData = [];
            ReportParamsModel.setLastDropped(null);
        }
    }

    // On Edit Redraw the updated chart
    // TODO: Remove if not in use
    function reDrawDashboardChart(reportId) {
        let reportInstance =
            ReportParamsModel.getDashboardReportInstance(reportIdMain);
        var reportProperties = ReportParamsModel.getReport(reportIdMain);
        reportInstance.reDrawChart();
    }

    // Redraw all the charts in Dashboard
    function reDrawAllDashboardCharts() {
        // Here are all the instances, Let's Redraw the charts
        let allReportInstances = ReportParamsModel.getAllDashboardReportInstances();
        for (var reportIdValue in allReportInstances) {
            // Redrawing charts one by one;
            var instance = allReportInstances[reportIdValue];
            instance.reDrawChart();
        }
    }

    // Switch Chart
    // Change title
    // onTitleChanged => Signal is fired

    function switchChart(chartTitleValue) {
        console.log("Switching to ", chartTitleValue, " chart");
        
        previousChartTitle = chartTitle;
        chartTitle = chartTitleValue;
        if (d3PropertyConfig.toolTip) {
            // Deleiing tooltips on changing chart
            delete d3PropertyConfig.toolTip;
            tempXModel.clear();
            tempYModel.clear();
            tempColorByModel.clear();
        }
    }

    function searchColumnNames(searchText) {
        ReportsDataModel.searchColumnNames(searchText);
    }

    function getAxisModelAsJson(axisName) {
        var model = null;
        switch (axisName) {
        case Constants.xAxisName:
            model = xAxisListModel;
            break;
        case Constants.yAxisName:
            model = yAxisListModel;
            break;
        case Constants.gaugePointerLabel:
        case Constants.row3Name:
            model = valuesListModel;
            break;
        }
        if (!model) {
            return [];
        }
        var columnsData = [];
        for (var i = 0; i < model.count; i++) {
            columnsData.push({
                                 itemName: model.get(i).itemName,
                                 tableValue: model.get(i).tableValue,
                                 droppedItemType: model.get(i).droppedItemType,
                                 dateFormat: model.get(i).dateFormat,
                             });
        }
        return columnsData;
    }

    // function to get the columnName from model
    function getAxisColumnNames(axisName) {
        var model = null;
        switch (axisName) {
        case Constants.xAxisName:
            model = xAxisListModel;
            break;
        case Constants.yAxisName:
            model = yAxisListModel;
            break;
        case Constants.row4Name:
        case Constants.row3Name:
            model = valuesListModel;
            break;
        }
        if (!model) {
            return [];
        }
        var columnsName = [];
        for (var i = 0; i < model.count; i++) {
            columnsName.push(model.get(i).tableValue);
        }
        return columnsName;
    }

    function getDataPaneAllDetails(axisName) {
        var model = null;
        switch (axisName) {
        case Constants.xAxisName:
            model = xAxisListModel;
            break;
        case Constants.yAxisName:
            model = yAxisListModel;
            break;
        case Constants.row3Name:
        case Constants.row4Name:
            model = valuesListModel;
            break;
        }
        if (!model) {
            return [];
        }
        var columnsAllDetails = [];
        for (var i = 0; i < model.count; i++) {
            columnsAllDetails.push({
                                       itemName: model.get(i).itemName,
                                       tableValue: model.get(i).tableValue,
                                       itemType: model.get(i).droppedItemType,
                                       dateFormat: model.get(i).dateFormat,
                                   });
        }
        return columnsAllDetails;
    }

    function clearAllChartValues() {
        // Not Setting ReportId to null
        // Because editReport signal is getting emitted to make it blank

        // Clear title
        // Clear Model
        // Set id to empty
        reportTitleName = "";
        ReportParamsModel.setReportTitle(reportTitleName);
        ReportParamsModel.setLastDropped(null);

        report_title_text.text = "";

        // Clear all the list models
        xAxisListModel.clear();
        yAxisListModel.clear();
        colorListModel.clear();
        valuesListModel.clear();
        dataItemList.clear();

        // Clear property Config
        d3PropertyConfig = {};

        // Clear general params
        lastPickedDataPaneElementProperties = {};
        reportDataPanes = {}; // Report Data Panes Object
        dragActiveObject = {};
        colorByData = [];

        // Clearing all the properties values
        alternateRowsCheckStatus = true;
        searchCheckStatus = true;
        compactStatusCheckStatus = false;

        // table total customization
        tableGrandTotalCheckStatus = false;
        totalSubTotalCheckStatus = false;
        totalRowTotalCheckStatus = false;

        // KPI Values!!
        boldCheckKPILabelStatus = false;
        italicCheckKPILabelStatus = false;
        underlineCheckKPILabelStatus = false;

        dataLabelDialogKpiColor = "#000000";
        dataLabelKpiColorBoxColor = "#000000";

        xAxisLabelStatus = true;
        yAxisLabelStatus = true;

        tempXModel.clear();
        tempYModel.clear();
        tempColorByModel.clear();

        reDrawChart();
    }

    // generate Report Id
    function generateReportId() {
        return ReportParamsModel.generateNewReportId();
    }

    // Slot Function
    // For changing the chart on clicking chart icons

    function reDrawChart(){
        DrawChartUtils.reDrawChart();
    }

    function focusReportTitle() {
        report_title_text.readOnly = false;
        report_title_text.focus = true;
    }


    function isNumber(number) {
        return !!(
                    number &&
                    number.trim() &&
                    !isNaN(number.trim().replace(/,/g, ""))
                    );
    }

    function openAxisSettings() {
        axisSettingsPopup.visible = true;
    }

    function updateReportTitle(title) {
        reportTitleName = title;
    }



    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS popup

    function dataTypeChange(dataType) {
        console.log(dataType)
    }

    function onCancelClickedCalc(){
        popupcalc.visible = false
    }

    function insertSyntax(i){
        //    syntaxEditorText.text = functionListElemText.text
        syntaxEditorText.text = functionModel.get(i).syntax
        report_desiner_page.mode = functionModel.get(i).mode
    }


    function onApplyClicked() {
        console.log("Apply clicked")
        if(nameTextField.text.length <= 0){
            report_desiner_page.errMsg = "Name column cannot be blank"
            popupError.text = report_desiner_page.errMsg
        } else {

            var name = nameTextField.text
//            var query = queryTextEdit.text
//            var query = `SELECT CASE WHEN "Row ID" < 10 THEN 'yes' ELSE 'no' END FROM orders1500 LIMIT 10`
//            var query = `SELECT CASE WHEN "id" < 10 THEN 'yes' ELSE 'no' END FROM users LIMIT 10`
            var query = `if [FIELD] < 6000 THEN "A" elseif [FIELD]  >= 6000 and [FIELD] < 9000 THEN "B" else "C" endif`
            var source = Constants.reportScreen


            // name, query, souce, mode
            console.log("name:", name, "q:", query, "source:", source, "mode:", mode)
            var status = CalculatedFields.addCalculatedField(name, query, source, report_desiner_page.mode)

            if (!status) {
                popupError.text = "Could not create calculated field"
            } else {
                onCancelClickedCalc()
            }
        }

    }



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    AxisSettingPopup{
        id: axisSettingsPopup
    }
    Popup {
        id: popupcalc
        width: parent.width * 0.8
        height: 800
        anchors.centerIn: parent

        visible: false
        modal: true
        padding: 0
        closePolicy: Popup.NoAutoClose

        background: Rectangle{
            color: Constants.whiteColor
        }

        // Popup Header Starts

        Rectangle{

            id: header
            color: Constants.themeColor
            height: 40
            width: parent.width - 2

            anchors.top: parent.top
            anchors.left: parent.left

            anchors.topMargin: 1
            anchors.leftMargin: 1

//            Text{
//                id: popupError
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.left : parent.left
//                font.pixelSize: Constants.fontCategoryHeader
//                anchors.leftMargin: 10
//                color: Constants.redColor
//            }

            Text{
                text: Constants.createCustomField
                anchors.verticalCenter: parent.verticalCenter
                anchors.left : parent.left
                font.pixelSize: Constants.fontCategoryHeader
                anchors.leftMargin: 10
            }
            Image {
                id: close_icn
                source: "/Images/icons/outline_close_black_18dp2x.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right:  parent.right
                height: 25
                width: 25
                anchors.rightMargin: 5
                MouseArea{
                    anchors.fill: parent
                    onClicked: onCancelClickedCalc()
                }
            }

        }

        // Popup Header Ends
        Rectangle{

            id: name
            anchors.top: header.bottom
            height: 70
            width: parent.width - 2

            Text{
                id:nameText
                text: Constants.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.left : parent.left
                font.pixelSize: Constants.fontCategoryHeader
                anchors.leftMargin: 30
            }

            Rectangle{
                anchors.left : nameText.right
                width: 210
                height: 30
                // radius: 15
                anchors.leftMargin:30
                border.color: Constants.borderBlueColor


                anchors.verticalCenter: parent.verticalCenter

                TextEdit {
                    // Green Input
                    // id: input1Field
                    id: nameTextField
                    leftPadding: 10
                    rightPadding: 10
                    width: parent.width
                    height:  parent.height
                    anchors.centerIn: parent
                    // onTextChanged: updateChart()
                    verticalAlignment: Text.AlignVCenter
                }
            }


        }

        Rectangle{

            id: calculation
            //            color: "yellow"
            anchors.top: name.bottom
            height: parent.height-100
            width: parent.width - 300
            Rectangle{

                id: calculationName
                //                color: "pink"
                anchors.top: parent.top
                height: 40
                width: parent.width - 2

                Text{
                    id:calculationText
                    text: Constants.calculation
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left : parent.left
                    font.pixelSize: Constants.fontCategoryHeader
                    anchors.leftMargin: 30
                }
            }
            Rectangle{
                id: calculationEditor
                anchors.left : parent.left
                anchors.top : calculationName.bottom
                width: parent.width-50
                height: parent.height-200
                // radius: 15
                anchors.leftMargin:30
                anchors.topMargin:30
                border.color: Constants.borderBlueColor
                //    color:"blue"

                // anchors.centerIn: parent

                // TextEdit {
                //     // Green Input
                //     // id: input1Field
                //     leftPadding: 10
                //     rightPadding: 10
                //     width: parent.width
                //     height:  parent.height
                //     anchors.centerIn: parent
                //     // onTextChanged: updateChart()
                //     //    verticalAlignment: Text.AlignVCenter
                // }
                // TODO: editor
                WebEngineView {
                    id: webEngineViewEditor
                    height:parent.height
                    width: parent.width
                    url: Constants.calculatedFieldEditorUrl
                    anchors.left: tool_sep_chartFilters.right
                    anchors.top: axis.bottom
                }
            }
            Rectangle{
                anchors.left : parent.left
                anchors.top : calculationEditor.bottom
                anchors.topMargin: 20
                anchors.leftMargin:30
                width: parent.width-50
                height: 70
                // radius: 15
                //               anchors.leftMargin:20
                border.color: Constants.borderBlueColor
                //    color:"blue"

                //               anchors.centerIn: parent

                TextEdit {
                    // Green Input
                    // id: input1Field
                    id: popupError
                    leftPadding: 10
                    rightPadding: 10
                    width: parent.width
                    height:  parent.height
                    anchors.centerIn: parent
                    // onTextChanged: updateChart()
                    //    verticalAlignment: Text.AlignVCenter
                }
            }

        }
        Rectangle{

            id: functionid
            //            color: "green"
            anchors.top: name.bottom
            anchors.right: parent.right
            height: parent.height-100
            width: 300
            Rectangle{

                id: functionName
                //                color: "pink"
                anchors.top: parent.top
                height: 40
                width: parent.width - 2

                Text{
                    id:functionText
                    text: Constants.functionName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left : parent.left
                    font.pixelSize: Constants.fontCategoryHeader
                    anchors.leftMargin: 20
                }
            }
            ComboBox {
                id:dropDownFunction
                currentIndex: 2
                anchors.top: functionName.bottom
                anchors.topMargin:27
                anchors.left : parent.left
                anchors.leftMargin:20
                model: [ "Logical Functions", "Aggregate Functions", "Numeric Functions" ]
                width: parent.width-40
                onCurrentIndexChanged: dataTypeChange(modelData)
            }
            Rectangle{
                id: functionEditor
                anchors.left : parent.left
                anchors.top : dropDownFunction.bottom
                width: parent.width-40
                height: 280
                // radius: 15
                anchors.leftMargin:20
                anchors.topMargin:5
                border.color: Constants.borderBlueColor
                clip: true
                Component {
                    id: contactDelegate
                    Rectangle {
                        // Rectangle{
                        id:functionListElem
                        width: parent.width-10;
                        height: 30;
                        anchors.left:parent.left
                        anchors.leftMargin:5
                        //  color:"red"
                        Column {
                            id:functionListElemText
                            Text { text: model.name }
                            // Text { text: 'Number: ' + model.number }
                        }
                        // }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: insertSyntax(index)
                            hoverEnabled: true
                            onEntered: {
                                functionListElem.color = "#F3F3F4"
                                overlay
                            }
                            onExited: {
                                //                                console.log("Exiting: ")
                                functionListElem.color = "white"
                            }

                        }

                    }
                }
                ListView {
                    anchors.fill: parent
                    clip: true
                    anchors.topMargin:10

                    ScrollBar.vertical: ScrollBar {}


                    model: functionModel

                    delegate: contactDelegate
                }

                // anchors.centerIn: parent

            }
            Rectangle{

                id: syntaxName
                //                color: "pink"
                anchors.top: functionEditor.bottom
                anchors.topMargin:20
                height: 40
                width: parent.width - 2

                Text{
                    id:syntaxText
                    text: Constants.syntax
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left : parent.left
                    font.pixelSize: Constants.fontCategoryHeader
                    anchors.leftMargin: 20
                    anchors.topMargin:30
                }
            }
            Rectangle{
                id: syntaxEditor
                anchors.left : parent.left
                anchors.top : syntaxName.bottom
                width: parent.width-50
                height: 105
                // radius: 15
                anchors.leftMargin:20
                anchors.topMargin:20
                //               anchors.leftMargin:20
                border.color: Constants.borderBlueColor
                color:"lightgrey"

                // anchors.centerIn: parent
                Text{
                    id:syntaxEditorText
                    text: "Syntax"
                    wrapMode: "WordWrap"
                    width:parent.width-20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left : parent.left
                    font.pixelSize: Constants.fontCategoryHeader
                    anchors.leftMargin: 20
                    anchors.topMargin:30
                }

            }
            Row{
                anchors.top:syntaxEditor.bottom
                anchors.left: parent.left
                anchors.topMargin: 40
                anchors.leftMargin: 20
                spacing: 20

                Button{
                    id: cancel_btn1
                    text: "Cancel"
                    //                    textValue: Messages.cancelBtnTxt
                    onClicked: onCancelClickedCalc()
                }


                Button{
                    id: apply_btn1
                    text: "Apply"
                    //                    textValue: Messages.applyBtnTxt
                    onClicked: onApplyClicked()
                }
            }
        }
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
                text: Messages.re_nr_customize
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
                placeholderText: Messages.re_nr_header
                selectByMouse: true
                width:250
                height: 40
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
                verticalAlignment:TextEdit.AlignVCenter
                Keys.onReturnPressed: report_title_text.focus = false
                background: Rectangle{
                    color: "transparent"
                    border.color: "transparent"
                }
            }

            //
            //            Image {
            //                source: "/Images/icons/Edit.png"
            //                height: 20
            //                width: 20
            //                anchors.right: parent.right
            //                anchors.rightMargin: 10
            //                anchors.verticalCenter: parent.verticalCenter
            //                MouseArea{
            //                    anchors.fill: parent
            //                    onClicked: focusReportTitle()
            //                }
            //            }
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
        z:-12000
    }
    // Left Menu Chart Icons Ends

    ToolSeparator{
        id: tool_sep_leftmenubarreports
        anchors.left: left_menubar_reports.right
        anchors.top: seperator_title_bar.bottom
        anchors.topMargin: -2
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
        z:-12000
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
                    onEntered:  DataPanesDropHandler.onDropAreaEntered(parent,Constants.xAxisName)
                    onExited:  DataPanesDropHandler.onDropAreaExited(parent,Constants.xAxisName)
                    onDropped: DataPanesDropHandler.onDropAreaDropped(parent,Constants.xAxisName)

                }
                ListView{

                    height: parent.height
                    width: parent.width - xAxisSettings.width - this.x
                    x:5
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    model: xAxisListModel
                    orientation: Qt.Horizontal
                    spacing: dataPanesSpacing
                    interactive: false
                    delegate: AxisDroppedRectangle{
                        textValue: itemName
                        itemType: droppedItemType
                        dateFormatValue: dateFormat
                        itemIndexId: index
                        axisType: Constants.xAxisName
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

                    visible: !allChartsMapping[chartTitle].axisSettingsDisabled

                    Image {
                        source: "/Images/icons/customize.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.centerIn: parent
                        height: 20
                        width: 20
                        MouseArea{
                            anchors.fill: parent
                            onClicked: openAxisSettings()
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
                    onEntered:  DataPanesDropHandler.onDropAreaEntered(parent,Constants.yAxisName)
                    onExited:  DataPanesDropHandler.onDropAreaExited(parent,Constants.yAxisName)
                    onDropped: DataPanesDropHandler.onDropAreaDropped(parent,Constants.yAxisName)
                }

                ListView{

                    height: parent.height
                    width: parent.width - yAxisSettings.width - 2*this.x
                    x:5
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    model: yAxisListModel
                    orientation: Qt.Horizontal
                    spacing: dataPanesSpacing
                    interactive: false
                    delegate: AxisDroppedRectangle{
                        textValue: itemName
                        itemType: droppedItemType
                        itemIndexId: index
                        axisType: Constants.yAxisName
                        dateFormatValue: dateFormat
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
                    visible: !allChartsMapping[chartTitle].axisSettingsDisabled


                    Image {
                        source: "/Images/icons/customize.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.centerIn: parent
                        height: 20
                        width: 20
                        MouseArea{
                            anchors.fill: parent
                            onClicked: openAxisSettings()
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
                border.color: "transparent"

                DropArea{
                    id: row3DropArea
                    anchors.fill: parent
                    onEntered:  DataPanesDropHandler.onDropAreaEntered(parent,Constants.row3Name)
                    onExited:  DataPanesDropHandler.onDropAreaExited(parent,Constants.row3Name)
                    onDropped: DataPanesDropHandler.onDropAreaDropped(parent,Constants.row3Name)
                }

                ListView{

                    height: parent.height
                    width: parent.width
                    x:5
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    model: valuesListModel
                    orientation: Qt.Horizontal
                    spacing: dataPanesSpacing
                    delegate: AxisDroppedRectangle{
                        textValue: itemName
                        itemType: droppedItemType
                        itemIndexId: index
                        axisType: Constants.row3Name
                        dateFormatValue: dateFormat
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
                            onClicked: openAxisSettings()
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
                    onEntered:  DataPanesDropHandler.onDropAreaEntered(parent,Constants.gaugePointerLabel)
                    onExited:  DataPanesDropHandler.onDropAreaExited(parent,Constants.gaugePointerLabel)
                    onDropped: DataPanesDropHandler.onDropAreaDropped(parent,Constants.gaugePointerLabel)
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
                    spacing: dataPanesSpacing
                    delegate: AxisDroppedRectangle{
                        textValue: itemName
                        itemType: droppedItemType
                        itemIndexId: index
                        axisType: Constants.row3Name
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
                width: 130
                height: parent.height
                anchors.left: row4Valueseparator.right

                // anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: input1Label
                    text: 'Max/Green'
                    anchors.centerIn: parent
                    // verticalalignment:parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.right:parent.right
                    anchors.rightMargin:10
                }
                z:1
            }

            // ToolSeparator{
            //     id: row4Valueseparator2
            //     orientation: Qt.Vertical
            //     anchors.left: row4TextInput1Label.right
            //     width: 1
            //     height: parent.height
            //     background: Rectangle{
            //         color: Constants.darkThemeColor
            //     }
            // }

            Rectangle{
                id: row4TextInput1
                width: 200
                height: parent.height
                anchors.left: row4TextInput1Label.right
                // border.color: Constants.borderBlueColor

                Rectangle{
                    width: 160
                    height: 30
                    radius: 15
                    border.color: Constants.borderBlueColor

                    anchors.centerIn: parent

                    TextEdit {
                        // Green Input
                        id: input1Field
                        leftPadding: 10
                        rightPadding: 10
                        width: parent.width
                        height:  parent.height
                        anchors.centerIn: parent
                        onTextChanged: updateChart()
                        verticalAlignment: Text.AlignVCenter
                    }
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
                    // [Tag: Refector]
                    // Move to constants
                    text: 'Yellow'
                    anchors.centerIn: parent
                }
                z:1
            }

            // ToolSeparator{
            //     id: row4Valueseparator4
            //     orientation: Qt.Vertical
            //     anchors.left: row4TextInput2Label.right
            //     width: 1
            //     height: parent.height
            //     background: Rectangle{
            //         color: Constants.darkThemeColor
            //     }
            // }

            Rectangle{
                id: row4TextInput2
                width: 200
                height: parent.height
                anchors.left: row4TextInput2Label.right

                Rectangle{
                    width: 160
                    height: 30
                    radius: 15
                    border.color: Constants.borderBlueColor
                    anchors.centerIn: parent

                    TextEdit {
                        id: input2Field
                        leftPadding: 10
                        rightPadding: 10
                        width: parent.width
                        height:  parent.height
                        anchors.centerIn: parent
                        onTextChanged: updateChart()
                        verticalAlignment: Text.AlignVCenter
                    }
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
                    // [Tag: Refector]
                    // Move to constants
                    text: 'Red'
                    anchors.leftMargin: 20
                    anchors.centerIn: parent
                }
                z:1
            }

            // ToolSeparator{
            //     id: row4Valueseparator6
            //     orientation: Qt.Vertical
            //     anchors.left: row4TextInput3Label.right
            //     width: 1
            //     height: parent.height
            //     background: Rectangle{
            //         color: Constants.darkThemeColor
            //     }
            // }

            Rectangle{
                id: row4TextInput3
                width: 200
                height: parent.height
                anchors.left: row4TextInput3Label.right
                // border.color: Constants.borderBlueColor
                Rectangle{
                    width: 160
                    height: 30
                    radius: 15
                    border.color: Constants.borderBlueColor

                    anchors.centerIn: parent

                    TextEdit {
                        id: input3Field
                        leftPadding: 10
                        rightPadding: 10
                        width: parent.width
                        height:  parent.height
                        anchors.centerIn: parent
                        onTextChanged: updateChart()
                        verticalAlignment: Text.AlignVCenter
                    }
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
        height:parent.height - axis.height -50
        width: parent.width - chartFilters1.width - left_menubar_reports.width - column_querymodeller.width-5
        url: Constants.baseChartUrl
        onLoadingChanged: ChartsWebViewHandler.onGrafieksChartPageLoaded(loadRequest)
        anchors.left: tool_sep_chartFilters.right
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
                    text: Messages.cancelBtnTxt
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
                    onClicked: Reports.cancelReport()
                }

                Button{
                    id: addReportButton
                    text: Messages.addBtnTxt
                    height: parent.height
                    anchors.right: parent.right
                    width: parent.width/2-0.5
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
                        onClicked: Reports.addReport(report_title_text.text)
                    }
                }
            }
            // Cancel and Add report Buttons Ends

            // Dashboard Name Starts

            Rectangle{
                id: dashboardNameRectangle

                anchors.top: tabbarQuerymodeller.bottom
                anchors.topMargin: 2

                height:40
                width: parent.width

                Text{
                    text: DSParamsModel.dsName
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
                        id: searchText
                        width: parent.parent.width
                        selectByMouse: true
                        height:30
                        cursorVisible: true
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        placeholderText: "Search"
                        background: Rectangle{
                            border.width: 0
                            height:parent.height
                        }
                        onTextChanged: searchColumnNames(searchText.text)
                    }


                }

                ToolSeparator{
                    orientation: Qt.Horizontal
                    width: parent.width - 10
                    anchors.top: searchBarRow.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 2
                }

            }

            // Search Ends

            // Data Pane Starts
            Rectangle{
                anchors.top: searchRectangle.bottom
                height: parent.height - (searchRectangle.height + dashboardNameRectangle.height + tabbarQuerymodeller.height)
                width: parent.width

                RightDataColumn{
                    //            console.log(output)
                }

            }
            // Data Pane Ends

        }

    }

    // Right Panel Ends
}
