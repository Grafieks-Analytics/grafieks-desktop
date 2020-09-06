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
    property int bufferHeight : 15 // distance between rectangle top to connectingLine point
    property int counter : 0
    property real droppedX : 0
    property real droppedY : 0
    property var frontRectangleCoordinates : new Map()
    property var rearRectangleCoordinates : new Map()
    property var existingTables : new Map()

    property var dynamicRectangle : Qt.createComponent("DroppedRectangle.qml");
    property var dynamicConnectorLine : Qt.createComponent("ConnectingLine.qml")
    property var dynamicJoinBox : Qt.createComponent("JoinBox.qml")

    property var newConnectingLine : new Map() // connectingLine object
    property var newJoinBox: new Map() // joinBox object btween 2 rectangles
    property var rectangles: new Map() // rectangle object
    property var frontRectLineMaps:new Map() // id of objects connected to rectangle front
    property var rearRectLineMaps:new Map() // id of objects connected to rectangle back

    property var tempRearRectLineMaps : [] // tmp id of objects connected to back of rectangle. used while processing

    property int refObject: 0
    property int refObjectWidth: 0



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


    // SLOT
    // Set the current selected rectangle
    function setRefObject(newRefObject, newRefObejectWidth){
        refObject = newRefObject
        refObjectWidth = newRefObejectWidth
    }

    // SLOT
    // Destroy Lines and JoinBox
    // When destroying main rectangle
    function destroyComponents(refObject){

        newConnectingLine.get(refObject).destroy();
        newJoinBox.get(refObject).destroy();

        rearRectLineMaps.get(refObject).forEach(function(value){
            newConnectingLine.get(value).destroy();
            newJoinBox.get(value).destroy();
        })
    }

    // New component on Dropped
    function onDropAreaDroppedNewComponent(x,y){
        console.log("Dropped" , x, y)
    }

    // New component on Entered
    function onDropAreaDraggedNewComponent(x,y){
        //        console.log("Dragging" , x, y, refObject)

        let rectLeftX = x
        let rectRightX = rectLeftX + refObjectWidth
        let rectLeftY = y
        let rectRightY = rectLeftY

        let frontVal = {x: rectLeftX, y: rectLeftY}
        let rearVal = {x: rectRightX, y: rectRightY}

        frontRectangleCoordinates.set(refObject, frontVal)
        rearRectangleCoordinates.set(refObject, rearVal)



        // Adjust the lines connected to the object front
        if(newConnectingLine.has(refObject)){
            newConnectingLine.get(refObject).incomingRectangleFrontX = x
            newConnectingLine.get(refObject).incomingRectangleFrontY = y + bufferHeight

            let frontVal = frontRectLineMaps.get(refObject)

            let tmpRearRectCoordinatesX = rearRectangleCoordinates.get(frontVal).x
            let tmpRearRectCoordinatesY = rearRectangleCoordinates.get(frontVal).y

            let diffX = Math.abs(rectLeftX - tmpRearRectCoordinatesX) /2
            let diffY = Math.abs(rectLeftY - tmpRearRectCoordinatesY) /2

            newJoinBox.get(refObject).x = rectLeftX <= tmpRearRectCoordinatesX ? ( rectLeftX +diffX ) : ( tmpRearRectCoordinatesX + diffX )
            newJoinBox.get(refObject).y = rectLeftY <= tmpRearRectCoordinatesY ? ( rectLeftY +diffY ) : ( tmpRearRectCoordinatesY + diffY )
        }


        // Adjust the lines connected to object rear
        // Also adjust the join objects
        if(rearRectLineMaps.has(refObject)){

            rearRectLineMaps.get(refObject).forEach(function(value, index){

                // Adjust the rear
                newConnectingLine.get(value).refRectangleRearX = x + refObjectWidth
                newConnectingLine.get(value).refRectangleRearY = y + bufferHeight

                let tmpFrontRectCoordinatesX = frontRectangleCoordinates.get(value).x
                let tmpFrontRectCoordinatesY = frontRectangleCoordinates.get(value).y

                let diffX = Math.abs(rectRightX - tmpFrontRectCoordinatesX) /2
                let diffY = Math.abs(rectRightY - tmpFrontRectCoordinatesY) /2

                newJoinBox.get(value).x = rectRightX <= tmpFrontRectCoordinatesX ? ( rectRightX +diffX ) : ( tmpFrontRectCoordinatesX + diffX )
                newJoinBox.get(value).y = rectRightY <= tmpFrontRectCoordinatesY ? ( rectRightY +diffY ) : ( tmpFrontRectCoordinatesY + diffY )
            })
        }

    }

    function onDropAreaPositionChanged(drag){

        // Show light shaded line between the current rectangle
        // and the nearest rectangle
        if(existingTables.size > 0){

            // Current reference Coordinate
            var currentPoint = {x: drag.x, y: drag.y};

            var nearestTable = nearestRectangle(rearRectangleCoordinates, currentPoint)

            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = rearRectangleCoordinates.get(nearestTable.tableId)
            newConnectingLine.get(counter).incomingRectangleFrontX = drag.x
            newConnectingLine.get(counter).incomingRectangleFrontY = drag.y + bufferHeight
            newConnectingLine.get(counter).refRectangleRearX = nearestRectangleCoordinates.x
            newConnectingLine.get(counter).refRectangleRearY = nearestRectangleCoordinates.y + bufferHeight
        }
    }

    function onDropAreaExited(){
        highlightRect.color = "white"

        newConnectingLine.get(counter).destroy()
    }

    function onDropAreaEntered(drag){

        highlightRect.color = Constants.dropAreaHighlightColor
        counter++

        // Show light shaded line between the current rectangle
        // and the nearest rectangle
        if(existingTables.size > 0){

            // Current reference Coordinate
            var currentPoint = {x: drag.x, y: drag.y};
            var nearestTable = nearestRectangle(rearRectangleCoordinates, currentPoint)

            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = rearRectangleCoordinates.get(nearestTable.tableId)

            // Add the line component on stage
            newConnectingLine.set(counter, dynamicConnectorLine.createObject(parent, {incomingRectangleFrontX:drag.x, incomingRectangleFrontY: drag.y, refRectangleRearX : nearestRectangleCoordinates.x, refRectangleRearY: nearestRectangleCoordinates.y, lineColor: "grey", objectName : counter}))

        }
    }

    function onDropAreaDropped(drag){

        // listView.model.remove(listView.dragItemIndex);
        // listView.dragItemIndex = -1;

        highlightRect.color = "white"

        // Assign new variable to the created object
        // Use this variable to connect the signals and slots
        rectangles.set(counter, dynamicRectangle.createObject(parent, {x:drag.x, y: drag.y, name: tableslist.tableName, objectName : counter}))

        rectangles.get(counter).dragged.connect(onDropAreaDraggedNewComponent)
//        rectangles.get(counter).dropped.connect(onDropAreaDroppedNewComponent)
        rectangles.get(counter).destroyComponents.connect(destroyComponents)
        rectangles.get(counter).refObjectCount.connect(setRefObject)

        // Created rectangle front & back coordinates
        var rectLeftX = drag.x
        var rectRightX = rectLeftX + tableslist.tableName.length * 10 + 30
        var rectLeftY = drag.y
        var rectRightY = rectLeftY


        // Current reference Coordinate
        var currentPoint = {x: rectLeftX, y: rectLeftY};


        // Get the nearest rectangle
        // And process the rest
        if(existingTables.size > 0){
            var nearestTable = nearestRectangle(rearRectangleCoordinates, currentPoint)

            //Change the line color to black
            newConnectingLine.get(counter).lineColor = "black"

            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = rearRectangleCoordinates.get(nearestTable.tableId)

            // Update the front and rear line arrays
            // Front will just have a single Connection
            // While back can have multiple connections
            frontRectLineMaps.set(counter, nearestTable.tableId)

            if(typeof rearRectLineMaps.get(nearestTable.tableId) !== "undefined"){
                tempRearRectLineMaps = rearRectLineMaps.get(nearestTable.tableId)
            }

            tempRearRectLineMaps.push(counter)

            rearRectLineMaps.set(nearestTable.tableId, tempRearRectLineMaps)

            // Reset temp array of the rear connections
            tempRearRectLineMaps = []


            // Draw a JoinBox
            var midLengthX = Math.abs(nearestRectangleCoordinates.x - currentPoint.x) / 2;
            var midLengthY = Math.abs(nearestRectangleCoordinates.y - currentPoint.y) / 2;

            var rectX = nearestRectangleCoordinates.x <= currentPoint.x ? nearestRectangleCoordinates.x + midLengthX : currentPoint.x + midLengthX
            var rectY = nearestRectangleCoordinates.y <= currentPoint.y ? nearestRectangleCoordinates.y + midLengthY : currentPoint.y + midLengthY

            newJoinBox.set(counter, dynamicJoinBox.createObject(parent, {x: rectX, y: rectY, objectName : counter}))

        }

        // Push the coordinates in the array
        frontRectangleCoordinates.set(counter, {x: rectLeftX, y: rectLeftY})
        rearRectangleCoordinates.set(counter, {x: rectRightX, y: rectRightY})
        existingTables.set(counter, tableslist.tableName)


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
        if(tmpRearRectangleCoordinates.size > 0){

            const mapIterator = tmpRearRectangleCoordinates[Symbol.iterator]();

            for (const item of mapIterator) {

                // calculate the distance b/w coordinates
                var newDistance = distance(currentPoint,item[1])
                tmpArray.push({"index": item[0], "coordinates" : item[1], "distance" : newDistance})
            }
        }

        // Sort all the coordinates based on distance
        // and find the nearest distance
        const sortByDistance = tmpArray.sort((a,b) => a.distance - b.distance).map((arr, distance, array) => arr.index)
        var nearestIndex = sortByDistance[0]

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
        z: 10

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
