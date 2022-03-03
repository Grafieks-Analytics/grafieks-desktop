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

    ListModel{
        id: listmodel
    }
    
    Connections{
        target : TableColumnsModel

        function onSendFilteredColumn(currentDashboard, allCategoricalMap, allNumericalMap, allDatesMap){

            if(currentDashboard === DashboardParamsModel.currentDashboard){
                for(const [key, value] of Object.entries(allCategoricalMap)){
                    listmodel.append({"key" : key, "value": value})
                }

                categoricalChecksItem.model =  listmodel
                currentDashboardId = currentDashboard
            }
        }
    }

    Connections{
        target: DashboardParamsModel

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard, dashboardUniqueWidgets){
            currentDashboardId = dashboardId
        }
    }

    Connections {
        target: ReportParamsModel

        function onGenerateWorkbookReports(){

        }
    }

    function handleCheckChange(colName, colValue, status){
        if(currentDashboardId === DashboardParamsModel.currentDashboard){
            if(colName !== ""){
                TableColumnsModel.setColumnVisibility(DashboardParamsModel.currentDashboard, colValue, Constants.categoricalTab, status)
                DashboardParamsModel.addToShowColumns(DashboardParamsModel.currentDashboard, colValue, status)
            }
        }
    }

    delegate: CheckBoxTpl{
        id: checkBox1
        height: 30
        checkbox_checked: DashboardParamsModel.fetchShowColumns(DashboardParamsModel.currentDashboard).indexOf(key) < 0 ? false: true
        checkbox_text: key
        parent_dimension: 16
        onCheckedChanged: handleCheckChange(key, value, checked)
    }

}
