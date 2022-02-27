import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataItemRange
    width: parent.width-25
       anchors.horizontalCenter: parent.horizontalCenter
    height: 150


    property alias componentName: filterDataItemRange.objectName
    property var value1 : 0
    property var value2: 0

    onComponentNameChanged: {
        var modelData

        if(GeneralParamsModel.getAPISwitch()) {
            TableColumnsModel.fetchColumnDataAPI(componentName, DashboardParamsModel.currentDashboard)
        } else if(GeneralParamsModel.getFromLiveFile() || GeneralParamsModel.getFromLiveQuery()){
            modelData = TableColumnsModel.fetchColumnDataLive(componentName)
            processDataList(modelData)
        } else {
            modelData = TableColumnsModel.fetchColumnData(componentName)
            processDataList(modelData)
        }

    }


    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard){
                componentTitle.text = newAlias
            }
        }
    }

    Connections {
        target: TableColumnsModel

        function onColumnDataChanged(columnData, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard)
                processDataList(columnData)
        }
    }

    function processDataList(modelData){
        modelData.sort()

        rangeSlider.from = Math.min(...modelData)
        rangeSlider.to = Math.max(...modelData)

        value1 = Math.min(...modelData)
        value2 = Math.max(...modelData)

        var previousCheckValues = DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName)
        if(previousCheckValues.length > 0){
            rangeSlider.first.value = previousCheckValues[0]
            rangeSlider.second.value = previousCheckValues[1]
        } else {
            rangeSlider.first.value = Math.min(...modelData)
            rangeSlider.second.value = Math.max(...modelData)
        }


        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
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
                    font.pixelSize: 12
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
            id: firstText
            width:110
            anchors.top: columnName.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 15
            text: rangeSlider.first.value
            elide: Text.ElideRight
            font.pixelSize: Constants.fontCategoryHeaderMedium
            verticalAlignment: Text.AlignVCenter
        }

 



        RangeSlider {
            id:rangeSlider
            anchors.top: firstText.bottom
            anchors.topMargin: 10
            width: parent.width
            first.onValueChanged: {
                value1 = first.value
                updateValue()
            }
            second.onValueChanged:{
                value2 = second.value
                updateValue()
            }
        Text {
            id: secondText
            width:110
            anchors.top: rangeSlider.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 15
            text: rangeSlider.second.value
            elide: Text.ElideRight
            font.pixelSize: Constants.fontCategoryHeaderMedium
            verticalAlignment: Text.AlignVCenter
        }

        }



    }
}
