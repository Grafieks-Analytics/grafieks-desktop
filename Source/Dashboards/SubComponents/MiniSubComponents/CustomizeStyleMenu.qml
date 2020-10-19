import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import com.grafieks.singleton.constants 1.0

import QtQuick.Dialogs 1.3

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

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard){

            opacitySpinBox.value = DashboardParamsModel.getDashboardOpacity(dashboardId)
            gridHideShowId.checked = DashboardParamsModel.getDashboardGrid(dashboardId)
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function onOpacityValueChanged(value){
        let dashboardId = DashboardParamsModel.currentDashboard
        DashboardParamsModel.setDashboardOpacity(dashboardId, value)
    }

    function setGridVisibility(checkedState){

        let dashboardId = DashboardParamsModel.currentDashboard
        DashboardParamsModel.setDashboardGrid(dashboardId, checkedState)
    }

    function setBackgroundColor(color){

        let dashboardId = DashboardParamsModel.currentDashboard
        DashboardParamsModel.setDashboardBackgroundColor(dashboardId, color)
    }



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    ColorDialog{
        id: backgroundColorSelector
        onAccepted: setBackgroundColor(backgroundColorSelector.color)
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

        Rectangle{

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



        Rectangle{

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

        Rectangle{

            width: parent.width
            height: 20
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15

            Text {
                text: qsTr("Grid")
            }

            CheckBoxTpl{
                id: gridHideShowId
                checked: false
                parent_dimension: Constants.defaultCheckBoxDimension
                anchors.right: parent.right
                anchors.top: parent.top

                onCheckedChanged: setGridVisibility(checked)
            }

        }



    }

}
