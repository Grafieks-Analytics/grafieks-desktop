import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1
import QtQuick.Dialogs 1.2
import QtWebEngine 1.10

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

// This is the Image Widget dynamically called from MainContainer
// when a column is dropped from right side customize



Item{

    id:newItem

    visible: true

    anchors{
        top: mainContainer.top
        left: mainContainer.left
        right: mainContainer.right
        bottom: mainContainer.bottom
    }
    property var hoverStatusReport: false
    property var originalPoint: Object()
    property var originalDimensions: Object()

    property var chartUrl: "qrc:/Source/Charts/build/index.html";
    property int reportId: 0;
    property var standardChart: null;
    property int dashboardId: 0
    property int reportsInCurrentDashboard: 0

    property var originalHeight: 0
    property var originalWidth: 0

    // Copied Properties from NewReport.qml
    // So that charts are displayed same as NewReport

    // Flag for horizontal graph
    // Changes when numerical value is added on X axis
    // Or Categorical Value is added on Y axis
    // On Change we update the graph title
    property bool isHorizontalGraph: false;

    property var backgroundColorValue: false;
    property var uniqueHash: "" // Important to identify unique reports with same report and dashboard id


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal editReport;


    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: DashboardParamsModel

        function onReportNameChanged(refDashboardId, refReportId, reportName){
            if(DashboardParamsModel.currentDashboard === refDashboardId && refReportId === parseInt(newItem.objectName)){
                setReportName(reportName);
            }
        }

        function onReportBackgroundColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            // let reportIdCpp = DashboardParamsModel.currentReport

            console.log(newItem.objectName, parseInt(newItem.objectName), "PARSE INT")

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName)){
                droppedReportId.color = refColor
                backgroundColorValue = refColor;
                setChartBackgroundColor(refColor);
            }
        }

        function onReportLineColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            // let reportId = DashboardParamsModel.currentReport

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName)){
                droppedReportId.border.color = refColor
                mainChart.border.color = refColor
            }

        }

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard, dashboardUniqueWidgets){

            newItem.dashboardId = dashboardId
            if(reportsInDashboard.includes(parseInt(mainContainer.objectName)) && dashboardUniqueWidgets.hasOwnProperty(uniqueHash)){
                newItem.visible = true
            } else{
                newItem.visible = false
            }

            reDrawChart();
        }

        function onReportUrlChanged(refDashboardId, refReportId, url){
            // this signal is emitted whenever setDashboard cpp function is called
            // setDashboard Report is called whenever a new report is dropped in dashboard area

            let dashboardId = DashboardParamsModel.currentDashboard
            let reportIdCpp = DashboardParamsModel.currentReport
            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName) && url !== ""){
                webEngineView.url = url;
            }
        }

        function onDashboardContentDestroyed(dashboardId){
            if(dashboardId === -1){
                newItem.destroy()
            }
        }


    }

    Connections{
        target: ReportParamsModel

        function onReportDeleted(deletedReportId){
            if(deletedReportId === newItem.reportId) {
                newItem.destroy()
                mainContainer.destroy()
                this.destroy()
                is_dashboard_blank = is_dashboard_blank - 1
            }
        }
    }


    Connections{
        target: ChartsModel

        function onSignalBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === DashboardParamsModel.currentDashboard)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalStackedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === DashboardParamsModel.currentDashboard)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalGroupedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalNewGroupedBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalAreaChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalLineChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalLineBarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalPieChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalFunnelChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalRadarChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalScatterChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalHeatMapChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalSunburstChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalWaterfallChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalGaugeChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalSankeyChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalTreeChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalTreeMapChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalKPIChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalTableChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalPivotChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalStackedAreaChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
        function onSignalMultiLineChartValues(output, reportId, dashboardId, chartSource){
            if(reportId === newItem.reportId && dashboardId === newItem.dashboardId)
                drawChartAfterReceivingSignal(output);
        }
    }
    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function drawChartAfterReceivingSignal(dataValues){
        console.log("datavaluestest",dataValues)
        if(webEngineView.loading){
            return;
        }

        const reportProperties = ReportParamsModel.getReport(reportId);
        var chartTitle = reportProperties.chartTitle;
        var d3PropertyConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        var optionalParams = JSON.parse(reportProperties.optionalConfig);

        if(standardChart){
            d3PropertyConfig.chartType = "Standard";
        }else{
            if(isHorizontalGraph){
                d3PropertyConfig.chartType = "FitHeight";
            }else{
                d3PropertyConfig.chartType = "FitWidth";
            }
        }

        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
        var row3Columns = getAxisColumnNames(Constants.row3Name);
        
        var xAxisColumnDetails = getAxisColumnDetails(Constants.xAxisName);
        var yAxisColumnDetails = getAxisColumnDetails(Constants.yAxisName);
        var row3ColumnDetails = getAxisColumnDetails(Constants.row3Name);

        var colorByData = JSON.parse(reportProperties.colorByDataColoumns);
        var colorByColumnName = colorByData[0] && colorByData[0].columnName;;

        var colorData = [];
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
            colorData = dataValues[1] || [];
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.stackedBarChartTitle:
            console.log(chartTitle,"CLICKED")
            dataValues = dataValues && JSON.parse(dataValues);
            colorData = dataValues[1] || [];
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.horizontalBarGroupedChartTitle:
            var [category, subcategory] =  getAxisColumnNames(Constants.yAxisName);
            if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
            }else{
                delete d3PropertyConfig['options'];
                colorByData = [];
            }

            break;
        case Constants.groupBarChartTitle:
            var [category, subcategory] =  getAxisColumnNames(Constants.xAxisName);
            if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
            }else{
                delete d3PropertyConfig['options'];
                colorByData = [];
                ReportParamsModel.setItemType(null);
                ReportParamsModel.setLastDropped(null);
            }

            console.log('Grouped bar chart!',xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);
            break;
        case Constants.areaChartTitle:
            colorData = (dataValues && [JSON.parse(dataValues)[1][0]]) || [];
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.stackedAreaChartTitle:
            console.log(chartTitle,"CLICKED")
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
        case Constants.multipleAreaChartTitle:
        case Constants.multiLineChartTitle:
            console.log(Constants.multiLineChartTitle,"CLICKED");
            dataValues = JSON.parse(dataValues);
            colorData = (dataValues && dataValues[1]) || [];
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.multipleHorizontalAreaChartTitle:
        case Constants.horizontalMultiLineChartTitle:
            dataValues = JSON.parse(dataValues);
            colorData = (dataValues && dataValues[1]) || [];
            break;
        case Constants.pieChartTitle:
        case Constants.donutChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.funnelChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.radarChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.scatterChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.treeChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.treeMapChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.heatMapChartTitle:
            console.log(chartTitle,"CLICKED");
            break;
        case Constants.sunburstChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.waterfallChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.gaugeChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.sankeyChartTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.kpiTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.tableTitle:
            console.log(chartTitle,"CLICKED")
            break;
        case Constants.pivotTitle:
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
        // Check if this is required?
        // if(colorData && colorData.length){
        //     colorData.forEach(function (element,index) {
        //         dataItemList.append({"colorValue" : Constants.d3ColorPalette[index % Constants.d3ColorPalette.length], "dataItemName" : element});
        //     });
        // }


        var scriptValue = 'window.addEventListener("resize", function () {
                   window.clearChart && clearChart();
                    drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+');
           });';
        scriptValue = "";
        clearChartValue();
        var runScriptString = 'grafieks.drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+'); '+scriptValue;
        webEngineView.runJavaScript(runScriptString);
        if(backgroundColorValue){
            setChartBackgroundColor(backgroundColorValue);
        }else{
            droppedReportId.color = "transparent";
        }
    }


    function destroyElement(){
        mainContainer.destroy()
        this.destroy()
        is_dashboard_blank = is_dashboard_blank - 1

        // Delete from c++
        DashboardParamsModel.deleteReport(DashboardParamsModel.currentReport, DashboardParamsModel.currentDashboard)
        DashboardParamsModel.deleteDashboardUniqueWidget(DashboardParamsModel.currentDashboard, uniqueHash)

    }

    function editSelectedReport(reportId){
        stacklayout_home.currentIndex = Constants.newReportIndex;
        ReportParamsModel.setReportId(reportId);
        ReportParamsModel.setEditReportToggle(reportId);
    }

    function toggleFullScreen(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        if(mainContainer.width === parent.parent.width-left_menubar.width && mainContainer.height === parent.parent.height-25)
        {
            mainContainer.width = newItem.originalWidth
            mainContainer.height = newItem.originalHeight

            // [Tag: Refactor]
            // Move this to constants
            fullScreenReport.source= "/Images/icons/zoom in gray.png"

            mainContainer.y = originalPoint.y
            mainContainer.x = originalPoint.x
        }
        else{
            mainContainer.width= Qt.binding(function(){
                return parent.parent.width-left_menubar.width })
            mainContainer.height= Qt.binding(function(){
                return parent.parent.height-25 })
            mainContainer.y=0
            mainContainer.x=0

            var coords = DashboardParamsModel.getDashboardWidgetCoordinates(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentReport)

            originalPoint.x = coords[0]
            originalPoint.y = coords[1]

            newItem.originalHeight = coords[3] - coords[1]
            newItem.originalWidth = coords[2] - coords[0]

            // [Tag: Refactor]
            // Move this to constants
            fullScreenReport.source= "/Images/icons/zoom out gray.png"
            DashboardParamsModel.setZIndex(++DashboardParamsModel.zIndex);
            newItem.z = DashboardParamsModel.zIndex;
            mainContainer.z = DashboardParamsModel.zIndex;

        }
    }

    function showCustomizeReport(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        customizeReport.visible = true;
    }

    function onItemPressed(){
        DashboardParamsModel.setZIndex(++DashboardParamsModel.zIndex);
        newItem.z = DashboardParamsModel.zIndex;
        mainContainer.z = DashboardParamsModel.zIndex;
        console.log(mainContainer.rulerStatus)
    }
    function showMenusReport(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        hoverStatusReport = true
        mainContainer.rulerStatus = true
        console.log("test")
    }
    function hideMenusReport(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        hoverStatusReport = false
        mainContainer.rulerStatus = false
    }

