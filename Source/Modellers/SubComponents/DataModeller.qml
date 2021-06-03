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
    property var tmpNearestTable: {"tableId" : 0, "tableName" : ""} // 0 // for highlighting nearest rect when an orphan rectangle is moved
    property int tmpOrphanTableId:  1 // dragged orphan table id

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
    property int firstRectId : 1



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

        // Query joiner

        function onMysqlLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("`")
            }
        }
        function onMongoLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("`")
            }
        }
        function onPostgresLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }
        function onOracleLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("")
            }
        }
        function onMssqlLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }
        function onAccessLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }

        function onRedshiftLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }
        function onTeradataLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }

        function onSnowflakeLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }

        function onSqliteLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("`")
            }
        }

        function onExcelLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }

        function onCsvLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }

        function onJsonLoginStatus(status){
            if(status.status === true){
                DSParamsModel.setQueryJoiner("\"")
            }
        }
    }


    Connections{
        target: NewTableColumnsModel

        function onColumnListObtained(allColumns, tableName, moduleName){

            if(moduleName === dataModellerItem.moduleName){
                allColumns.forEach(function(item, index){

                    let param = DSParamsModel.queryJoiner + tableName + DSParamsModel.queryJoiner + "." + DSParamsModel.queryJoiner + item[0] + DSParamsModel.queryJoiner
                    DSParamsModel.addToQuerySelectParamsList(param)
                })
            }
        }
    }


    Connections{
        target : DSParamsModel

        function onDestroyLocalObjectsAndMaps(){
            deleteAll()
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

            // DSParams rectangle
            var rectangleObjectsSize = DSParamsModel.rectanglesSize()
            var lineObjectsSize = DSParamsModel.linesSize()
            var rectangleObjectKeys = DSParamsModel.fetchAllRectangleKeys()
            var newLineObjectKeys = DSParamsModel.fetchAllLineKeys()


            // Check if the rectangles are connected to some rectangle in front (except the first one)
            // If not throw an error
            if(rectangleObjectsSize - lineObjectsSize === 1){

                var firstRectArr = rectangleObjectKeys.filter(x => newLineObjectKeys.indexOf(x) === -1)
                firstRectId = firstRectArr[0]
                // Call the function to process the rest of the query
                joinOrder(firstRectId )


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

        // Delete cases

        // a. If "all" selected, delete these 9 components
        // 1. Main rect (deleted the object in DroppedRectangle.qml)
        // 2. Rect back
        // 3. Rect front
        // 4. Rect Front map
        // 5. Rect Back map
        // 6. Immediately behind line
        // 7. Immediately behind join box
        // 8. Immediately behind rect front map
        // 9. Immediately front line
        // 10. Immediately front join box
        // 11. Immediately front rect back map

        // b. Else if only joinbox deleted, delete these 4 components
        // 1. Line
        // 2. Join box
        // 3. Main rect front map
        // 4. Front rect back map

        // IF the main object is deleted
        if(depth === "all"){

            // Delete rectangle front and back coordinates. Also delete the rectangle
            // a.1.Main rect(value)
            // a.2.Rect front
            // a.3.Rect back
            if(DSParamsModel.fetchRectangles(refObject) !== ""){

                // Ensure that deleted tables are not reflected in generated query later
                let dynamicObjectName =  DSParamsModel.queryJoiner + DSParamsModel.fetchRectangles(refObject).name + DSParamsModel.queryJoiner + "."
                DSParamsModel.removeQuerySelectParamsList(dynamicObjectName, true)

                DSParamsModel.removeRectangles(refObject);
                DSParamsModel.removeFrontRectangleCoordinates(refObject)
                DSParamsModel.removeRearRectangleCoordinates(refObject)
                DSParamsModel.removeExistingTables(refObject)
            }


            if(typeof DSParamsModel.fetchRearLineMap(refObject) !== "undefined"){
                DSParamsModel.fetchRearLineMap(refObject).forEach(function(value){

                    // a.6.Immediately behind line (delete object and map value)
                    // a.7.Immediately behind join box (delete object and map value)
                    // Delete object
                    DSParamsModel.fetchNewConnectingLine(value).destroy();
                    DSParamsModel.fetchNewJoinBox(value).destroy();

                    // Delete values from the map
                    DSParamsModel.removeNewConnectingLine(value)
                    DSParamsModel.removeNewJoinBox(value)


                    // a.8.Immediately behind rect front map
                    DSParamsModel.removeFrontLineMap((value))

                    // Delete from DSParamsModel
                    DSParamsModel.removeJoinBoxTableMap(value)
                    DSParamsModel.removeJoinIconMap(value)
                    DSParamsModel.removeJoinTypeMap(value)
                    DSParamsModel.removePrimaryJoinTable(value)
                    DSParamsModel.removeJoinMapList(value, 0, true)

                })

                // a.5.Rect Back map
                DSParamsModel.removeRearLineMap(refObject)
            }
        }

        // Delete front line and joinbox (object and values)
        // a.9 | b.1.Immediately front line
        // a.10 | b.2.Immediately front join box
        // Destroy dynamically created components
        if(typeof DSParamsModel.fetchNewConnectingLine(refObject) !== "undefined")
            DSParamsModel.fetchNewConnectingLine(refObject).destroy();

        if(typeof DSParamsModel.fetchNewJoinBox(refObject) !== "undefined")
            DSParamsModel.fetchNewJoinBox(refObject).destroy();

        // Delete values from the map
        if(typeof DSParamsModel.fetchNewConnectingLine(refObject) !== "undefined")
            DSParamsModel.removeNewConnectingLine(refObject)

        if(typeof DSParamsModel.fetchNewJoinBox(refObject) !== "undefined")
            DSParamsModel.removeNewJoinBox(refObject)


        // a.11 | b.3.Immediately front rect back map
        if(typeof DSParamsModel.fetchFrontLineMap(refObject) !== "undefined"){
            let frontItemOfConcernedRect = DSParamsModel.fetchFrontLineMap(refObject)
            let rearItemsOfFrontRect = DSParamsModel.fetchRearLineMap(frontItemOfConcernedRect);

            let itemToRemoveFromRearRect = rearItemsOfFrontRect.indexOf(refObject)
            rearItemsOfFrontRect.splice(itemToRemoveFromRearRect, 1)

            DSParamsModel.addToRearLineMap(frontItemOfConcernedRect, rearItemsOfFrontRect);
        }

        // a.4 | b.4 Rect front map
        //        if(frontRectLineMaps.has(refObject))
        DSParamsModel.removeFrontLineMap(refObject);


        DSParamsModel.removeJoinBoxTableMap(refObject)
        DSParamsModel.removeJoinIconMap(refObject)
        DSParamsModel.removeJoinTypeMap(refObject)
        DSParamsModel.removeJoinMapList(refObject, 0, true)
    }


    // SLOT
    // Make a new join to orphan rectangle
    function createNewJoin(refObject, refObjectName){

        if(tmpOrphanTableId === refObject && tmpNearestTable.tableId > 0){

            // Get front coordinates of the orphan rectangle
            // Get the rear coordinates of the nearest rectangle

            let orphanX = DSParamsModel.fetchFrontRectangleCoordinates(tmpOrphanTableId).x
            let orphanY = DSParamsModel.fetchFrontRectangleCoordinates(tmpOrphanTableId).y
            let nearestX = DSParamsModel.fetchRearRectangleCoordinates(tmpNearestTable.tableId).x
            let nearestY = DSParamsModel.fetchRearRectangleCoordinates(tmpNearestTable.tableId).y

            // Get the center of the line for JoinBox
            let diffX = Math.abs(orphanX - nearestX) /2
            let diffY = Math.abs(orphanY - nearestY) /2

            let rectX = orphanX <= nearestX ? ( orphanX +diffX ) : ( nearestX + diffX )
            let rectY = orphanY <= nearestY ? ( orphanY +diffY ) : ( nearestY + diffY )

            // Add the line component on stage
            DSParamsModel.addToNewConnectingLine(tmpOrphanTableId, dynamicConnectorLine.createObject(parent, {incomingRectangleFrontX:orphanX, incomingRectangleFrontY: orphanY + bufferHeight, refRectangleRearX : nearestX, refRectangleRearY: nearestY + bufferHeight, lineColor: "black", objectName : tmpOrphanTableId}))

            // Add joinBox
            DSParamsModel.addToNewJoinBox(tmpOrphanTableId, dynamicJoinBox.createObject(parent, {x: rectX, y: rectY, objectName : tmpOrphanTableId}))

            // Connect join box destroy signal and slot
            DSParamsModel.fetchNewJoinBox(tmpOrphanTableId).destroyJoin.connect(destroyComponents)


            // Front Rectangle Line Maps
            DSParamsModel.addToFrontLineMap(tmpOrphanTableId, tmpNearestTable.tableId)

            // Rear Rectangle Line Maps
            let tmpArray = []
            if(typeof DSParamsModel.fetchRearLineMap(tmpNearestTable.tableId) !== "undefined" && DSParamsModel.fetchRearLineMap(tmpNearestTable.tableId).length > 0){
                tmpArray = DSParamsModel.fetchRearLineMap(tmpNearestTable.tableId)
            }
            tmpArray.push(tmpOrphanTableId)

            DSParamsModel.addToRearLineMap(tmpNearestTable.tableId, tmpArray)

            // Reset glow color of nearest rectangle
            dataModellerItem.changeGlowColor(Constants.defaultDroppedRectangleColor, tmpNearestTable.tableId)
            dataModellerItem.changeGlowColor(Constants.defaultDroppedRectangleColor, tmpOrphanTableId)

            // Add to DSParamsModel
            DSParamsModel.addToJoinBoxTableMap(tmpOrphanTableId, refObjectName, tmpNearestTable.tableName)
            DSParamsModel.addToPrimaryJoinTable(tmpOrphanTableId, refObjectName)

            // Popup join details
            showJoinPopup(tmpOrphanTableId)

            // Reset orphane and nearest tables
            tmpOrphanTableId = 0

            tmpNearestTable.tableId =  0
            tmpNearestTable.tableName =  ""


        }
    }


    // Destroy components and maps
    function deleteAll(){
        // Destroy dynamic objects

        var rectangleObjects = DSParamsModel.fetchAllRectangles()

        for (var prop in rectangleObjects) {
            if(typeof DSParamsModel.fetchFrontRectangleCoordinates(prop) !== "undefined"){
                if(typeof DSParamsModel.fetchNewConnectingLine(prop) !== "undefined") DSParamsModel.fetchNewConnectingLine(prop).destroy()
                if(typeof DSParamsModel.fetchNewJoinBox(prop) !== "undefined") DSParamsModel.fetchNewJoinBox(prop).destroy()
                if(typeof DSParamsModel.fetchRectangles(prop) !== "undefined") DSParamsModel.fetchRectangles(prop).destroy()

            }
        }

        // Reset other variables
        tempRearRectLineMaps = []
        counter = 0
        tmpOrphanTableId = 1
        firstRectId = 1
    }

    // Display join popup
    function showJoinPopup(counter){

        // Set joinId. Required to get value from Map() in the parent component
        DSParamsModel.setJoinId(counter)
        joinPopup.visible = true
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


        objArray.forEach(function(item){

            if(typeof DSParamsModel.fetchRearLineMap(item) !== "undefined"){

                tmpArray = tmpArray.concat(DSParamsModel.fetchRearLineMap(item))


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
                        tmpJoinString += " " + DSParamsModel.queryJoiner + joinCurrentTableName + DSParamsModel.queryJoiner + "." + DSParamsModel.queryJoiner+ joinConditions[key][1] + DSParamsModel.queryJoiner + " = " + DSParamsModel.queryJoiner + joinCompareTableName + DSParamsModel.queryJoiner + "."  + DSParamsModel.queryJoiner + joinConditions[key][0] + DSParamsModel.queryJoiner+  " AND"
                    }

                    let lastIndex = tmpJoinString.lastIndexOf(" AND");
                    tmpJoinString = tmpJoinString.substring(0, lastIndex);
                    tmpJoinString += ")"

                    joinString += " " + joinType + " " + DSParamsModel.queryJoiner + joinPrimaryJoinTable + DSParamsModel.queryJoiner + " ON " + tmpJoinString

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

            finalQuery = "SELECT " + selectColumns + " FROM " + DSParamsModel.queryJoiner + DSParamsModel.fetchExistingTables(firstRectId) + DSParamsModel.queryJoiner + " " + joinString

            // Call and execute the query
            DSParamsModel.setTmpSql(finalQuery)

            if(GeneralParamsModel.getDbClassification() === Constants.sqlType){
                console.log("QUERY set QUERYMODEL", DSParamsModel.tmpSql)
                QueryModel.callSql(DSParamsModel.tmpSql)
            } else if(GeneralParamsModel.getDbClassification() === Constants.duckType){
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

        DSParamsModel.addToFrontRectangleCoordinates(refObject, frontVal)
        DSParamsModel.addToRearRectangleCoordinates(refObject, rearVal)

        // This block is for orphan rectangles and when they are brought near other rectangle
        // to create new joins

        // if its not the first dragged rectangle
        // and if the moved rectangle doesnot have any connections to other objects
        if(typeof refObject !== "undefined" && typeof DSParamsModel.fetchFrontLineMap(refObject) === "undefined"){

            var nearestTable = nearestRectangle(DSParamsModel.fetchAllRearRectangleCoordinates(), frontVal)

            if(nearestTable.tableId !== refObject){

                // Check if the nearest rectangle is not already connected to the current one
                let ifRearRelationExists = false
                let ifFrontRelationExists = false

                if(typeof DSParamsModel.fetchRearLineMap(refObject) !== "undefined"){
                    DSParamsModel.fetchRearLineMap(refObject).every(function(item){

                        if(item === nearestTable.tableId){
                            ifRearRelationExists = true;
                            return false
                        }
                        return true
                    })

                }


                // check for front relations
                if(ifRearRelationExists === false){
                    if(DSParamsModel.fetchFrontLineMap(refObject) === nearestTable.tableId){
                        ifFrontRelationExists = true
                    }
                }

                // Check if any relation exists
                if(ifRearRelationExists === false && ifFrontRelationExists === false){

                    if(nearestTable.distance <= 100){

                        if(tmpNearestTable.tableId !== nearestTable.tableId){
                            dataModellerItem.changeGlowColor(Constants.defaultDroppedRectangleColor, tmpNearestTable.tableId)
                        }

                        // Set the temporary nearest table
                        tmpNearestTable.tableId = nearestTable.tableId
                        tmpNearestTable.tableName = nearestTable.tableName

                        tmpOrphanTableId = refObject


                        dataModellerItem.changeGlowColor(Constants.grafieksLightGreenColor, tmpNearestTable.tableId)
                        dataModellerItem.changeGlowColor(Constants.grafieksLightGreenColor, refObject)

                    } else{
                        dataModellerItem.changeGlowColor(Constants.defaultDroppedRectangleColor, tmpNearestTable.tableId)
                        dataModellerItem.changeGlowColor(Constants.defaultDroppedRectangleColor, refObject)

                        // Reset tmpNearestTable
                        tmpNearestTable.tableId = 0
                        tmpNearestTable.tableName =  ""
                    }
                }
            }
        }


        // Adjust the lines connected to the object front
        if(typeof DSParamsModel.fetchNewConnectingLine(refObject) !== "undefined"){
            DSParamsModel.fetchNewConnectingLine(refObject).incomingRectangleFrontX = x
            DSParamsModel.fetchNewConnectingLine(refObject).incomingRectangleFrontY = y + bufferHeight

            let frontVal = DSParamsModel.fetchFrontLineMap(refObject)

            let tmpRearRectCoordinatesX = DSParamsModel.fetchRearRectangleCoordinates(frontVal).x
            let tmpRearRectCoordinatesY = DSParamsModel.fetchRearRectangleCoordinates(frontVal).y

            let diffX = Math.abs(rectLeftX - tmpRearRectCoordinatesX) /2
            let diffY = Math.abs(rectLeftY - tmpRearRectCoordinatesY) /2

            DSParamsModel.fetchNewJoinBox(refObject).x = rectLeftX <= tmpRearRectCoordinatesX ? ( rectLeftX + diffX - Constants.joinBoxWidth ) : ( tmpRearRectCoordinatesX + diffX - Constants.joinBoxWidth )
            DSParamsModel.fetchNewJoinBox(refObject).y = rectLeftY <= tmpRearRectCoordinatesY ? ( rectLeftY + diffY  ) : ( tmpRearRectCoordinatesY + diffY )

        }


        // Adjust the lines connected to object rear
        // Also adjust the join objects
        if(DSParamsModel.fetchRearLineMap(refObject)){


            DSParamsModel.fetchRearLineMap(refObject).forEach(function(value, index){

                // Adjust the rear
                DSParamsModel.fetchNewConnectingLine(value).refRectangleRearX = x + refObjectWidth
                DSParamsModel.fetchNewConnectingLine(value).refRectangleRearY = y + bufferHeight

                let tmpFrontRectCoordinatesX = DSParamsModel.fetchFrontRectangleCoordinates(value).x
                let tmpFrontRectCoordinatesY = DSParamsModel.fetchFrontRectangleCoordinates(value).y

                let diffX = Math.abs(rectRightX - tmpFrontRectCoordinatesX) /2
                let diffY = Math.abs(rectRightY - tmpFrontRectCoordinatesY) /2

                DSParamsModel.fetchNewJoinBox(value).x = rectRightX <= tmpFrontRectCoordinatesX ? ( rectRightX +diffX - Constants.joinBoxWidth ) : ( tmpFrontRectCoordinatesX + diffX - Constants.joinBoxWidth)
                DSParamsModel.fetchNewJoinBox(value).y = rectRightY <= tmpFrontRectCoordinatesY ? ( rectRightY +diffY ) : ( tmpFrontRectCoordinatesY + diffY )
            })
        }

    }

    function onDropAreaPositionChanged(drag){

        // Show light shaded line between the current rectangle
        // and the nearest rectangle
        if(DSParamsModel.existingTablesSize() > 0){

            // Current reference Coordinate
            var currentPoint = {x: drag.x, y: drag.y};

            var nearestTable = nearestRectangle(DSParamsModel.fetchAllRearRectangleCoordinates(), currentPoint)


            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = DSParamsModel.fetchRearRectangleCoordinates(nearestTable.tableId)
            DSParamsModel.fetchNewConnectingLine(counter).incomingRectangleFrontX = drag.x
            DSParamsModel.fetchNewConnectingLine(counter).incomingRectangleFrontY = drag.y + bufferHeight
            DSParamsModel.fetchNewConnectingLine(counter).refRectangleRearX = nearestRectangleCoordinates.x
            DSParamsModel.fetchNewConnectingLine(counter).refRectangleRearY = nearestRectangleCoordinates.y + bufferHeight
        }
    }

    function onDropAreaExited(){
        highlightRect.color = "white"

        DSParamsModel.fetchNewConnectingLine(counter).destroy()
    }

    function onDropAreaEntered(drag){

        highlightRect.color = Constants.dropAreaHighlightColor
        counter++

        // Show light shaded line between the current rectangle
        // and the nearest rectangle
        if(DSParamsModel.existingTablesSize() > 0){


            // Current reference Coordinate
            var currentPoint = {x: drag.x, y: drag.y};
            var nearestTable = nearestRectangle(DSParamsModel.fetchAllRearRectangleCoordinates(), currentPoint)

            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = DSParamsModel.fetchRearRectangleCoordinates(nearestTable.tableId)

            // Add the line component on stage
            DSParamsModel.addToNewConnectingLine(counter, dynamicConnectorLine.createObject(parent, {incomingRectangleFrontX:drag.x, incomingRectangleFrontY: drag.y, refRectangleRearX : nearestRectangleCoordinates.x, refRectangleRearY: nearestRectangleCoordinates.y, lineColor: "grey", objectName : counter}))
        }
    }

    function onDropAreaDropped(drag){

        // listView.model.remove(listView.dragItemIndex);
        // listView.dragItemIndex = -1;

        //        TODO white
        highlightRect.color = "white"
        droppedCount = droppedCount+1

        // Assign new variable to the created object
        // Use this variable to connect the signals and slots
        // DSParams Rectangle
        DSParamsModel.addToRectangles(counter, dynamicRectangle.createObject(parent, {x:drag.x, y: drag.y, name: tableslist.tableName, objectName : counter, glowColor:Constants.defaultDroppedRectangleColor}))

        // DSParams Rectangle
        DSParamsModel.fetchRectangles(counter).dragged.connect(onDropAreaDraggedNewComponent)
        DSParamsModel.fetchRectangles(counter).destroyComponents.connect(destroyComponents)
        DSParamsModel.fetchRectangles(counter).refObjectCount.connect(setRefObject)
        DSParamsModel.fetchRectangles(counter).createNewJoin.connect(createNewJoin)
        dataModellerItem.changeGlowColor.connect(DSParamsModel.fetchRectangles(counter).slotDisplayColor)


        // Created rectangle front & back coordinates
        var rectLeftX = drag.x
        var rectRightX = rectLeftX + Constants.droppedRectBufferWidth
        var rectLeftY = drag.y
        var rectRightY = rectLeftY


        // Current reference Coordinate
        var currentPoint = {x: rectLeftX, y: rectLeftY};

        // Get Column names of the table
        NewTableColumnsModel.getColumnsForTable(tableslist.tableName, dataModellerItem.moduleName)



        // Get the nearest rectangle
        // And process the rest
        if(DSParamsModel.existingTablesSize() > 0){
            var nearestTable = nearestRectangle(DSParamsModel.fetchAllRearRectangleCoordinates(), currentPoint)

            //Change the line color to black
            DSParamsModel.fetchNewConnectingLine(counter).lineColor = "black"

            // Get the coordinates for the nearest rectangle
            var nearestRectangleCoordinates = DSParamsModel.fetchRearRectangleCoordinates(nearestTable.tableId)

            // Update the front and rear line arrays
            // Front will just have a single Connection
            // While back can have multiple connections
            DSParamsModel.addToFrontLineMap(counter, nearestTable.tableId)


            if(typeof DSParamsModel.fetchRearLineMap(nearestTable.tableId) !== "undefined"){
                tempRearRectLineMaps = DSParamsModel.fetchRearLineMap(nearestTable.tableId)
            }

            dataModellerItem.tempRearRectLineMaps.push(counter)

            DSParamsModel.addToRearLineMap(nearestTable.tableId, tempRearRectLineMaps)

            // Reset temp array of the rear connections
            tempRearRectLineMaps = []


            // Draw a JoinBox
            var midLengthX = Math.abs(nearestRectangleCoordinates.x - currentPoint.x) / 2;
            var midLengthY = Math.abs(nearestRectangleCoordinates.y - currentPoint.y) / 2;

            var rectX = nearestRectangleCoordinates.x <= currentPoint.x ? nearestRectangleCoordinates.x + midLengthX - Constants.joinBoxWidth : currentPoint.x + midLengthX - Constants.joinBoxWidth
            var rectY = nearestRectangleCoordinates.y <= currentPoint.y ? nearestRectangleCoordinates.y + midLengthY : currentPoint.y + midLengthY

            DSParamsModel.addToNewJoinBox(counter, dynamicJoinBox.createObject(parent, {x: rectX, y: rectY, objectName : counter}))

            // Connect join box destroy signal and slot
            DSParamsModel.fetchNewJoinBox(counter).destroyJoin.connect(destroyComponents)

            // Save the Join Box Table map for join manipulation later
            DSParamsModel.addToJoinBoxTableMap(counter, nearestTable.tableName, tableslist.tableName)

            // Popup join details
            showJoinPopup(counter)
        }

        // Set the table name for the query in a join
        DSParamsModel.addToPrimaryJoinTable(counter, tableslist.tableName)

        // Push the coordinates in the array
        DSParamsModel.addToFrontRectangleCoordinates(counter, {x: rectLeftX, y: rectLeftY})
        DSParamsModel.addToRearRectangleCoordinates(counter, {x: rectRightX, y: rectRightY})
        DSParamsModel.addToExistingTables(counter, tableslist.tableName)
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
        var rectangleObjects = tmpRearRectangleCoordinates
        for (var prop in rectangleObjects) {
            var newDistance = distance(currentPoint,rectangleObjects[prop])
            tmpArray.push({"index": prop, "coordinates" : rectangleObjects[prop], "distance" : newDistance})
        }


        // Sort all the coordinates based on distance
        // and find the nearest distance
        const sortByDistance = tmpArray.sort((a,b) => a.distance - b.distance).map((arr, distance, array) => arr)
        var nearestIndex = sortByDistance[0].index
        var nearestDistance = sortByDistance[0].distance

        // return table name & id
        return {"tableName" :DSParamsModel.fetchExistingTables(nearestIndex), "tableId" : nearestIndex, "distance" : nearestDistance}
    }

    // Create sql from the visual Data modeller
    // and execute query
    function executeSql(){

        if(GeneralParamsModel.getDbClassification() === Constants.sqlType){
            QueryModel.callSql(DSParamsModel.tmpSql)
        } else if(GeneralParamsModel.getDbClassification() === Constants.duckType){
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



//    Column{
//        id: button_options_group
//        x:20
//        y:10
//        z: 10

//        Button{
//            id: align_btn
//            width: 30
//            height: 30

//            Image{
//                id: align_icon
//                height: 22
//                width: 22

//                source: "/Images/icons/align.png"
//                anchors.centerIn: align_btn
//                anchors.topMargin: 3
//                anchors.leftMargin: 2
//                horizontalAlignment: Image.AlignHCenter
//                verticalAlignment: Image.AlignVCenter

//            }

//            onClicked: onAlignBtnClicked()
//            background: Rectangle {
//                id: align_btn_background
//                color:  align_btn.hovered? Constants.darkThemeColor: Constants.themeColor

//            }

//            ToolTip.delay: Constants.tooltipShowTime
//            ToolTip.timeout: Constants.tooltipHideTime
//            ToolTip.visible: hovered
//            ToolTip.text: qsTr("Restore original")

//        }

//        Button{
//            id:plus_icon_btn
//            width: 30
//            height: 30
//            Image{
//                id: plus_icon
//                source: "/Images/icons/Plus_32.png"
//                height: 25
//                width: 25
//                anchors.centerIn: plus_icon_btn
//                anchors.topMargin: 3
//                horizontalAlignment: Image.AlignHCenter
//                verticalAlignment: Image.AlignVCenter

//            }

//            background: Rectangle {
//                id: plus_icon_btn_background
//                color:  plus_icon_btn.hovered? Constants.darkThemeColor: Constants.themeColor

//            }
//            onClicked: onZoomInClicked()

//            ToolTip.delay: Constants.tooltipShowTime
//            ToolTip.timeout: Constants.tooltipHideTime
//            ToolTip.visible: hovered
//            ToolTip.text: qsTr("Zoom in")


//        }

//        Button{
//            id:minus_icon_btn
//            width: 30
//            height: 30
//            Image{
//                id: minus_icon
//                source: "/Images/icons/zoom out.png"
//                height: 20
//                width: 20
//                anchors.topMargin: 3
//                anchors.leftMargin:3
//                anchors.centerIn: minus_icon_btn
//                anchors.top: minus_icon_btn.top
//                horizontalAlignment: Image.AlignHCenter
//                verticalAlignment: Image.AlignVCenter

//            }

//            background: Rectangle {
//                id: minus_icon_btn_background
//                color:  minus_icon_btn.hovered? Constants.darkThemeColor: Constants.themeColor

//            }

//            onClicked: onZoomOutClicked()

//            ToolTip.delay: Constants.tooltipShowTime
//            ToolTip.timeout: Constants.tooltipHideTime
//            ToolTip.visible: hovered
//            ToolTip.text: qsTr("Zoom out")
//        }

//    }
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
                    color: "transparent"
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

    MessageDialog{
        id: promptPrimaryTableModal

        modality: Qt.ApplicationModal
        title: "Select Primary table"
        standardButtons: StandardButton.Close
    }
}
