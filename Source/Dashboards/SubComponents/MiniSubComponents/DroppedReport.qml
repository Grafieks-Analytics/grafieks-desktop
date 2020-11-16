import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1
import QtQuick.Dialogs 1.2
import QtWebEngine 1.10

import com.grafieks.singleton.constants 1.0

// This is the Image Widget dynamically called from MainContainer
// when a column is dropped from right side customize



Item{

    id:newItem

    visible: true

    anchors{
        top: mainContainer.top
        left: mainContainer.left
        right: mainContainer.right
        bottom: mainContainer.bottom
    }
     property var hoverStatusReport: false


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

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName)){
                droppedReportId.color = refColor
            }
        }

        function onReportLineColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            let reportId = DashboardParamsModel.currentReport

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName))
                droppedReportId.border.color = refColor
        }

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard){

            if(reportsInDashboard.includes(parseInt(mainContainer.objectName))){
                newItem.visible = true
            } else{
                newItem.visible = false
            }
        }

        function onReportUrlChanged(refDashboardId, refReportId, url){

            let dashboardId = DashboardParamsModel.currentDashboard
            let reportId = DashboardParamsModel.currentReport
            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName) && url !== ""){
//                let newUrl =  "file:" + GeneralParamsModel.getTmpPath()  + "../area.html"
                let newUrl = "qrc:/Source/Charts/area.html"
                webengine.url = newUrl
            }
        }

    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        // Add name to report
        // reportName.text = name
        webengine.url = "qrc:/Source/Charts/area.html"
    }

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()

        // Delete from c++
    }

    function editSelectedReport(){
        stacklayout_home.currentIndex = 7
    }

    function toggleFullScreen(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
//        if(mainContainer.width === dashboard_summary.width-5 && mainContainer.height === dashboard_summary.height-5)
//        {
//            mainContainer.width = Constants.defaultDroppedReportWidth
//            mainContainer.height = Constants.defaultDroppedReportHeight
//        }
//        else{
//            mainContainer.width= Qt.binding(function(){
//                return dashboard_summary.width-5 })
//            mainContainer.height= Qt.binding(function(){
//                return dashboard_summary.height-5 })
//            mainContainer.y=0
//            mainContainer.x=0

//        }
        if(mainContainer.width === parent.width-left_menubar.width && mainContainer.height === parent.height-5)
        {
            mainContainer.width = Constants.defaultDroppedReportWidth
            mainContainer.height = Constants.defaultDroppedReportHeight
           fullScreenReport.source= "/Images/icons/zoom_in_new.png"

        }
        else{
            mainContainer.width= Qt.binding(function(){
                return parent.width-left_menubar.width })
            mainContainer.height= Qt.binding(function(){
                return parent.height-5 })
            mainContainer.y=0
            mainContainer.x=0

             fullScreenReport.source= "/Images/icons/zoom_out_new.png"

        }

    }

    function showCustomizeReport(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        customizeReport.visible = true;
    }

    function onItemPressed(){
        DashboardParamsModel.setZIndex(++DashboardParamsModel.zIndex);
        newItem.z = DashboardParamsModel.zIndex;
        mainContainer.z = DashboardParamsModel.zIndex;
        console.log(mainContainer.rulerStatus)
    }
    function showMenusReport(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        hoverStatusReport = true
        mainContainer.rulerStatus = true
        console.log("test")
    }
    function hideMenusReport(){
        DashboardParamsModel.setCurrentReport(newItem.objectName)
        hoverStatusReport = false
        mainContainer.rulerStatus = false
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

        id: droppedReportId
        color: "white"
        border.width: 1
        border.color: Constants.darkThemeColor

        width: parent.width
        height: parent.height

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        MouseArea{
            height: parent.height-4
            width: parent.width-4
            anchors.centerIn: parent
            hoverEnabled: true
            onEntered: showMenusReport()
            onExited: hideMenusReport()
//            onEntered: {
//                mainContainer.rulerStatus=true

//            }
//            onExited: {
//                mainContainer.rulerStatus=false
//            }
            drag{
                target: mainContainer
                minimumX: 0
                minimumY: 0
//                maximumX: (mainContainer.parent.width)
//                maximumY: mainContainer.parent.height - mainContainer.height - Constants.subMenuWidth
//                maximumY: mainContainer.parent.height - mainContainer.height - Constants.subMenuWidth

//                 maximumY: Qt.binding(function(){ return (dashboard_summary.height - mainContainer.height + Constants.subMenuWidth) })
//                 maximumX: Qt.binding(function(){ return (dashboard_summary.width - mainContainer.width + Constants.leftMenubarWidth) })

//                maximumY: dashboard_summary.height - mainContainer.height + Constants.subMenuWidth
//                maximumX: dashboard_summary.width - mainContainer.width + Constants.leftMenubarWidth
                maximumY: dashboard_summary.height- mainContainer.height
                maximumX: dashboard_summary.width- mainContainer.width


            }
//            Drag.hotSpot.x: 2
//            Drag.hotSpot.y: 2
            onClicked:  showCustomizeReport()
            onPressed:  onItemPressed()
        }

        Rectangle{

            id: mainChart
            color: "transparent"
            anchors.top: parent.top
            height: 40
            width: parent.width
            border.color: Constants.darkThemeColor
            border.width: 1

            Text {
                id: reportName
                text: qsTr("Report Name")
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle{
                id: chartMenu
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height

                Row{
                    id:menuOptions

                    height: parent.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                     visible: hoverStatusReport

                    spacing: 10

                    Image{
                        id: editReport
                        height: 18
                        width: 18
                        source: "/Images/icons/edit grey.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked: editOptions.open()
                        }
                    }

                    Image{
                        id: resizeReport
                        height: 16
                        width: 16
                        source: "/Images/icons/view.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked: resizeOptions.open()
                        }
                    }

                    Image {
                        id: fullScreenReport
                        height: 16
                        width: 16
                        source: "/Images/icons/zoom_in_new.png"
//                        source: "/Images/icons/minimise.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent

                            onClicked: {
                                toggleFullScreen()
                            }

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
                            background: Rectangle{
                                implicitWidth: 200
                                border.color: Constants.darkThemeColor
                            }

                            MenuItem {
                                text: qsTr("Edit")
                                onTriggered: editSelectedReport()
                            }

                            MenuItem {
                                text: qsTr("Delete")
                                onTriggered: destroyElement()
                            }
                        }
                        Menu{
                            id: resizeOptions
                            background: Rectangle{
                                implicitWidth: 200
                                border.color: Constants.darkThemeColor
                            }

                            MenuItem {
                                text: qsTr("Standard")
                                onTriggered: editSelectedReport()
                            }

                            MenuItem {
                                text: qsTr("Custom")
                                onTriggered: destroyElement()
                            }
                        }

                    }


                }



            }


        }
        WebEngineView{
            id: webengine
            anchors.top : mainChart.bottom
            anchors.centerIn: parent

            width:newItem.width - 10
            height:newItem.height  - mainChart.height - 20

//                    onLoadingChanged: {

//                        switch(loadRequest.status){

//                        case ( WebView.LoadFailedStatus):
//                            webengine.visible = false
//                            chooseImage.visible = true
//                            break

//                        case ( WebView.LoadSucceededStatus):
//                            webengine.visible = true
//                            chooseImage.visible = false
//                            break
//                        }

//                    }

        }

    }

}
