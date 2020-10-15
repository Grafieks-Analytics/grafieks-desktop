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

    property var dynamicContainer : Qt.createComponent("./MiniSubComponents/MainContainer.qml");

    property var dynamicText : Qt.createComponent("./DroppedText.qml");
    property var dynamicImageBox : Qt.createComponent("./DroppedImage.qml");
    property var dynamicBlankBox : Qt.createComponent("./DroppedBlank.qml");
    property var dynamicReportBox : Qt.createComponent("./DroppedReport.qml");

    property var objectType: "";

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



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS



    Component.onCompleted: {

        objectType = DashboardParamsModel.lastContainerType;

        if(DashboardParamsModel.lastContainerType === "text"){
            rectangles.set(counter,dynamicText.createObject(parent,{z:mainContainer.z, name: 'Text', objectName : mainContainer.objectName}))
        }

        else if(DashboardParamsModel.lastContainerType === "image"){
            rectangles.set(counter, dynamicImageBox.createObject(parent, {z:mainContainer.z, name: 'Choose Image', objectName : mainContainer.objectName}))
        }
        else if(DashboardParamsModel.lastContainerType === "blank"){
            rectangles.set(counter, dynamicBlankBox.createObject(parent, {z:mainContainer.z, name: 'Blank', objectName : mainContainer.objectName}))
        }
        else{
            console.log(objectType);
            rectangles.set(counter, dynamicReportBox.createObject(parent, {z:mainContainer.z, name: objectType, objectName : mainContainer.objectName}))
        }

        DashboardParamsModel.setZIndex(++DashboardParamsModel.zIndex);

        console.log('x',mainContainer.x);
        console.log('y',mainContainer.y);
        console.log('z',mainContainer.z);

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

//        drag{
//            target: parent
//            minimumX: 0
//            minimumY: Constants.subMenuWidth
//            maximumX: parent.parent.width - parent.width
//            maximumY: parent.parent.height - parent.height - Constants.subMenuWidth
//            smoothed: true
//        }

//        onClicked: containerClicked()
//        onDoubleClicked: containerDoubleClicked()

        hoverEnabled: true

        onEntered: showRulers()
        onExited: {

            console.log('exit main container');
            rulerStatus = false
        }

    }


    // Page Design Ends
    /***********************************************************************************************************************/


}

