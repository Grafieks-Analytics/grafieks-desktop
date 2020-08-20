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
import QtQuick.Shapes 1.15



import com.grafieks.singleton.constants 1.0


Item {

    id: dataModellerItem
    property real droppedX : 0
    property real droppedY : 0
    property var frontRectangleCoordinates : []
    property var rearRectangleCoordinates : []
    property var existingTables : []

    property var dynamicRectangle : Qt.createComponent("DroppedRectangle.qml");
    property var dynamicConnectorLine : Qt.createComponent("ConnectingLine.qml")
    property var dynamicJoinBox : Qt.createComponent("JoinBox.qml")

    property var newConnectingLine
    property var newJoinBox



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



    // New component on Dropped
    function onDropAreaDroppedNewComponent(x,y){
        console.log("Dropped" , x, y)
    }

    // New component on Entered
    function onDropAreaEnteredNewComponent(x,y){
        console.log("Dragging" , x, y)
    }

    function onDropAreaPositionChanged(drag){

        // Show light shaded line between the current rectangle
        // and the nearest rectangle
        if(existingTables.length > 0){

            // Current reference Coordinate
            var currentPoint = {x: drag.x, y: drag.y};

            var nearestTable = nearestRectangle(rearRectangleCoordinates.slice(), currentPoint)

            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = rearRectangleCoordinates[nearestTable.tableId]
            newConnectingLine.incomingRectangleFrontX = drag.x
            newConnectingLine.incomingRectangleFrontY = drag.y
            newConnectingLine.refRectangleRearX = nearestRectangleCoordinates.x
            newConnectingLine.refRectangleRearY = nearestRectangleCoordinates.y
        }
    }

    function onDropAreaExited(){
        highlightRect.color = "white"
    }

    function onDropAreaEntered(drag){

        highlightRect.color = "ivory"

        // Show light shaded line between the current rectangle
        // and the nearest rectangle
        if(existingTables.length > 0){

            // Current reference Coordinate
            var currentPoint = {x: drag.x, y: drag.y};
            var nearestTable = nearestRectangle(rearRectangleCoordinates.slice(), currentPoint)

            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = rearRectangleCoordinates[nearestTable.tableId]

            // Add the line component on stage
            newConnectingLine =  dynamicConnectorLine.createObject(parent, {incomingRectangleFrontX:drag.x, incomingRectangleFrontY: drag.y, refRectangleRearX : nearestRectangleCoordinates.x, refRectangleRearY: nearestRectangleCoordinates.y, lineColor: "grey"})

        }
    }

    function onDropAreaDropped(drag){

        // listView.model.remove(listView.dragItemIndex);
        // listView.dragItemIndex = -1;

        highlightRect.color = "white"

        // Assign new variable to the created object
        // Use this variable to connect the signals and slots
        var newRect =  dynamicRectangle.createObject(parent, {x:drag.x, y: drag.y, name: tableslist.tableName})

        newRect.dragged.connect(onDropAreaEnteredNewComponent)
        newRect.dropped.connect(onDropAreaDroppedNewComponent)

        // Created rectangle front & back coordinates
        var rectLeftX = drag.x
        var rectRightX = rectLeftX + tableslist.tableName.length * 10 + 30
        var rectLeftY = drag.y + 15
        var rectRightY = rectLeftY


        // Current reference Coordinate
        var currentPoint = {x: rectLeftX, y: rectLeftY};


        // Get the nearest rectangle
        // And process the rest
        if(existingTables.length > 0){
            var nearestTable = nearestRectangle(rearRectangleCoordinates.slice(), currentPoint)

            //Change the line color to black
            newConnectingLine.lineColor = "black"

            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = rearRectangleCoordinates[nearestTable.tableId]

            // Draw a JoinBox
            var midLengthX = Math.abs(nearestRectangleCoordinates.x - currentPoint.x) / 2;
            var midLengthY = Math.abs(nearestRectangleCoordinates.y - currentPoint.y) / 2;

            var rectX = nearestRectangleCoordinates.x <= currentPoint.x ? nearestRectangleCoordinates.x + midLengthX : currentPoint.x + midLengthX
            var rectY = nearestRectangleCoordinates.y <= currentPoint.y ? nearestRectangleCoordinates.y + midLengthY : currentPoint.y + midLengthY

            newJoinBox = dynamicJoinBox.createObject(parent, {x: rectX, y: rectY})
        }

        // Push the coordinates in the array
        frontRectangleCoordinates.push({x: rectLeftX, y: rectLeftY})
        rearRectangleCoordinates.push({x: rectRightX, y: rectRightY})
        existingTables.push(tableslist.tableName)
    }



    // Calculate distance between 2 points
    function distance(currentPoint, referencePoint) {
        return Math.pow((referencePoint.x - currentPoint.x), 2) + Math.pow((referencePoint.y - currentPoint.y), 2);
    }


    // Get the nearest rectangle when another rectangle is brought on stage
    function nearestRectangle(tmpRearRectangleCoordinates, currentPoint){

        var tmpArray = []


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

        // return table name & id
        return {"tableName" :existingTables[nearestIndex], tableId : nearestIndex}
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
            onEntered: onDropAreaEntered(drag)
            onExited: onDropAreaExited()
            onPositionChanged: onDropAreaPositionChanged(drag)
            onDropped: onDropAreaDropped(drag)
        }
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}
