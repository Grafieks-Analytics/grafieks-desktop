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

    width: 180
    height: 100

    property int rulersSize: 10


    property var rectangles: new Map() // rectangle object

    property var dynamicContainer : Qt.createComponent("./MiniSubComponents/MainContainer.qml");

    property var dynamicText : Qt.createComponent("./DroppedText.qml");
    property var dynamicImageBox : Qt.createComponent("./DroppedImage.qml");
    property var dynamicReportBox : Qt.createComponent("./DroppedReport.qml");

    property int counter: 1

    property var objectType: "";


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

        objectType = DashboardContainerModel.lastContainerType;

        if(DashboardContainerModel.lastContainerType == "text"){
            rectangles.set(counter,dynamicText.createObject(parent,{name: 'Text', objectName : counter}))
        }

        else if(DashboardContainerModel.lastContainerType == "image"){
            rectangles.set(counter, dynamicImageBox.createObject(parent, { name: 'Choose Image', objectName : counter}))
        }

        else{
            console.log(objectType);
            rectangles.set(counter, dynamicReportBox.createObject(parent, { name: objectType, objectName : counter}))
        }

        counter++;

    }

    function containerClicked(){
        if(objectType == "image"){
            fileDialog.open()
        }
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



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    FileDialog{
        id: fileDialog
        title: "Select a file (*.jpg *.jpeg *.png  only)"
        selectMultiple: false
        nameFilters: [ "Image files (*.jpg *.jpeg *.png )"]
    }



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    MouseArea {     // drag mouse area
        anchors.fill: parent
        drag{
            target: parent
            minimumX: 0
            minimumY: 0
            maximumX: parent.parent.width - parent.width
            maximumY: parent.parent.height - parent.height
            smoothed: true
        }

        onClicked: containerClicked()

    }

    Rectangle {
        width: rulersSize
        height: rulersSize
        color: Constants.grafieksGreenColor
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            anchors.fill: parent
            drag{ target: parent; axis: Drag.XAxis }
            cursorShape: Qt.SizeHorCursor
            onMouseXChanged: {
                onLeftResize(drag,mouseX)
            }
        }
    }

    Rectangle {
        width: rulersSize
        height: rulersSize
        color: Constants.grafieksGreenColor
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            anchors.fill: parent
            drag{ target: parent; axis: Drag.XAxis }
            cursorShape: Qt.SizeHorCursor
            onMouseXChanged: {


                onRightResize(drag,mouseX)

            }
        }
    }

    Rectangle {
        width: rulersSize
        height: rulersSize
        x: parent.x / 2
        y: 0
        color: Constants.grafieksGreenColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.top

        MouseArea {
            anchors.fill: parent
            drag{ target: parent; axis: Drag.YAxis }
            cursorShape: Qt.SizeVerCursor
            onMouseYChanged: {
                onTopResize(drag,mouseY)
            }
        }
    }


    Rectangle {
        width: rulersSize
        height: rulersSize
        x: parent.x / 2
        y: parent.y
        color: Constants.grafieksGreenColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.bottom

        MouseArea {
            anchors.fill: parent
            drag{ target: parent; axis: Drag.YAxis }
            cursorShape: Qt.SizeVerCursor
            onMouseYChanged: {
                onDownResize(drag,mouseY)
            }
        }
    }
}

