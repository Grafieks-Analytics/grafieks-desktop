import QtQuick 2.15
import QtQuick.Controls 2.15

import "../../SubComponents"
import "../../../MainSubComponents"

import com.grafieks.singleton.constants 1.0

Rectangle{

    id: newItem
    width: parent.width
    height: parent.height

    readonly property string moduleName : "JoinDisplayTable"
    property int modelCounter: 0
    property var allColumnsProperty : []
    property string tableNameProperty : ""
    property alias tableName: title.text
    property var selectedKeys : new Map()
    property var existingModel : []

    onTableNameChanged: loadTableColumns(tableName)




    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id:displayColList
    }

    ListModel{
        id: tableListModel
    }



    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal selectedColumn(string columnName, string tableName, int counter)

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: NewTableColumnsModel

        function onColumnListObtained(allColumns, tableName, moduleName){

            allColumnsProperty = allColumns
            tableNameProperty = tableName

            if(moduleName === newItem.moduleName && tableName === newItem.tableName)
                displayColumns(allColumns, tableName)
        }
    }

    Connections{
        target: DSParamsModel

        // Re render column list model when
        // a column is checked/unchecked in the right panel
        function onHideColumnsChanged(hideColumns){

            if(tableNameProperty === newItem.tableName)
                displayColumns(allColumnsProperty, newItem.tableName)
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS



    function slotCounterModelChanged(modelCounter){
        appendToModel(modelCounter)
    }


    function slotClearModel(haveExistingValues){

        tableListModel.clear()

        if(haveExistingValues === false){
            tableListModel.append({counter: 0, currIndex: 0})
        } else{

            newItem.existingModel.forEach(function(item, index){

                let newCurrIndex = 0
                for(var i = 0; i < displayColList.count; i++){

                    if (displayColList.get(i).colName === newItem.selectedKeys.get(item)){
                        newCurrIndex = displayColList.get(i).index
                    }
                }

                tableListModel.append({counter: parseInt(item), currIndex: newCurrIndex})
            })
        }
    }

    function slotDeleteModel(counter){
        tableListModel.remove(counter)
    }


    function appendToModel(counter){
        tableListModel.append({counter: counter, currIndex: 0})
    }

    function loadTableColumns(tableName){

        NewTableColumnsModel.getColumnsForTable(tableName, newItem.moduleName)
    }


    function displayColumns(allColumns, tableName){

        const searchKey = tableName + "."
        let toHideCols = DSParamsModel.fetchHideColumns(searchKey)

        displayColList.clear()

        allColumns.forEach(function(item, index){

            var regex = new RegExp("[.]" + item[0] + "$");

            if(!toHideCols.find(value => regex.test(value))){
                displayColList.append({colName: item[0], index: index})
            }
        })
    }


    function changeColumn(columnName, counter){
        selectedColumn(columnName, tableName, counter)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    ButtonGroup{
        id: tableLeftRightJoinGrp
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle{
        id: content
        height: parent.height
        width: parent.width - 20
        border.color: Constants.darkThemeColor

        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 10

        Rectangle{
            id: header
            color: Constants.lightThemeColor
            border.color: Constants.darkThemeColor
            height: 30
            width: parent.width
            anchors.left: parent.left


            Text{
                id : title
                anchors.left : parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }


        ListView{

            id: tableListView
            anchors.top: header.bottom
            height: parent.height - header.height
            width: parent.width
            anchors.left: parent.left
            spacing: 2
            model: tableListModel

            delegate:
//                CustomComboBox{
//                id: columnDropDown
//                objectName: counter
//                height: 30
//                width: parent.width-5
//                anchors.horizontalCenter: parent.horizontalCenter
//                model: displayColList
//                textRole: "colName"
//                currentIndex: currIndex


//                background: Rectangle{
//                    color: Constants.whiteColor
//                    radius: 0
//                    border.color: Constants.borderBlueColor
//                    border.width: Constants.borderWidth
//                }




//                onCurrentTextChanged: changeColumn(columnDropDown.currentText, columnDropDown.objectName)

//            }
                ComboBox {
                    id:columnDropDown
                    objectName: counter
                                   height: 30
                                   width: parent.width-8
                                   anchors.horizontalCenter: parent.horizontalCenter
                                   model: displayColList
                                   textRole: "colName"
                                   currentIndex: currIndex
                                   background: Rectangle{
                                                       color: Constants.whiteColor
                                                       radius: 0
                                                       border.color: Constants.borderBlueColor
                                                       border.width: Constants.borderWidth
                                                   }

                                   onCurrentTextChanged: changeColumn(columnDropDown.currentText, columnDropDown.objectName)

                    indicator: Canvas {
                        id: canvas
                        x: columnDropDown.width - width - columnDropDown.rightPadding
                        y: columnDropDown.topPadding + (columnDropDown.availableHeight - height) / 2
                        width: 12
                        height: 8
                        contextType: "2d"

                        Connections {
                            target: columnDropDown
                            onPressedChanged: canvas.requestPaint()
                        }

                        onPaint: {
                            context.reset();
                            context.moveTo(0, 0);
                            context.lineTo(width, 0);
                            context.lineTo(width / 2, height);
                            context.closePath();
                            context.fillStyle = columnDropDown.pressed ? "#black" : "#gray";
                            context.fill();
                        }
                    }
            }
        }


    }


    // Page Design Ends
    /***********************************************************************************************************************/

}
