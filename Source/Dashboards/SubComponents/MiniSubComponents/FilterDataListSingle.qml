import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataItemSingle
    width: parent.width-25
    height: 200
    anchors.horizontalCenter: parent.horizontalCenter

    property alias componentName: filterDataItemSingle.objectName
    property var modelContent: []
    property bool master: false

    ListModel{
        id: listModel
        dynamicRoles: true
    }


    onComponentNameChanged: {
        modelContent = TableColumnsModel.fetchColumnData(componentName)
        modelContent.unshift("Select All")

        var previousCheckValues = DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName)
        listModel.clear()
        var i = 0;
        if(previousCheckValues.length > 0){
            modelContent.forEach(item => {
                                     var checkedStatus = previousCheckValues.includes(item) ? true : false;
                                     listModel.append({"name": item, "checked": checkedStatus, "index": i})
                                     i++
                                 })
        } else {
            modelContent.forEach(item => {
                                     listModel.append({"name": item, "checked": true, "index": i})
                                     i++
                                 })
        }

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

    function onRadioSelect(modelData,checked){

        if(checked === true){

            // Start pushing the individual checked item in the array
            DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)

        } else{
            // Remove item if unchecked
            DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)
        }

    }

    function toggleSearch(){

        if(searchFilter.visible){
            searchFilter.visible=false
            searchFilter.height=0
            dataListView.height=150
            return
        }
        searchFilter.visible=true
        searchFilter.height=30
        dataListView.height=130
    }

    function searchData(searchText){
        modelContent = TableColumnsModel.searchColumnData(searchText, componentName)
        modelContent.unshift("Select All")

        listModel.clear()
        var i = 0;
        modelContent.forEach(item => {
                                 listModel.append({"name": item, "checked": true, "index": i})
                                 i++
                             })
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
        id:singleselect
        Row{
            CustomRadioButton{
                ButtonGroup.group: buttonGroupSingleList
                radio_text: model.name
                radio_checked: model.checked
                parent_dimension: 16

                onCheckedChanged: onRadioSelect(model.name, checked)
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

                spacing: 10

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15




                Text {
                    id: componentTitle
                    width:110
                    text: DashboardParamsModel.fetchColumnAliasName(currentDashboardId, componentName)
                    elide: Text.ElideRight
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    verticalAlignment: Text.AlignVCenter


                }

                Row{

                    height: parent.height
                    width: 40
                    spacing: 5
                    anchors.verticalCenter: parent.verticalCenter



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
            anchors.topMargin: 10
            height: 0
            width: parent.width-10
            anchors.horizontalCenter: parent.horizontalCenter
            TextField{
                id: searchText
                width: parent.width-10
                selectByMouse: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                placeholderText: qsTr("Search")
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    width: parent.width
                    border.width: Constants.borderWidth
                }
                onTextChanged: searchData(searchText.text)

            }

        }

        ListView{
            id: dataListView
            topMargin: 10
            model: listModel
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
}
