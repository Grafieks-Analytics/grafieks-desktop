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

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard, dashboardUniqueWidgets){

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
                var reportTypes = DashboardParamsModel.fetchAllReportTypeMap(allDashboardKeys[i]);

                reportsInFirstDashboard.forEach(j => {

                                                    var coordinates = DashboardParamsModel.getDashboardWidgetCoordinates(allDashboardKeys[i], j)

                                                    let x1 = coordinates[0]
                                                    let y1 = coordinates[1]

                                                    let reportType = Constants.reportTypeChart;
                                                    let draggedItem = DashboardParamsModel.getReportName(allDashboardKeys[i], j);

                                                    dashboardArea.color = previousColor ? previousColor : Constants.dashboardDefaultBackgroundColor

                                                    // Set the last container type param
                                                    // report type - chart, image, blank, text
                                                    DashboardParamsModel.setLastContainerType(reportTypeArray[reportTypes[j]]);

                                                    var uniqueHash = DashboardParamsModel.getDashboardUniqueWidget(allDashboardKeys[i], j)

                                                    var objectJson = {x: x1, y: y1, z: DashboardParamsModel.getReportZOrder(allDashboardKeys[i],j),  objectName : j, reportId: j, uniqueHash: uniqueHash, webUrl: DashboardParamsModel.getDashboardWidgetUrl(allDashboardKeys[i], j)};
                                                    rectangles.set(counter, dynamicContainer.createObject(parent,objectJson));

                                                    const reportProperties = ReportParamsModel.getReport(j);


                                                    // ["blank", "text", "image", "report"]
                                                    if(reportTypeArray[reportTypes[j]] === reportTypeArray[1]){
                                                        DashboardParamsModel.setDashboardWidgetUrl(DashboardParamsModel.currentDashboard, j, DashboardParamsModel.getDashboardWidgetUrl(allDashboardKeys[i], j));
                                                    } else if(reportTypeArray[reportTypes[j]] === reportTypeArray[2]){
                                                        DashboardParamsModel.setDashboardWidgetUrl(DashboardParamsModel.currentDashboard, j, DashboardParamsModel.getDashboardWidgetUrl(allDashboardKeys[i], j));
                                                    } else if(reportTypeArray[reportTypes[j]] === reportTypeArray[3]) {
                                                        const chartUrl = reportProperties && (Constants.baseChartUrl + reportProperties.chartUrl);
                                                        DashboardParamsModel.setDashboardWidgetUrl(DashboardParamsModel.currentDashboard, j, chartUrl);
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

    function isReportDropEligbile(){
        if(listViewElem.itemName == "Text" || listViewElem.itemName == "Image" || listViewElem.itemName == "Blank"){
            return true;
        }
        return !DashboardParamsModel.getDashboardReportMap(listViewElem.reportId)
    }



    function onDropAreaEntered(drag){
       dashboardArea.color = isReportDropEligbile() ? Constants.dropHighlightColor : Constants.dropIneligibleHighlightColor 
    }

    function onDropAreaDropped(drag){

        var backgroundColor = DashboardParamsModel.getDashboardBackgroundColor(DashboardParamsModel.currentDashboard);
        dashboardArea.color = backgroundColor ? backgroundColor : Constants.dashboardDefaultBackgroundColor
        // check if the report is added
        // don't allow the user to drop the repot 
        if(!isReportDropEligbile()){
            return;
        }
        is_dashboard_blank = is_dashboard_blank + 1

        let x1 = drag.x
        let y1 = drag.y
        let x2 = drag.x + Constants.defaultDroppedReportWidth
        let y2 = drag.y + Constants.defaultDroppedReportHeight
        let currentPoint = {x: drag.x, y: drag.y};
        currnetPointReport = {x: drag.x, y: drag.y};

        let reportType = 0;
        let draggedItem = listViewElem.itemName.toLocaleLowerCase();
        var newReportId = 0;

        switch(listViewElem.itemName){

        case "Blank":
            reportType = Constants.reportTypeBlank
            newReportId = ReportParamsModel.generateNewReportId();
            ReportParamsModel.setReportId(newReportId);
            break;
        case "Text":
            reportType = Constants.reportTypeText
            newReportId = ReportParamsModel.generateNewReportId();
            ReportParamsModel.setReportId(newReportId);
            break;
        case "Image":
            reportType = Constants.reportTypeImage
            newReportId = ReportParamsModel.generateNewReportId();
            ReportParamsModel.setReportId(newReportId);
            break;
        default:
            reportType = Constants.reportTypeChart
            newReportId = listViewElem.reportId;
            break;
        }

        dashboardArea.color = previousColor ? previousColor : Constants.dashboardDefaultBackgroundColor

        // Set the last container type param
        DashboardParamsModel.setLastContainerType(listViewElem.itemName.toLowerCase());


        var randHash = randomHash(5);
        var objectJson = {x: x1, y: y1, z: DashboardParamsModel.zIndex,  objectName : newReportId, reportId: newReportId, uniqueHash: randHash};


        rectangles.set(counter, dynamicContainer.createObject(parent,objectJson))

        var reportTitle = "";
        if(reportType === Constants.reportTypeChart){
            reportTitle = ReportParamsModel.getReport(listViewElem.reportId).reportTitle;
        }

        DashboardParamsModel.setDashboardUniqueWidget(DashboardParamsModel.currentDashboard, newReportId, randHash)
        DashboardParamsModel.dragNewReport(DashboardParamsModel.currentDashboard, newReportId, reportTitle)
        DashboardParamsModel.setReportZOrder(DashboardParamsModel.currentDashboard, counter, DashboardParamsModel.zIndex)
        DashboardParamsModel.setDashboardWidgetCoordinates(DashboardParamsModel.currentDashboard, newReportId, x1, y1, x2, y2)
        DashboardParamsModel.setDashboardWidgetTypeMap(DashboardParamsModel.currentDashboard, newReportId, reportType)

        const reportProperties = ReportParamsModel.getReport(listViewElem.reportId);
        const chartUrl = reportProperties && (Constants.baseChartUrl + reportProperties.chartUrl);

        if(reportType === Constants.reportTypeChart){
            DashboardParamsModel.setDashboardWidgetUrl(DashboardParamsModel.currentDashboard, newReportId, chartUrl);
        }

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

    function randomHash(length) {
        var result           = '';
        var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;
        for ( var i = 0; i < length; i++ ) {
          result += characters.charAt(Math.floor(Math.random() *
     charactersLength));
       }
       return result;
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
