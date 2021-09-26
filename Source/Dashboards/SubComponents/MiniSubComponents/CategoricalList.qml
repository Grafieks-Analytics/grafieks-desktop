import QtQuick 2.15
import com.grafieks.singleton.constants 1.0
import QtQuick.Controls 2.15

import "../../../MainSubComponents"

ListView {

    id: categoricalChecksItem
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    interactive: true
    clip: true
    height: parent.height-text4.height-5
    width: parent.width-15
    ScrollBar.vertical: ScrollBar {}
    property var currentDashboardId: 0

    
    Connections{
        target : TableColumnsModel

        function onSendFilteredColumn(currentDashboard, allCategorical, allNumerical, allDates){
            if(currentDashboard === DashboardParamsModel.currentDashboard){
                categoricalChecksItem.model =  allCategorical
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

    Connections {
        target: ReportParamsModel

        function onGenerateWorkbookReports(){

        }
    }

    function handleCheckChange(colName, status){
        if(currentDashboardId === DashboardParamsModel.currentDashboard){
            if(colName !== ""){
                TableColumnsModel.setColumnVisibility(DashboardParamsModel.currentDashboard, colName, Constants.categoricalTab, status)
                DashboardParamsModel.addToShowColumns(DashboardParamsModel.currentDashboard, colName, status)
            }
        }
    }

    delegate: CheckBoxTpl{
        id: checkBox1
        height: 30
        checkbox_checked: DashboardParamsModel.fetchShowColumns(DashboardParamsModel.currentDashboard).indexOf(modelData) < 0 ? false: true
        checkbox_text: modelData
        parent_dimension: 16
        onCheckedChanged: handleCheckChange(checkBox1.checkbox_text, checked)
    }

}
