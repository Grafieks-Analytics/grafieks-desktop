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

    height: parent.height
    width: parent.width

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

        function onCurrentDashboardChanged(dashboardId){

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
        var currentPoint = {x: drag.x, y: drag.y};
        console.log("Entered", currentPoint.x, listViewElem.itemName)
    }

    function onDropAreaDropped(drag){

        let x1 = drag.x
        let y1 = drag.y
        let x2 = drag.x + Constants.defaultDroppedReportWidth
        let y2 = drag.y + Constants.defaultDroppedReportHeight
        let currentPoint = {x: drag.x, y: drag.y};
        let draggedItem = listViewElem.itemName.toLocaleLowerCase();

        dashboardArea.color = "transparent"

        rectangles.set(counter,dynamicContainer.createObject(parent,{x: x1, y: y1, z: DashboardParamsModel.zIndex,  objectName : counter}))

        DashboardParamsModel.dragNewReport(DashboardParamsModel.currentDashboard, counter)
        DashboardParamsModel.setReportZOrder(DashboardParamsModel.currentDashboard, counter, DashboardParamsModel.zIndex)
        DashboardParamsModel.setDashboardReportCoordinates(DashboardParamsModel.currentDashboard, counter, x1, y1, x2, y2)
        DashboardParamsModel.setDashboardReportTypeMap(DashboardParamsModel.currentDashboard, counter, draggedItem)
        DashboardParamsModel.setDashboardReportUrl(DashboardParamsModel.currentDashboard, counter, "")

        DashboardParamsModel.setLastContainerType(listViewElem.itemName.toLowerCase());
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
