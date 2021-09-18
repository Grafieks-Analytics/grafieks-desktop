import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{

    Connections{
        target: DashboardParamsModel

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard){

            let dashboardDimensions = DashboardParamsModel.getDashboardDimensions(dashboardId)
            widthId.value = dashboardDimensions[0]
            heightId.value = dashboardDimensions[1]
        }
    }

    Connections{
        target: ReportParamsModel

        function onGenerateWorkbookReports(){
            var dashboardDimensions = DashboardParamsModel.getDashboardDimensions(DashboardParamsModel.currentDashboard)
            widthId.value = dashboardDimensions[0]
            heightId.value = dashboardDimensions[1]
        }
    }

    function onWidthValueChanged(value){



        // Old function to set dimensions in individual canvas
        // Do not delete. Might be required later

        // let dashboardHeight = heightId.value
        // let dashboardId = DashboardParamsModel.currentDashboard
        // DashboardParamsModel.setDashboardDimensions(dashboardId, value, dashboardHeight)

        DashboardParamsModel.setTmpCanvasWidth(value)
        dashboard_summary.width=value
    }
    function onHeightValueChanged(value){

        // Old function to set dimensions in individual canvas
        // Do not delete. Might be required later

        // let dashboardWidth = widthId.value
        // let dashboardId = DashboardParamsModel.currentDashboard
        // DashboardParamsModel.setDashboardDimensions(dashboardId, dashboardWidth, value)

        DashboardParamsModel.setTmpCanvasHeight(value)
        dashboard_summary.height=value
    }

    Column{
        spacing: 10
        width: parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 10

        Row{

            width: parent.width
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 5

            Column{
                height: parent.height * 2
                width: parent.width/2
                spacing: 10
                Text {
                    text: qsTr("Width")
                }
                CustomSpinBox {
                    id: widthId
                    value: 1280
                    minimumValue :100
                    maximumValue:5000
                    onValueChanged: onWidthValueChanged(value)
                }
            }

            Column{
                height: parent.height * 2
                width: parent.width/2
                spacing: 10
                Text {
                    text: qsTr("Height")
                }
                CustomSpinBox {
                    id: heightId
                    value: 800
                    minimumValue :100
                    maximumValue:5000
                    onValueChanged: onHeightValueChanged(value)
                }
            }

        }

    }

}
