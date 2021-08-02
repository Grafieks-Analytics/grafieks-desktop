import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1
import QtQuick.Dialogs 1.2
import QtWebEngine 1.10

import com.grafieks.singleton.constants 1.0

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

    property var chartUrl: "qrc:/Source/Charts/BarChartArrayInput.html";
    property var reportId: "";
    property var standardChart: null;

    // Copied Properties from NewReport.qml
    // So that charts are displayed same as NewReport

    // Flag for horizontal graph
    // Changes when numerical value is added on X axis
    // Or Categorical Value is added on Y axis
    // On Change we update the graph title
    property bool isHorizontalGraph: false;
    

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

        function onReportBackgroundColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            // let reportIdCpp = DashboardParamsModel.currentReport

            console.log(newItem.objectName, parseInt(newItem.objectName), "PARSE INT")

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName)){
                droppedReportId.color = refColor
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

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard){

            if(reportsInDashboard.includes(parseInt(mainContainer.objectName))){
                newItem.visible = true
            } else{
                newItem.visible = false
            }
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
        target: ChartsModel

        function onSignalBarChartValues(output){
            drawChartAfterReceivingSignal(output);
        }

        function onSignalStackedBarChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalGroupedBarChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalNewGroupedBarChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalAreaChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalLineChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalLineBarChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalPieChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalFunnelChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalRadarChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalScatterChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalHeatMapChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalSunburstChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalWaterfallChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalGaugeChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalSankeyChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalTreeChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalTreeMapChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalKPIChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalTableChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalPivotChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalStackedAreaChartValues(output){
            drawChartAfterReceivingSignal(output);
        }
        function onSignalMultiLineChartValues(output){
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

        const reportProperties = ReportParamsModel.getReport(reportId);
        var chartTitle = reportProperties.chartTitle;
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
        
        var xAxisColumns = getAxisColumnNames(Constants.xAxisName);
        var yAxisColumns = getAxisColumnNames(Constants.yAxisName);

        console.log(xAxisColumns, yAxisColumns)
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
            // colorData = (dataValues && JSON.parse(dataValues)[1]) || [];
            dataValues = dataValues && JSON.parse(dataValues);
            dataValues[2] = [yAxisColumns[0],colorByColumnName,xAxisColumns[0]];
            colorData = dataValues[1] || [];
            dataValues = JSON.stringify(dataValues);
            break;
        case Constants.stackedBarChartTitle:
            console.log(chartTitle,"CLICKED")
            dataValues = dataValues && JSON.parse(dataValues);
            dataValues[2] = [xAxisColumns[0],colorByColumnName,yAxisColumns[0]];
            colorData = dataValues[1] || [];
            dataValues = JSON.stringify(dataValues);
            // colorData = (dataValues && JSON.parse(dataValues)[1]) || [];
            break;
        case Constants.horizontalBarGroupedChartTitle:
            var [category, subcategory] =  getAxisColumnNames(Constants.yAxisName);
            if(colorByColumnName && (colorByColumnName == category || colorByColumnName==subcategory) ){
                d3PropertyConfig['options'] = { groupBarChartColorBy: colorByColumnName == subcategory ? 'subcategory' : 'category'  }
            }else{
                delete d3PropertyConfig['options'];
                colorByData = [];
            }
            dataValues = JSON.parse(dataValues);
            dataValues.push([xAxisColumns[0],xAxisColumns[1],yAxisColumns[0]]);
            // console.log(dataValues);

            dataValues = JSON.stringify(dataValues);
            
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
            
            dataValues = JSON.parse(dataValues);
            dataValues.push([xAxisColumns[0],xAxisColumns[1],yAxisColumns[0]]);
            // console.log(dataValues);

            dataValues = JSON.stringify(dataValues);

            console.log('Grouped bar chart!',xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);
            break;
        case Constants.areaChartTitle:
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
        case Constants.multiLineChartTitle:
            console.log(Constants.multiLineChartTitle,"CLICKED");
            colorData = (dataValues && JSON.parse(dataValues)[1]) || [];
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
            console.log(chartTitle,"CLICKED")
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

        clearChartValue();
        var runScriptString = 'drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+'); '+scriptValue;
        webEngineView.runJavaScript(runScriptString);
    }

    Component.onCompleted: {        
    }

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()
        is_dashboard_blank = is_dashboard_blank - 1

        // Delete from c++
    }

    function editSelectedReport(reportId){
        stacklayout_home.currentIndex = Constants.newReportIndex;
        ReportParamsModel.setReportId(reportId);
        ChartsThread.setChartSource("report", ReportParamsModel.reportId)
        ReportParamsModel.setEditReportToggle(reportId);
    }

    function toggleFullScreen(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        if(mainContainer.width === parent.width-left_menubar.width && mainContainer.height === parent.height-5)
        {
            mainContainer.width = Constants.defaultDroppedReportWidth
            mainContainer.height = Constants.defaultDroppedReportHeight
            
            // [Tag: Refactor]
            // Move this to constants
            fullScreenReport.source= "/Images/icons/zoom in gray.png"

            mainContainer.y = originalPoint.y
            mainContainer.x = originalPoint.x


        }
        else{
            mainContainer.width= Qt.binding(function(){
                return parent.width-left_menubar.width })
            mainContainer.height= Qt.binding(function(){
                return parent.height-5 })
            mainContainer.y=0
            mainContainer.x=0

            originalPoint.x = currnetPointReport.x
            originalPoint.y = currnetPointReport.y

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

    function onDropAreaPositionChangedReport(){
        currnetPointReport.x=mainContainer.x;
        currnetPointReport.y=mainContainer.y;
    }

    function onChartLoaded(loadRequest){

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
        webEngineView.url = Constants.chartsBaseUrl+chartUrl;
    }

    function setChartBackgroundColor(background){
        webEngineView.runJavaScript('setSvgBackground("'+background+'")');
    }

    // Clear the chart defaults
    function clearChartValue(){
        webEngineView.runJavaScript('window.clearChart && clearChart()');
    }

    function reDrawChart(){
        const reportProperties = ReportParamsModel.getReport(reportId);
        reportName.text = reportProperties.reportTitle;
        drawChart(reportProperties);
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
            var xAxisListModel = JSON.parse(reportProperties.xAxisColumns);        
            model = xAxisListModel;
            break
        case Constants.yAxisName:
            var yAxisListModel = JSON.parse(reportProperties.yAxisColumns);
            model = yAxisListModel;
            break;
        }
        if(!model){
            return [];
        }
        var columnsName = [];
        for(var i=0; i< model.length; i++){
            columnsName.push(model[i].itemName);
        }
        return columnsName;
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

        console.log("Okay, Now it's time to draw the chart")

        console.log('Draw Chart X Column names',xAxisColumns);
        console.log('Draw Chart Y Column names',yAxisColumns);
        console.log('Chart Title', chartTitle);
        console.log('Chart Url', chartUrl);
        console.log('d3PropertiesConfig', JSON.stringify(d3PropertyConfig))

        if(xAxisColumns.length===0 && yAxisColumns.length === 0){
            // set everything to default
            // Can add any default case here
            isHorizontalGraph = false;
        }

        if(xAxisColumns.length && yAxisColumns.length){

            var xAxisColumnNamesArray = [];
            var i = 0; // itereator => By passing warning
            for(i=0;i<xAxisColumns.length;i++){
                xAxisColumnNamesArray.push(yAxisColumns[i]);
            }
            var yAxisColumnNamesArray = [];
            for(i=0;i<yAxisColumns.length;i++){
                yAxisColumnNamesArray.push(yAxisColumns[i]);
            }

            var dataValues = null;
            console.log('Chart Title - Draw Chart Function - ',chartTitle)
            var colorByColumnName = colorByData[0] && colorByData[0].columnName;

            var colorData = [];
            switch(chartTitle){
            case Constants.horizontalBarChartTitle:
                console.log("Horizontal BAR");
                ChartsModel.getBarChartValues(yAxisColumns[0],xAxisColumns[0]);

                // datavalues is a global property and set using connections
                // due to multi threading
                colorData = [JSON.parse(dataValues)[1][0]] || [];
                break;
            case Constants.barChartTitle:
                console.log("BAR CLICKED", xAxisColumns[0])
                ChartsModel.getBarChartValues(xAxisColumns[0],yAxisColumns[0]);

                break;
            case Constants.horizontalStackedBarChartTitle:
                ChartsModel.getStackedBarChartValues(colorByColumnName,xAxisColumns[0], yAxisColumns[0]);
                break;
            case Constants.stackedBarChartTitle:
                console.log('Stacked bar chart!');
                ChartsModel.getStackedBarChartValues(colorByColumnName,yAxisColumns[0], xAxisColumns[0]);
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
                ChartsModel.getNewGroupedBarChartValues(yAxisColumns[0],xAxisColumns[0], yAxisColumns[1]);
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
                ChartsModel.getNewGroupedBarChartValues(xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);

                ReportParamsModel.setItemType(null);
                ReportParamsModel.setLastDropped(null);
                break;
            case Constants.areaChartTitle:
                console.log("AREA CLICKED")
                // Area - xAxis(String), yAxis(String)
                ChartsModel.getAreaChartValues(xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.stackedAreaChartTitle:
                console.log('Stacked Area Chart')
                console.log('Colour By columnName',columnName)
                ChartsModel.getStackedAreaChartValues(colorByColumnName,yAxisColumns[0],xAxisColumns[0]);
                break;
            case Constants.lineChartTitle:
                console.log("LINE CLICKED")
                // Line - xAxis(String), yAxis(String)
                ChartsModel.getLineChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                // Line Bar - xAxis(String), yAxis(String)
                //                dataValues =  ChartsModel.getLineBarChartValues("state", "id", "population");
                break;
            case Constants.horizontalLineChartTitle:
                console.log(Constants.horizontalLineChartTitle,"CLICKED")
                ChartsModel.getLineChartValues(yAxisColumns[0],xAxisColumns[0],'Sum');
                break;
            case Constants.multiLineChartTitle:
                console.log(Constants.multiLineChartTitle,"CLICKED");
                ChartsModel.getMultiLineChartValues(xAxisColumns[0],yAxisColumns[0],colorByColumnName);
                break;
            case Constants.horizontalMultiLineChartTitle:
                console.log(chartTitle,"CLICKED");
                ChartsModel.getMultiLineChartValues(colorByColumnName,xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.pieChartTitle:
            case Constants.donutChartTitle:
                console.log("DONUT/PIE CLICKED")
                ChartsModel.getPieChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.funnelChartTitle:
                console.log("FUNNEL CLICKED")
                ChartsModel.getFunnelChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.radarChartTitle:
                console.log("RADAR CLICKED")
                ChartsModel.getRadarChartValues(xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.scatterChartTitle:
                console.log("SCATTER CLICKED")
                ChartsModel.getScatterChartValues(xAxisColumns[0],yAxisColumns[0],yAxisColumns[1]);
                break;
            case Constants.treeChartTitle:
                console.log("TREECHART CLICKED")
                ChartsModel.getTreeChartValues(xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.treeMapChartTitle:
                ChartsModel.getTreeMapChartValues(xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.heatMapChartTitle:
                console.log("HEATMAP CLICKED")
                ChartsModel.getHeatMapChartValues(xAxisColumns[0],yAxisColumns[0], ReportParamsModel.itemName);
                break;
            case Constants.sunburstChartTitle:
                console.log("SUNBURST CLICKED");
                ChartsModel.getSunburstChartValues(xAxisColumnNamesArray,yAxisColumns[0],'Sum');
                break;
            case Constants.waterfallChartTitle:
                console.log("WATERFALL CLICKED")
                ChartsModel.getWaterfallChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                console.log('Waterfall Data values',dataValues);
                break;
            case Constants.gaugeChartTitle:
                console.log("GAUGE CLICKED")
                ChartsModel.getGaugeChartValues(xAxisColumns[0],yAxisColumns[0],'Sum');
                break;
            case Constants.sankeyChartTitle:
                console.log("SANKEY CLICKED")
                ChartsModel.getSankeyChartValues(xAxisColumns[0],  xAxisColumns[1], yAxisColumns[0] );
                break;
            case Constants.kpiTitle:
                console.log("KPI CLICKED")
                ChartsModel.getKPIChartValues(xAxisColumns[0]);
                break;
            case Constants.tableTitle:
                console.log("TABLE CLICKED")
                ChartsModel.getTableChartValues(["state", "city", "district"], ["population", "id"],'Sum');
                break;
            case Constants.pivotTitle:
                console.log("PIVOT CLICKED")
                //                dataValues = ChartsModel.getPivotChartValues(["state", "district"],xAxisColumns[0],'Sum');
                ChartsModel.getTableChartValues(["state", "district"], "population",'Sum');
                break;
            }
            if(!dataValues){
                return;
            }

        //     console.log('Webengine View Loading Status:',webEngineView.loading);
        //     console.log('Data Values:',JSON.stringify(dataValues));
        //     var colorData = [];
        //     console.log("colorData5",colorData)
        //     colorData = JSON.parse(dataValues)[1] || [];

        //     console.log("colorData2" ,colorData)
        //     console.log("dataValues" ,JSON.parse(dataValues))

        //     console.log('Selected Chart Title:',chartTitle)
        //     console.log("D3Config: "+JSON.stringify(d3PropertyConfig))
        //     console.log('Starting to plot');

        //    var scriptValue = 'window.addEventListener("resize", function () {
        //              window.clearChart && clearChart();
        //             drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+');
        //    });';

        //    clearChartValue();
        //    webEngineView.runJavaScript('drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+'); '+scriptValue);

           // Clear Chart Data
            // ReportsDataModel.clearData();
           return;
        }

        webEngineView.runJavaScript('clearChart()');
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
            //            onEntered: {
            //                mainContainer.rulerStatus=true

            //            }
            //            onExited: {
            //                mainContainer.rulerStatus=false
            //            }
            drag{
                target: mainContainer

                //                maximumX: (mainContainer.parent.width)
                //                maximumY: mainContainer.parent.height - mainContainer.height - Constants.subMenuWidth
                //                maximumY: mainContainer.parent.height - mainContainer.height - Constants.subMenuWidth

                //                 maximumY: Qt.binding(function(){ return (dashboard_summary.height - mainContainer.height + Constants.subMenuWidth) })
                //                 maximumX: Qt.binding(function(){ return (dashboard_summary.width - mainContainer.width + Constants.leftMenubarWidth) })

                //                maximumY: dashboard_summary.height - mainContainer.height + Constants.subMenuWidth
                //                maximumX: dashboard_summary.width - mainContainer.width + Constants.leftMenubarWidth
                minimumX: 0
                minimumY: 0
                maximumY: dashboard_summary.height- mainContainer.height
                maximumX: dashboard_summary.width- mainContainer.width



            }
            //            Drag.hotSpot.x: 2
            //            Drag.hotSpot.y: 2
            onClicked:  showCustomizeReport()
            onPressed:  onItemPressed()
            onPositionChanged:  onDropAreaPositionChangedReport()
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
                anchors.rightMargin: 80
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

                    Image{
                        id: resizeReport
                        height: 16
                        width: 16
                        source: "/Images/icons/view gray.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked: resizeOptions.open()
                        }
                    }

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
                    anchors.rightMargin: -70
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
                                text: qsTr("Edit")
                                onTriggered: editSelectedReport(newItem.reportId)
                            }

                            MenuItem {
                                text: qsTr("Delete")
                                onTriggered: destroyElement()
                            }
                        }
                        Menu{
                            id: resizeOptions
                            background: Rectangle{
                                implicitWidth: 200
                                border.color: Constants.darkThemeColor
                            }

                            MenuItem {
                                text: qsTr("Standard")
                                onTriggered: convertToStandard()
                            }

                            MenuItem {
                                text: qsTr("FitWidth")
                                onTriggered: convertToFit()
                            }
                            MenuItem {
                                text: qsTr("FitHeight")
                                onTriggered: convertToFit()
                            }
                        }

                    }


                }



            }


        }
        WebEngineView{
            id: webEngineView
            anchors.top : mainChart.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            onLoadingChanged: onChartLoaded(loadRequest)
            width:newItem.width - 10
            height:newItem.height  - mainChart.height - 20

            //                    onLoadingChanged: {

            //                        switch(loadRequest.status){

            //                        case ( WebView.LoadFailedStatus):
            //                            webEngineView.visible = false
            //                            chooseImage.visible = true
            //                            break

            //                        case ( WebView.LoadSucceededStatus):
            //                            webEngineView.visible = true
            //                            chooseImage.visible = false
            //                            break
            //                        }

            //                    }

        }

    }

}
