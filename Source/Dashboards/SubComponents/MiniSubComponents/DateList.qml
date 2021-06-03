import QtQuick 2.15
import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

ListView {

    id: dateChecksItem
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
<<<<<<< HEAD
    interactive: true
    clip: true
    height: parent.height-dataTypeDate.height-5
    width: parent.width-15
    ScrollBar.vertical: ScrollBar {}
=======
    interactive: false
    clip: false
    height: parent.height
    width: parent.width
    property var currentDashboardId: 0
>>>>>>> b190c6dfb8132196e77fc617b5f7f27a60ec1e4e


    Connections{
        target : TableColumnsModel

        function onSendFilteredColumn(currentDashboard, allCategorical, allNumerical, allDates){
            if(currentDashboard === DashboardParamsModel.currentDashboard){
                dateChecksItem.model =  allDates
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
<<<<<<< HEAD
        height: 30
=======
        height: 20
         checkbox_checked: DashboardParamsModel.fetchShowColumns(DashboardParamsModel.currentDashboard).indexOf(modelData) < 0 ? false: true
>>>>>>> b190c6dfb8132196e77fc617b5f7f27a60ec1e4e
        checkbox_text: modelData
        parent_dimension: 16
        onCheckedChanged: handleCheckChange(checkBox1.checkbox_text, checked)
    }

}
