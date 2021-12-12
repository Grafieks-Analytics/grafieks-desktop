/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard
** New Dashboard
**
****************************************************************************/


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.7
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"
import "./SubComponents"

Page {

    id: new_dashboard_page
    property int menu_width: 60

    property int is_dashboard_blank: 0

    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    // List model for all dashboards
    ListModel{
        id: dashboardModel
    }


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts


    Connections {
        target: DashboardParamsModel

        function onDashboardNameChanged(dashboardId, dashboardName){
            for(var i = 0; i < dashboardModel.rowCount(); i++){
                if(dashboardModel.get(i).dashboardId === dashboardId){
                    dashboardModel.get(i).dashboardName = dashboardName
                }
            }
        }

        function onHideAllDashboardParams(){
            column_filter_newdashboard.visible = false
            column_newdashboard.visible = false
            column_filter_newdashboard_add.visible = false
        }

        function onCurrentDashboardChanged(dashboardId, reportsInDashboard, dashboardUniqueWidgets){
            column_filter_newdashboard.visible = false
            column_newdashboard.visible = false
            column_filter_newdashboard_add.visible = false

            // [TODO: Required]
            // Update height and width of dashboard area
            // Get and Set old values
            // Or Set value by default
            // dashboard_summary.height = Constants.defaultDashboardHeight
            // dashboard_summary.width = Constants.defaultDashboardWidth
            
        }

        function onDashboardContentDestroyed(dashboardId){

            if(dashboardId === -1){
                dashboardModel.clear()
                dashboardModel.append({"dashboardName" : 'Dashboard 1', 'dashboardId': 0, backgroundColorTest:"white"})
                is_dashboard_blank = 0
            }
        }
    }

    Connections{
        target: TableColumnsModel

        function onVisibleColumnListChanged(visibleColumnsTypeMap){

            column_filter_newdashboard.visible = true

            // hide other panels
            column_newdashboard.visible = false
            column_filter_newdashboard_add.visible = false
        }
    }

    Connections{
        target: ReportParamsModel

        function onGenerateWorkbookReports(){
            var dashboards = DashboardParamsModel.fetchAllDashboards()
            var dashboardIds = Object.keys(dashboards);
            var dashboardNames = Object.values(dashboards);

            // We will start from i =1 because component on completed already generated first dashboard
            for(var i = 1; i < dashboardNames.length; i++){
                dashboardModel.append({"dashboardName" : dashboardNames[i], 'dashboardId': parseInt(dashboardIds[i])})
                TableColumnsModel.addNewDashboard(parseInt(dashboardIds[i]))
            }

        }

    }

    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    Component.onCompleted: {
        column_newdashboard.visible = true
        dashboardModel.append({"dashboardName" : 'Dashboard 1', 'dashboardId': 0, backgroundColorTest:"white"})
    }

    function openDashboardFilters(){

        // [Tag: Refactor]
        // Return in if
        // this will reduce id else ladders

        if(column_filter_newdashboard.visible === true){
            column_filter_newdashboard.visible = false

            // hide other panels
            column_newdashboard.visible = false
        }
        else{
            column_filter_newdashboard.visible = true

            // hide other panels
            column_newdashboard.visible = false
            column_filter_newdashboard_add.visible = false
        }

    }
    function openDashboardFiltersAdd(){

        // [Tag: Refactor]
        // Return in if
        // this will reduce id else ladders
        if(column_filter_newdashboard_add.visible === true){
            column_filter_newdashboard_add.visible = false

            // hide other panels
            column_newdashboard_add.visible = false
        }
        else{
            column_filter_newdashboard_add.visible = true

            // hide other panels
            column_newdashboard.visible = false
            column_filter_newdashboard.visible = false
        }

    }

    function onCustomizeBtnClicked(){

        // [Tag: Refactor]
        // Return in if
        // this will reduce id else ladders
        if(column_newdashboard.visible === true){
            column_newdashboard.visible = false

            // hide other panels
            column_filter_newdashboard.visible = false
        }
        else{
            column_newdashboard.visible = true

            // hide other panels
            column_filter_newdashboard.visible = false
            column_filter_newdashboard_add.visible = false
        }
    }

    function addDashboard(){

        let currentCount = DashboardParamsModel.dashboardCount
        let newCount = currentCount + 1
        DashboardParamsModel.setDashboardCount(newCount)

        var previousDashboardIndex = DashboardParamsModel.currentDashboard;
        var themeColorCopy = Constants.themeColor.toString();

        var allDashboardKeys = Object.keys(DashboardParamsModel.fetchAllDashboards());
        var newDashboardId = parseInt(allDashboardKeys[allDashboardKeys.length - 1]) + 1

        let newDashboardName =  "Dashboard "+ (newDashboardId + 1)
        dashboardModel.append({"dashboardName" : newDashboardName, 'dashboardId': newDashboardId})


        DashboardParamsModel.createNewDashboard(newDashboardId)
        DashboardParamsModel.setCurrentDashboard(newDashboardId)

        dashboardModel.setProperty(previousDashboardIndex,"backgroundColorTest",themeColorCopy);
        DashboardParamsModel.setDashboardName(newDashboardId, newDashboardName)

        TableColumnsModel.addNewDashboard(newDashboardId)
    }

    function setCurrentDashboard(dashboardId,index){
        var listContent = dashboardList.contentItem.children
        var previousDashboardIndex = DashboardParamsModel.currentDashboard;
        var themeColorCopy = Constants.themeColor.toString();

        if(dashboardModel.get(previousDashboardIndex))
            dashboardModel.setProperty(previousDashboardIndex,"backgroundColorTest",themeColorCopy);

        dashboardModel.setProperty(index,"backgroundColorTest","white");
        DashboardParamsModel.setCurrentDashboard(dashboardId)

    }

    function createNewReport(){
        var reportId = ReportParamsModel.generateNewReportId();
        ReportParamsModel.setReportId(reportId);


        ReportParamsModel.clearReportsScreen();
        // Setting Edit toggle to false
        // Signal event is added
        // If Edit Report is false =>  We clear the chart value
        ReportParamsModel.setEditReportToggle(false);
        GeneralParamsModel.setCurrentScreen(Constants.reportScreen)
        stacklayout_home.currentIndex = Constants.newReportIndex;

    }

    function scrollToLeft(){
        dashboardList.flick(300, 0)
    }

    //    function scrollToExtremeLeft(){
    //        dashboardList.flick(300, 0)
    //    }

    function scrollToRight(){
        dashboardList.flick(-300, 0)
    }

    function deleteDashboard(index){
        dashboardModel.remove(index, 1);
        DashboardParamsModel.destroyDashboard(index)
        TableColumnsModel.deleteDashboard(index)
    }

    function getEndPos(){
        var ratio = 1.0 - dashboardList.visibleArea.widthRatio;
        var endPos = dashboardList.contentWidth * ratio;
        return endPos;
    }

    function scrollToExtremeRight(){
        dashboardList.contentX = getEndPos();
    }

    function scrollToExtremeLeft(){
        dashboardList.contentX = 0;
    }

    function onPublishWorkbookClicked(){
        // If already logged in, dont prompt
        if (typeof settings.value("user/sessionToken") == "undefined"){
            connectGrafieks1.visible = true
        } else{
            ProjectsListModel.fetchProjectList()
            publishWorkbookPopup.open()
        }
    }



    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    SaveWorkbookPopup{
        id: publishWorkbookPopup
    }

    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    LeftMenuBar{
        id: left_menubar
    }

    Rectangle{
        id: submenu
        height: 22.5
        width: parent.width - menu_width + 11
        x: menu_width - 11




        // Add new Dashboard Button Starts

        Button{
            id: new_dashboard_btn
            anchors.left: parent.left
            width: 50
            z:1000

            Image{
                id: new_dashboard_icon
                source: "/Images/icons/Plus_32.png"
                height: 20
                width: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter:  parent.horizontalCenter
            }

            background: Rectangle {
                id: new_dashboard_btn_background
                color:  new_dashboard_btn.pressed? Constants.darkThemeColor: Constants.themeColor

            }
            contentItem: Text{
                id: new_dashboard_btn_text
                text: new_dashboard_btn.text
                color:  "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }


            onClicked: addDashboard()
        }

        // Add new Dashboard Button End

        // All Dashboards Lists Starts

        Row{
            height: 50
            //            width: submenu.width - toptool_newdashboard.width - 500
            width: 300
            anchors.left: new_dashboard_btn.right
            anchors.right: parent.right
            anchors.rightMargin: 30

            ListView{
                id: dashboardList
                height: parent.height
                width: submenu.width - toptool_newdashboard.width - 50

                model: dashboardModel
                orientation: ListView.Horizontal

                // When scroll end align to the nearest item
                snapMode: ListView.SnapToItem
                // data outside specified size during flick
                clip: true
                // Increase Flick speed
                maximumFlickVelocity: 10000
                cacheBuffer:1000
                delegate: CustomDashboardNameButton{
                    id: dashboardNameButton
                    textValue: dashboardName
                    bgColor: (backgroundColorTest?backgroundColorTest:"white")
                    Component.onCompleted: {
                        if(dashboardNameButton.width > 100){
                            dashboardNameButton.width = 100
                        }else{
                            dashboardNameButton.width = dashboardNameButton.width
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse.button == Qt.RightButton) ? options.open() : setCurrentDashboard(dashboardId,index)
                    }

                    Menu{
                        id: options
                        y: dashboardNameButton.height
                        MenuItem {
                            text: qsTr("Delete")
                            onClicked: deleteDashboard(index)
                        }
                    }
                }
            }
        }

        // Dashboard List Ends

        // Sub menu Right Buttons Starts

        Row{
            id: toptool_newdashboard
            anchors.right: submenu.right


            // left dashboard button starts
            Button{
                width: 20
                height: 28
                Row{
                    spacing: 5
                    anchors.centerIn: parent
                    Image {
                        source: "/Images/icons/extreme_left.png"
                        width: 20
                        height: 20
                    }
                }
                onPressed: scrollToExtremeLeft()
                background: Rectangle {
                    color: parent.hovered? Constants.darkThemeColor: Constants.whiteColor
                }

            }
            // left dashboard button ends



            // left dashboard button starts
            Button{
                width: 20
                height: 28
                Row{
                    spacing: 5
                    anchors.centerIn: parent
                    Image {
                        source: "/Images/icons/arrow_left.png"
                        width: 20
                        height: 20
                    }
                }
                onPressed: scrollToLeft()
                background: Rectangle {
                    color: parent.hovered? Constants.darkThemeColor: Constants.whiteColor
                }

            }
            // left dashboard button ends



            // right dashboard button starts

            Button{

                width: 20
                height: 28

                Row{
                    spacing: 5
                    anchors.centerIn: parent
                    Image {
                        source: "/Images/icons/arrow_right.png"
                        width: 20
                        height: 20
                    }
                }

                onPressed: scrollToRight()

                background: Rectangle {
                    color: parent.hovered? Constants.darkThemeColor: Constants.whiteColor
                }

            }

            // right dashboard button ends


            // right dashboard button starts

            Button{

                width: 20
                height: 28

                Row{
                    spacing: 5
                    anchors.centerIn: parent
                    Image {
                        source: "/Images/icons/extreme_right.png"
                        width: 20
                        height: 20
                    }
                }

                onPressed: scrollToExtremeRight()

                background: Rectangle {
                    color: parent.hovered? Constants.darkThemeColor: Constants.whiteColor
                }

            }

            ToolSeparator{
                orientation: Qt.Vertical
                height: 26

                anchors.verticalCenter: parent.verticalCenter

                contentItem: Rectangle {
                    implicitWidth: parent.vertical ? 1 : 24
                    implicitHeight: parent.vertical ? 25 : 1
                    color: Constants.grafieksGreen
                }

            }

            // [Tag: Future Release]
            // Remove if not requied

            // Add Report Button Ends

            // Filter button starts

            //            Button{
            //                width: 100
            //                height: 28
            //                anchors.leftMargin: 10

            //                Row{
            //                    spacing: 5
            //                    anchors.centerIn: parent



            //                    Text{
            //                        id: filterText
            //                        text: "Filter"
            //                        anchors.verticalCenter: parent.verticalCenter
            //                    }

            //                    Text {
            //                        id: filterLeftSquareBracket
            //                        text: qsTr(":")
            //                        //                        color: Constants.grafieksGreen

            //                        anchors.verticalCenter: parent.verticalCenter
            //                    }
            //                    Image{
            //                        id: filter_querymodeller
            //                        source: "/Images/icons/Plus_32.png"
            //                        height: 20
            //                        width: 20
            //                    }
            //                    Image{
            //                        id: filter_show_querymodeller
            //                        source: "/Images/icons/show.png"
            //                        height: 12
            //                        width: 16
            //                        anchors.verticalCenter: parent.verticalCenter
            //                    }


            //                }

            //                background: Rectangle{
            //                    color: parent.hovered ? Constants.darkThemeColor : "white"
            //                }

            //                onClicked: openDashboardFilters()
            //            }

            Button{

                width: 100
                height: 28



                Row{
                    spacing: 5
                    anchors.centerIn: parent

                    Text{
                        id: filterText
                        text: "Filter"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        //                        id: filterLeftSquareBracket
                        text: qsTr(":")
                        //                        color: Constants.grafieksGreen

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Button{
                        //
                        width: 20
                        height: 28
                        onClicked: openDashboardFiltersAdd()
                        Image{
                            id: filter_querymodeller
                            source: "/Images/icons/Plus_32.png"
                            height: 20
                            width: 20
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter:  parent.horizontalCenter
                        }


                        background: Rectangle {
                            //                            id: report_btn_background
                            color: parent.hovered? Constants.darkThemeColor: Constants.whiteColor

                        }

                    }
                    Button{
                        //
                        width: 20
                        height: 28
                        onClicked: openDashboardFilters()
                        Image{
                            id: filter_show_querymodeller
                            source: "/Images/icons/show.png"
                            height: 11
                            width: 16
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter:  parent.horizontalCenter
                        }


                        background: Rectangle {
                            //                            id: report_btn_background
                            color: parent.hovered? Constants.darkThemeColor: Constants.whiteColor

                        }

                    }



                }
                background: Rectangle {
                    //                        id: report_btn_background
                    color:  Constants.whiteColor
                }


            }
            ToolSeparator{
                orientation: Qt.Vertical
                height: 26

                anchors.verticalCenter: parent.verticalCenter

                contentItem: Rectangle {
                    implicitWidth: parent.vertical ? 1 : 24
                    implicitHeight: parent.vertical ? 25 : 1
                    color: Constants.grafieksGreen
                }

            }
            // Filter Button Ends

            // Customize Button Starts



            Button{

                width: 110
                height: 28
                //                anchors.right: parent.right
                anchors.rightMargin: 20



                Row{
                    spacing: 5
                    //                    anchors.centerIn: parent


                    Text{
                        text: "Customize"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        //                        id: filterLeftSquareBracket
                        text: qsTr(":")
                        //                        color: Constants.grafieksGreen

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Button{
                        //
                        width: 28
                        height: 28
                        onClicked:onCustomizeBtnClicked()


                        Image {
                            source: "/Images/icons/customize.png"
                            width: 16
                            height: 16
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter:  parent.horizontalCenter
                        }

                        background: Rectangle {
                            color: parent.hovered? Constants.darkThemeColor: Constants.whiteColor

                        }

                    }



                }
                background: Rectangle {
                    //                        id: report_btn_background
                    color:  Constants.whiteColor
                }


            }
            // Customize Button Ends
            // Tab button starts

            TabBar{
                id: tabbar_dashboard

                width:200
                z: 20

                background: Rectangle {
                    color: "transparent"
                }
                // Next button starts

                TabButton{
                    id: tabPublishDashboard
                    width:rectangle_querymodeller_right_col.width / 2
                    height: parent.height
                    z: 20

                    Image {
                        id: publishIcon
                        source: "/Images/icons/publish_20.png"
                        height: 20
                        width: 20
                        anchors.centerIn: parent
                    }

                    onClicked: onPublishWorkbookClicked()

                    background: Rectangle{
                        color: Constants.grafieksLightGreenColor
                        opacity: tabPublishDashboard.hovered ? 0.42 : 1
                    }

                    ToolTip.delay:Constants.tooltipShowTime
                    ToolTip.timeout: Constants.tooltipHideTime
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Publish Dashboard")

                }


                TabButton{
                    id: tabCreateDashboard
                    width:rectangle_querymodeller_right_col.width / 2
                    height: parent.height
                    z: 20

                    Image {
                        id: dashboardIcon
                        source: "/Images/icons/create_dashboard_20.png"
                        height: 20
                        width: 20
                        anchors.centerIn: parent
                    }

                    contentItem: Text{
                        id:tabCreateDashboard_text
                    }
                    background: Rectangle {
                        color: Constants.grafieksLightGreenColor
                        opacity: tabCreateDashboard.hovered ? 0.42 : 1
                    }

                    onClicked: createNewReport()

                    ToolTip.delay:Constants.tooltipShowTime
                    ToolTip.timeout: Constants.tooltipHideTime
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Create Report")

                }

                // Next button ends
            }

            // Tab button ends


        }

        // Sub menu right button ends

    }


    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width - left_menubar.width
        anchors.top: submenu.bottom
        anchors.left: left_menubar.right
        anchors.leftMargin: -2
        anchors.horizontalCenter: submenu.horizontalCenter

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 25 : 1
            color: Constants.darkThemeColor

        }

    }

    // Center Panel Starts

    Rectangle{
        color:Constants.themeColor
        anchors.left: left_menubar.right
        anchors.top: toolsep1.bottom
        anchors.topMargin: -6
        height: parent.height
        width:parent.width

        Flickable {
            id: dashboardMain

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 0
            height: parent.height
            width:parent.width

            contentHeight: dashboard_summary.height
            contentWidth: dashboard_summary.width
            
            clip: true

            ScrollBar.horizontal: ScrollBar {
                policy: ScrollBar.AlwaysOn
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                implicitHeight: dashboard_summary.width > parent.width ? 10 : 0
                implicitWidth: dashboard_summary.width
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
                anchors.right: parent.right
                anchors.rightMargin: 50
                implicitHeight: dashboard_summary.height
                implicitWidth: dashboard_summary.height > parent.height ? 10 : 0
            }

            boundsMovement: Flickable.StopAtBounds

            DashboardSummary{
                id: dashboard_summary
                //        height: parent.height
                //        width: parent.width

                // [Tag: Refector]
                // Move this to constants
                // Initial Chart Dimension
                height: Constants.defaultDashboardHeight
                width: Constants.defaultDashboardWidth


                Text{
                    id:hintText
                    text:  !is_dashboard_blank ? "Add Reports and Widgets Here" : ""
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Constants.grayColor
                }

                // [Tag: Refactor]
                // Remove Commented Code

                //        anchors.left: left_menubar.right
                //        anchors.top: toolsep1.bottom
                //        anchors.topMargin: -6

                //        width: parent.width  - left_menubar.width
            }
        }
    }
    // Center Panel Ends



    // Right Dashboard Customize Starts

    Column{
        id: column_newdashboard

        height:parent.height - submenu.height
        width: 200
        anchors.right:parent.right
        anchors.top: submenu.bottom
        anchors.topMargin: 4
        spacing: 50

        visible: false


        z:99999999


        ToolSeparator{

            anchors.left: column_newdashboard.left
            anchors.top: parent.top
            anchors.leftMargin: -8
            height:parent.height

            contentItem: Rectangle {
                implicitWidth: parent.vertical ? 1 : 24
                implicitHeight: parent.vertical ? 24 : 1
                color: Constants.darkThemeColor
            }
        }


        Rectangle{
            id: rectangle_newdashboard_right_col
            color:Constants.themeColor
            width:column_newdashboard.width
            height:column_newdashboard.height
            anchors.top: parent.top
            anchors.topMargin: 3

            Rectangle{
                id: rectangle_newdashboard_right_col1

                height:50
                width: rectangle_newdashboard_right_col.width

                Text{
                    text: "Customize Dashboard"
                    anchors.verticalCenter: rectangle_newdashboard_right_col1.verticalCenter
                    anchors.left: rectangle_newdashboard_right_col1.left
                    anchors.leftMargin: 10
                }
            }

            // Widget Drawer starts

            DashboardCustomize{
                id: listViewElem
                anchors.top: rectangle_newdashboard_right_col1.bottom
                anchors.left: parent.left
            }

            // Widget Drawer ends
        }

    }

    // Right Dashboard Customize Ends

    CustomizeReport{
        id: customizeReport

        z:100000000
    }

    // Right Filter Starts

    Column{
        id: column_filter_newdashboard

        height:parent.height - submenu.height
        width: 200
        anchors.right:parent.right
        anchors.top: submenu.bottom
        anchors.topMargin: 4
        spacing: 50
        visible: false

        z:99999999


        ToolSeparator{
            anchors.top: parent.top
            anchors.left: column_newdashboard.left

            height:parent.height

            contentItem: Rectangle {
                implicitWidth: parent.vertical ? 1 : 24
                implicitHeight: parent.vertical ? 24 : 1
                color: Constants.darkThemeColor
            }
        }


        DashboardFilters{}
    }

    // Right Filter Ends
    // Right Filter Add Starts

    Column{
        id: column_filter_newdashboard_add

        height:parent.height - submenu.height
        width: 200
        anchors.right:parent.right
        anchors.top: submenu.bottom
        anchors.topMargin: 4
        spacing: 50
        visible: false

        z:99999999


        ToolSeparator{
            anchors.top: parent.top
            anchors.left: column_newdashboard.left

            height:parent.height

            contentItem: Rectangle {
                implicitWidth: parent.vertical ? 1 : 24
                implicitHeight: parent.vertical ? 24 : 1
                color: Constants.darkThemeColor

            }
        }


        DashboardFiltersAdd{}
    }

    // Right Filter Ends


    // Page Design Ends
    /***********************************************************************************************************************/

}
