import QtQuick 2.15
import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

ListView {

    id: numericalChecksItem
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    interactive: false
    clip: false
    height: parent.height
    width: parent.width
    property var currentDashboardId: 0


    Connections{
        target : TableColumnsModel

        function onSendFilteredColumn(currentDashboard, allCategorical, allNumerical, allDates){
            if(currentDashboard === DashboardParamsModel.currentDashboard){
                numericalChecksItem.model =  allNumerical
                currentDashboardId = currentDashboard
            }
        }
    }

    Connections{
        target: DashboardParamsModel

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard){
            currentDashboardId = dashboardId
        }
    }

    function handleCheckChange(colName, status){
        if(currentDashboardId === DashboardParamsModel.currentDashboard){
            if(colName !== ""){
                TableColumnsModel.setColumnVisibility(DashboardParamsModel.currentDashboard, colName, status)
                DashboardParamsModel.addToShowColumns(DashboardParamsModel.currentDashboard, colName, status)
            }
        }
    }

    delegate: CheckBoxTpl{
        id: checkBox1
        height: 20
        checkbox_checked: DashboardParamsModel.fetchShowColumns(DashboardParamsModel.currentDashboard).indexOf(modelData) < 0 ? false: true
        checkbox_text: modelData
        parent_dimension: 16
        onCheckedChanged: handleCheckChange(checkBox1.checkbox_text, checked)
    }

}
