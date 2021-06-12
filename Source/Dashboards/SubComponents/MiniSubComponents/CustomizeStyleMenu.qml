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
//            gridHideShowId.checked = DashboardParamsModel.getDashboardGrid(dashboardId)
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

    function startReDrawingCharts(){
        // Here are all the instances, Let's Redraw the charts
        let allReportInstances = ReportParamsModel.getAllDashboardReportInstances();
        for(var reportIdValue in allReportInstances){
            // Redrawing charts one by one;
            var instance = allReportInstances[reportIdValue]; 
            instance.reDrawChart();

            // Here I need to know the type of graphs that are generated
            // Or you will have to call the updated graph functions individually when I send an update graph signal
        }
    }



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts


    ColorDialog{
        id: backgroundColorSelector
        color: Constants.greenThemeColor
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

            id: backgroundColorBox
            width: parent.width
            height: 20
            anchors.top: parent.top
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
                source: "/Images/icons/edit gray.png"
                height: 18
                width: 18

                MouseArea{
                    anchors.fill: parent
                    onClicked: backgroundColorSelector.open()
                }
            }

        }



        Rectangle{
            id: opacityBox
            width: parent.width
            height: 30
            anchors.top: backgroundColorBox.bottom
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

        // [Tag: Refactor]
        // Remove this test button from here
        // Added this button to call redraw function in all the instances
        Row{
            anchors.top: opacityBox.bottom
            CustomButton{
                textValue: "Test Re Drawing Buton"
                onClicked: startReDrawingCharts();
            }
        }

        // [Tag: Future Release]
        // Grid Functionality 

//        Rectangle{

//            width: parent.width
//            height: 20
//            anchors.left: parent.left
//            anchors.leftMargin: 15
//            anchors.right: parent.right
//            anchors.rightMargin: 15

//            Text {
//                text: qsTr("Grid")
//            }

//            CheckBoxTpl{
//                id: gridHideShowId
//                checked: false
//                parent_dimension: Constants.defaultCheckBoxDimension
//                anchors.right: parent.right
//                anchors.top: parent.top

//                onCheckedChanged: setGridVisibility(checked)
//            }

//        }



    }

}
