import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1

import com.grafieks.singleton.constants 1.0

// This is the Text Widget dynamically called from MainContainer
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
    property string webUrl: ""


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

                droppedTextId.color = refColor
                webengine.reload()
            }
        }


        function onReportLineColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            let reportId = DashboardParamsModel.currentReport

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName))
                droppedTextId.border.color = refColor
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
            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName))
                webengine.reload()
        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        var globalCordinates = this.mapToGlobal(0,0)
        console.log('global x',globalCordinates.x)
        console.log('global y',globalCordinates.y)

        let currentDashboard = DashboardParamsModel.currentDashboard
        let currentReport = DashboardParamsModel.currentReport + 1

        console.log(currentDashboard, currentReport, "CURRENT")

        let path = GeneralParamsModel.getTmpPath() + currentDashboard + "_" + currentReport + "_" + GeneralParamsModel.getFileToken() + ".html"
        webengine.url = "file:" + path
    }

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()

        // Delete from c++
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

    function showTextEditor(){

        textEditor.visible = true
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



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    Rectangle {

        id: droppedTextId
        color: "white"
        border.width: 1
        border.color: Constants.darkThemeColor
        height: parent.height
        width: parent.width

        // Edit Menu Options Starts

        Rectangle{

            id: textMenu
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

                    Image{
                        id: editReport
                        height: 18
                        width: 18
                        source: "/Images/icons/Edit.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked: showTextEditor()
                        }
                    }

                    Image {
                        id: fullScreenReport
                        height: 16
                        width: 16
                        source: "/Images/icons/close black.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent

                            onClicked: destroyElement()
                        }
                    }
                }

            }


        }

        // Edit Menu Options Ends

        MouseArea{
            height: parent.height-4
            width: parent.width-4
            anchors.centerIn: parent
            onDoubleClicked: showTextEditor()
            hoverEnabled: true
            drag{
                target: mainContainer
                minimumX: 0
                minimumY: 0
                maximumY: dashboard_summary.height- mainContainer.height
                maximumX: dashboard_summary.width- mainContainer.width

                smoothed: true
            }
            onClicked:  showCustomizeReport()
            onPressed:  onItemPressed()
            onEntered: showMenus()
            onExited: hideMenus()

        }

        WebView{
            id: webengine
            anchors.top : textMenu.bottom
            anchors.centerIn: parent

            width:newItem.width - 10
            height:newItem.height - textMenu.height

            onLoadingChanged: {

                switch(loadRequest.status){

                case ( WebView.LoadFailedStatus):
                    webengine.visible = false
                    break

                case ( WebView.LoadSucceededStatus):
                    webengine.visible = true
                    break
                }

            }

        }

    }

    WidgetTextEditor{
        id: textEditor
    }


}

