import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataItemRange
    width: parent.width-25
       anchors.horizontalCenter: parent.horizontalCenter
    height: 180


    property alias componentName: filterDataItemRange.objectName
    property var value1 : 0
    property var value2: 0

    onComponentNameChanged: {
        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
    }


    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard){
                componentTitle.text = newAlias
            }
        }

    }

    function updateValue(){

        // Remove existing value
        DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, "", true)

        // Update new value
        var updateValue = value1 + "," + value2
        DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, updateValue)

        console.log("NEW VALUE", DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName))

    }

    function filterClicked(){

        var currentColumnType = TableColumnsModel.findColumnType(componentName)
        DashboardParamsModel.setCurrentColumnType(currentColumnType)
        DashboardParamsModel.setCurrentSelectedColumn(componentName)

        labelShapePopup1.visible = true
    }

    ButtonGroup{
        id:buttonGroupSingleList
    }


    Component{
        id:range
        Row{
            CustomRadioButton{
                ButtonGroup.group: buttonGroupSingleList
                radio_text: modelData
                radio_checked: false
                parent_dimension: 16
            }
        }
    }


    Rectangle{
        height: parent.height
        width: parent.width
        color: "white"
        border.color: Constants.darkThemeColor



        Rectangle{
            id:columnName
            width:parent.width
            height:25
            color: Constants.themeColor

            border.color: Constants.darkThemeColor
            Row{

                spacing: 15

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15


                Text {
                    id: componentTitle
                    width:123
                    text: DashboardParamsModel.fetchColumnAliasName(currentDashboard, componentName)
                    elide: Text.ElideRight
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    verticalAlignment: Text.AlignVCenter


                }

                Row{

                    height: parent.height
                    width: 40
                    spacing: 15
                     anchors.verticalCenter: parent.verticalCenter
                    Image {
                        source: "/Images/icons/customize.png"
                        width: 16
                        height: 16
                        MouseArea{
                            anchors.fill: parent
                            onClicked: filterClicked()
                        }

                    }
                }


            }
        }
        Text {
            id: betweenText
            width:110
            anchors.top: columnName.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 15
            text: "Between"
            elide: Text.ElideRight
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter


        }


        Rectangle{
            id: conditionEqual
            visible: true
            anchors.top: betweenText.bottom
            anchors.topMargin: 15
            height: 25
            width: parent.width-10
            anchors.horizontalCenter: parent.horizontalCenter
            TextField{
                id: condition1Text
                width: parent.width-10
                selectByMouse: true

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    width: parent.width
                    border.width: Constants.borderWidth
                }
                onTextChanged: {
                    value1 = condition1Text.text
                    updateValue()
                }

            }

        }

        Text {
            id: toText
            width:110
            anchors.top: conditionEqual.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 15
            text: "And"
            elide: Text.ElideRight
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter


        }


        Rectangle{
            id: conditionEqual1
            visible: true
            anchors.top: toText.bottom
            anchors.topMargin: 15
            height: 25
            width: parent.width-10
            anchors.horizontalCenter: parent.horizontalCenter
            TextField{
                id: condition2Text
                width: parent.width-10
                selectByMouse: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    width: parent.width
                    border.width: Constants.borderWidth
                }
                onTextChanged: {
                    value2 = condition2Text.text
                    updateValue()
                }

            }

        }

    }
}
