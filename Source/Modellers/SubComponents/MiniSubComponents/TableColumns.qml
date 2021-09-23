import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {

    id: tableColumnsComponent
    height:columnListView.height
    z: 2

    property alias objectName: tableColumnsComponent.objectName // Table name sent here from the caller
    property var tableColumnsMap : new Map()
    property var itemMap: new Map()


    ListModel{
        id: newListModel
    }


    Connections{
        target: NewTableColumnsModel

        function onColumnListObtained(allColumns, tableName, moduleName){
            if(moduleName === "TableColumns")
                onReceivingSignal(allColumns, tableName);
        }
    }


    function onReceivingSignal(allColumns, tableName){

        if(tableColumnsComponent.objectName === tableName && itemMap.size <= 0){
            allColumns.forEach(function(item){

                let colName = item[0]
                let colType = item[1]

                itemMap.set(colName, colType)
                newListModel.append({colName: colName, colType: colType, tableName: tableName})
            })

            tableColumnsMap.set(tableName, itemMap)
            columnListView.model = newListModel
            columnListView.height = newListModel.count * 25
        }
    }

    function hideColumnSelection(state, colName, tableName){

        var key = ""
        if(GeneralParamsModel.getDbClassification() === Constants.excelType){
            key = "[" + tableName + "$]" + "." + "[" + colName + "]"
        } else if(GeneralParamsModel.getDbClassification() === Constants.accessType) {
            key = "[" + tableName + "]" + "." + "[" + colName + "]"
        } else {
            key = tableName + "." + colName
        }

        // If key already exists, remove
        // Else insert into DSParamsModel.hideColumns
        if(state === true){

            DSParamsModel.removeFromHideColumns(key)
        } else{

            // check if the key exists
            DSParamsModel.addToHideColumns(key)
        }
    }

    function changeDataType(colName, colType, tableName, changeToFormat){
        console.log(colName, colType, tableName, changeToFormat)

        GeneralParamsModel.changeColumnTypes(colName, tableName, changeToFormat)
    }



    ListView{
        id: columnListView
        anchors.top: parent.top
        anchors.topMargin: 5



        delegate: Rectangle{
            id: innerListView
            height: 25
            width: item_querymodeller.width-80



            CheckBoxTpl{
                id: checkBox1
                checkbox_text: colName
                font.pointSize: 8
                checkbox_checked: true
                parent_dimension: 12

                onClicked: hideColumnSelection(checked, colName, tableName)
            }       

            Image {
                id: toggleMenuIcon
                height: 20
                width: 20
                source : "/Images/icons/menu-button.png"
                anchors.right: parent.right
                anchors.rightMargin:  -20
                anchors.verticalCenter: tableImg.verticalCenter
                visible: tableShowToggle
                z:50
                MouseArea{
                    anchors.fill: parent
                    onClicked: menuOptions.open()
                }


            }


            Row{

                anchors.right: tableImg.right
                anchors.top: toggleMenuIcon.bottom
                anchors.rightMargin: -70
                width: parent.width-30
                height: 80

                Item {
                    id: name

                    anchors.right:parent.right

                    x: -menuOptions.width

                    Menu{
                        id: menuOptions
                        background: Rectangle{
                            implicitWidth: 200
                            border.color: Constants.darkThemeColor
                        }


                        Menu{
                            id: menuOptionsdsd
                            title: qsTr("Convert Data To")

                            background: Rectangle{
                                implicitWidth: 180

                                border.color: Constants.darkThemeColor
                            }
                            MenuItem {
                                id:menuItem1
                                implicitHeight: 30
                                leftPadding: 15
                                text: qsTr("Categorical")

                                onClicked: changeDataType(colName, colType, tableName, Constants.categoricalTab)

                            }
                            MenuSeparator{}
                            MenuItem {
                                id:menuItem2
                                implicitHeight: 30
                                leftPadding: 15
                                text: qsTr("Numerical")

                                onClicked: changeDataType(colName, colType, tableName, Constants.numericalTab)
                            }

                        }
                    }
                }


            }
        }
    }
}
