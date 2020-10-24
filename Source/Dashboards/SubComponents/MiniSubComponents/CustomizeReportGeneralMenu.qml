import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Rectangle{

    id: reportGeneralCustomize
    property bool categoryTab : true

    Connections{
        target: DashboardParamsModel

        function onCurrentReportChanged(reportId){
            let dashboardId = DashboardParamsModel.currentDashboard
            reportName.text = DashboardParamsModel.getReportName(dashboardId, reportId)
        }

    }



    function setReportName(reportName){
        let currentDashboardId = DashboardParamsModel.currentDashboard
        let currentReportId = DashboardParamsModel.currentReport
        DashboardParamsModel.setReportName(currentDashboardId, currentReportId, reportName)
    }


    Column{

        id: col
        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.topMargin: 5

        spacing: 5

        Text {
            text: qsTr("Report Name")
        }

        TextField{
            id: reportName
            width: parent.width
            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 6
                width: parent.width
                border.width: Constants.borderWidth
            }

            onTextChanged: setReportName(text)
        }
    }

}

