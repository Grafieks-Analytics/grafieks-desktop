import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts
import Qt.labs.platform
import QtQuick.Dialogs


import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

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
            //              opacitySpinBox.value = DashboardParamsModel.getReportOpacity(dashboardId, reportId)
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
        //        color: Constants.greenThemeColor
        modality: Qt.WindowModal
        title: "Choose a color"
        selectedColor: document.color
        onAccepted: setBackgroundColor(selectedColor)
    }
    Rectangle {
        id: document
    }

    ColorDialog{
        id: lineColorSelector
        modality: Qt.WindowModal
        title: "Choose a color"
        //        color: Constants.greenThemeColor
        selectedColor: document2.color
        onAccepted: setLineColor(selectedColor)
    }
    Rectangle {
        id: document2
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
                text: Messages.da_sub_crsm_bgcolor
            }

            Image {
                anchors.right: parent.right
                source: "/Images/icons/edit gray.png"
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
                text: Messages.da_sub_crsm_linecolor
            }

            Image {
                anchors.right: parent.right
                source: "/Images/icons/edit gray.png"
                height: 20
                width: 20

                MouseArea{
                    anchors.fill: parent
                    onClicked: lineColorSelector.open()
                }
            }

        }

        // Row{

        //     width: parent.width
        //     height: 30
        //     anchors.left: parent.left
        //     anchors.leftMargin: 15
        //     anchors.right: parent.right
        //     anchors.rightMargin: 15

        //     Text {
        //         id: opacity
        //         text: qsTr("Opacity")
        //         anchors.verticalCenter: parent.verticalCenter
        //     }

        //     CustomSpinBox {
        //         id: opacitySpinBox
        //         value: 0
        //         anchors.right: parent.right
        //         onValueChanged: onOpacityValueChanged(value)
        //     }

        // }


    }

}
