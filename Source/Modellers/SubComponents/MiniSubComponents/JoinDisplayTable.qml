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
    property var allColumnsProperty : []
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

            if(moduleName === newItem.moduleName)
                displayColumns(allColumns, tableName)
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
        console.log(displayColList)
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

            Row{
                id: tableHeader
                height: parent.height
                anchors.top: parent.top

                Text{
                    id : title
                    anchors.left : parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                }


                Rectangle{
                    height: parent.height
                    anchors.left: title.right

                    CustomRadioButton{

                        id: leftJoinRadio
                        radio_text: "L"
                        checked: true
                        parent_dimension: 16
                        ButtonGroup.group: tableLeftRightJoinGrp

                    }

                    CustomRadioButton{
                        id: rightJoinRadio
                        anchors.left: leftJoinRadio.right
                        checked: false
                        radio_text: "R"
                        parent_dimension: 16
                        ButtonGroup.group: tableLeftRightJoinGrp
                    }
                }
            }
        }


        ListView{

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
                currentIndex: 0
            }
        }


    }

}
