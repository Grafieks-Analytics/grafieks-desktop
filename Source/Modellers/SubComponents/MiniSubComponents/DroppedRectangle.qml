import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

// This is the rectangle dynamically called in DataModeller
// when a column is dropped from right side listview


Item{

    id: newItem
    visible: true
    width: droppedRectangle.width
    height: droppedRectangle.height
    property string name: nameID.text
    readonly property string moduleName : "DroppedRectangle"

    property var allColumnsProperty : []
    property string tableNameProperty : ""


    signal dragged(double x, double y);
    signal dropped(double x, double y);
    signal destroyComponents(int counter, string depth)
    signal refObjectCount(int counter, int objectWidth)
    signal createNewJoin(int refObjectId, string tableName)


    ListModel{
        id: displayColList
    }

    Connections{
        target: TableColumnsModel

        function onColumnListObtained(allColumns, tableName, moduleName){

            allColumnsProperty = allColumns
            tableNameProperty  = tableName

            if(moduleName === newItem.moduleName && tableName === newItem.name)
                displayColumns(allColumns, tableName)
        }
    }

    Connections{
        target : DSParamsModel

        // Re render column list model when
        // a column is checked/unchecked in the right panel
        function onHideColumnsChanged(){

            if(tableNameProperty === newItem.name)
                displayColumns(allColumnsProperty, newItem.name)
        }
    }



    Component.onCompleted: {
        nameID.text = name
        droppedRectangle.width = nameID.text.length * 10 + 30
    }


    function slotDisplayColor(glowColor, tableId){

        if(tableId === parseInt(newItem.objectName))
            droppedRectangle.color = glowColor
    }

    function displayColumns(allColumns, tableName){

        const searchKey = tableName + "."
        let toHideCols = DSParamsModel.fetchHideColumns(searchKey)

        displayColList.clear()

        allColumns.forEach(function(item){

            var regex = new RegExp("[.]" + item[0] + "$");

            if(!toHideCols.find(value => regex.test(value))){
                displayColList.append({colName: item[0], colType: item[1]})
            }
        })
    }

    function onRectangleToggle(){

        columnListDroppedRect.visible = columnListDroppedRect.visible === true ? false : true
        TableColumnsModel.getColumnsForTable(newItem.name, newItem.moduleName)
    }

    function destroyRectangle(counter){
        newItem.destroy()
        destroyComponents(counter, "all")
    }


    function onReleasedRectangle(parent){

        // Call signal
        parent.dropped(newItem.x, newItem.y)
        parent.createNewJoin(parseInt(parent.objectName), newItem.name)

    }


    Component{
        id: listviewComponent

        Row{
            id: innerRow
            height: 20

            Text{
                text: colName
            }
        }
    }


    Rectangle {

        id: droppedRectangle
        border.width: 1
        border.color: "grey"
        height: 30


        Text{
            id: nameID
            text: text
            anchors.centerIn: parent
        }

        Image{
            id: removeIcon
            source : "/Images/icons/remove.png"
            anchors.right: droppedRectangle.right
            anchors.rightMargin: 10
            anchors.verticalCenter: droppedRectangle.verticalCenter
            z: 5

            MouseArea{
                anchors.fill: parent
                onClicked: destroyRectangle(parseInt(newItem.objectName))
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: newItem

            onDoubleClicked: onRectangleToggle()
            onReleased: onReleasedRectangle(newItem)
            onPositionChanged: newItem.dragged(newItem.x, newItem.y)
            onPressed: newItem.refObjectCount(parseInt(newItem.objectName), newItem.width, newItem.height)
        }
    }

    ListView{
        id: columnListDroppedRect
        visible: false
        anchors.top : droppedRectangle.bottom
        height: model.count * 30
        model: displayColList
        delegate: listviewComponent
    }
}

