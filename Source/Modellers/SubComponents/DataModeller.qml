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
import QtQuick.Dialogs 1.2


import com.grafieks.singleton.constants 1.0

import "../SubComponents"
import "../SubComponents/MiniSubComponents"




Item {


    id: dataModellerItem

    //    scale: Constants.scaleTable
    property int bufferHeight : 15 // distance between rectangle top to connectingLine point
    property int counter : 0
    property real droppedX : 0
    property real droppedY : 0
    property var frontRectangleCoordinates : new Map()
    property var rearRectangleCoordinates : new Map()
    property var existingTables : new Map()
    property var tmpNearestTable: {"tableId" : 0, "tableName" : ""} // 0 // for highlighting nearest rect when an orphan rectangle is moved
    property int tmpOrphanTableId:  0 // dragged orphan table id

    property var dynamicRectangle : Qt.createComponent("./MiniSubComponents/DroppedRectangle.qml");
    property var dynamicConnectorLine : Qt.createComponent("./MiniSubComponents/ConnectingLine.qml")
    property var dynamicJoinBox : Qt.createComponent("./MiniSubComponents/JoinBox.qml")

    property var newConnectingLine : new Map() // connectingLine object
    property var newJoinBox: new Map() // joinBox object btween 2 rectangles
    property var rectangles: new Map() // rectangle object
    property var frontRectLineMaps:new Map() // id of objects connected to rectangle front
    property var rearRectLineMaps:new Map() // id of objects connected to rectangle back

    property var tempRearRectLineMaps : [] // tmp id of objects connected to back of rectangle. used while processing

    property int refObject: 0
    property int refObjectWidth: 0
    readonly property string moduleName: "DataModeller"
    property string joinString: ""
    property int firstRectId : 0

    property var connectionType: Constants.sqlType
    property var query_joiner: ""




    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal changeGlowColor(string color, int tableId)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: ConnectorsLoginModel

        function onConnectedDBType(conType){

            if(conType === Constants.sqlType){
                connectionType = Constants.sqlType
            } else if(conType === Constants.duckType){
                connectionType = Constants.duckType
            } else{
                connectionType = Constants.forwardType
            }
        }

        // Query joiner

        function onMysqlLoginStatus(status){
            if(status.status === true){
                query_joiner = "`"
            }
        }
        function onMongoLoginStatus(status){
            if(status.status === true){
                query_joiner = "`"
            }
        }
        function onPostgresLoginStatus(status){
            if(status.status === true){
                query_joiner = "\""
            }
        }
        function onOracleLoginStatus(status){
            if(status.status === true){
                query_joiner = ""
            }
        }
        function onMssqlLoginStatus(status){
            if(status.status === true){
                query_joiner = "\""
            }
        }
        function onAccessLoginStatus(status){
            if(status.status === true){
                 query_joiner = "\""
            }
        }

        function onRedshiftLoginStatus(status){
            if(status.status === true){
                query_joiner = "\""
            }
        }
        function onTeradataLoginStatus(status){
            if(status.status === true){
                query_joiner = "\""
            }
        }

        function onSnowflakeLoginStatus(status){
            if(status.status === true){
                query_joiner = "\""
            }
        }

        function onSqliteLoginStatus(status){
            if(status.status === true){
                query_joiner = "`"
            }
        }

        function onExcelLoginStatus(status){
            if(status.status === true){
                query_joiner = "\""
            }
        }

        function onCsvLoginStatus(status){
            if(status.status === true){
                query_joiner = "\""
            }
        }

        function onJsonLoginStatus(status){
            if(status.status === true){
                query_joiner = "\""
            }
        }
    }


    Connections{
        target: NewTableColumnsModel

        function onColumnListObtained(allColumns, tableName, moduleName){

            if(moduleName === dataModellerItem.moduleName){
                allColumns.forEach(function(item, index){

                    let param = query_joiner + tableName + query_joiner + "." + query_joiner + item[0] + query_joiner
                    DSParamsModel.addToQuerySelectParamsList(param)
                })
            }
        }
    }


    Connections{
        target : DSParamsModel

        function onDestroyLocalObjectsAndMaps(){

            // Destroy dynamic objects
            rectangles.forEach(function(value, index){

                if(newConnectingLine.has(index)) newConnectingLine.get(index).destroy()
                if(newJoinBox.has(index)) newJoinBox.get(index).destroy()
                if(rectangles.has(index)) rectangles.get(index).destroy()
            })

            // Clear all maps
            frontRectangleCoordinates.clear()
            rearRectangleCoordinates.clear()
            existingTables.clear()
            newConnectingLine.clear()
            newJoinBox.clear()
            rectangles.clear()
            frontRectLineMaps.clear()
            rearRectLineMaps.clear()

            // Reset other variables
            tempRearRectLineMaps = []
            counter = 0
            tmpOrphanTableId = 0
        }

        // Delete select params, if signal received
        function onHideColumnsChanged(hideColumns){
            DSParamsModel.removeQuerySelectParamsList(hideColumns)
        }

        // Generate the dynamic query and run in on receiving the signal
        function onProcessQuery(){

            // STEPS
            // 1. check if more than 1 rects dont have any connections in front
            // 2. Identify the first rect
            // 3. Recrsive function to process the back connections and reorder them
            // 4. Write the function to create query
            // 5. Execute query

            var undefinedCounter = 0
            var firstRectId = 0
            dataModellerItem.rectangles.forEach(function(item, key){
                if(dataModellerItem.frontRectLineMaps.has(key) === false)
                    undefinedCounter++
            })

            // Check if the rectangles are connected to some rectangle in front (except the first one)
            // If not throw an error
            if(undefinedCounter <= 1){

                dataModellerItem.rectangles.forEach(function(item, key){
                    if(dataModellerItem.frontRectLineMaps.has(key) === false)
                        dataModellerItem.firstRectId  = key
                })

                // Call the function to process the rest of the query

                joinOrder(dataModellerItem.firstRectId )


            } else{
                // Throw an error here
                queryErrorModal.text = "JOIN is not complete"
                queryErrorModal.open();

            }
        }
    }


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
    // or destroying main rectangle
    function destroyComponents(refObject, depth){

        // IF the main object is deleted
        if(depth === "all"){

            rearRectLineMaps.get(refObject).forEach(function(value){
                newConnectingLine.get(value).destroy();
                newJoinBox.get(value).destroy();

                // Delete values from the map
                newConnectingLine.delete(value)
                newJoinBox.delete(value)

                // Delete from DSParamsModel
                DSParamsModel.removeJoinBoxTableMap(value)
                DSParamsModel.removeJoinIconMap(value)
                DSParamsModel.removeJoinTypeMap(value)
                DSParamsModel.removePrimaryJoinTable(value)
                DSParamsModel.removeJoinMapList(value, 0, true)
            })

        }

        // Destroy dynamically created components
        newConnectingLine.get(refObject).destroy();
        newJoinBox.get(refObject).destroy();

        // Delete values from the map
        newConnectingLine.delete(refObject)
        newJoinBox.delete(refObject)

        let frontItemOfConcernedRect = frontRectLineMaps.get(refObject)
        let rearItemsOfFrontRect = rearRectLineMaps.get(frontItemOfConcernedRect);

        let itemToRemoveFromRearRect = rearItemsOfFrontRect.indexOf(refObject)
        rearItemsOfFrontRect.splice(itemToRemoveFromRearRect, 1)

        frontRectLineMaps.delete(refObject);
        rearRectLineMaps.set(frontItemOfConcernedRect, rearItemsOfFrontRect);

        DSParamsModel.removeJoinBoxTableMap(refObject)
        DSParamsModel.removeJoinIconMap(refObject)
        DSParamsModel.removeJoinTypeMap(refObject)
        DSParamsModel.removePrimaryJoinTable(refObject)
        DSParamsModel.removeJoinMapList(refObject, 0, true)

    }


    // SLOT
    // Make a new join to orphan rectangle
    function createNewJoin(refObject, refObjectName){

        if(tmpOrphanTableId === refObject && tmpNearestTable.tableId > 0){

            // Get front coordinates of the orphan rectangle
            // Get the rear coordinates of the nearest rectangle

            let orphanX = frontRectangleCoordinates.get(tmpOrphanTableId).x
            let orphanY = frontRectangleCoordinates.get(tmpOrphanTableId).y
            let nearestX = rearRectangleCoordinates.get(tmpNearestTable.tableId).x
            let nearestY = rearRectangleCoordinates.get(tmpNearestTable.tableId).y

            // Get the center of the line for JoinBox
            let diffX = Math.abs(orphanX - nearestX) /2
            let diffY = Math.abs(orphanY - nearestY) /2

            let rectX = orphanX <= nearestX ? ( orphanX +diffX ) : ( nearestX + diffX )
            let rectY = orphanY <= nearestY ? ( orphanY +diffY ) : ( nearestY + diffY )

            // Add the line component on stage
            newConnectingLine.set(tmpOrphanTableId, dynamicConnectorLine.createObject(parent, {incomingRectangleFrontX:orphanX, incomingRectangleFrontY: orphanY, refRectangleRearX : nearestX, refRectangleRearY: nearestY, lineColor: "black", objectName : tmpOrphanTableId}))

            // Add joinBox
            newJoinBox.set(tmpOrphanTableId, dynamicJoinBox.createObject(parent, {x: rectX, y: rectY, objectName : tmpOrphanTableId}))

            // Connect join box destroy signal and slot
            newJoinBox.get(tmpOrphanTableId).destroyJoin.connect(destroyComponents)

            // Front Rectangle Line Maps
            frontRectLineMaps.set(tmpOrphanTableId, tmpNearestTable.tableId)

            // Rear Rectangle Line Maps
            let tmpArray = []
            if(typeof rearRectLineMaps.get(tmpNearestTable.tableId) !== "undefined" && rearRectLineMaps.get(tmpNearestTable.tableId).length > 0){
                tmpArray = rearRectLineMaps.get(tmpNearestTable.tableId)
            }
            tmpArray.push(tmpOrphanTableId)


            rearRectLineMaps.set(tmpNearestTable.tableId, tmpArray)

            // Reset glow color of nearest rectangle
            dataModellerItem.changeGlowColor("white", tmpNearestTable.tableId)
            dataModellerItem.changeGlowColor("white", tmpOrphanTableId)

            // Add to DSParamsModel
            DSParamsModel.addToJoinBoxTableMap(tmpOrphanTableId, refObjectName, tmpNearestTable.tableName)

            // Reset orphane and nearest tables
            tmpOrphanTableId = 0

            tmpNearestTable.tableId =  0
            tmpNearestTable.tableName =  ""
        }
    }


    // Set the join order for sql
    // Form the sql join statement
    function joinOrder(objId, recursion = false){

        var objArray = []
        var tmpArray = []
        var tmpJoinString = ""

        if(recursion === true) {
            objArray = objId
        }else{
            objArray.push(objId)
            DSParamsModel.addToJoinOrder(objId)
        }

        console.log(objArray, "OBJ ARRAY")
        objArray.forEach(function(item){
            if(dataModellerItem.rearRectLineMaps.has(item) === true){

                tmpArray = tmpArray.concat(dataModellerItem.rearRectLineMaps.get(item))


                tmpArray.forEach(function(innerItem){

                    DSParamsModel.addToJoinOrder(innerItem)

                    let joinType = DSParamsModel.fetchJoinTypeMap(innerItem)
                    let joinCompareTableName = DSParamsModel.fetchJoinBoxTableMap(innerItem)[1]
                    let joinCurrentTableName = DSParamsModel.fetchJoinBoxTableMap(innerItem)[2]
                    let joinConditions = DSParamsModel.fetchJoinMapList(innerItem)
                    let joinPrimaryJoinTable = DSParamsModel.fetchPrimaryJoinTable(innerItem)
                    let joinConditionsList = ""

                    tmpJoinString += "("

                    for (var i=0; i<Object.keys(joinConditions).length; i++){

                        let key = Object.keys(joinConditions)[i]
                        tmpJoinString += " " + query_joiner + joinCurrentTableName + query_joiner + "." + query_joiner+ joinConditions[key][1] + query_joiner + " = " + query_joiner + joinCompareTableName + query_joiner + "."  + query_joiner + joinConditions[key][0] + query_joiner+  " AND"
                    }

                    let lastIndex = tmpJoinString.lastIndexOf(" AND");
                    tmpJoinString = tmpJoinString.substring(0, lastIndex);
                    tmpJoinString += ")"

                    joinString += " " + joinType + " " + query_joiner + joinPrimaryJoinTable + query_joiner + " ON " + tmpJoinString

                    tmpJoinString = ""

                })


            }
        })

        objArray = tmpArray
        tmpArray = []

        // Call the recursive function till the end
        // Then generate the final query and execute it
        if(objArray.length > 0){
            joinOrder(objArray, true)

        } else{

            // Generate the final column parameters
            let selectColumns = ""
            let finalQuery = ""
            let hideColumns = DSParamsModel.fetchHideColumns()
            DSParamsModel.fetchQuerySelectParamsList().forEach(function(item){

                // Check if the column is unselected by a user
                if(hideColumns.indexOf(item.replace(/[\"'`]/g, '')) === -1)
                    selectColumns += " " + item + ","
            })



            let lastIndex = selectColumns.lastIndexOf(",");
            selectColumns = selectColumns.substring(0, lastIndex);

            finalQuery = "SELECT " + selectColumns + " FROM " + query_joiner + existingTables.get(dataModellerItem.firstRectId) + query_joiner + " " + joinString

            // Call and execute the query
            DSParamsModel.setTmpSql(finalQuery)

            if(connectionType === Constants.sqlType){
                console.log("QUERY set QUERYMODEL", DSParamsModel.tmpSql)
                QueryModel.callSql(DSParamsModel.tmpSql)
            } else if(connectionType === Constants.duckType){
                console.log("QUERY set DUCKQUERYMODEL", DSParamsModel.tmpSql)
                DuckQueryModel.setQuery(DSParamsModel.tmpSql)
            } else{
                console.log("QUERY set FORWARDONLYQUERYMODEL", DSParamsModel.tmpSql)
                ForwardOnlyQueryModel.setQuery(DSParamsModel.tmpSql)
            }

            TableSchemaModel.showSchema(DSParamsModel.tmpSql)
        }

        joinString = ""

    }


    // New component on Entered
    function onDropAreaDraggedNewComponent(x,y){


        let rectLeftX = x
        let rectRightX = rectLeftX + refObjectWidth
        let rectLeftY = y
        let rectRightY = rectLeftY

        var frontVal = {x: rectLeftX, y: rectLeftY}
        var rearVal = {x: rectRightX, y: rectRightY}

        frontRectangleCoordinates.set(refObject, frontVal)
        rearRectangleCoordinates.set(refObject, rearVal)


        // This block is for orphan rectangles and when they are brought near other rectangle
        // to create new joins

        // if its not the first dragged rectangle
        // and if the moved rectangle doesnot have any connections to other objects
        if(typeof refObject !== "undefined" && frontRectLineMaps.has(refObject) === false){

            var nearestTable = nearestRectangle(rearRectangleCoordinates, frontVal)

            if(nearestTable.tableId !== refObject){

                // Check if the nearest rectangle is not already connected to the current one
                let ifRearRelationExists = false
                let ifFrontRelationExists = false

                if(typeof rearRectLineMaps.get(refObject) !== "undefined"){
                    rearRectLineMaps.get(refObject).every(function(item){

                        if(item === nearestTable.tableId){
                            ifRearRelationExists = true;
                            return false
                        }
                        return true
                    })

                }


                // check for front relations
                if(ifRearRelationExists === false){
                    if(frontRectLineMaps.get(refObject) === nearestTable.tableId){
                        ifFrontRelationExists = true
                    }
                }

                // Check if any relation exists
                if(ifRearRelationExists === false && ifFrontRelationExists === false){

                    if(nearestTable.distance <= 100){

                        if(tmpNearestTable.tableId !== nearestTable.tableId){
                            dataModellerItem.changeGlowColor("white", tmpNearestTable.tableId)
                        }

                        // Set the temporary nearest table
                        tmpNearestTable.tableId = nearestTable.tableId
                        tmpNearestTable.tableName = nearestTable.tableName

                        tmpOrphanTableId = refObject


                        dataModellerItem.changeGlowColor(Constants.grafieksLightGreenColor, tmpNearestTable.tableId)
                        dataModellerItem.changeGlowColor(Constants.grafieksLightGreenColor, refObject)

                    } else{
                        dataModellerItem.changeGlowColor("white", tmpNearestTable.tableId)
                        dataModellerItem.changeGlowColor("white", refObject)

                        // Reset tmpNearestTable
                        tmpNearestTable.tableId = 0
                        tmpNearestTable.tableName =  ""
                    }
                }
            }
        }


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

        //        TODO white
        highlightRect.color = "white"
        droppedCount = droppedCount+1
        console.log("droppedCount"+droppedCount)

        // Assign new variable to the created object
        // Use this variable to connect the signals and slots
        rectangles.set(counter, dynamicRectangle.createObject(parent, {x:drag.x, y: drag.y, name: tableslist.tableName, objectName : counter, glowColor: "white"}))

        rectangles.get(counter).dragged.connect(onDropAreaDraggedNewComponent)
        rectangles.get(counter).destroyComponents.connect(destroyComponents)
        rectangles.get(counter).refObjectCount.connect(setRefObject)
        rectangles.get(counter).createNewJoin.connect(createNewJoin)
        dataModellerItem.changeGlowColor.connect(rectangles.get(counter).slotDisplayColor)


        // Created rectangle front & back coordinates
        var rectLeftX = drag.x
        var rectRightX = rectLeftX + tableslist.tableName.length * 10 + 30
        var rectLeftY = drag.y
        var rectRightY = rectLeftY


        // Current reference Coordinate
        var currentPoint = {x: rectLeftX, y: rectLeftY};

        // Get Column names of the table
        NewTableColumnsModel.getColumnsForTable(tableslist.tableName, dataModellerItem.moduleName)



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

            // Connect join box destroy signal and slot
            newJoinBox.get(counter).destroyJoin.connect(destroyComponents)

            // Save the Join Box Table map for join manipulation later
            DSParamsModel.addToJoinBoxTableMap(counter, nearestTable.tableName, tableslist.tableName)

        }

        // Push the coordinates in the array
        frontRectangleCoordinates.set(counter, {x: rectLeftX, y: rectLeftY})
        rearRectangleCoordinates.set(counter, {x: rectRightX, y: rectRightY})
        existingTables.set(counter, tableslist.tableName)
    }



    // Calculate distance between 2 points
    function distance(currentPoint, referencePoint) {
        return Math.sqrt(Math.pow((referencePoint.x - currentPoint.x), 2) + Math.pow((referencePoint.y - currentPoint.y), 2));
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
        const sortByDistance = tmpArray.sort((a,b) => a.distance - b.distance).map((arr, distance, array) => arr)
        var nearestIndex = sortByDistance[0].index
        var nearestDistance = sortByDistance[0].distance

        // return table name & id
        return {"tableName" :existingTables.get(nearestIndex), tableId : nearestIndex, distance : nearestDistance}
    }

    // Create sql from the visual Data modeller
    // and execute query
    function executeSql(){

        if(connectionType === Constants.sqlType){
            QueryModel.callSql(DSParamsModel.tmpSql)
        } else if(connectionType === Constants.duckType){
            console.log("QUERY exe", DSParamsModel.tmpSql)
            DuckQueryModel.setQuery(DSParamsModel.tmpSql)
        } else{
            ForwardOnlyQueryModel.setQuery(DSParamsModel.tmpSql)
        }
    }


    function onZoomOutClicked(){
        console.log('Zoom Out')
        //        highlightRect.height =  highlightRect.height-5
        //        highlightRect.width =  highlightRect.width-10

        //            highlightRect.scale -= 0.2;
        //         Constants.Constants -= 0.2;
        //        outer.height = outer.height-10;
        //        outer.width = outer.width-10;


        Constants.scaleTable = Qt.binding(function(){
            return Constants.scaleTable-0.2 })


        //        Constants.newPosition = Constants.newPosition + 8


    }

    function onZoomInClicked(){
        console.log('Zoom In')
        //        highlightRect.height =  highlightRect.height+5
        //        highlightRect.width =  highlightRect.width+5

        //          highlightRect.scale += 0.2;
        //        Constants.Constants += 0.2;

        //        outer.height = outer.height+10
        //        outer.width = outer.width+10
        Constants.scaleTable = Qt.binding(function(){

            return Constants.scaleTable+0.2 })

        //        Constants.newPosition = Constants.newPosition - 8


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

                source: "/Images/icons/align.png"
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

            ToolTip.delay: Constants.tooltipShowTime
            ToolTip.timeout: Constants.tooltipHideTime
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Restore original")

        }

        Button{
            id:plus_icon_btn
            width: 30
            height: 30
            Image{
                id: plus_icon
                source: "/Images/icons/Plus_32.png"
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

            ToolTip.delay: Constants.tooltipShowTime
            ToolTip.timeout: Constants.tooltipHideTime
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Zoom in")


        }

        Button{
            id:minus_icon_btn
            width: 30
            height: 30
            Image{
                id: minus_icon
                source: "/Images/icons/zoom out.png"
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

            ToolTip.delay: Constants.tooltipShowTime
            ToolTip.timeout: Constants.tooltipHideTime
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Zoom out")
        }

    }
    Rectangle{
        id:outer
        height: parent.height
        width: parent.width
        //             scale: Constants.scaleTable

        Flickable {
            id: flickArea
            anchors {fill: parent; margins: 0; }
            contentWidth: highlightRect.width* Constants.scaleTable
            contentHeight: highlightRect.height* Constants.scaleTable


            Rectangle {
                id: highlightRect
                transformOrigin: Item.TopLeft
                x: 0; y: 0;
                width: outer.width;
                height: outer.height;
                //                                           color: "lightblue"

                Rectangle {
                    id: inner
                    anchors { fill: parent; margins: 10; }
                    //                                               color: "yellow"
                    DropArea {
                        id: dropArea
                        scale: highlightRect.scale
                        anchors.fill: parent
                        onEntered: onDropAreaEntered(drag)
                        onExited: onDropAreaExited()
                        onPositionChanged: onDropAreaPositionChanged(drag)
                        onDropped: onDropAreaDropped(drag)
                    }
                }
            }

        }


        //    Rectangle{
        //        id:highlightRect
        //        height: parent.height
        //        width: parent.width
        //        color: "red"



        //        Flickable {
        //                          id: flickArea
        //                          anchors {fill: parent; margins: 0; }
        //                          contentWidth: rect.width*rect.scale
        //                          contentHeight: rect.height*rect.scale

        //                          Rectangle {
        //                              id: rect
        //                              transformOrigin: Item.TopLeft
        //                              x: 0; y: 0;
        //                              width: highlightRect.width;
        //                              height: highlightRect.height;
        //                              color: "transparent"

        //                              Rectangle {
        //                                  id: inner
        //                                  anchors { fill: parent; margins: 10; }
        //                                  color: "yellow"
        //                                  DropArea {
        //                                      id: dropArea
        ////                                      scale: highlightRect.scale
        //                                      anchors.fill: parent
        //                                      onEntered: onDropAreaEntered(drag)
        //                                      onExited: onDropAreaExited()
        //                                      onPositionChanged: onDropAreaPositionChanged(drag)
        //                                      onDropped: onDropAreaDropped(drag)
        //                                  }
        //                              }
        //                          }
        //                      }


        //                   Button {
        //                       anchors.bottom: parent.bottom;
        ////                       anchors.horizontalCenter: parent.horizontalCenter;
        //                       text: "Scale flickArea"
        //                       onClicked: {
        //                           rect.scale -= 0.2;
        //                           abc.scale -= 0.2;
        //                       }

        //                   }
        //                   Button {
        //                       anchors.bottom: parent.bottom;
        //                       anchors.horizontalCenter: parent.horizontalCenter;
        //                       text: "Scale + flickArea"
        //                       onClicked: {
        //                           rect.scale += 0.2;
        //                       }

        //                   }

        //        Rectangle {
        //               anchors.fill: parent/5
        //               color: "green"

        //               Flickable {
        //                   id: flickArea
        //                   anchors {fill: parent; margins: 10; }
        //                   contentWidth: rect.width*rect.scale
        //                   contentHeight: rect.height*rect.scale
        //                   Rectangle {
        //                       id: rect
        //                       transformOrigin: Item.TopLeft
        //                       x: 0; y: 0;
        //                       width: 200; height: 300;
        //                       color: "lightgrey"

        //                       Rectangle {
        //                           id: inner
        //                           anchors { fill: parent; margins: 10; }
        //                           color: "red"
        //                       }
        //                   }
        //               }
        //           }
        //           Button {
        //               anchors.bottom: parent.bottom;
        //               anchors.horizontalCenter: parent.horizontalCenter;
        //               text: "Scale flickArea"
        //               onClicked: {
        //                   rect.scale -= 0.2;
        //               }
        //           }

        //        Flickable {
        //                id: flick
        //                anchors.fill: parent
        //                contentWidth: 500
        //                contentHeight: 500


        //                PinchArea {
        //                    width: Math.max(flick.contentWidth, flick.width)
        //                    height: Math.max(flick.contentHeight, flick.height)



        //                    property real initialWidth
        //                    property real initialHeight
        //                    property real initialTesteX
        //                    property real initialTesteY
        //                    onPinchStarted: {
        //                        initialWidth = flick.contentWidth
        //                        initialHeight = flick.contentHeight
        //                        initialTesteX = marker.canvasX
        //                        initialTesteY = marker.canvasY
        //                    }

        //                    onPinchUpdated: {
        //                        // adjust content pos due to drag
        //                        flick.contentX += pinch.previousCenter.x - pinch.center.x
        //                        flick.contentY += pinch.previousCenter.y - pinch.center.y

        //                        // resize content
        //                        flick.resizeContent(initialWidth * pinch.scale, initialHeight * pinch.scale, pinch.center)
        //                        marker.canvasX = initialTesteX*(pinch.scale)
        //                        marker.canvasY = initialTesteY*(pinch.scale)

        //                    }

        //                    onPinchFinished: {
        //                        // Move its content within bounds.
        //                        flick.returnToBounds()
        //                    }

        //                    Canvas {
        //                        id: marker
        //                        anchors {
        //                            top: parent.top
        //                            left: parent.left
        //                            margins: 4
        //                        }
        //                        z: 100
        //                        property real canvasX: 341
        //                        property real canvasY: 330

        //                        width: flick.contentWidth
        //                        height: flick.contentHeight

        //                        antialiasing: true
        //                        transformOrigin: Item.TopLeft

        //                        onPaint: {
        //                            var ctx = getContext( "2d" );
        //                            ctx.save();
        //                            ctx.clearRect( 0, 0, width, height );
        //                            ctx.lineWidth = 2;
        //                            ctx.beginPath();
        //                            ctx.strokeStyle = "blue"
        //                            ctx.arc(canvasX,
        //                                    canvasY,
        //                                    6,
        //                                    0,
        //                                    Math.PI * 2 );
        //                            ctx.stroke();
        //                            ctx.restore();
        //                        }
        //                    }
        //                }
        //        }




    }



    // Page Design Ends
    /***********************************************************************************************************************/

    MessageDialog{
        id: queryErrorModal

        modality: Qt.ApplicationModal
        title: "Query Error"
        standardButtons: StandardButton.Close
    }
}
