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

    onComponentNameChanged: {
        var modelData = TableColumnsModel.fetchColumnData(componentName)
        modelData.sort()

        rangeSlider.from = Math.min(...modelData)
        rangeSlider.to = Math.max(...modelData)
        rangeSlider.first.value = Math.min(...modelData)
        rangeSlider.second.value = Math.max(...modelData)

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

    function toggleSearch(){

        if(searchFilter.visible){
            searchFilter.visible=false
            searchFilter.height=0
            return
        }
        searchFilter.visible=true
        searchFilter.height=30
    }

    function searchData(searchText){
        console.log(searchText, componentName)
        dataListView.model = TableColumnsModel.searchColumnData(searchText, componentName)
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
                    text: DashboardParamsModel.fetchColumnAliasName(currentDashboardId, componentName)
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
                console.log("firstRangeValue",first.value)
            }
            second.onValueChanged:{
                console.log("secondRangeValue",second.value)
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