//    function onDropAreaPositionChangedReport(){
//        currnetPointReport.x= mainContainer.x;
//        currnetPointReport.y= mainContainer.y;
//    }

    function onChartLoaded(loadRequest){

        console.log("XE Log", loadRequest)
        if(loadRequest.status === WebEngineLoadRequest.LoadFailedStatus){
            console.log('Page Loading Failed')
            console.log('Error',JSON.stringify(loadRequest))
            return;
        }
        reDrawChart();
    }

    function getChartUrl(){
        return webEngineView.url;
    }

    function setChartUrl(chartUrl){
        // webEngineView.url = Constants.chartsBaseUrl;
    }

    function setChartBackgroundColor(background){
        webEngineView.runJavaScript('window.setSvgBackground && setSvgBackground("'+background+'")');
    }

    // Clear the chart defaults
    function clearChartValue(){
        webEngineView.runJavaScript('window.grafieks.clearChart()');
    }

    function setReportName(reportTitle){
        reportName.text = reportTitle;
    }

    function reDrawChart(){
        const reportProperties = ReportParamsModel.getReport(reportId);
        setReportName(DashboardParamsModel.getReportName(DashboardParamsModel.currentDashboard, reportId));
        drawChart(reportProperties);
    }

    function isGaugeChart(){
        const reportProperties = ReportParamsModel.getReport(reportId);
        const optionalConfig = JSON.parse(reportProperties.optionalConfig);
        const gaugeChartOptions = optionalConfig[Constants.gaugeChartTitle];
        console.log('Gauge options', JSON.stringify(gaugeChartOptions));
        var { greenValue, redValue, yellowValue } = gaugeChartOptions;
        var row3Columns = getAxisColumnNames(Constants.row3Name);
        console.log(row3Columns.length);
        if(row3Columns.length && yellowValue && redValue && greenValue){
            return true;
        }
        return false;
    }


    // function to get the columnName from model
    // Difference between NewReport.qml and DroopedReport:
    // 1. Columns are in modal | Columns are in Array
    // 2. Since list model uses count and get function, Modified them here as per Array Change

    function getAxisColumnNames(axisName){
        var model = null;
        const reportProperties = ReportParamsModel.getReport(reportId);
        switch(axisName){
        case Constants.xAxisName:
            var xAxisListModel = JSON.parse(reportProperties.d3PropertiesConfig).dataColumns.xAxisColumnDetails;
            model = xAxisListModel;
            break
        case Constants.yAxisName:
            var yAxisListModel = JSON.parse(reportProperties.d3PropertiesConfig).dataColumns.yAxisColumnDetails;
            model = yAxisListModel;
            break;
        case Constants.row3Name:
            model = JSON.parse(reportProperties.d3PropertiesConfig).dataColumns.row3ColumnDetails;
            break;
        }
        if(!model){
            return [];
        }
        var columnsName = [];
        for(var i=0; i< model.length; i++){
            columnsName.push(model[i].tableValue);
        }
        return columnsName;
    }


    function getAxisColumnDetails(axisName){
        var model = null;
        const reportProperties = ReportParamsModel.getReport(reportId);
        switch(axisName){
        case Constants.xAxisName:
            var xAxisListModel = JSON.parse(reportProperties.xAxisColumns);
            model = xAxisListModel;
            break
        case Constants.yAxisName:
            var yAxisListModel = JSON.parse(reportProperties.yAxisColumns);
            model = yAxisListModel;
            break;
        case Constants.row3Name:
            model = JSON.parse(reportProperties.row3Columns || "[]");
            break;
        }
        if(!model){
            return [];
        }
        return model;
    }

    
    function isPivotChart(){
        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
        var row3Columns = getAxisColumnNames(Constants.row3Name);
        if((xAxisColumns.length > 0 || yAxisColumns.length > 0)  || (xAxisColumns.length > 0 && row3Columns.length > 0) || (yAxisColumns.length > 0 && row3Columns.length > 0)){
            console.log('Pivot is eliigble')
            return true;
        }
        return false;
    }
    
    // This function is copied from NewReport.qml
    // Make sure to make the changes properly
    // Add a comment whenever a different change is made

    function drawChart(reportProperties){

        // Check if chart is still loading or not.
        if(webEngineView.loading){
            console.log('Chart is still loading... Please wait')
            return;
        }

        var chartTitle = reportProperties.chartTitle;
        var chartId = reportProperties.reportId;
        var chartUrl = reportProperties.chartUrl;
        var d3PropertyConfig = JSON.parse(reportProperties.d3PropertiesConfig);

        if(standardChart){
            d3PropertyConfig.chartType = "Standard";
        }else{
            if(isHorizontalGraph){
                d3PropertyConfig.chartType = "FitHeight";
            }else{
                d3PropertyConfig.chartType = "FitWidth";
            }
        }

        var colorByData = JSON.parse(reportProperties.colorByDataColoumns);
        console.log('Colour By Data',JSON.stringify(colorByData));

        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);
        var row3Columns = getAxisColumnNames(Constants.row3Name);

        var xAxisColumnDetails = getAxisColumnDetails(Constants.xAxisName);
        var yAxisColumnDetails = getAxisColumnDetails(Constants.yAxisName);
        var row3ColumnDetails = getAxisColumnDetails(Constants.row3Name);

        console.log("Okay, Now it's time to draw the chart")

        console.log('Draw Chart X Column names',JSON.stringify(xAxisColumns));
        console.log('Draw Chart Y Column names',yAxisColumns);
        console.log('Chart Title', chartTitle);
        console.log('Chart Url', chartUrl);
        console.log('d3PropertiesConfig', JSON.stringify(d3PropertyConfig))


        if(xAxisColumns.length===0 && yAxisColumns.length === 0){
            // set everything to default
            // Can add any default case here
            isHorizontalGraph = false;
        }



        if(
            (xAxisColumns.length && yAxisColumns.length) || 
            (xAxisColumns.length && (chartTitle == Constants.tableTitle || chartTitle == Constants.kpiTitle)) || 
            (chartTitle == Constants.gaugeChartTitle && isGaugeChart()) ||
            (chartTitle == Constants.pivotTitle && isPivotChart())
        ) {

            var xAxisColumnNamesArray = Array.from(xAxisColumns);
            var yAxisColumnNamesArray = Array.from(yAxisColumns);

            var dataValues = null;
            console.log('Chart Title - Draw Chart Function - ',chartTitle)
            var colorByColumnName = colorByData[0] && colorByData[0].columnName;

            var colorData = [];
            switch(chartTitle){
            case Constants.horizontalBarChartTitle:
                console.log("Horizontal BAR");
                ChartsModel.getBarChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, yAxisColumns[0],xAxisColumns[0]);

                // datavalues is a global property and set using connections
                // due to multi threading
                colorData = [JSON.parse(dataValues)[1][0]] || [];
                break;
            case Constants.barChartTitle:
                console.log("BAR CLICKED", xAxisColumns[0])
                ChartsModel.getBarChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0]);

                break;
            case Constants.horizontalStackedBarChartTitle:
                ChartsModel.getStackedBarChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, colorByColumnName,xAxisColumns[0], yAxisColumns[0]);
                break;
            case Constants.stackedBarChartTitle:
                console.log('Stacked bar chart!');
                ChartsModel.getStackedBarChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, colorByColumnName,yAxisColumns[0], xAxisColumns[0]);
                break;
            case Constants.horizontalBarGroupedChartTitle:
                console.log('horizontalBarGroupedChart chart!', yAxisColumns[0],xAxisColumns[0], yAxisColumns[1]);
                var [category, subcategory] =  getAxisColumnNames(Constants.yAxisName);
                if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                    d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
                }else{
                    delete d3PropertyConfig['options'];
                    // colorListModel.clear();
                    colorByData = [];
                }
                ChartsModel.getNewGroupedBarChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, yAxisColumns[0],xAxisColumns[0], yAxisColumns[1]);
                break;
            case Constants.groupBarChartTitle:
                var [category, subcategory] =  getAxisColumnNames(Constants.xAxisName);
                if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                    d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
                }else{
                    delete d3PropertyConfig['options'];
                    // colorListModel.clear();
                    colorByData = [];

                    ReportParamsModel.setItemType(null);
                    ReportParamsModel.setLastDropped(null);
                }
                console.log('Grouped bar chart!',xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);
                ChartsModel.getNewGroupedBarChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);

                ReportParamsModel.setItemType(null);
                ReportParamsModel.setLastDropped(null);
                break;
            case Constants.areaChartTitle:
                console.log("AREA CLICKED")
                // Area - xAxis(String), yAxis(String)
                ChartsModel.getAreaChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.stackedAreaChartTitle:
            case Constants.multipleAreaChartTitle:
                console.log('Stacked Area Chart')
                console.log('Colour By columnName',colorByColumnName)
                ChartsModel.getMultiLineChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0],colorByColumnName);
                break;
            case Constants.lineChartTitle:
                console.log("LINE CLICKED")
                // Line - xAxis(String), yAxis(String)
                ChartsModel.getLineChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0],'Sum');
                // Line Bar - xAxis(String), yAxis(String)
                //                dataValues =  ChartsModel.getLineBarChartValues("state", "id", "population");
                break;
            case Constants.horizontalAreaChartTitle:
            case Constants.horizontalLineChartTitle:
                console.log(Constants.horizontalLineChartTitle,"CLICKED")
                ChartsModel.getLineChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, yAxisColumns[0],xAxisColumns[0],'Sum');
                break;
            case Constants.multiLineChartTitle:
                console.log(Constants.multiLineChartTitle,"CLICKED");
                ChartsModel.getMultiLineChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0],colorByColumnName);
                break;
            case Constants.multipleHorizontalAreaChartTitle:
            case Constants.horizontalMultiLineChartTitle:
                console.log(chartTitle,"CLICKED");
                ChartsModel.getMultiLineChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, yAxisColumns[0], xAxisColumns[0],colorByColumnName);
                break;
            case Constants.pieChartTitle:
            case Constants.donutChartTitle:
                console.log("DONUT/PIE CLICKED")
                ChartsModel.getPieChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.funnelChartTitle:
                console.log("FUNNEL CLICKED")
                ChartsModel.getFunnelChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.radarChartTitle:
                console.log("RADAR CLICKED")
                ChartsModel.getRadarChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.scatterChartTitle:
                console.log("SCATTER CLICKED");
                if(!colorByColumnName){
                    ChartsModel.getScatterChartNumericalValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen,  xAxisColumns[0], yAxisColumns[0]);
                    break;
                }
                ChartsModel.getScatterChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0], yAxisColumns[0], colorByColumnName);
                break;
            case Constants.treeChartTitle:
                console.log("TREECHART CLICKED")
                ChartsModel.getTreeChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.treeMapChartTitle:
                ChartsModel.getTreeMapChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.heatMapChartTitle:
                console.log("HEATMAP CLICKED")
                ChartsModel.getHeatMapChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0], colorByColumnName, yAxisColumns[0]);
                break;
            case Constants.sunburstChartTitle:
                console.log("SUNBURST CLICKED");
                ChartsModel.getSunburstChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.waterfallChartTitle:
                console.log("WATERFALL CLICKED")
                ChartsModel.getWaterfallChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],yAxisColumns[0],'Sum');
                console.log('Waterfall Data values',dataValues);
                break;
            case Constants.gaugeChartTitle:
                console.log("GAUGE CLICKED")
                var row3ColumnsArray = Array.from(row3Columns);
                const optionalConfig = JSON.parse(reportProperties.optionalConfig);
                const gaugeChartOptions = optionalConfig[Constants.gaugeChartTitle];
                var { greenValue, redValue, yellowValue } = gaugeChartOptions;
                
                ChartsModel.getGaugeChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, row3ColumnsArray[0] , greenValue, yellowValue, redValue);
                break;
            case Constants.sankeyChartTitle:
                console.log("SANKEY CLICKED")
                ChartsModel.getSankeyChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0],  xAxisColumns[1], yAxisColumns[0] );
                break;
            case Constants.kpiTitle:
                console.log("KPI CLICKED")
                ChartsModel.getKPIChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, xAxisColumns[0]);
                break;
            case Constants.tableTitle:
                console.log("TABLE CLICKED");
                var nonMeasures = xAxisColumnDetails.filter(d=>{
                    if((d.itemType || d.droppedItemType).toLowerCase() != "numerical"){
                        return true;
                    }
                    return false;
                }).map(d => d.itemName)
                var measures = xAxisColumnDetails.filter(d=>{
                    if((d.itemType || d.droppedItemType).toLowerCase() == "numerical"){
                        return true;
                    }
                    return false;
                }).map(d=> d.itemName)
                console.log('Non Measues',JSON.stringify(nonMeasures))
                console.log('Measures',JSON.stringify(measures))
                
                var dateConversionOptions = xAxisColumnDetails.filter(d=>{
                    if((d.itemType || d.droppedItemType).toLowerCase() == "date"){
                        return true;
                    }
                    return false;
                }).map(d => {
                    var format = d.dateFormat;
                    switch(format){
                        case "%Y":
                            format = "Year";
                            break; 
                        case "%d":
                            format = "Day";
                            break; 
                        case "%b":
                            format = "month";
                            break; 
                        case "%d %b %Y":
                            format = "day,month,year";
                            break; 
                        case "%b %Y":
                            format = "month,year";
                            break; 
                        default:
                            format = "Year";
                            break;
                    }
                    return { itemName: d.itemName, itemType: d.itemType, dateFormat: format, separator: " "  }
                })
                console.log('Date Values',JSON.stringify(dateConversionOptions));
                
                dateConversionOptions = JSON.stringify(dateConversionOptions);
                
                console.log(measures, "MEASURES")
                ChartsModel.getTableChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, nonMeasures , measures, dateConversionOptions);
                break;
            case Constants.pivotTitle:
                console.log("PIVOT CLICKED")
                 var row3ColumnsArray = Array.from(row3Columns);
                  
                var tempDataValues = [...xAxisColumnDetails, ...yAxisColumnDetails];
                var dateConversionOptions = tempDataValues.filter(d=>{
                    if((d.itemType || d.droppedItemType).toLowerCase() == "date"){
                        return true;
                    }
                    return false;
                }).map(d => {
                    var format = d.dateFormat;
                    switch(format){
                        case "%Y":
                            format = "Year";
                            break; 
                        case "%d":
                            format = "Day";
                            break; 
                        case "%b":
                            format = "month";
                            break; 
                        case "%d %b %Y":
                            format = "day,month,year";
                            break; 
                        case "%b %Y":
                            format = "month,year";
                            break; 
                        default:
                            format = "Year";
                            break;
                    }
                    return { itemName: d.itemName, itemType: d.itemType, dateFormat: format, separator: " "  }
                })
                
                dateConversionOptions = JSON.stringify(dateConversionOptions);
                ChartsModel.getPivotChartValues(chartId, DashboardParamsModel.currentDashboard, Constants.dashboardScreen, [...xAxisColumnNamesArray, ...yAxisColumnNamesArray], row3ColumnsArray,dateConversionOptions, [xAxisColumnNamesArray, yAxisColumnNamesArray, row3ColumnsArray]);
                break;
            }
            if(!dataValues){
                return;
            }
            return;
        }

        webEngineView.runJavaScript('window.clearChart && clearChart()');
    }

    // Convert the graph to Standard
    function convertToStandard(){
        standardChart = true;
        reDrawChart();
    }

    // Convert the graph to FitWidth / FitHeight
    function convertToFit(){
        standardChart = false;
        reDrawChart()
    }

    function updateChart(){
        reDrawChart();
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle {

        id: droppedReportId
        color: "white"
        border.width: 1
        border.color: Constants.darkThemeColor

        width: parent.width
        height: parent.height

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        MouseArea{
            height: parent.height-4
            width: parent.width-4
            anchors.centerIn: parent
            hoverEnabled: true
            onEntered: showMenusReport()
            onExited: hideMenusReport()
            drag{
                target: mainContainer
                minimumX: 0
                minimumY: 0
                maximumY: dashboard_summary.height- mainContainer.height
                maximumX: dashboard_summary.width- mainContainer.width
            }
            onPositionChanged: DashboardParamsModel.setDashboardWidgetCoordinates(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentReport, newItem.x, newItem.y, newItem.x + mainContainer.width, newItem.y + mainContainer.height)
            onClicked:  showCustomizeReport()
            onPressed:  onItemPressed()
        }

        Rectangle{

            id: mainChart
            color: "transparent"
            anchors.top: parent.top
            height: 40
            width: parent.width
            border.color: Constants.darkThemeColor
            border.width: 1

            Text {
                id: reportName
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle{
                id: chartMenu
                anchors.right: parent.right
                anchors.rightMargin: 60
                anchors.top: parent.top
                height: parent.height


                Row{
                    id:menuOptions

                    height: mainChart.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    visible: hoverStatusReport
                    anchors.left: parent.left
                    anchors.fill: parent


                    spacing: 10

                    Image{
                        id: editReport
                        height: 18
                        width: 18
                        source: "/Images/icons/edit gray.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked: editOptions.open()
                        }
                    }

                    // Image{
                    //     id: resizeReport
                    //     height: 16
                    //     width: 16
                    //     source: "/Images/icons/view gray.png"
                    //     anchors.verticalCenter: parent.verticalCenter

                    //     MouseArea{
                    //         anchors.fill: parent
                    //         onClicked: resizeOptions.open()
                    //     }
                    // }

                    Image {
                        id: fullScreenReport
                        height: 16
                        width: 16
                        source: "/Images/icons/zoom in gray.png"
                        //                        source: "/Images/icons/minimise.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent

                            onClicked: {
                                toggleFullScreen()
                            }

                        }
                    }

                }

                Row{

                    anchors.right: parent.right
                    anchors.top: chartMenu.bottom
                    anchors.rightMargin: 0
                    width: parent.width
                    height: 100

                    Item {
                        id: name
                        anchors.left:menuOptions.left

                        x: -editOptions.width

                        Menu{
                            id: editOptions
                            background: Rectangle{
                                implicitWidth: 200
                                border.color: Constants.darkThemeColor
                            }

                            MenuItem {
                                text: Messages.da_sub_dc_edit
                                onTriggered: editSelectedReport(newItem.reportId)
                            }

                            MenuItem {
                                text: Messages.da_sub_dc_delete
                                onTriggered: destroyElement()
                            }
                        }
                        // Menu{
                        //     id: resizeOptions
                        //     background: Rectangle{
                        //         implicitWidth: 200
                        //         border.color: Constants.darkThemeColor
                        //     }

                        //     MenuItem {
                        //         text: qsTr("Standard")
                        //         onTriggered: convertToStandard()
                        //     }

                        //     MenuItem {
                        //         text: qsTr("FitWidth")
                        //         onTriggered: convertToFit()
                        //     }
                        //     MenuItem {
                        //         text: qsTr("FitHeight")
                        //         onTriggered: convertToFit()
                        //     }
                        // }
                    }
                }
            }


        }
        WebEngineView{
            id: webEngineView
            anchors.top : mainChart.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            url: Constants.chartsBaseUrl
            onLoadingChanged: onChartLoaded(loadRequest)
            width:newItem.width - 10
            height:newItem.height  - mainChart.height - 20
        }

    }

}
