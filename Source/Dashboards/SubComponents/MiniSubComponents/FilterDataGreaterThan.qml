import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataItemRange
    width: parent.width-25
       anchors.horizontalCenter: parent.horizontalCenter
    height: 110


    property alias componentName: filterDataItemRange.objectName

    onComponentNameChanged: {
        var previousCheckValues = DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName)
        conditionText.text = previousCheckValues[0].length > 0 ? previousCheckValues[0] : ""
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

    function updateValue(updateValue){

        // Remove existing value
        DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, "", true)

        // Update new value
        DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, updateValue)

        console.log("NEW VALUE", DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName))

    }

    function filterClicked(){

        var columnAlias = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
        var currentColumnType = TableColumnsModel.findColumnType(columnAlias)
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
            id: inputText
            width:110
            anchors.top: columnName.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 15
            text: "Greater Than"
            elide: Text.ElideRight
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter


        }

        Rectangle{
            id: conditionEqual
            visible: true
            anchors.top: inputText.bottom
            anchors.topMargin: 15
            height: 25
            width: parent.width-10
            anchors.horizontalCenter: parent.horizontalCenter

            TextField{
                id: conditionText
                width: parent.width-10
                selectByMouse: true

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top


                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    width: parent.width
                    border.width: Constants.borderWidth
                }
                 onTextChanged: updateValue(conditionText.text)

            }

        }







    }
}
