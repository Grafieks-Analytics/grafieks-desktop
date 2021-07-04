import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataItemMulti
    width: parent.width-25
    height: 200
    anchors.horizontalCenter: parent.horizontalCenter
    property alias componentName: filterDataItemMulti.objectName
    property var modelContent: []
    property var tmpCheckedValues: []

    onComponentNameChanged: {
        modelContent = TableColumnsModel.fetchColumnData(componentName)
        modelContent.unshift("Select All")
        dataListView.model = modelContent
        componentTitle.text = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)

        // for the first time, select all values
        selectAll(true)
    }


    Connections{
        target: DashboardParamsModel

        function onAliasChanged(newAlias, columnName, dashboardId){
            if(columnName === componentName && dashboardId === DashboardParamsModel.currentDashboard){
                componentTitle.text = newAlias
            }
        }
    }

    function onMultiSelectCheckboxSelected(modelData,checked, index){

        if(checked === true){

            // Start pushing the individual checked item in the array
            DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)
            tmpCheckedValues.push(modelData)

        } else{
            // Remove item if unchecked
            DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)

            const removeIndex = tmpCheckedValues.indexOf(modelData);
            if (removeIndex > -1) {
                tmpCheckedValues.splice(removeIndex, 1);
            }

            selectAll(false)
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
        console.log(searchText, componentName)
        modelContent = TableColumnsModel.searchColumnData(searchText, componentName)
        modelContent.unshift("Select All")
        dataListView.model = modelContent
    }

    function filterClicked(){

        var currentColumnType = TableColumnsModel.findColumnType(componentName)
        DashboardParamsModel.setCurrentColumnType(currentColumnType)
        DashboardParamsModel.setCurrentSelectedColumn(componentName)

        labelShapePopup1.visible = true
    }

    function selectAll(checkedState){
        if(checkedState === true){
            modelContent.forEach(item => {
                                     DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, item)
                                 })

        } else {
            DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, "", true)
        }
    }

    ButtonGroup {
        id: childGroup
        exclusive: false
    }

    Component{
        id:multipleselect
        Row{
            CheckBoxTpl{
                id: multicheckbox
                checkbox_text: modelData
                parent_dimension: 14
                checkbox_checked: childGroup.checkState
                ButtonGroup.group: childGroup

                onCheckedChanged: {
                    if(index === 0){
                        childGroup.checkState = checkState
                        selectAll(true)
                    } else {
                        onMultiSelectCheckboxSelected(modelData,checked, index)
                    }
                }
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
                    elide: Text.ElideRight
                    text: DashboardParamsModel.fetchColumnAliasName(currentDashboardId, componentName)
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
            leftMargin: 10
            height:130
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            ScrollBar.vertical: CustomScrollBar {}
            width: parent.width
            anchors.top: searchFilter.bottom


            delegate:{
                return multipleselect
            }
        }
    }
}
