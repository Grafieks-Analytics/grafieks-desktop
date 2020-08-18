/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Modeller
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15



import com.grafieks.singleton.constants 1.0


Item {

    id: dataModellerItem
    property real droppedX : 0
    property real droppedY : 0
    property var frontRectangleCoordinates : []
    property var rearRectangleCoordinates : []
    property var existingTables : []



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
        var dynamicRectangle = Qt.createComponent("DroppedRectangle.qml");
    }

    function onDropAreaExited(){
        highlightRect.color = "white"
    }

    function onDropAreaEntered(){

        highlightRect.color = "ivory"

        // Show light shaded line between the current rectangle
        // and the nearest rectangle
        if(existingTables.length > 1){

        }
    }

    function onDropAreaDropped(drag){

        // listView.model.remove(listView.dragItemIndex);
        // listView.dragItemIndex = -1;

        highlightRect.color = "white"

        var  dynamicRectangle = Qt.createComponent("DroppedRectangle.qml");
        dynamicRectangle.createObject(parent, {x:drag.x, y: drag.y, name: tableslist.tableName})

        // Created rectangle front & back coordinates
        var rectLeftX = drag.x
        var rectRightX = rectLeftX + tableslist.tableName.length * 10 + 30
        var rectLeftY = drag.y + 15
        var rectRightY = rectLeftY
        var tmpArray = []

        // Push the coordinates in the array
        frontRectangleCoordinates.push({x: rectLeftX, y: rectLeftY})
        rearRectangleCoordinates.push({x: rectRightX, y: rectRightY})
        existingTables.push(tableslist.tableName)

        // Current reference Coordinate
        var currentPoint = {x: rectLeftX, y: rectLeftY};

        // Temporary clone the rear rectangle coordinates to a variable
        var tmpRearRectangleCoordinates = rearRectangleCoordinates.slice();
        tmpRearRectangleCoordinates.pop();


        // Find the distance b/w all rear of a rectangle
        // and the current point
        if(tmpRearRectangleCoordinates.length > 0){

            tmpRearRectangleCoordinates.forEach(function(item, index){

                // calculate the distance b/w coordinates
                var newDistance = distance(currentPoint,item)
                tmpArray.push({"index": newDistance, "coordinates" : item})
            })
        }

        // Sort all the coordinates based on distance
        // and find the nearest distance
        const sortByDistance = tmpArray.sort((a,b) => a.index - b.index).map((arr, index, array) => arr.coordinates)
        var nearestIndex = tmpRearRectangleCoordinates.indexOf(sortByDistance[0])

        if(nearestIndex > -1){
            console.log(existingTables[nearestIndex])
        }

    }



    // Calculate distance between 2 points
    function distance(currentPoint, referencePoint) {
        return Math.pow((referencePoint.x - currentPoint.x), 2) + Math.pow((referencePoint.y - currentPoint.y), 2);
    }


    function onZoomOutClicked(){
        console.log('Zoom Out')
    }

    function onZoomInClicked(){
        console.log('Zoom In')
    }


    function onAlignBtnClicked(){
        console.log('Align Btn Clicked')
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Column{
        id: button_options_group
        x:20
        y:10

        Button{
            id: align_btn
            width: 30
            height: 30

            Image{
                id: align_icon
                height: 22
                width: 22

                source: "../../../Images/icons/align.png"
                anchors.centerIn: align_btn
                anchors.topMargin: 3
                anchors.leftMargin: 2
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter

            }

            onClicked: onAlignBtnClicked()
            background: Rectangle {
                id: align_btn_background
                color:  align_btn.hovered? Constants.darkThemeColor: Constants.themeColor

            }

        }

        Button{
            id:plus_icon_btn
            width: 30
            height: 30
            Image{
                id: plus_icon
                source: "../../../Images/icons/Plus_32.png"
                height: 25
                width: 25
                anchors.centerIn: plus_icon_btn
                anchors.topMargin: 3
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter

            }

            background: Rectangle {
                id: plus_icon_btn_background
                color:  plus_icon_btn.hovered? Constants.darkThemeColor: Constants.themeColor

            }
            onClicked: onZoomInClicked()
        }

        Button{
            id:minus_icon_btn
            width: 30
            height: 30
            Image{
                id: minus_icon
                source: "../../../Images/icons/zoom out.png"
                height: 20
                width: 20
                anchors.topMargin: 3
                anchors.leftMargin:3
                anchors.centerIn: minus_icon_btn
                anchors.top: minus_icon_btn.top
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter

            }

            background: Rectangle {
                id: minus_icon_btn_background
                color:  minus_icon_btn.hovered? Constants.darkThemeColor: Constants.themeColor

            }

            onClicked: onZoomOutClicked()
        }

    }

    Rectangle{
        id:highlightRect
        height: parent.height
        width: parent.width



        DropArea {
            id: dropArea
            anchors.fill: parent
            onEntered: onDropAreaEntered()
            onExited: onDropAreaExited()
            onDropped: onDropAreaDropped(drag)
        }
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}
