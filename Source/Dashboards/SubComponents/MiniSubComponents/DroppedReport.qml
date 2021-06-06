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

    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: DashboardParamsModel

        function onReportBackgroundColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            // let reportIdCpp = DashboardParamsModel.currentReport

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName)){
                droppedReportId.color = refColor
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

    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {        
    }

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()
        is_dashboard_blank = is_dashboard_blank - 1

        // Delete from c++
    }

    function editSelectedReport(){
        stacklayout_home.currentIndex = 7
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

    // Clear the chart defaults
    function clearChartValue(){
        webEngineView.runJavaScript('clearChart()');
    }

    function reDrawChart(){
        const reportProperties = ReportParamsModel.getReport(reportId);
        drawChart(reportProperties);
    }

    function drawChart(reportProperties){

        var xAxisColumns = JSON.parse(reportProperties.xAxisColumns);
        var yAxisColumns = JSON.parse(reportProperties.yAxisColumns);
        var chartTitle = reportProperties.chartTitle;
        var d3PropertyConfig = JSON.parse(reportProperties.d3PropertiesConfig);
        var colorByData = JSON.parse(reportProperties.colorByDataColoumns);

        // Check if chart is still loading or not.
        if(webEngineView.loading){
            console.log('Chart is still loading... Please wait')
            return;
        }

        console.log("Okay, Now it's time to draw the chart")

        console.log('Draw Chart X Column names',xAxisColumns);
        console.log('Draw Chart Y Column names',yAxisColumns);
        console.log('Chart Title', chartTitle);
        console.log('d3PropertiesConfig', d3PropertyConfig)

        if(xAxisColumns.length===0 && yAxisColumns.length === 0){
            // set everything to default
            // Any can add any default case here
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
            var colorByColumnName = '';

            switch(chartTitle){
            case Constants.horizontalBarChartTitle:
                console.log("Horizontal BAR");
                dataValues =  ChartsModel.getBarChartValues(yAxisColumns[0],xAxisColumns[0]);
                break;
            case Constants.barChartTitle:
                console.log("BAR CLICKED", xAxisColumns[0])
                dataValues =  ChartsModel.getBarChartValues(xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.horizontalStackedBarChartTitle:
                colorByColumnName = colorByData[0].columnName;
                dataValues =  ChartsModel.getStackedBarChartValues(colorByColumnName,xAxisColumns[0], yAxisColumns[0]);
                
                break;
            case Constants.stackedBarChartTitle:
                console.log('Stacked bar chart!');
                colorByColumnName = colorByData[0].columnName;
                dataValues =  ChartsModel.getStackedBarChartValues(colorByColumnName,yAxisColumns[0], xAxisColumns[0]);
                break;
            case Constants.horizontalBarGroupedChartTitle:
                console.log('horizontalBarGroupedChart chart!');
                dataValues =  ChartsModel.getNewGroupedBarChartValues(yAxisColumns[0],xAxisColumns[0], yAxisColumns[1]);
                break;
            case Constants.groupBarChartTitle:
                console.log('Grouped bar chart!',xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);
                dataValues =  ChartsModel.getNewGroupedBarChartValues(xAxisColumns[0],yAxisColumns[0], xAxisColumns[1]);
                console.log(dataValues);
                break;
            case Constants.areaChartTitle:
                console.log("AREA CLICKED")
                // Area - xAxis(String), yAxis(String)
                dataValues =  ChartsModel.getAreaChartValues(xAxisColumns[0],yAxisColumns[0]);
                break;
            case Constants.stackedAreaChartTitle:
                console.log('Stacked Area Chart')
                colorByColumnName = colorByData[0].columnName;
                console.log('Colour By columnName',columnName)
                dataValues =  ChartsModel.getStackedAreaChartValues(colorByColumnName,yAxisColumns[0],xAxisColumns[0]);
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

            console.log('Webengine View Loading Status:',webEngineView.loading);
            console.log('Data Values:',JSON.stringify(dataValues));
            var colorData = [];
            console.log("colorData5",colorData)
            colorData = JSON.parse(dataValues)[1] || [];

            console.log("colorData2" ,colorData)
            console.log("dataValues" ,JSON.parse(dataValues))

            console.log('Selected Chart Title:',chartTitle)
            console.log("D3Config: "+JSON.stringify(d3PropertyConfig))
            console.log('Starting to plot');

           var scriptValue = 'window.addEventListener("resize", function () {
                    d3.selectAll("#my_dataviz").html("");
                    drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+');
           });';

           clearChartValue();
           webEngineView.runJavaScript('drawChart('+dataValues+','+JSON.stringify(d3PropertyConfig)+'); '+scriptValue);

           // Clear Chart Data
            // ChartsModel.clearData();
           return;
        }

        webEngineView.runJavaScript('clearChart()');
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
                text: qsTr("Report Name")
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
                                onTriggered: editSelectedReport()
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
                                onTriggered: editSelectedReport()
                            }

                            MenuItem {
                                text: qsTr("Custom")
                                onTriggered: destroyElement()
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
