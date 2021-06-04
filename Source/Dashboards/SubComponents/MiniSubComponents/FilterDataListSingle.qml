import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataItemSingle
    width: parent.width-5
    height: 200
    property alias componentName: filterDataItemSingle.objectName

    onComponentNameChanged: {
        dataListView.model = TableColumnsModel.fetchColumnData(componentName)
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
        DashboardParamsModel.setCurrentSelectedColumn(componentName)
        labelShapePopup1.visible = true
    }

    ButtonGroup{
        id:buttonGroupSingleList
    }

    Component{
        id:singleselect
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
        id:columnName
        width:parent.width
        height:25
        color: Constants.themeColor

        border.color: Constants.themeColor
        Row{

            spacing: 80

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15


            Text {
                id: componentTitle
                text: DashboardParamsModel.fetchColumnAliasName(currentDashboardId, componentName)
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }

            Row{

                height: parent.height
                width: 40
                spacing: 5


                Image {
                    source: "/Images/icons/iconmonstr-search-thin.svg"
                    width: 14
                    height: 14

                    MouseArea{
                        anchors.fill: parent
                        onClicked:  toggleSearch()
                    }
                }
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

    Rectangle{
        id: searchFilter
        visible: false
        anchors.top: columnName.bottom
        height: 0
        width: parent.width
        TextField{
            id: searchText
            width: parent.width-10
            selectByMouse: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            placeholderText: qsTr("Search")
            background: Rectangle {
                border.color: Constants.themeColor
                width: parent.width
                border.width: Constants.borderWidth
            }
            onTextChanged: searchData(searchText.text)

        }

    }

    ListView{
        id: dataListView
        topMargin: 10

     leftMargin: 10
        height:150
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        ScrollBar.vertical: CustomScrollBar {}
        width: parent.width
        anchors.top: searchFilter.bottom

        delegate:{
            return singleselect
        }
    }
}
