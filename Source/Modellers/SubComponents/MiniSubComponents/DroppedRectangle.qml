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
    //    x:newItem.x+Constants.scaleTable
    //    y:newItem.y+Constants.scaleTable

    scale: Constants.scaleTable
    property string name: nameID.text
    readonly property string moduleName : "DroppedRectangle"

    property var allColumnsProperty : []
    property var colors: ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462","#b3de69","#fccde5","#d9d9d9","#bc80bd","#ccebc5","#ffed6f"]


    property string tableNameProperty : ""
    property var hoverCrossIcon: false


    signal dragged(double x, double y);
    signal dropped(double x, double y);
    signal destroyComponents(int counter, string depth)
    signal refObjectCount(int counter, int objectWidth)
    signal createNewJoin(int refObjectId, string tableName)


    ListModel{
        id: displayColList
    }

    Connections{
        target: NewTableColumnsModel

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
        function onHideColumnsChanged(hideColumns){

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
        dropDownIcon.source = columnListDroppedRect.visible === true ?  "/Images/icons/Up_20.png" : "/Images/icons/Down_20.png"
        NewTableColumnsModel.getColumnsForTable(newItem.name, newItem.moduleName)

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

    function showCrossIcon(){
        //        DashboardParamsModel.setCurrentReport(newItem.objectName)
        hoverCrossIcon = true


    }
    function hideCrossIcon(){
        //        DashboardParamsModel.setCurrentReport(newItem.objectName)
        hoverCrossIcon = false

    }




    function hideColumnSelection(colName, tableName){

        console.log("remove column")
        var key = tableName + "." + colName

        // If key already exists, remove
        // Else insert into DSParamsModel.hideColumns


        DSParamsModel.removeFromHideColumns(key)

    }


    Component{
        id: listviewComponent
        Rectangle{
            id:tableContent

            height: 30

            Row{
                id: innerRow
                height: 20

                Text{
                    text: colName
                }

                Image{
                    id: columnIcon;
                    source :

                        if(colType == "numerical"){"/Images/icons/integer.png";}
                        else if(colType == "categorical"){
                            source : "/Images/icons/string new.png";
                        }
                        else if(colType == "date"){
                            source : "/Images/icons/date.png";
                        }

                    height: 12
                    width: 13
                    anchors.right: parent.right
                    anchors.rightMargin:  20
                    anchors.verticalCenter: droppedRectangle.verticalCenter
                    z: 5
                }
                Image{
                    id: columnMenuIcon
                    source : "/Images/icons/menu-button.png"
                    height: 30
                    width: 30
                    anchors.left: parent.left
                    anchors.leftMargin:  110
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    anchors.verticalCenter: droppedRectangle.verticalCenter
                    z: 5

                    MouseArea{
                        anchors.fill: parent
                        onClicked: editOptions.open()
                    }
                }
            }
            //            ToolSeparator{
            //                id: toolsep3
            //                orientation: Qt.Horizontal
            //                width: 200
            //                anchors.bottom:  innerRow.bottom
            //                anchors.bottomMargin: -10
            //                anchors.left: parent.left
            //                anchors.leftMargin: -50
            //            }

            Row{

                anchors.right: parent.right
                anchors.top: columnMenuIcon.bottom
                //                anchors.topMargin: 50
                anchors.rightMargin: -60
                width: parent.width
                height: 10


                Item {
                    id: name
                    anchors.left:parent.left
                    anchors.leftMargin: 50

                    Menu{
                        id: editOptions
                        background: Rectangle{
                            implicitWidth: 150
                            border.color: Constants.darkThemeColor
                        }


                        MenuItem {
                            text: qsTr("Rename")
                            onTriggered: destroyElement()
                            visible: false
                        }
                        MenuItem {
                            text: qsTr("Convert To")
                            onTriggered: destroyElement()
                            visible: false
                        }

                        MenuItem {
                            text: qsTr("Remove")
                            onClicked: hideColumnSelection(colName, tableName)
                            visible: false
                        }
                    }}
            }

        }

    }


    Rectangle {

        id: droppedRectangle
        border.width: 1
        //        scale: Constants.scaleTable
        //        x:Constants.newPosition+droppedRectangle.x
        //        y:Constants.droppedRectangle.y
        border.color: colors[droppedCount+1]
        //        color: "#26009B8F"
        color: colors[droppedCount+1]

        height: 30

        MouseArea {
            id: mouseAreaDroppedRect
            anchors.fill: parent
            drag{

                target: newItem
                minimumX: 0
                minimumY: 0
                maximumY: outer.height
                maximumX: outer.width
            }

            //            hoverEnabled: true

            //            onDoubleClicked: onRectangleToggle()
            onReleased: onReleasedRectangle(newItem)
            onPositionChanged: newItem.dragged(newItem.x, newItem.y)
            onPressed: newItem.refObjectCount(parseInt(newItem.objectName), newItem.width, newItem.height)
            onEntered: showCrossIcon();
            onExited: hideCrossIcon();
        }


        Text{
            id: nameID
            text: text
            anchors.left: droppedRectangle.left
            anchors.leftMargin: 20
            //            anchors.centerIn: parent
            anchors.verticalCenter: droppedRectangle.verticalCenter
        }
        Image{
            id: dropDownIcon

            source : "/Images/icons/Down_20.png"
            anchors.right: droppedRectangle.right
            height: 15
            width: 15
            anchors.rightMargin: 32
            anchors.verticalCenter: droppedRectangle.verticalCenter
            z: 5
            //            visible: hoverCrossIcon

            MouseArea{
                anchors.fill: parent
                onClicked: onRectangleToggle()
            }
        }

        Image{
            id:removeIcon

            source : "/Images/icons/close black.png"
            anchors.right: droppedRectangle.right
            height: 12
            width: 12
            anchors.rightMargin: 10
            anchors.verticalCenter: droppedRectangle.verticalCenter
            z: 5
            //            visible: hoverCrossIcon

            MouseArea{
                anchors.fill: parent
                onClicked: destroyRectangle(parseInt(newItem.objectName))
            }
        }

    }


    Rectangle{

        border.color: colors[droppedCount+1]
        anchors.top : droppedRectangle.bottom
        width: 200
        height: tableId.height
        id: columnListDroppedRect
        visible: false





        ListView{
            id:tableId

            height: (model.count * 30) + 20
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.top: parent.top
            anchors.topMargin: 10


            model: displayColList
            delegate: listviewComponent


        }

    }
}

