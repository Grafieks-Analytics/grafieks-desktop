import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.8
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

            if(dashboardId === refDashboardId && refReportId === parseInt(newItem.objectName))
                droppedTextId.color = refColor
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
        hoverStatus = true
        mainContainer.rulerStatus = true
    }
    function hideMenus(){
        hoverStatus = false
        mainContainer.rulerStatus = false
    }

    Component.onCompleted: {
        var globalCordinates = this.mapToGlobal(0,0)
        console.log('global x',globalCordinates.x)
        console.log('global y',globalCordinates.y)
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
                        height: 20
                        width: 20
                        source: "/Images/icons/Edit.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked:  editOptions.open()
                        }
                    }

                    Image {
                        id: fullScreenReport
                        height: 22
                        width: 22
                        source: "/Images/icons/fullscreen.png"
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea{
                            anchors.fill: parent
                            onClicked:  toggleFullScreen()
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
            height: parent.height-4
            width: parent.width-4
            anchors.centerIn: parent
            onDoubleClicked: showTextEditor()
            hoverEnabled: true
            drag{
                target: mainContainer
                minimumX: Constants.leftMenubarWidth
                minimumY: 29
                maximumX: mainContainer.parent.width - mainContainer.width
                maximumY: mainContainer.parent.height - mainContainer.height - Constants.subMenuWidth
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
            height:newItem.height - 10 - textMenu.height

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

            Component.onCompleted: {
                let path = GeneralParamsModel.getTmpPath() + "0_1_" + GeneralParamsModel.getFileToken() + ".html"
                webengine.url = "file:" + path
            }

        }

    }

    WidgetTextEditor{
        id: textEditor
    }


}

