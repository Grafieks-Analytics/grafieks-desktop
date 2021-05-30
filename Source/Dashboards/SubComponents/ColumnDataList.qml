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
    height: 600
    color: "white"
    border.color: Constants.themeColor
    property var filterTypes: ["dataListSingle", "dataListMulti", "dataDropdownSingle", "dataDropdownMulti"]

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

    ListView{
        id: filterDataListview
        height: parent.height
        width: parent.width
        model: listModel

        DelegateChooser {
            id: chooser
            role: "type"
            DelegateChoice { roleValue: filterTypes[0]; FilterDataList { componentName: name } }
            DelegateChoice { roleValue: filterTypes[1]; FilterDataList { componentName: name } }
            DelegateChoice { roleValue: filterTypes[2]; FilterDataSingleDropdown { componentName: name } }
            DelegateChoice { roleValue: filterTypes[3]; FilterDataMultiDropdown { componentName: name } }
        }

        delegate: chooser
    }
}




