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

import com.grafieks.singleton.constants 1.0

Rectangle {
    id: selComp
    border {
        width: 1
        color: Constants.grafieksGreenColor
    }

    width: 100
    height: 100

    property int rulersSize: 10


    property var rectangles: new Map() // rectangle object

    property var dynamicContainer : Qt.createComponent("./MiniSubComponents/MainContainer.qml");

    property var dynamicText : Qt.createComponent("./DroppedText.qml");
    property var dynamicImageBox : Qt.createComponent("./DroppedImage.qml");

    property int counter: 1

    Component.onCompleted: {

        if(DashboardContainer.lastContainerType == "text"){
            rectangles.set(counter,dynamicText.createObject(parent,{x:DashboardContainer.positionX, y: DashboardContainer.positionY, name: 'Text', objectName : counter}))
        }

        if(DashboardContainer.lastContainerType == "image"){
            rectangles.set(counter, dynamicImageBox.createObject(parent, {x:DashboardContainer.positionX, y: DashboardContainer.positionY, name: 'Select an Image', objectName : counter}))
        }

        counter++;
    }


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
                if(drag.active){
                    selComp.width = selComp.width - mouseX
                    selComp.x = selComp.x + mouseX
                    if(selComp.width < 30)
                        selComp.width = 30
                }
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
                if(drag.active){
                    selComp.width = selComp.width + mouseX
                    if(selComp.width < 50)
                        selComp.width = 50
                }
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
                if(drag.active){
                    selComp.height = selComp.height - mouseY
                    selComp.y = selComp.y + mouseY
                    if(selComp.height < 50)
                        selComp.height = 50
                }
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
                if(drag.active){
                    selComp.height = selComp.height + mouseY
                    if(selComp.height < 50)
                        selComp.height = 50
                }
            }
        }
    }
}

