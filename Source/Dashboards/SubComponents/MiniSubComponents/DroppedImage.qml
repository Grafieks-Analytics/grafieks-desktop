import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 1.1
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

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


    property var hoverStatus: false

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
                droppedImageId.color = refColor
        }

        function onReportLineColorChanged(refDashboardId, refReportId, refColor){

            let dashboardId = DashboardParamsModel.currentDashboard
            let reportId = DashboardParamsModel.currentReport

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName))
                droppedImageId.border.color = refColor
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
                let newUrl =  "file:" + GeneralParamsModel.getTmpPath()  + url
                webengine.url = newUrl
            }
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {

        selectFile()
        webengine.url = ""
    }

    function selectFile(){
        fileDialog.open()
    }

    function destroyElement(){
        mainContainer.destroy()
        this.destroy()
        is_dashboard_blank = is_dashboard_blank - 1

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
           fullScreenReport.source= "/Images/icons/zoom in gray.png"

        }
        else{
            mainContainer.width= Qt.binding(function(){
                return parent.width-left_menubar.width })
            mainContainer.height= Qt.binding(function(){
                return parent.height-5 })
            mainContainer.y=0
            mainContainer.x=0

             fullScreenReport.source= "/Images/icons/zoom out gray.png"

        }

    }


    function saveImage(selectedFile){
        let currentDashboard = DashboardParamsModel.currentDashboard
        let currentReport = DashboardParamsModel.currentReport
        let fileToken = GeneralParamsModel.getFileToken();

        const newFileName = currentDashboard + "_" + currentReport + "_" + fileToken

        DashboardParamsModel.saveImage(selectedFile, newFileName)
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    FileDialog{
        id: fileDialog
        title: "Select a file (*.jpg *.jpeg *.png  only)"
        selectMultiple: false
        nameFilters: [ "Image files (*.jpg *.jpeg *.png )"]

        onAccepted: saveImage(fileUrl)
        onRejected: webengine.url = ""
    }



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Rectangle {

        id: droppedImageId
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

        // Edit Menu Options Starts

        Rectangle{

            id: imageMenu
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
                        height: 20
                        width: 20
                        source: "/Images/icons/edit gray.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked:  selectFile()
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

            onClicked:  showCustomizeReport()
            onPressed:  onItemPressed()
            onEntered: showMenus()
            onExited: hideMenus()
        }



        WebView{
            id: webengine
            anchors.top : imageMenu.bottom
            anchors.centerIn: parent
            visible: false

            width:newItem.width - 10
            height:newItem.height  - imageMenu.height

            onLoadingChanged: {

                switch(loadRequest.status){

                case ( WebView.LoadFailedStatus):
                    webengine.visible = false
                    chooseImage.visible = true
                    break

                case ( WebView.LoadSucceededStatus):
                    webengine.visible = true
                    chooseImage.visible = false
                    break
                }

            }

        }



    }

    CustomButton{
        id: chooseImage
        textValue: "Choose Image"
        anchors.centerIn: parent
        visible: true
        onClicked: selectFile()
    }

}

