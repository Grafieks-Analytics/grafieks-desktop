import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{


    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts

    Connections{
        target: DashboardParamsModel

        function onCurrentReportChanged(reportId){

            let dashboardId = DashboardParamsModel.currentDashboard
            opacitySpinBox.value = DashboardParamsModel.getReportOpacity(dashboardId, reportId)
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function onOpacityValueChanged(value){
        let dashboardId = DashboardParamsModel.currentDashboard
        let reportId = DashboardParamsModel.currentReport

        DashboardParamsModel.setReportOpacity(dashboardId, reportId, value)

    }

    function setBackgroundColor(color){

        let dashboardId = DashboardParamsModel.currentDashboard
        let reportId = DashboardParamsModel.currentReport

        DashboardParamsModel.setReportBackgroundColor(dashboardId, reportId, color)
    }

    function setLineColor(color){

        let dashboardId = DashboardParamsModel.currentDashboard
        let reportId = DashboardParamsModel.currentReport

        DashboardParamsModel.setReportLineColor(dashboardId, reportId, color)

    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    ColorDialog{
        id: backgroundColorSelector
        onAccepted: setBackgroundColor(backgroundColorSelector.color)
    }

    ColorDialog{
        id: lineColorSelector
        onAccepted: setLineColor(lineColorSelector.color)
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



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
            height: 20
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15

            Text {
                id: backgroundColor
                text: qsTr("Background Color")
            }

            Image {
                anchors.right: parent.right
                source: "/Images/icons/Edit.png"
                height: 20
                width: 20

                MouseArea{
                    anchors.fill: parent
                    onClicked: backgroundColorSelector.open()
                }
            }

        }

        Row{

            width: parent.width
            height: 20
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15

            Text {
                id: lineColor
                text: qsTr("Line Color")
            }

            Image {
                anchors.right: parent.right
                source: "/Images/icons/Edit.png"
                height: 20
                width: 20

                MouseArea{
                    anchors.fill: parent
                    onClicked: lineColorSelector.open()
                }
            }

        }

        Row{

            width: parent.width
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15

            Text {
                id: opacity
                text: qsTr("Opacity")
                anchors.verticalCenter: parent.verticalCenter
            }

            CustomSpinBox {
                id: opacitySpinBox
                value: 0
                anchors.right: parent.right
                onValueChanged: onOpacityValueChanged(value)
            }

        }


    }

}
