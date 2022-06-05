import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../../MainSubComponents"

Item {
    id: filterDataItemMulti
    width: parent.width-25
    height: 200
    anchors.horizontalCenter: parent.horizontalCenter
    property alias componentName: filterDataItemMulti.objectName
    property var modelContent: []
    property bool master: false

    ListModel{
        id: listModel
        dynamicRoles: true
    }

    onComponentNameChanged: {

        idPlesaeWaitThorbber.visible = true
        idPlesaeWaitText.visible = true

        if(GeneralParamsModel.getAPISwitch()) {
            // This part is taken care in DashboardFiltersAdd addNewFilterColumns()
        } else if(GeneralParamsModel.getFromLiveFile() || GeneralParamsModel.getFromLiveQuery()){
            modelContent = TableColumnsModel.fetchColumnDataLive(componentName)
            processDataList(modelContent)
        } else {
            modelContent = TableColumnsModel.fetchColumnData(componentName)
            processDataList(modelContent)
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

    function onMultiSelectCheckboxSelected(modelData,checked, index){

        if(checked === true){
            // Start pushing the individual checked item in the array
            DashboardParamsModel.setColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)

        } else{
            // Remove item if unchecked
            DashboardParamsModel.deleteColumnValueMap(DashboardParamsModel.currentDashboard, componentName, modelData)
        }

    }

    function processDataList(modelContent){
        modelContent.unshift(Messages.filterAll)

        var previousCheckValues = DashboardParamsModel.fetchColumnValueMap(DashboardParamsModel.currentDashboard, componentName)
        var i = 0;
        listModel.clear()

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

        // for the first time, select all values
        master = true

        idPlesaeWaitThorbber.visible = false
        idPlesaeWaitText.visible = false
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
        modelContent.unshift(Messages.filterAll)
        console.log(modelContent)

        listModel.clear()
        var i = 0;
        modelContent.forEach(item => {
                                 listModel.append({"name": item, "checked": true, "index": i})
                                 i++
                             })

    }

    function filterClicked(){
        var columnAlias = DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
        var currentColumnType = TableColumnsModel.findColumnType(columnAlias)
        DashboardParamsModel.setCurrentColumnType(currentColumnType)
        DashboardParamsModel.setCurrentSelectedColumn(componentName)

        labelShapePopup1.visible = true
    }

    function selectAll(checkedState){
        DashboardParamsModel.setSelectAll(checkedState, componentName, DashboardParamsModel.currentDashboard)

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
        Column{
            CheckBoxTpl{
                id: multicheckbox
                objectName: model.index
                checkbox_checked: model.checked
                checkbox_text: model.name
                parent_dimension: 14

                Component.onCompleted: {
                    if(index > 0){
                        ButtonGroup.group = childGroup
                    }
                }

                onCheckedChanged: {
                    if(index === 0){
                        childGroup.checkState = multicheckbox.checkState
                        for(var i =0; i < listModel.count; ++i){
                            listModel.setProperty(i, "checked", checked)
                        }
                        if(checked === true){
                            master = true
                        } else {
                            master = false
                        }
                    } else {

                        if(master === true && checked === false){
                            master = false
                            for(var i =0; i < listModel.count; ++i){
                                listModel.setProperty(i, "checked", false)
                            }
                        }

                        if(master === false && checked === true){
                            listModel.setProperty(model.index, "checked", true)
                        }
                        onMultiSelectCheckboxSelected(model.name, checked, index)
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
                    text: DashboardParamsModel.fetchColumnAliasName(DashboardParamsModel.currentDashboard, componentName)
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

                placeholderText: Messages.search
                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    width: parent.width
                    border.width: Constants.borderWidth
                }
                onTextChanged: searchData(searchText.text)

            }

        }

        BusyIndicatorTpl{
            id: idPlesaeWaitThorbber
            anchors.centerIn: parent
        }

        Text {
            id: idPlesaeWaitText
            text: Messages.loadingPleaseWait
            anchors.top: idPlesaeWaitThorbber.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }


        ListView{
            id: dataListView
            model: listModel
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
