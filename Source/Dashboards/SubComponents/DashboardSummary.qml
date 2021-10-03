/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Summary
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0




Rectangle {

    id: dashboardArea
    Flickable {
        contentWidth: 2000
        ScrollBar.horizontal: ScrollBar { }
    }

    property var rectangles: new Map() // rectangle object
    property var dynamicContainer : Qt.createComponent("./MiniSubComponents/MainContainer.qml");

    property var previousColor:null;
    property var currnetPointReport: null;



    property int counter: 1

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

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard){

            // Fetch Dashboard customize params
            dashboardArea.color = DashboardParamsModel.getDashboardBackgroundColor(dashboardId)
        }

        function onDashboardBackgroundColorChanged(dashboardId, color){
            dashboardArea.color = color
            previousColor = color
        }

        function onDashboardContentDestroyed(dashboardId){

            if(dashboardId === -1){
                rectangles.clear()
                dashboardArea.color =  Constants.dashboardDefaultBackgroundColor
            }
        }
    }

    Connections{
        target: ReportParamsModel

        function onGenerateWorkbookReports(){

            var reportTypeArray = ["blank", "text", "image", "report"]
            is_dashboard_blank = is_dashboard_blank + 1

            var allDashboardsObj = DashboardParamsModel.fetchAllDashboards()
            var allDashboardKeys = Object.keys(allDashboardsObj)

            for(var i = 0; i < allDashboardKeys.length; i++){
                var reportsInFirstDashboard = DashboardParamsModel.fetchReportsInDashboard(allDashboardKeys[i])
                var reportTypes = DashboardParamsModel.fetchAllReportTypeMap(i);

                reportsInFirstDashboard.forEach(j => {

                                                    var coordinates = DashboardParamsModel.getDashboardWidgetCoordinates(i, j)

                                                    let x1 = coordinates[0]
                                                    let y1 = coordinates[1]

                                                    let reportType = Constants.reportTypeChart;
                                                    let draggedItem = DashboardParamsModel.getReportName(i, j);

                                                    dashboardArea.color = previousColor ? previousColor : Constants.dashboardDefaultBackgroundColor

                                                    // Set the last container type param
                                                    // report type - chart, image, blank, text
                                                    DashboardParamsModel.setLastContainerType(reportTypeArray[reportTypes[j]]);

                                                    var mainContainerVisibility = i === 0 ? true : false
                                                    var objectJson = {x: x1, y: y1, z: DashboardParamsModel.getReportZOrder(i,j),  objectName : counter, webUrl: DashboardParamsModel.getDashboardWidgetUrl(i, j), visible: mainContainerVisibility};
                                                    console.log("VISIO", JSON.stringify(objectJson))
                                                    objectJson.reportId = j;
                                                    rectangles.set(counter, dynamicContainer.createObject(parent,objectJson));

                                                    const reportProperties = ReportParamsModel.getReport(j);


                                                    // ["blank", "text", "image", "report"]
                                                    if(reportTypeArray[reportTypes[j]] === reportTypeArray[1]){
                                                        DashboardParamsModel.setDashboardWidgetUrl(DashboardParamsModel.currentDashboard, counter, DashboardParamsModel.getDashboardWidgetUrl(i, j));
                                                    } else if(reportTypeArray[reportTypes[j]] === reportTypeArray[2]){
                                                        DashboardParamsModel.setDashboardWidgetUrl(DashboardParamsModel.currentDashboard, counter, DashboardParamsModel.getDashboardWidgetUrl(i, j));
                                                    } else if(reportTypeArray[reportTypes[j]] === reportTypeArray[3]) {
                                                        const chartUrl = reportProperties && (Constants.baseChartUrl + reportProperties.chartUrl);
                                                        DashboardParamsModel.setDashboardWidgetUrl(DashboardParamsModel.currentDashboard, counter, chartUrl);
                                                    }

                                                    counter++;
                                                })

            }

            DashboardParamsModel.setCurrentDashboard(allDashboardKeys.length - 1);

        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS



    function onDropAreaEntered(drag){

        dashboardArea.color = Constants.dropHighlightColor
    }

    function onDropAreaDropped(drag){
        is_dashboard_blank = is_dashboard_blank + 1

        let x1 = drag.x
        let y1 = drag.y
        let x2 = drag.x + Constants.defaultDroppedReportWidth
        let y2 = drag.y + Constants.defaultDroppedReportHeight
        let currentPoint = {x: drag.x, y: drag.y};
        currnetPointReport = {x: drag.x, y: drag.y};

        let reportType = 0;
        let draggedItem = listViewElem.itemName.toLocaleLowerCase();

        switch(listViewElem.itemName){

        case "Blank":
            reportType = Constants.reportTypeBlank
            break;
        case "Text":
            reportType = Constants.reportTypeText
            break;
        case "Image":
            reportType = Constants.reportTypeImage
            break;
        default:
            reportType = Constants.reportTypeChart
            break;
        }

        dashboardArea.color = previousColor ? previousColor : Constants.dashboardDefaultBackgroundColor

        // Set the last container type param
        DashboardParamsModel.setLastContainerType(listViewElem.itemName.toLowerCase());

        var objectJson = {x: x1, y: y1, z: DashboardParamsModel.zIndex,  objectName : counter};
        if(listViewElem.reportId){
            objectJson.reportId = listViewElem.reportId;
        }
        rectangles.set(counter, dynamicContainer.createObject(parent,objectJson))

        DashboardParamsModel.dragNewReport(DashboardParamsModel.currentDashboard, counter)
        DashboardParamsModel.setReportZOrder(DashboardParamsModel.currentDashboard, counter, DashboardParamsModel.zIndex)
        DashboardParamsModel.setDashboardWidgetCoordinates(DashboardParamsModel.currentDashboard, counter, x1, y1, x2, y2)
        DashboardParamsModel.setDashboardWidgetTypeMap(DashboardParamsModel.currentDashboard, counter, reportType)

        const reportProperties = ReportParamsModel.getReport(listViewElem.reportId);
        const chartUrl = reportProperties && (Constants.baseChartUrl + reportProperties.chartUrl);

        if(reportType === Constants.reportTypeChart)
            DashboardParamsModel.setDashboardWidgetUrl(DashboardParamsModel.currentDashboard, counter, chartUrl);

        DashboardParamsModel.setPositionX(x1);
        DashboardParamsModel.setPositionY(y1);

        counter++;
    }

    function onDropAreaPositionChanged(drag){
        DashboardParamsModel.setPositionX(drag.x);
        DashboardParamsModel.setPositionY(drag.y);

    }
    function onDropAreaExited(){
        //        console.log('Exit');
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts

    DropArea {
        id: dropArea
        anchors.fill: parent
        onEntered: onDropAreaEntered(drag)
        onExited: onDropAreaExited()
        onPositionChanged: onDropAreaPositionChanged(drag)
        onDropped: onDropAreaDropped(drag)
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}
