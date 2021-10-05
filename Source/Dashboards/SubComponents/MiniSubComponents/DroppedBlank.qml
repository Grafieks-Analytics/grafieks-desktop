import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

// This is the Blank Widget dynamically called from MainContainer
// when a column is dropped from right side customize

Item{

    id: newItem
    visible: true

    anchors{
        top: mainContainer.top
        left: mainContainer.left
        right: mainContainer.right
        bottom: mainContainer.bottom
    }


    property var hoverStatus: false
    property var uniqueHash: "" // Important to identify unique reports with same report and dashboard id

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

        function onReportBackgroundColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            let reportId = DashboardParamsModel.currentReport

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName))
                droppedRectangle.color = refColor
        }

        function onReportLineColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            let reportId = DashboardParamsModel.currentReport

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName))
                droppedRectangle.border.color = refColor
        }

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard, dashboardUniqueWidgets){

            if(reportsInDashboard.includes(parseInt(mainContainer.objectName)) && dashboardUniqueWidgets.hasOwnProperty(uniqueHash)){
                newItem.visible = true
            } else{
                newItem.visible = false
            }
        }

        function onDashboardContentDestroyed(dashboardId){
            if(dashboardId === -1){
                newItem.destroy()
            }
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()
        is_dashboard_blank = is_dashboard_blank - 1

        // Delete from c++
        DashboardParamsModel.deleteReport(DashboardParamsModel.currentReport, DashboardParamsModel.currentDashboard)
        DashboardParamsModel.deleteDashboardUniqueWidget(DashboardParamsModel.currentDashboard, uniqueHash)
    }

    function showCustomizeReport(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        customizeReport.visible = true;

    }

    function onItemPressed(){
        DashboardParamsModel.setZIndex(++DashboardParamsModel.zIndex);
        newItem.z = DashboardParamsModel.zIndex;
        mainContainer.z = DashboardParamsModel.zIndex;
    }


    function showMenus(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        hoverStatus = true
        mainContainer.rulerStatus = true
    }
    function hideMenus(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        hoverStatus = false
        mainContainer.rulerStatus = false
    }

    function toggleFullScreen(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    Rectangle {

        id: droppedRectangle
        color: "white"
        border.width: 1
        border.color: Constants.darkThemeColor
        height: parent.height
        width: parent.width

        // Edit Menu Options Starts

        Rectangle{

            color: "transparent"
            anchors.top: parent.top
            height: 40
            width: parent.width
            z:20000

            Rectangle{
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height

                Row{
                    id:menuOptions

                    height: parent.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 10

                    spacing: 10
                    z:20001

                    visible: hoverStatus

                    Image {
                        id: fullScreenReport
                        height: 16
                        width: 16
                        source: "/Images/icons/close gray.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent

                            onClicked: destroyElement()
                        }
                    }

                }

                Row{

                    anchors.left: parent.right
                    anchors.top: menuOptions.bottom
                    width: parent.width
                    height: 100

                    Item {
                        id: name
                        anchors.left:menuOptions.left

                        x: -editOptions.width

                        Menu{
                            id: editOptions

                            MenuItem {
                                text: qsTr("Edit")
                                onTriggered: showTextEditor()
                                onHoveredChanged: showMenus()
                            }

                            MenuItem {
                                text: qsTr("Delete")
                                onTriggered: destroyElement()
                                onHoveredChanged: showMenus()
                            }
                        }

                    }

                }

            }


        }

        // Edit Menu Options Ends


        MouseArea{
            anchors.centerIn: parent
            height: parent.height-4
            width: parent.width-4

            hoverEnabled: true
            drag{
                target: mainContainer
                minimumX: 0
                minimumY: 0
                maximumY: dashboard_summary.height- mainContainer.height
                maximumX: dashboard_summary.width- mainContainer.width
                smoothed: true
            }
            onPositionChanged: DashboardParamsModel.setDashboardWidgetCoordinates(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentReport, newItem.x, newItem.y, newItem.x + mainContainer.width, newItem.y + mainContainer.height)

            onClicked:  showCustomizeReport()
            onPressed:  onItemPressed()
            onEntered: showMenus()
            onExited: hideMenus()

        }


    }

}

