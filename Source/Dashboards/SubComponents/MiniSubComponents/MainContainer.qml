/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents/MiniComponent
** Main Container
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

Rectangle {
    id: mainContainer
    border {
        width: 1
        color: Constants.grafieksGreenColor
    }

    width: Constants.defaultDroppedReportWidth
    height: Constants.defaultDroppedReportHeight

    property int rulersSize: 10


    property var rectangles: new Map() // rectangle object

    property var dynamicText : Qt.createComponent("./DroppedText.qml");
    property var dynamicImageBox : Qt.createComponent("./DroppedImage.qml");
    property var dynamicBlankBox : Qt.createComponent("./DroppedBlank.qml");
    property var dynamicReportBox : Qt.createComponent("./DroppedReport.qml");

    property var objectType: "";
    property var reportId: ""; // This works only in case of reports | Else this will always be empty [Tag: Optimization]

    property var rulerStatus: false


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

            if(reportsInDashboard.includes(parseInt(mainContainer.objectName))){
                mainContainer.visible = true
            } else{
                mainContainer.visible = false
            }
        }

        function onDashboardContentDestroyed(dashboardId){
            if(dashboardId === -1)
                rectangles.clear()
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS



    Component.onCompleted: {

        var objectType = DashboardParamsModel.lastContainerType;
        var counter = mainContainer.objectName
        
        // [Tag: Refactor]
        // Use Switch Case
        
        if(DashboardParamsModel.lastContainerType === "text"){
            rectangles.set(counter,dynamicText.createObject(parent, {z:mainContainer.z, name: 'Text', objectName : counter}))
        }

        else if(DashboardParamsModel.lastContainerType === "image"){
            rectangles.set(counter, dynamicImageBox.createObject(parent, {z:mainContainer.z, name: 'Choose Image', objectName : counter}))
        }
        else if(DashboardParamsModel.lastContainerType === "blank"){
            rectangles.set(counter, dynamicBlankBox.createObject(parent, {z:mainContainer.z, name: 'Blank', objectName : counter}))
        }
        else{

            // Condition for reports

            // [Tag: Refactor]
            // Make sure to use them in "Reports" case|condition instead of else
            let reportObj = dynamicReportBox.createObject(parent, {z:mainContainer.z, name: objectType, objectName : counter, reportId: reportId});
            console.log('Type Report Obj',typeof reportObj);
            
            ReportParamsModel.addDashboardReportInstance(reportObj, reportId);
            rectangles.set(counter, reportObj);
        }

        DashboardParamsModel.setZIndex(++DashboardParamsModel.zIndex);

        console.log('x',mainContainer.x, 'y', mainContainer.y, 'z', mainContainer.z, mainContainer.width, mainContainer.height);

    }



    function onLeftResize(drag,mouseX){
        if(drag.active){
            mainContainer.width = mainContainer.width - mouseX
            mainContainer.x = mainContainer.x + mouseX
            if(mainContainer.width < 30)
                mainContainer.width = 30
        }
    }

    function onRightResize(drag,mouseX){

        if(drag.active){
            mainContainer.width = mainContainer.width + mouseX
            if(mainContainer.width < 50)
                mainContainer.width = 50
        }
    }


    function onTopResize(drag,mouseY){

        if(drag.active){
            mainContainer.height = mainContainer.height - mouseY
            mainContainer.y = mainContainer.y + mouseY
            if(mainContainer.height < 50)
                mainContainer.height = 50
        }
    }


    function onDownResize(drag,mouseY){
        if(drag.active){
            mainContainer.height = mainContainer.height + mouseY
            if(mainContainer.height < 50)
                mainContainer.height = 50
        }
    }

    function showRulers(){
        rulerStatus = true
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    // Rulers Starts
    //Left Ruler

    Rectangle {
        width: rulersSize
        height: rulersSize
        color: Constants.grafieksGreenColor
        z:mainContainer.z
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.verticalCenter
        visible: rulerStatus

        MouseArea {
            anchors.fill: parent
            drag{ target: parent; axis: Drag.XAxis }
            cursorShape: Qt.SizeHorCursor
            onMouseXChanged: onLeftResize(drag,mouseX)
        }
    }


    //Right Ruler
    Rectangle {
        width: rulersSize
        height: rulersSize
        color: Constants.grafieksGreenColor
        z:mainContainer.z
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.verticalCenter
        visible: rulerStatus

        MouseArea {
            anchors.fill: parent
            drag{ target: parent; axis: Drag.XAxis }
            cursorShape: Qt.SizeHorCursor
            onMouseXChanged: onRightResize(drag,mouseX)
        }
    }

    // Top Ruler
    Rectangle {
        width: rulersSize
        height: rulersSize
        x: parent.x / 2
        y: 0
        z:mainContainer.z
        color: Constants.grafieksGreenColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.top
        visible: rulerStatus

        MouseArea {
            anchors.fill: parent
            drag{ target: parent; axis: Drag.YAxis }
            cursorShape: Qt.SizeVerCursor
            onMouseYChanged: onTopResize(drag,mouseY)
        }
    }

    //Bottom Ruler
    Rectangle {
        width: rulersSize
        height: rulersSize
        x: parent.x / 2
        y: parent.y
        z:mainContainer.z
        color: Constants.grafieksGreenColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.bottom
        visible: rulerStatus

        MouseArea {
            anchors.fill: parent
            drag{ target: parent; axis: Drag.YAxis }
            cursorShape: Qt.SizeVerCursor
            onMouseYChanged: onDownResize(drag,mouseY)
        }
    }


    //Ruler Ends


    MouseArea {     // drag mouse area

        anchors.fill: parent
        hoverEnabled: true

        onEntered: showRulers()
        onExited: {

            rulerStatus = false
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/


}

