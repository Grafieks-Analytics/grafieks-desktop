import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

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
    property var filePathSet: false
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

            console.log(newItem.objectName, parseInt(newItem.objectName), "PARSE INT")

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

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard, dashboardUniqueWidgets){

            if(reportsInDashboard.includes(parseInt(mainContainer.objectName))){
                newItem.visible = true
            } else{
                newItem.visible = false
            }
        }


        function onReportUrlChanged(refDashboardId, refReportId, url){

            let dashboardId = DashboardParamsModel.currentDashboard
            let reportId = DashboardParamsModel.currentReport
            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName)){
                webengine.url = GeneralParamsModel.getTmpPath() + url

                textEditor.widgetReportId = refReportId
                textEditor.widgetDashboardId = refDashboardId
                webengine.reload()
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

    //    onWebUrlChanged: {
    //        webengine.url = "file:" + webUrl
    //    }

    Component.onCompleted: {
        //        var globalCordinates = this.mapToGlobal(0,0)
        //        console.log('global x',globalCordinates.x)
        //        console.log('global y',globalCordinates.y)
        //        let currentDashboard = DashboardParamsModel.currentDashboard
        //        let currentReport = DashboardParamsModel.currentReport + 1


        //        let path = GeneralParamsModel.getTmpPath()  + currentDashboard + "_" + currentReport + "_" + GeneralParamsModel.getFileToken() + ".html"
        //        webengine.url = "file:" + path
    }

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
                        source: "/Images/icons/edit gray.png"
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
                        source: "/Images/icons/close gray.png"
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

            onPositionChanged: DashboardParamsModel.setDashboardWidgetCoordinates(DashboardParamsModel.currentDashboard, DashboardParamsModel.currentReport, newItem.x, newItem.y, newItem.x + mainContainer.width, newItem.y + mainContainer.height)
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
                    editText.visible = true
                    break

                case ( WebView.LoadSucceededStatus):
                    webengine.visible = true
                    editText.visible = false
                    break
                }

            }

        }

    }

    CustomButton{
        id: editText
        textValue: "Edit Text"
        anchors.centerIn: parent
        visible: true
        onClicked: showTextEditor()
    }

    WidgetTextEditor{
        id: textEditor
        visible: false
    }


}

