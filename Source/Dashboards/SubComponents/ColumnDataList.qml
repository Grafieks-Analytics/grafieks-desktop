import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "./MiniSubComponents"


Rectangle {
    id: rectangle1

    width: 200
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: apply_btn.bottom
    anchors.topMargin: 10
    height: parent.height-80
    color: "white"
    //    border.color: Constants.themeColor

    ListModel{
        id: listModel
    }

    Connections{
        target: TableColumnsModel

        function onVisibleColumnListChanged(visibleColumnsTypeMap){
            listModel.clear()

            for (const key in visibleColumnsTypeMap) {

                var dashboardId = DashboardParamsModel.currentDashboard
                var columnType = "";

                switch(visibleColumnsTypeMap[key]){
                case Constants.categoricalTab:
                case Constants.dateTab:
                    columnType = Constants.filterCategoricalTypes[0]
                    break;

                case Constants.numericalTab:
                    columnType = Constants.filterNumericalTypes[0]
                    break;
                }

                listModel.append({type: columnType, name: key})
            }
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
        width: 198
        model: listModel
        clip: true
        interactive: true
        spacing: 10


        ScrollBar.vertical: ScrollBar {}



        // filterCategoricalTypes: ["dataListMulti", "dataListSingle", "dataDropdownSingle", "dataDropdownMulti"]
        // filterNumericalTypes: ["dataRange","dataEqual","datanotEqual","dataSmaller","dataGreater","dataEqualOrSmaller","dataEqualOrGreater","dataBetween"]

        DelegateChooser {
            id: chooser
            role: "type"
            DelegateChoice { roleValue: Constants.filterCategoricalTypes[0]; FilterDataListMultiple { componentName: name } }
            DelegateChoice { roleValue: Constants.filterCategoricalTypes[1]; FilterDataListSingle { componentName: name } }
            DelegateChoice { roleValue: Constants.filterCategoricalTypes[2]; FilterDataSingleDropdown { componentName: name } }
            DelegateChoice { roleValue: Constants.filterCategoricalTypes[3]; FilterDataMultiDropdown { componentName: name } }
            DelegateChoice { roleValue: Constants.filterNumericalTypes[0]; FilterDataRange { componentName: name } }
            DelegateChoice { roleValue: Constants.filterNumericalTypes[1]; FilterDataEqual { componentName: name } }
            DelegateChoice { roleValue: Constants.filterNumericalTypes[2]; FilterDataNotEqual { componentName: name } }
            DelegateChoice { roleValue: Constants.filterNumericalTypes[3]; FilterDataSmallerThan { componentName: name } }
            DelegateChoice { roleValue: Constants.filterNumericalTypes[4]; FilterDataGreaterThan { componentName: name } }
            DelegateChoice { roleValue: Constants.filterNumericalTypes[5]; FilterDataEqualOrSmaller { componentName: name } }
            DelegateChoice { roleValue: Constants.filterNumericalTypes[6]; FilterDataEqualorGreater { componentName: name } }
            DelegateChoice { roleValue: Constants.filterNumericalTypes[7]; FilterDataBetween { componentName: name } }
        }

        delegate: chooser
    }
}




