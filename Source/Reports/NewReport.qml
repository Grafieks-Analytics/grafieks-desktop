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
    property bool row3Active: null

    property var maxDropOnXAxis: 1;
    property var maxDropOnYAxis: 1;

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
    property int reportIdMain:ReportParamsModel.reportId;

    // Initial Chart Config
    property string chartUrl: 'BarChartArrayInput.html';
    property string chartTitle: Constants.barChartTitle;
    property var customizationsAvailable: "Properties,Reference Line,Legend,Axis Size";
    property var subMenuCustomizationsAvailable: "color by,tool tip,size,data label,grid line";

    // This contains all the customizable config and is passed to drawChart function
    // In draw chart we take out these config; If config is empty => We have default config for it.
    property var d3PropertyConfig: ({});

    property var lastPickedDataPaneElementProperties: ({});
    property var reportDataPanes: ({});  // Report Data Panes Object

    property var dragActiveObject: ({});

    property var allChartsMapping: ({});
    // An array having item type and name of the spilt by value
    // Colour By Data is filled
    // 1. saved colour values -> CPP (Report Properties)
    // 2. when it is dropped -> (PropertiesFilter.qml)
    property var colorByData: [];

    property var allowedXAxisDataPanes: 0;
    property var allowedYAxisDataPanes: 0;

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

    // Array List -> This will contain all the charts which can be converted to horizontal
    property var horizontalChartList: [];

    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    // Colour By Drop List
    ListModel{
        id: colorListModel
    }

    // X Axis Bar => Used for all charts where 2 axis are requied
    ListModel{
        id: xAxisListModel

        onCountChanged: {
            console.log("AXIS NAMES Count changed",count)
        }
    }

    // Y Axis Bar => Used for all charts where 2 axis are requied
    ListModel{
        id: yAxisListModel
    }

    // Value Bar => Used miscellaneous graphs like Sanky
    ListModel{
        id: valuesListModel
    }

    // Colur By Data Item List
    ListModel{
        id: dataItemList
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
                return;
            }
            if(reportId != "false"){
                addReportButton.text = "Update";
                editReportFlag = true;
                setValuesOnEditReport(reportId);
            }else{
                addReportButton.text = "Add";
                ReportParamsModel.setReportId(reportIdMain);
                
                ReportParamsModel.setChartType(Constants.barChartTitle);
                ReportParamsModel.setChartTitle(Constants.barChartTitle);
            }
        }

        function onReportIdChanged(reportIdValue){
            // Todo
            // Tag: Check
            console.log('DEBUG::: Report id value',reportIdValue);
            if(!reportIdValue){
                clearValuesOnAddNewReport();

                // When New Report is added we clear all the fields -> So if multiple line/bar is changed then we have to revert it.
                // We can also handle this from dropped page :think:
                console.log('This is a new report!. Please handle the charts in this section here');
                console.log(chartTitle);

                switch(chartTitle){
                    case Constants.horizontalStackedBarChartTitle:
                    case Constants.stackedBarChartTitle:
                        switchChart(Constants.barChartTitle);
                        break;
                    case Constants.multipleHorizontalAreaChartTitle:
                    case Constants.multipleAreaChartTitle:
                        switchChart(Constants.areaChartTitle);
                        break;
                    case Constants.horizontalMultiLineChartTitle:
                    case Constants.multiLineChartTitle:
                        switchChart(Constants.lineChartTitle);
                        break;
                }
                
            }
            report_desiner_page.reportIdMain = reportIdValue;
            ReportParamsModel.restoreMasterReportFilters(reportIdValue)
        }

        function onClearScreenSignal(){
            clearValuesOnAddNewReport();
            clearAllChartValues()
        }

    }

    Connections{
        target: ChartsModel

        function onSignalBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }

        function onSignalStackedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalGroupedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalNewGroupedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalAreaChartValues(output, reportId, dashboardId, chartSource){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalLineChartValues(output, reportId, dashboardId, chartSource){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalLineBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalPieChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalFunnelChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalRadarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalScatterChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalHeatMapChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalSunburstChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalWaterfallChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalGaugeChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalSankeyChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalTreeChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalTreeMapChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalKPIChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalTableChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalPivotChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalStackedAreaChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalMultiLineChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === report_desiner_page.reportIdMain)
                drawChartAfterReceivingSignal(output);
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function drawChartAfterReceivingSignal(dataValues){
        if(webEngineView.loading){
            return;
        }
        
        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
        var row3Columns = getAxisColumnNames(Constants.row3Name);
        var colorByColumnName = colorByData[0] && colorByData[0].columnName;

        var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
        var yAxisColumnDetails = getDataPaneAllDetails(Constants.yAxisName);
        var row3ColumnDetails = getDataPaneAllDetails(Constants.row3Name);

        console.log(xAxisColumns, yAxisColumns)
        colorData = [];
        switch(chartTitle){
        case Constants.horizontalBarChartTitle:
            console.log(chartTitle,"CLICKED")
            // datavalues is a global property and set using connections
            // due to multi threading
            colorData = (dataValues && [JSON.parse(dataValues)[1][0]]) || [];
            break;
        case Constants.barChartTitle:
            console.log(chartTitle,"CLICKED")
            colorData = (dataValues && [JSON.parse(dataValues)[1][0]]) || [];
            break;
        case Constants.horizontalStackedBarChartTitle:
            console.log(chartTitle,"CLICKED")

            dataValues = dataValues && JSON.parse(dataValues);
            dataValues[2] = [yAxisColumns[0],colorByColumnName,xAxisColumns[0]];
            colorData = dataValues[1] || [];
            console.log(dataValues);
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.stackedBarChartTitle:
            console.log(chartTitle,"CLICKED")
            
            dataValues = dataValues && JSON.parse(dataValues);
            dataValues[2] = [xAxisColumns[0],colorByColumnName,yAxisColumns[0]];
            colorData = dataValues[1] || [];
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.horizontalBarGroupedChartTitle:
            var [category, subcategory] =  getAxisColumnNames(Constants.yAxisName);
            if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
            }else{
                delete d3PropertyConfig['options'];
                colorListModel.clear();
                colorByData = [];
            }
            dataValues = JSON.parse(dataValues);
            dataValues.push([yAxisColumns[0],yAxisColumns[1],xAxisColumns[0]]);
            dataValues = JSON.stringify(dataValues);
            
            break;
        case Constants.groupBarChartTitle:
            var [category, subcategory] =  getAxisColumnNames(Constants.xAxisName);
            if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
            }else{
                delete d3PropertyConfig['options'];
                colorListModel.clear();
                colorByData = [];
                ReportParamsModel.setItemType(null);
                ReportParamsModel.setLastDropped(null);
            }
            
            dataValues = JSON.parse(dataValues);
            dataValues.push([xAxisColumns[0],xAxisColumns[1],yAxisColumns[0]]);
            dataValues = JSON.stringify(dataValues);

            console.log('Grouped bar chart!',xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);
            break;
        case Constants.areaChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.horizontalAreaChartTitle:
            console.log(chartTitle,"CLICKED")
            colorData = (dataValues && [JSON.parse(dataValues)[1][0]]) || [];
            break;
        case Constants.lineChartTitle:
            console.log(chartTitle,"CLICKED");
            colorData = (dataValues && [JSON.parse(dataValues)[1][0]]) || [];
            break;
        case Constants.horizontalLineChartTitle:
            console.log(chartTitle,"CLICKED")
            colorData = (dataValues && [JSON.parse(dataValues)[1][0]]) || [];
            break;
        case Constants.stackedAreaChartTitle:
        case Constants.multiLineChartTitle:
            console.log(Constants.multiLineChartTitle,"CLICKED");
            dataValues = JSON.parse(dataValues);
            dataValues[1].splice(1,0,colorByColumnName);
            colorData = (dataValues && dataValues[1]) || [];
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.multipleHorizontalAreaChartTitle:
        case Constants.horizontalMultiLineChartTitle:
            dataValues = JSON.parse(dataValues);
            dataValues[1].splice(1,0,colorByColumnName);
            colorData = (dataValues && dataValues[1]) || [];
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.pieChartTitle:
        case Constants.donutChartTitle:
            console.log(chartTitle,"CLICKED");
//            var dataValuesTemp = dataValues && JSON.parse(dataValues);
//            colorData = dataValuesTemp[0].map(d=> d.key );
//            delete dataValuesTemp;
            break;
        case Constants.funnelChartTitle:
            console.log(chartTitle,"CLICKED");
            var dataValuesTemp = dataValues && JSON.parse(dataValues);
            colorData = Object.keys(dataValuesTemp[0])
            delete dataValuesTemp;
            break;
        case Constants.radarChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.scatterChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.treeChartTitle:
            console.log(chartTitle,"CLICKED")
            dataValues = [{ name: xAxisColumns[0] , children: JSON.parse(dataValues) }]
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.treeMapChartTitle:
            dataValues = { name: xAxisColumns[0] , children: JSON.parse(dataValues) }
            dataValues = JSON.stringify(dataValues);
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.heatMapChartTitle:
            console.log('Debug:: datavalues',dataValues);
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.sunburstChartTitle:
            dataValues = [{ name: xAxisColumns[0] , children: JSON.parse(dataValues) }]
            dataValues = JSON.stringify(dataValues);
            console.log('Data values sunburst', dataValues);
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.waterfallChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.gaugeChartTitle:
            console.log(chartTitle,"CLICKED");
            console.log('Debug:::dataValues',dataValues);
            var greenValue = input1Field.text;
            var yellowValue = input2Field.text;
            var redValue = input3Field.text;
            console.log('Gauge Data',greenValue, yellowValue, redValue);
            dataValues = [[+greenValue, +yellowValue, +redValue, dataValues], row3Columns[0]];
            dataValues = JSON.stringify(dataValues);
            console.log('Debug:::dataValues',dataValues);
            break;
        case Constants.sankeyChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.kpiTitle:
            dataValues = [dataValues, xAxisColumns[0]];
            dataValues = JSON.stringify(dataValues);
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.tableTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.pivotTitle:
            
            dataValues = JSON.parse(dataValues);
            dataValues.push([xAxisColumns,yAxisColumns,row3Columns]);
            dataValues = JSON.stringify(dataValues);
            
            console.log(chartTitle,"CLICKED")
            break;
        default:
            console.log(chartTitle,"Clicked, but is a missed case")
        }
        if(!dataValues){
            return;
        }

        console.log('Debug: Colour Data',colorData);
        console.log('data values',dataValues);

        // Appending list to select color
        dataItemList.clear();
        console.log('Color Data',colorData);
        if(colorData && colorData.length){
            colorData.forEach(function (element,index) {
                dataItemList.append({"colorValue" : Constants.d3ColorPalette[index % Constants.d3ColorPalette.length], "dataItemName" : element});
            });
        }

        var scriptValue = 'window.addEventListener("resize", function () {
                   window.clearChart && clearChart();
                    drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+');
           });';

        clearChartValue();
        var runScriptString = 'drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+'); '+scriptValue;
        webEngineView.runJavaScript(runScriptString);
    }

    Component.onCompleted: {

        // Connect signal and slots
        ReportParamsModel.xAxisActive = false;
        ReportParamsModel.yAxisActive = false;
        ReportParamsModel.colorByActive = false;
        row3Active = false;

        // Clearing xAxisListModel and yAxisListModel if any
        // Might be possible that this is getting called once
        // Check if can be removed [TAG: Optimization]
        xAxisListModel.clear();
        yAxisListModel.clear();

        // Pushing all the horiontal type chart
        horizontalChartList.push(Constants.barChartTitle);
        horizontalChartList.push(Constants.stackedBarChartTitle);
        horizontalChartList.push(Constants.groupBarChartTitle);

        horizontalChartList.push(Constants.horizontalBarChartTitle);
        horizontalChartList.push(Constants.horizontalStackedBarChartTitle);
        horizontalChartList.push(Constants.horizontalBarGroupedChartTitle);

        horizontalChartList.push(Constants.lineChartTitle);
        horizontalChartList.push(Constants.horizontalLineChartTitle);
        horizontalChartList.push(Constants.multiLineChartTitle);
        horizontalChartList.push(Constants.horizontalMultiLineChartTitle);
        
        horizontalChartList.push(Constants.areaChartTitle);
        horizontalChartList.push(Constants.horizontalAreaChartTitle);
        horizontalChartList.push(Constants.multipleAreaChartTitle);
        horizontalChartList.push(Constants.multipleHorizontalAreaChartTitle);

    }


    onIsHorizontalGraphChanged: {

        console.log('Horizontal Bar Flag Change', chartTitle);

        if(isHorizontalGraph){

            allowedXAxisDataPanes = 1;
            allowedYAxisDataPanes = 2;

            switch(chartTitle){
            case Constants.stackedBarChartTitle:
                console.log('Switching to horizontal stacked bar chart')
                switchChart(Constants.horizontalStackedBarChartTitle);
                break;
            case Constants.barChartTitle:
                allowedYAxisDataPanes = 2;
                console.log('Switching to horizontal bar chart')
                switchChart(Constants.horizontalBarChartTitle);
                break;
            case Constants.multiLineChartTitle:
                allowedYAxisDataPanes = 1;
                console.log('Switching to multiple horizontal line chart')
                switchChart(Constants.horizontalMultiLineChartTitle);
                break;
            case Constants.lineChartTitle:
                allowedYAxisDataPanes = 1;
                console.log('Switching to horizontal line chart')
                switchChart(Constants.horizontalLineChartTitle);
                break;
            case Constants.multipleAreaChartTitle:
                allowedYAxisDataPanes = 1;
                console.log('Switching to multiple horizontal area chart')
                switchChart(Constants.multipleHorizontalAreaChartTitle);
                break;
            case Constants.areaChartTitle:
                allowedYAxisDataPanes = 1;
                console.log('Switching to horizontal area chart')
                switchChart(Constants.horizontalAreaChartTitle);
                break;
            default:
                console.log('Missed condition in isHorizontalGraph change horizontal')
            }
        }else{

            // Changing the maximum values allowed (This will be the only case bar graphs )
            allowedXAxisDataPanes = 2;
            allowedYAxisDataPanes = 1;

            switch(chartTitle){
            case Constants.horizontalBarChartTitle:
                console.log('Switching to bar chart')
                switchChart(Constants.barChartTitle);
                break;
            case Constants.horizontalStackedBarChartTitle:
                console.log('Switching to stacked bar chart')
                switchChart(Constants.stackedBarChartTitle);
                break;
            case Constants.horizontalLineChartTitle:
                allowedXAxisDataPanes = 1;
                console.log('Switching to line chart')
                switchChart(Constants.lineChartTitle);
                break;
            case Constants.horizontalMultiLineChartTitle:
                allowedXAxisDataPanes = 1;
                console.log('Switching to multiple line chart')
                switchChart(Constants.multiLineChartTitle);
                break;
            case Constants.horizontalAreaChartTitle:
                allowedXAxisDataPanes = 1;
                console.log('Switching to line chart')
                switchChart(Constants.areaChartTitle);
                break;
            case Constants.multipleHorizontalAreaChartTitle:
                allowedXAxisDataPanes = 1;
                console.log('Switching to multiple line chart')
                switchChart(Constants.multipleAreaChartTitle);
                break;
            default:
                console.log('Missed condition in isHorizontalGraph change veritcal')

            }

        }
    }


    onChartTitleChanged: {

        console.log('Chart Title Changed',chartTitle);

        // Charts Mapping
        // Basically these are the basic configs
        // Having Max Allowed Values for now
        const chartDetailsConfig = allChartsMapping[chartTitle];
        const { maxDropOnXAxis, maxDropOnYAxis } = chartDetailsConfig || {maxDropOnXAxis: allowedXAxisDataPanes, maxDropOnYAxis: allowedYAxisDataPanes};

        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);;

        // check if maximum drop is less than in config?
        // if less then remove all the extra values
        // else no change -> Plot the graph

        var dataValuesRemoved = false;
        if(maxDropOnXAxis > 0 && maxDropOnXAxis < xAxisColumns.length){
            xAxisColumns = xAxisColumns.splice(0,maxDropOnXAxis);
            ReportParamsModel.setXAxisColumns(xAxisColumns);
            xAxisListModel.remove(maxDropOnXAxis,xAxisListModel.count - maxDropOnXAxis);
            dataValuesRemoved = true;
        }

        if(maxDropOnYAxis > 0 && maxDropOnYAxis < yAxisColumns.length){
            yAxisColumns = yAxisColumns.splice(0,maxDropOnYAxis);
            ReportParamsModel.setYAxisColumns(yAxisColumns);
            yAxisListModel.remove(maxDropOnYAxis,yAxisListModel.count - maxDropOnYAxis);
            dataValuesRemoved = true;
        }

        allowedXAxisDataPanes = maxDropOnXAxis;
        allowedYAxisDataPanes = maxDropOnYAxis;

        // change axis on the basis of chart title
        // Updating the Row visible here => Sanky charts can have 3 rows
        // where we can drop the columns

        // Optimization Can be done => call switch function here to change the graph
        switch(chartTitle){
        case Constants.horizontalStackedBarChartTitle:
            console.log('Make Horizontal stacked bar chart');
            chartUrl=Constants.horizontalStackedBarChartUrl
            webEngineView.url = Constants.chartsBaseUrl+chartUrl;
            xAxisVisible = true
            yAxisVisible = true
            row3Visible = false
            row4Visible = false
            break;
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
        case Constants.sankeyTitle:
            row3Visible =  true;
            xAxisVisible = true
            yAxisVisible = true
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
        case Constants.kpiTitle:
            yAxisVisible = false
            xAxisVisible = true
            row3Visible = false
            row4Visible = false
            break;
        default:
            xAxisVisible = true
            yAxisVisible = true
            row3Visible = false
            row4Visible = false
        }

        // If any column is removed on changing the chart name
        // redraw the chart
        if(dataValuesRemoved){
            redrawChart();
        }

    }

    // Variable when drop is hovered on X Axis
    onXaxisActiveChanged: {
        if(xaxisActive){
            xAxisRectangle.border.color = Constants.grafieksLightGreenColor;
            xAxisRectangle.border.width = Constants.dropEligibleBorderWidth;
        }else{
            xAxisRectangle.border.color = "transparent";
            xAxisRectangle.border.width = Constants.dropInActiveBorderWidth;
        }
    }

    // Variable when drop is hovered on Y Axis
    onYaxisActiveChanged: {
        if(yaxisActive){
            yAxisRectangle.border.color = Constants.grafieksLightGreenColor;
            yAxisRectangle.border.width = Constants.dropEligibleBorderWidth;
        }else{
            yAxisRectangle.border.width = Constants.dropInActiveBorderWidth;
        }
    }
    
    // Variable when drop is hovered on Y Axis
    onRow3ActiveChanged: {
        if(row3Active){
            row3DropAreaRectangle.border.color = Constants.grafieksLightGreenColor;
            row3DropAreaRectangle.border.width = Constants.dropEligibleBorderWidth;
        }else{
            row3DropAreaRectangle.border.color = "transparent";
            row3DropAreaRectangle.border.width = Constants.dropInActiveBorderWidth;
        }
    }
    
    function exportPivotChart(){
        webEngineView.runJavaScript('exportToExcel()');
    }

    
    function clearValuesOnAddNewReport(){
        clearAllChartValues();
        // switchChart(Constants.barChartTitle);
    }

    function setValuesOnEditReport(reportId){

        ReportParamsModel.setLastDropped(null);

        // Setting the report title value to empty
//        report_title_text.text = "";
        report_desiner_page.reportIdMain = reportId;

        // Clear all the list models
        xAxisListModel.clear();
        yAxisListModel.clear();
        colorListModel.clear();
        valuesListModel.clear();
        dataItemList.clear();
        
        var reportProperties = ReportParamsModel.getReport(reportIdMain);

        var xAxisColumnsReportData = JSON.parse(reportProperties.xAxisColumns);
        var yAxisColumnsReportData = JSON.parse(reportProperties.yAxisColumns);
        var colorListModelData = JSON.parse(reportProperties.colorByDataColoumns);

        // Update List Models
        for(var i=0; i<xAxisColumnsReportData.length; i++){
            xAxisListModel.append({ itemName: xAxisColumnsReportData[i].itemName, droppedItemType: xAxisColumnsReportData[i].droppedItemType, dateFormat: xAxisColumnsReportData[i].dateFormat })
        }
        for(var i=0; i< yAxisColumnsReportData.length; i++){
            yAxisListModel.append({ itemName: yAxisColumnsReportData[i].itemName, droppedItemType: yAxisColumnsReportData[i].droppedItemType, dateFormat: yAxisColumnsReportData[i].dateFormat })
        }
        for(var i=0; i<colorListModelData.length; i++){
            colorListModel.append({ textValue: colorListModelData[i].columnName })
        }

        // Update Property Variables
        report_title_text.text = reportProperties.reportTitle
        report_desiner_page.chartTitle = reportProperties.chartTitle;
        report_desiner_page.chartUrl = reportProperties.chartUrl
        report_desiner_page.d3PropertyConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        report_desiner_page.colorByData = JSON.parse(reportProperties.colorByDataColoumns);

        reDrawChart();
    }

    // On Edit Redraw the updated chart
    function reDrawDashboardChart(reportId){
        let reportInstance = ReportParamsModel.getDashboardReportInstance(reportIdMain);
        console.log(reportInstance);
        var reportProperties = ReportParamsModel.getReport(reportIdMain);
        var reportUrl = reportInstance.getChartUrl();

        // Check if on updating the graph chart url was changed.
        // If changed update the url in report instance
        // Else just redraw the chart.
        if(reportUrl !== reportProperties.chartUrl){
            reportInstance.setChartUrl(reportProperties.chartUrl);
            return;
        }

        reportInstance.reDrawChart();
    }

    // Redraw all the charts in Dashboard
    function reDrawAllDashboardCharts(){
        // Here are all the instances, Let's Redraw the charts
        let allReportInstances = ReportParamsModel.getAllDashboardReportInstances();
        for(var reportIdValue in allReportInstances){
            // Redrawing charts one by one;
            var instance = allReportInstances[reportIdValue];
            instance.reDrawChart();
        }
    }


    // Switch Chart Urls
    // Whenever Chart is changed
    // Perform these things
    // 1. Change the title
    // 2. Change the URL
    // 3. Update the webEngine URL

    function switchChart(chartTitleValue){
        chartTitle = chartTitleValue;
        var chartUrl = '';
        switch(chartTitle){
        case Constants.barChartTitle:
            chartUrl = Constants.barChartUrl;
            break;
        case Constants.horizontalBarChartTitle:
            chartUrl = Constants.horizontalBarChartUrl;
            break;
        case Constants.horizontalStackedBarChartTitle:
            chartUrl = Constants.horizontalStackedBarChartUrl;
            break;
        case Constants.stackedBarChartTitle:
            chartUrl = Constants.stackedBarChartUrl
            break;
        case Constants.groupBarChartTitle:
            chartUrl = Constants.barGroupedChartUrl
            break;
        case Constants.horizontalLineChartTitle:
            chartUrl = Constants.horizontalLineChartUrl
            break;
        case Constants.multiLineChartTitle:
            chartUrl = Constants.multiLineChartUrl;
            break;
        case Constants.lineChartTitle:
            chartUrl  = Constants.lineChartUrl;
            break;
        case Constants.horizontalMultiLineChartTitle:
            chartUrl = Constants.horizontalMultiLineChartUrl;
            break;
        case Constants.areaChartTitle:
            chartUrl = Constants.areaChartUrl;
            break;
        case Constants.multipleAreaChartTitle:
            chartUrl = Constants.multipleAreaChartUrl;
            break;
        case Constants.horizontalAreaChartTitle:
            chartUrl = Constants.horizontalAreaChartUrl;
            break;
        case Constants.multipleHorizontalAreaChartTitle:
            chartUrl = Constants.multipleHorizontalAreaChartUrl;
            break;
        }

        webEngineView.url = Constants.baseChartUrl+chartUrl;
        report_desiner_page.chartUrl = chartUrl;
    }

    function searchColumnNames(searchText){
        ReportsDataModel.searchColumnNames(searchText)
    }

    function getAxisModelAsJson(axisName){
        var model = null;
        switch(axisName){
        case Constants.xAxisName:
            model = xAxisListModel;
            break
        case Constants.yAxisName:
            model = yAxisListModel;
            break;
        case Constants.gaugePointerLabel:
        case Constants.row3Name:
            model = valuesListModel;
            break;
        }
        if(!model){
            return [];
        }
        var columnsData = [];
        for(var i=0; i< model.count; i++){
            columnsData.push({ itemName: model.get(i).itemName, droppedItemType: model.get(i).droppedItemType, dateFormat: model.get(i).dateFormat });
        }
        return columnsData;
    }


    // function to get the columnName from model
    function getAxisColumnNames(axisName){
        var model = null;
        switch(axisName){
        case Constants.xAxisName:
            model = xAxisListModel;
            break
        case Constants.yAxisName:
            model = yAxisListModel;
            break;
        case Constants.row3Name:
            model = valuesListModel;
            break;
        }
        if(!model){
            return [];
        }
        var columnsName = [];
        for(var i=0; i< model.count; i++){
            columnsName.push(model.get(i).itemName);
        }
        return columnsName;
    }

    function getDataPaneAllDetails(axisName){
         var model = null;
        switch(axisName){
        case Constants.xAxisName:
            model = xAxisListModel;
            break
        case Constants.yAxisName:
            model = yAxisListModel;
            break;
        case Constants.row3Name:
            model = valuesListModel;
            break;
        }
        if(!model){
            return [];
        }
        var columnsAllDetails = [];
        for(var i=0; i< model.count; i++){
            columnsAllDetails.push({ itemName: model.get(i).itemName, itemType: model.get(i).droppedItemType, dateFormat: model.get(i).dateFormat });
        }
        return columnsAllDetails;
    }

    function clearAllChartValues(){

        // Not Setting ReportId to null
        // Because editReport signal is getting emitted to make it blank

        // Clear title
        // Clear Model
        // Set id to empty
        reportTitleName = ""
        ReportParamsModel.setReportTitle(reportTitleName);
        ReportParamsModel.setLastDropped(null);

        report_title_text.text = "";
        reportIdMain = 0;

        // Clear all the list models
        xAxisListModel.clear();
        yAxisListModel.clear();
        colorListModel.clear();
        valuesListModel.clear();
        dataItemList.clear();

        // Clear property Config
        d3PropertyConfig = {};

        // Clear general params
        lastPickedDataPaneElementProperties= {};
        reportDataPanes= {};  // Report Data Panes Object
        dragActiveObject= {};
        colorByData = [];

        // Calling this redraw will clear the chart because no x and y columns will be available
        // [Tag: Optimization]
        // Check instead of reDraw if we can call only one function to clear the chart
        // May be webengineview.runJs("call clearValues");
        reDrawChart();

    }

    // generate Report Id
    function generateReportId(){
        return ReportParamsModel.generateNewReportId();
    }

    // Slot Function
    // For changing the chart on clicking chart icons

    // Clear the chart defaults
    function clearChartValue(){
        webEngineView.runJavaScript('clearChart()');
    }

    function checkHorizontalGraph(){
        
        if(!horizontalChartList.includes(chartTitle)){
            console.log('Debug:: Chart does not have horizontal title... returning')
            return;
        }
        var xAxisType = xAxisListModel.count && xAxisListModel.get(0).droppedItemType.toLowerCase();
        var yAxisType = yAxisListModel.count && yAxisListModel.get(0).droppedItemType.toLowerCase();

        console.log('Debug::',xAxisType, yAxisType);

        if(xAxisType == "numerical" || yAxisType == "date" || yAxisType == "categorical"){
            console.log('Debug:: Graph is horizontal');
            isHorizontalGraph = true;
        }else if(yAxisType == "numerical" || xAxisType == "date" || xAxisType == "categorical"){
            console.log('Debug:: Graph is not horizontal');
            isHorizontalGraph = false;
        }

    }

    function reDrawChart(){

        checkHorizontalGraph();
        console.log('Debug::',chartTitle,': Colour By',colorByData, colorListModel.count, colorListModel)
        
        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
        var row3Columns = getAxisColumnNames(Constants.row3Name);

        if(chartTitle == Constants.gaugeChartTitle && isGaugeChart()){
            drawChart();
        }

        if(chartTitle == Constants.pivotTitle){

            if(xAxisColumns.length > 0 && yAxisColumns.length > 0  && row3Columns.length > 0){
                console.log(xAxisColumns, row3Columns, yAxisColumns)
                drawChart();
            }
            return;
        }

        
        if(chartTitle == Constants.tableTitle || chartTitle == Constants.kpiTitle){
            console.log('Start plotting ',chartTitle,'chart')
            if(xAxisColumns.length > 0 ){
                console.log(xAxisColumns)
                drawChart();
            }
            return;
        }

        

        // Check graph type for redrawing
        // If length = 1 and type of chart is
        // 1. Grouped Bar Chart and no Colour By is there => Bar chart
        // 2. Grouped Bar Chart and Colour By Present => Stacked Bar Chart

        if(xAxisColumns.length === 1 && yAxisColumns.length === 1){

            // Condition for horizontal bar graph;
            if(isHorizontalGraph){
                allowedXAxisDataPanes = 1;
                allowedYAxisDataPanes = 2;
                
                switch(chartTitle){

                case Constants.barChartTitle:
                    if(colorByData.length)  {
                        switchChart(Constants.horizontalStackedBarChartTitle)
                        break;
                    }
                    chartUrl = Constants.horizontalBarChartUrl;
                    webEngineView.url = Constants.baseChartUrl+chartUrl;
                    chartTitle = Constants.horizontalBarChartTitle;
                    break;
                case Constants.lineChartTitle:
                    console.log(Constants.lineChartTitle);
                    if(colorByData.length)  {
                        console.log('Changeing to Horizontal Multi Line');
                        switchChart(Constants.horizontalMultiLineChartTitle)
                        break;
                    }
                    switchChart(Constants.horizontalLineChartTitle)
                    break;
                case Constants.areaChartTitle:
                    console.log(Constants.areaChartTitle);
                    if(colorByData.length)  {
                        console.log('Changeing to Horizontal Stack Area');
                        switchChart(Constants.multipleHorizontalAreaChartTitle)
                        break;
                    }
                    switchChart(Constants.horizontalAreaChartTitle)
                    break;
                case Constants.horizontalBarGroupedChartTitle:
                    if(colorByData.length){
                        switchChart(Constants.horizontalStackedBarChartTitle)
                        break;
                    }
                    switchChart(Constants.horizontalBarChartTitle);
                    break;
                case Constants.horizontalMultiLineChartTitle:
                    if(colorByData.length){
                        break;
                    }
                    switchChart(Constants.horizontalLineChartTitle);
                    break;
                case Constants.horizontalAreaChartTitle:
                    if(colorByData.length){
                        switchChart(Constants.multipleHorizontalAreaChartTitle);
                        break;
                    }
                    break;
                case Constants.multipleHorizontalAreaChartTitle:
                    if(colorByData.length){
                        break;
                    }
                    switchChart(Constants.horizontalAreaChartTitle);
                    break;
                default:
                    console.log('Debug:','Horizontal Graph Missed condition',chartTitle);

                }
            }else{

                if(chartTitle === Constants.barChartTitle && colorByData.length){
                    console.log('Change to stacked bar chart')
                    switchChart(Constants.stackedBarChartTitle);
                }else if(chartTitle === Constants.groupBarChartTitle && !colorByData.length){
                    console.log('Redraw Function - Check which graph to be plotted here')
                    chartUrl = Constants.barChartUrl;
                    webEngineView.url = Constants.baseChartUrl+chartUrl;
                    chartTitle = Constants.barChartTitle;
                }else if(chartTitle === Constants.groupBarChartTitle && colorByData.length){
                    switchChart(Constants.stackedBarChartTitle);
                }else if(chartTitle === Constants.areaChartTitle && colorByData.length){
                    switchChart(Constants.multipleAreaChartTitle);
                }else if(chartTitle === Constants.lineChartTitle && colorByData.length){
                    switchChart(Constants.multiLineChartTitle);
                }else if(chartTitle === Constants.multipleAreaChartTitle && !colorByData.length){
                    switchChart(Constants.areaChartTitle);
                }
            }

        }

        drawChart();
    }

    // Load New Chart
    function changeChart(chartname){
        webEngineView.url = chartname;
    }

    function addReport(titleName){

        // Add report to dashboard
       if(!ReportParamsModel.editReportToggle || ReportParamsModel.editReportToggle  == "false" || ReportParamsModel.editReportToggle == "-1"){
            reportIdMain = generateReportId();
            ReportParamsModel.setReportId(reportIdMain);
       }
        
        stacklayout_home.currentIndex = Constants.dashboardDesignerIndex;

        let currentDashboard = DashboardParamsModel.currentDashboard

        // [Tag: Optimization]
        // We can create the object here and pass to cpp
        // to store in reportsMap

        // Save add the data in cpp
        // get the data in cpp and create an object

        // Check if report name exists or not
        // If name is not given add the name as Report "NUMBER"
        // Else is  not required (Case to set the value, because it is getting saved on key presses)
        if(typeof titleName === "undefined" || titleName.length <= 0){
            var numberOfReports = ReportParamsModel.reportsCount();
            ReportParamsModel.setReportTitle('Report '+ (numberOfReports));
        } else {
            ReportParamsModel.setReportTitle(titleName)
        }

        console.log("ANY", chartTitle, JSON.stringify(d3PropertyConfig), report_desiner_page.chartUrl, Constants.xAxisName)
        ReportParamsModel.setChartType(chartTitle);
        ReportParamsModel.setChartTitle(chartTitle);
        ReportParamsModel.setD3PropertiesConfig(JSON.stringify(d3PropertyConfig));
        ReportParamsModel.setChartUrl(report_desiner_page.chartUrl);
        ReportParamsModel.setXAxisColumns(JSON.stringify(getAxisModelAsJson(Constants.xAxisName)));
        ReportParamsModel.setYAxisColumns(JSON.stringify(getAxisModelAsJson(Constants.yAxisName)));
        ReportParamsModel.setColorByDataColoumns(JSON.stringify(colorByData));

        ReportParamsModel.addReport(reportIdMain);

        chartTitle = Constants.barChartTitle;
        chartUrl = Constants.barChartUrl;


        console.log('Editing Flag?',editReportFlag)
        // On Edit => Redraw Only Updated chart in Dashboard
        if(editReportFlag){
            reDrawDashboardChart(reportIdMain);
        }
        editReportFlag = false;

        // Setting it to -1 so that editReportToggle signal is called
        // After this editReportToggle is set to false
        // Gets called again which creates a new id and add it to map
        ReportParamsModel.setEditReportToggle("-1");

        DashboardParamsModel.setDashboardReportMap(reportIdMain);
        // switchChart(Constants.barChartTitle);
    }

    function cancelReport(){
        // Back to dashboard
        GeneralParamsModel.setCurrentScreen(Constants.dashboardScreen)
        stacklayout_home.currentIndex = Constants.dashboardDesignerIndex
        // ReportsDataModel.removeTmpChartData()

        if(addReportButton.text == "Add"){
            console.log('Deleting Report',reportIdMain)
            ReportParamsModel.deleteReport(reportIdMain,false);
        }

        let currentDashboard = DashboardParamsModel.currentDashboard
    }

    function focusReportTitle(){
        report_title_text.readOnly= false
        report_title_text.focus = true;
    }

    function onDropAreaEntered(element,elementName){
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

    function xAxisDropEligible(itemName, itemType){
        console.log('Debug:: Item type',itemType)
        var xAxisColumns  = getAxisColumnNames(Constants.xAxisName);
        // Check if condition more data pills can be added or not';
        if(xAxisColumns.length === allowedXAxisDataPanes){
            return false;
        }

        switch(chartTitle){
            case Constants.tableTitle:
                if(!xAxisColumns.length && (itemType && itemType.toLowerCase()) == "numerical"){
                    return false;
                }
        }
        

        const multiChart = true;
        if(multiChart){
            return true;
        }
        return false;

        
    }

    function yAxisDropEligible(itemName){
        var yAxisColumns  = getAxisColumnNames(Constants.yAxisName);
        const multiChart = true;
        // Check if condition more data pills can be added or not';
        if(yAxisColumns.length === allowedYAxisDataPanes){
            return false;
        }
        if(multiChart){
            return true;
        }
        return false;
    }

    function allNumericalValues(data){
        return true;
    }
    
    function row3AxisDropEligible(itemName, itemType){
        var row3Columns  = getAxisColumnNames(row3Columns);
        const multiChart = true;
        // Check if condition more data pills can be added or not';
        if(row3Columns.length === allowedYAxisDataPanes){
            return false;
        }
        if(chartTitle == Constants.pivotTitle && itemType != "numerical"){
            return false;
        }
        if(multiChart){
            return true;
        }
        return false;
    }

    function onDropAreaDropped(element,axis){

        row3Active = null;
        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);

        var itemType = lastPickedDataPaneElementProperties.itemType;

        element.border.width = Constants.dropEligibleBorderWidth
        element.border.color = Constants.themeColor

        var itemName = ReportParamsModel.itemName;


        if(axis === Constants.xAxisName){

            if(!xAxisDropEligible(itemName, itemType)){
                // Red color
                return;
            }
            xAxisListModel.append({itemName: itemName, droppedItemType: itemType, dateFormat: Constants.yearFormat})
            xAxisColumns.push(itemName);

        }else if(axis === Constants.yAxisName){
            if(!yAxisDropEligible(itemName)){
                // Red color
                return;
            }

            console.log('Y Axis itemType',itemType, itemName);
            yAxisListModel.append({itemName: itemName, droppedItemType: itemType, dateFormat: Constants.yearFormat})
            yAxisColumns.push(itemName);

        }else if(axis == Constants.row3Name){
            if(!row3AxisDropEligible(itemName, itemType)){
                // Red color
                return;
            }
            console.log(itemType, 'Adding it to values?');
            valuesListModel.append({itemName: itemName, droppedItemType: itemType, dateFormat: Constants.yearFormat});
        }else{
            // Gauge
            if(!row3AxisDropEligible(itemName, itemType)){
                return;
            }
            console.log(itemType, 'Adding for gauge?');
            valuesListModel.append({itemName: itemName, droppedItemType: itemType, dateFormat: Constants.yearFormat});
            
        }


        // To Make group chart: Make sure to have 2 xAxisValueColumn and 1 yAxisColumn

        if( getAxisColumnNames(Constants.xAxisName).length > 1
                && getAxisColumnNames(Constants.yAxisName).length
                && (chartTitle === Constants.barChartTitle  || chartTitle === Constants.stackedBarChartTitle)){
            console.log('Make Grouped Bar Chart');
            webEngineView.url = Constants.baseChartUrl+Constants.barGroupedChartUrl;
            chartTitle = Constants.groupBarChartTitle;
            chartUrl = Constants.barGroupedChartUrl;
            return;

        }

        if( getAxisColumnNames(Constants.yAxisName).length > 1
                && getAxisColumnNames(Constants.xAxisName).length
                && (chartTitle === Constants.horizontalBarChartTitle  || chartTitle === Constants.horizontalStackedBarChartTitle)){

            console.log('Make Horizontal Grouped Bar Chart')
            chartUrl = Constants.horizontalBarGroupedChartUrl;
            webEngineView.url = Constants.baseChartUrl+chartUrl;
            chartTitle = Constants.horizontalBarGroupedChartTitle;

            return;
        }

        reDrawChart();

    }

    function onChartLoaded(loadRequest){

        if(loadRequest.status === WebEngineLoadRequest.LoadFailedStatus){
            console.log('Page Loading Failed')
            console.log('Error',JSON.stringify(loadRequest))
            return;
        }
        reDrawChart();
    }

    function isNumber(number){
        return !!(number && number.trim() && !isNaN(number.trim().replace(/,/g,''))) 
    }

    function isGaugeChart(){
        var row3Columns = getAxisColumnNames(Constants.row3Name);
        if(row3Columns.length && isNumber(input1Field.text) && isNumber(input2Field.text) && isNumber(input3Field.text)){
            return true;
        }
        return false;
    }

    function drawChart(){

        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
        var row3Columns = getAxisColumnNames(Constants.row3Name);

        var xAxisColumnDetails = getDataPaneAllDetails(Constants.xAxisName);
        var yAxisColumnDetails = getDataPaneAllDetails(Constants.yAxisName);
        var row3ColumnDetails = getDataPaneAllDetails(Constants.row3Name);


        if(webEngineView.loading){
            return;
        }

        console.log(JSON.stringify(d3PropertyConfig));

        /*
        if(xAxisColumns.length===0 && yAxisColumns.length === 0){
            // set everything to default
            // Can add any default case here
            isHorizontalGraph = false;
        }
        */

        if((xAxisColumns.length && yAxisColumns.length) || (xAxisColumns.length && (chartTitle == Constants.tableTitle || chartTitle == Constants.kpiTitle)) || (chartTitle == Constants.gaugeChartTitle && isGaugeChart())) {

            var xAxisColumnNamesArray = Array.from(xAxisColumns);
            var yAxisColumnNamesArray = Array.from(yAxisColumns);

            console.log('Chart Title - Draw Chart Function - ',chartTitle)
            var colorByColumnName = colorByData[0] && colorByData[0].columnName;
            dataItemList.clear();
            var colorData = [];
            switch(chartTitle){
            case Constants.horizontalBarChartTitle:
                console.log("Horizontal BAR");
                ChartsModel.getBarChartValues(reportIdMain, 0, Constants.reportScreen, yAxisColumns[0],xAxisColumns[0]);

                // datavalues is a global property and set using connections
                // due to multi threading
                colorData = [JSON.parse(dataValues)[1][0]] || [];
                colorData.forEach(function (element,index) {
                    dataItemList.append({"colorValue" : Constants.d3ColorPalette[index % Constants.d3ColorPalette.length], "dataItemName" : element});
                });
                break;
            case Constants.barChartTitle:
                console.log("BAR CLICKED", xAxisColumns[0])
                ChartsModel.getBarChartValues(reportIdMain,  0, Constants.reportScreen, xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.horizontalStackedBarChartTitle:
                ChartsModel.getStackedBarChartValues(reportIdMain,  0, Constants.reportScreen, colorByColumnName,xAxisColumns[0], yAxisColumns[0]);
                break;
            case Constants.stackedBarChartTitle:
                console.log('Stacked bar chart!');
                ChartsModel.getStackedBarChartValues(reportIdMain,  0, Constants.reportScreen, colorByColumnName,yAxisColumns[0], xAxisColumns[0]);
                break;
            case Constants.horizontalBarGroupedChartTitle:
                console.log('horizontalBarGroupedChart chart!', yAxisColumns[0],xAxisColumns[0], yAxisColumns[1]);
                var [category, subcategory] =  getAxisColumnNames(Constants.yAxisName);
                if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                    d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
                }else{
                    delete d3PropertyConfig['options'];
                    colorListModel.clear();
                    colorByData = [];
                }
                ChartsModel.getNewGroupedBarChartValues(reportIdMain,  0, Constants.reportScreen, yAxisColumns[0],xAxisColumns[0], yAxisColumns[1]);
                break;
            case Constants.groupBarChartTitle:
                var [category, subcategory] =  getAxisColumnNames(Constants.xAxisName);
                if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                    d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
                }else{
                    delete d3PropertyConfig['options'];
                    colorListModel.clear();
                    colorByData = [];

                    ReportParamsModel.setItemType(null);
                    ReportParamsModel.setLastDropped(null);
                }
                console.log('Grouped bar chart!',xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);
                ChartsModel.getNewGroupedBarChartValues(reportIdMain,  0, Constants.reportScreen, xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);

                ReportParamsModel.setItemType(null);
                ReportParamsModel.setLastDropped(null);
                break;
            case Constants.areaChartTitle:
                console.log("AREA CLICKED")
                // Area - xAxis(String), yAxis(String)
                ChartsModel.getAreaChartValues(reportIdMain,  0, Constants.reportScreen, xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.horizontalAreaChartTitle:
                ChartsModel.getAreaChartValues(reportIdMain,  0, Constants.reportScreen, yAxisColumns[0],xAxisColumns[0]);
                break;
            case Constants.stackedAreaChartTitle:
            case Constants.multipleAreaChartTitle:
                console.log('Stacked Area Chart')
                console.log('Colour By columnName',colorByColumnName)
                ChartsModel.getMultiLineChartValues(reportIdMain,  0, Constants.reportScreen, xAxisColumns[0],yAxisColumns[0],colorByColumnName);
                break;
            case Constants.multipleHorizontalAreaChartTitle:
                console.log('Stacked Area Chart')
                console.log('Colour By columnName',colorByColumnName)
                ChartsModel.getMultiLineChartValues(reportIdMain,  0, Constants.reportScreen, yAxisColumns[0],xAxisColumns[0],colorByColumnName);
                break;
            case Constants.lineChartTitle:
                console.log("LINE CLICKED")
                // Line - xAxis(String), yAxis(String)
                ChartsModel.getLineChartValues(reportIdMain,  0, Constants.reportScreen, xAxisColumns[0],yAxisColumns[0],'Sum');
                // Line Bar - xAxis(String), yAxis(String)
                //                dataValues =  ChartsModel.getLineBarChartValues("state", "id", "population");
                break;
            case Constants.horizontalLineChartTitle:
                console.log(Constants.horizontalLineChartTitle,"CLICKED")
                ChartsModel.getLineChartValues(reportIdMain,  0, Constants.reportScreen, yAxisColumns[0],xAxisColumns[0],'Sum');
                break;
            case Constants.multiLineChartTitle:
                console.log(Constants.multiLineChartTitle,"CLICKED");
                ChartsModel.getMultiLineChartValues(reportIdMain,  0, Constants.reportScreen, xAxisColumns[0],yAxisColumns[0],colorByColumnName);
                break;
            case Constants.horizontalMultiLineChartTitle:
                console.log(chartTitle,"CLICKED");
                ChartsModel.getMultiLineChartValues(reportIdMain,  0, Constants.reportScreen, yAxisColumns[0],xAxisColumns[0],colorByColumnName);
                break;
            case Constants.pieChartTitle:
            case Constants.donutChartTitle:
                console.log("DONUT/PIE CLICKED")
                ChartsModel.getPieChartValues(reportIdMain,  0, Constants.reportScreen, xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.funnelChartTitle:
                console.log("FUNNEL CLICKED")
                ChartsModel.getFunnelChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.radarChartTitle:
                console.log("RADAR CLICKED")
                ChartsModel.getRadarChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.scatterChartTitle:
                console.log("SCATTER CLICKED");
                if(!colorByColumnName){
                    break;
                }
                ChartsModel.getScatterChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumns[0],yAxisColumns[0],colorByColumnName);
                break;
            case Constants.treeChartTitle:
                console.log("TREECHART CLICKED")
                ChartsModel.getTreeChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.treeMapChartTitle:
                ChartsModel.getTreeMapChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.heatMapChartTitle:
                console.log("HEATMAP CLICKED")
                if(!colorByColumnName){
                    break;
                }
                console.log(xAxisColumns[0],yAxisColumns[0], colorByColumnName);
                ChartsModel.getHeatMapChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumns[0],colorByColumnName, yAxisColumns[0]);
                break;
            case Constants.sunburstChartTitle:
                console.log("SUNBURST CLICKED");
                ChartsModel.getSunburstChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.waterfallChartTitle:
                console.log("WATERFALL CLICKED")
                ChartsModel.getWaterfallChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumns[0],yAxisColumns[0],'Sum');
                console.log('Waterfall Data values',dataValues);
                break;
            case Constants.gaugeChartTitle:
                var row3ColumnsArray = Array.from(row3Columns);
                console.log("GAUGE CLICKED")
                console.log('row3ColumnsArray',row3ColumnsArray)
                ChartsModel.getGaugeChartValues(reportIdMain, 0, Constants.reportScreen, row3ColumnsArray[0] ,'Sum');
                break;
            case Constants.sankeyChartTitle:
                console.log("SANKEY CLICKED")
                ChartsModel.getSankeyChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumns[0],  xAxisColumns[1], yAxisColumns[0] );
                break;
            case Constants.kpiTitle:
                console.log("KPI CLICKED")
                ChartsModel.getKPIChartValues(reportIdMain, 0, Constants.reportScreen,  xAxisColumns[0]);
                break;
            case Constants.tableTitle:
                console.log("TABLE CLICKED");
                var nonMeasures = xAxisColumnDetails.filter(d=>{
                    if(d.itemType.toLowerCase() != "numerical"){
                        return true;
                    }
                    return false;
                }).map(d => d.itemName)
                var measures = xAxisColumnDetails.filter(d=>{
                    if(d.itemType.toLowerCase() == "numerical"){
                        return true;
                    }
                    return false;
                }).map(d=> d.itemName)
                console.log('Non Measues',JSON.stringify(nonMeasures))
                console.log('Measures',JSON.stringify(measures))
                
                ChartsModel.getTableChartValues(reportIdMain, 0, Constants.reportScreen, nonMeasures , measures,'Sum');
                break;
            case Constants.pivotTitle:
                console.log("PIVOT CLICKED")
                console.log('row3Columns',row3Columns);
                var row3ColumnsArray = Array.from(row3Columns);
                
                // Temporary running function
                ChartsModel.getPivotChartValues(reportIdMain, 0, Constants.reportScreen, [...xAxisColumnNamesArray, ...yAxisColumnNamesArray], row3ColumnsArray,'Sum');
                
                /*

                [
                    {
                        itemName: "Order Date",
                        itemType: "Date"
                        dateFormat: "%Y",
                        qtDateFormat: "YYYY"
                    }
                    {
                        itemName: "Order Date",
                        itemType: "Categorical"
                        dateFormat: "%Y",
                        qtDateFormat: "YYYY"
                    }
                ]


                // Change required 
                // Group the dates according to date format and sum the values.
                // Values can be multiple so we will have to sum all of the values
                // Passing column name and type

                var nonValueColumnNames = [ ...xAxisColumnDetails, ...yAxisColumnDetails ];
                var valuesColumns = row3ColumnDetails;
                ChartsModel.getPivotChartValues(nonValueColumnNames, valuesColumns,'Sum');

                */
                
                break;
            }
            if(!dataValues){
                return;
            }

            /*
            After changing to signals and slots this code is not required and 
            can be removed once confirmed that everything is copied to drawChartAfterReceivingSignal function
            
            console.log('Webengine View Loading Status:',webEngineView.loading);
            console.log('Data Values:',JSON.stringify(dataValues));
            //            colorData = [];
            //            console.log("colorData5",colorData)
            //            colorData = JSON.parse(dataValues)[1] || [];
            //            console.log("colorData2" ,colorData)
            //            console.log("dataValues" ,JSON.parse(dataValues))

            //           dataItemList.clear();
            //           colorData.forEach(function (element,index) {
            //               dataItemList.append({"colorValue" : Constants.d3ColorPalette[index % Constants.d3ColorPalette.length], "dataItemName" : element});
            //               console.log("newreportcolor",Constants.d3ColorPalette[index % Constants.d3ColorPalette.length])
            //           });

            console.log('Selected Chart Title:',report_desiner_page.chartTitle)
            console.log('Selected Chart URL:',report_desiner_page.chartUrl)
            console.log("D3Config: "+JSON.stringify(d3PropertyConfig))

            //    need to initialise only once
            console.log('Starting to plot');
            // console.log('Data Values',dataValues);
            console.log('Chart Url', report_desiner_page.chartUrl, webEngineView.url)

            var scriptValue = 'window.addEventListener("resize", function () {
                    window.clearChart && clearChart();
                    drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+');
           });';

            clearChartValue();
            var runScriptString = 'drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+'); '+scriptValue;
            webEngineView.runJavaScript(runScriptString);

            // Clear Chart Data
            // ReportsDataModel.clearData();

            */

            return;

        }

        webEngineView.runJavaScript('clearChart()');
    }

    function openYAxisSettings(){
        yAxisSettingsPopup.visible = true
    }


    function updateReportTitle(title){
        reportTitleName = title
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
        Component.onCompleted: {

            loadchart.connect(report_desiner_page.changeChart)
        }

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
                border.color: "transparent"

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
                        onTextChanged: reDrawChart()
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
                        onTextChanged: reDrawChart()
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
                        onTextChanged: reDrawChart()
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
        // [Tag: Refector]
        // Move to constants
        url: "../Charts/BarChartArrayInput.html"
        onLoadingChanged: onChartLoaded(loadRequest)
        anchors.left: tool_sep_chartFilters.right
        //        anchors.leftMargin: 50
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
                    id: addReportButton
                    text:"Add"
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
                        onClicked: addReport(report_title_text.text)
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
                        width: parent.parent.width - search_icon.width - 5
                        selectByMouse: true
                        height:30
                        cursorVisible: true
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        placeholderText: "Search"
                        background: Rectangle{
                            border.width: 0
                        }
                        onTextChanged: searchColumnNames(searchText.text)
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

                RightDataColumn{
                    //            console.log(output)
                }

            }
            // Data Pane Ends

        }

    }

    // Right Panel Ends
}




