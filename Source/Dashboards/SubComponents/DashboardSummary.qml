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
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS



    function onDropAreaEntered(drag){

        dashboardArea.color = Constants.dropHighlightColor
        console.log("Entered", currentPoint.x, listViewElem.itemName)
    }

    function onDropAreaDropped(drag){

        let x1 = drag.x
        let y1 = drag.y
        let x2 = drag.x + Constants.defaultDroppedReportWidth
        let y2 = drag.y + Constants.defaultDroppedReportHeight
        let currentPoint = {x: drag.x, y: drag.y};
        let reportType = 0;
        let draggedItem = listViewElem.itemName.toLocaleLowerCase();


        switch(listViewElem.itemType){

        case "blank":
            reportType = Constants.reportTypeBlank
            break;
        case "text":
            reportType = Constants.reportTypeText
            break;
        case "image":
            reportType = Constants.reportTypeImage
            break;
        case "chart":
            reportType = Constants.reportTypeChart
            break;
        }

        dashboardArea.color = "transparent"

        // Set the last container type param
        DashboardParamsModel.setLastContainerType(listViewElem.itemName.toLowerCase());

        rectangles.set(counter, dynamicContainer.createObject(parent,{x: x1, y: y1, z: DashboardParamsModel.zIndex,  objectName : counter}))

        DashboardParamsModel.dragNewReport(DashboardParamsModel.currentDashboard, counter)
        DashboardParamsModel.setReportZOrder(DashboardParamsModel.currentDashboard, counter, DashboardParamsModel.zIndex)
        DashboardParamsModel.setDashboardReportCoordinates(DashboardParamsModel.currentDashboard, counter, x1, y1, x2, y2)
        DashboardParamsModel.setDashboardReportTypeMap(DashboardParamsModel.currentDashboard, counter, reportType)
        DashboardParamsModel.setDashboardReportUrl(DashboardParamsModel.currentDashboard, counter, "")

        DashboardParamsModel.setPositionX(x1);
        DashboardParamsModel.setPositionY(y1);

        counter++;
    }

    function onDropAreaPositionChanged(drag){
//        console.log(drag);
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
