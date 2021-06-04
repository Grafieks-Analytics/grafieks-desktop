import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"


Rectangle {
    id: rectangle1

    width: parent.width-20
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: apply_btn.bottom
    anchors.topMargin: 10
    height: parent.height-80
    color: "white"
    border.color: Constants.themeColor

    ListModel{
        id: listModel
    }

    Connections{
        target: TableColumnsModel

        function onVisibleColumnListChanged(visibleColumns){
            listModel.clear()

            visibleColumns.forEach((item) => {
                                       var dashboardId = DashboardParamsModel.currentDashboard
                                       var columnType = DashboardParamsModel.fetchColumnFilterType(dashboardId, item)
                                       listModel.append({type: columnType, name: item})
                                   })
        }
    }


    Connections{
        target: DashboardParamsModel

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard){
            listModel.clear()
            var showColumns = DashboardParamsModel.fetchShowColumns(dashboardId)
            showColumns.forEach((item) => {
                                    var columnType = DashboardParamsModel.fetchColumnFilterType(dashboardId, item)
                                    listModel.append({type: columnType, name: item})
                                })
        }

        function onColumnFilterTypeChanged(){
            listModel.clear()

            var dashboardId = DashboardParamsModel.currentDashboard
            var showColumns = DashboardParamsModel.fetchShowColumns(dashboardId)

            showColumns.forEach((item) => {
                                    var columnType = DashboardParamsModel.fetchColumnFilterType(dashboardId, item)
                                    listModel.append({type: columnType, name: item})
                                })
        }
    }

    ListView{
        id: filterDataListview
        height: parent.height
        width: parent.width+2
        model: listModel
        clip: true
        interactive: true
            ScrollBar.vertical: ScrollBar {}


        // filterTypes: ["dataListSingle", "dataListMulti", "dataDropdownSingle", "dataDropdownMulti"]

        DelegateChooser {
            id: chooser
            role: "type"
            DelegateChoice { roleValue: Constants.filterTypes[0]; FilterDataListSingle { componentName: name } }
            DelegateChoice { roleValue: Constants.filterTypes[1]; FilterDataListMultiple { componentName: name } }
            DelegateChoice { roleValue: Constants.filterTypes[2]; FilterDataSingleDropdown { componentName: name } }
            DelegateChoice { roleValue: Constants.filterTypes[3]; FilterDataMultiDropdown { componentName: name } }
        }

        delegate: chooser
    }
}




