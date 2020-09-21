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
    property alias modelCounter: tableListView.model
    property var allColumnsProperty : []
    property string tableNameProperty : ""
    property alias tableName: title.text

    onTableNameChanged: loadTableColumns(tableName)


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id:displayColList
    }



    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    Connections{
        target: TableColumnsModel

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
        function onHideColumnsChanged(){

            if(tableNameProperty === newItem.tableName)
                displayColumns(allColumnsProperty, newItem.tableName)
        }
    }

    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function loadTableColumns(tableName){

        TableColumnsModel.getColumnsForTable(tableName, newItem.moduleName)
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



    // Page Design Ends
    /***********************************************************************************************************************/

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
            model: 1

            delegate:   CustomComboBox{
                id: columnDropDown
                height: 30
                width: parent.width
                model: displayColList
                textRole: "colName"
                valueRole: "colId"
                currentIndex: 0
            }
        }


    }

}
