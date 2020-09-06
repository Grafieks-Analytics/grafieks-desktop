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
    property var dynamicText : Qt.createComponent("./MiniSubComponents/DroppedText.qml");
    property var dynamicImageBox : Qt.createComponent("./MiniSubComponents/DroppedImage.qml");

    property int textCounter: 1

    property string item: 'test'

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

    function onDropAreaEntered(drag,itemName){


        dashboardArea.color = Constants.dropHighlightColor

        var currentPoint = {x: drag.x, y: drag.y};
        console.log("Entered", currentPoint.x, itemName)
//        console.log(dropArea.keys)



    }
    function onDropAreaDropped(drag,itemName){
        var currentPoint = {x: drag.x, y: drag.y};
//        console.log(currentPoint.x)
//        console.log(currentPoint.y)

//        console.log(subItemRepeater);

        dashboardArea.color = "transparent"

        rectangles.set(textCounter, dynamicImageBox.createObject(parent, {x:drag.x, y: drag.y, name: 'Select an Image', objectName : textCounter}))
        textCounter++;


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



    Rectangle {
        id: rectangle
        x: 8
        y: 8
        width: 235
        height: 50
        color: "white"
        border.color: Constants.themeColor

        Image {
            id: image
            x: 8
            y: 10
            source: "../../../Images/icons/charts/Map2_30.png"
        }

        Text {
            id: text1
            x: 45
            y: 10
            color: "#3d31e9"
            text: qsTr("$1,000")
            font.weight: Font.Bold
            font.pixelSize: 12
        }

        Text {
            id: text2
            x: 45
            y: 25
            height: 15
            text: qsTr("Total Revenue")
            lineHeight: 1
            font.pixelSize: 12
        }
    }

    Rectangle {
        id: rectangle1
        x: 8
        y: 64
        width: 235
        height: 50
        color: "white"
        border.color: Constants.themeColor
        Image {
            id: image1
            x: 8
            y: 10
            source: "../../../Images/icons/charts/Map2_30.png"
        }


        Text {
            id: text3
            x: 45
            y: 10
            color: "#3d31e9"
            text: qsTr("$1,000")
            font.pixelSize: 12
            font.weight: Font.Bold
        }

        Text {
            id: text4
            x: 45
            y: 25
            height: 15
            text: qsTr("Growth")
            lineHeight: 1
            font.pixelSize: 12
        }
    }

    Rectangle {
        id: rectangle2
        x: 8
        y: 120
        width: 235
        height: 50
        color: "white"
        border.color: Constants.themeColor
        Image {
            id: image2
            x: 8
            y: 10
            source: "../../../Images/icons/charts/Map2_30.png"
        }

        Text {
            id: text5
            x: 45
            y: 10
            color: "#3d31e9"
            text: qsTr("$1,000")
            font.pixelSize: 12
            font.weight: Font.Bold
        }

        Text {
            id: text6
            x: 45
            y: 25
            height: 15
            text: qsTr("Revenue")
            lineHeight: 1
            font.pixelSize: 12
        }
    }

    DropArea {
        id: dropArea

        property alias dropProxy: dropArea

        anchors.fill: parent
        onEntered: onDropAreaEntered(drag, dropArea.itemName)
        onExited: onDropAreaExited()
        onPositionChanged: onDropAreaPositionChanged(drag)
        onDropped: onDropAreaDropped(drag,dropArea.itemName)
        keys: [dragItemIndex,itemName]
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}
