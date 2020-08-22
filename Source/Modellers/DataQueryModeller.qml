/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Query Modeller
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
//import Qt.labs.platform 1.1

import com.grafieks.singleton.constants 1.0


import "../MainSubComponents"
import "./SubComponents"

Page {

    id: queryModellerPage
    height: parent.height


    property int menu_width: 60
    property bool dataModellerSelected: true
    property int statusIndex: 1
    property bool collapsed: false
    property bool open: true
    property int dataPreviewNo: 6


    property Page page: queryModellerPage
    property LeftMenuBar leftMenuBar : left_menubar

    /***********************************************************************************************************************/
    // Connection Starts


    Connections{
        target: ConnectorsLoginModel

        onMysqlLoginStatus:{
            if(status.status === true){
                // Call functions
                TableListModel.callQuery()
                tableslist.model = TableListModel
            }
        }
        onSqliteLoginStatus:{
            if(status.status === true){
                // Call functions
                TableListModel.callQuery()
                tableslist.model = TableListModel
            }
        }
    }


    // Connection  Ends
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTIONS STARTS

    function onDataModellerClicked(){
        if(!dataModellerSelected){
            dataModellerSelected = !dataModellerSelected
            datamodeller_querymodeller_background.color = Constants.leftDarkColor;
            queryModellerTab_background.color = queryModellerTab_background.hovered ? Constants.leftDarkColor : Constants.themeColor
            datamodeller_querymodeller_text.color = Constants.blackColor
            // Prompt dialog to warn user of data deletion
            // If accepted, the clear data
            // and push to another stackview screen
            // MessageDialog defined at the bottom
            dataRemovalWarningDataModel.open()
        }
    }

    function onDataModellerHovered(){
        if(!dataModellerSelected){
            datamodeller_querymodeller_background.color = datamodeller_querymodeller.hovered ? Constants.grafieksGreenColor : Constants.themeColor
            datamodeller_querymodeller_text.color = datamodeller_querymodeller.hovered ? Constants.whiteColor : Constants.blackColor

        }
    }

    function onQueryModellerHovered(){
        if(dataModellerSelected){
            queryModellerTab_background.color = queryModellerTab.hovered ? Constants.grafieksGreenColor : Constants.themeColor
            queryModellerTab_text.color = queryModellerTab.hovered ? Constants.whiteColor : Constants.blackColor
            datamodeller_querymodeller_text.color = Constants.blackColor
        }
    }

    function onQueryModellerClicked(){

        if(dataModellerSelected){
            dataModellerSelected = !dataModellerSelected

            queryModellerTab_background.color = Constants.leftDarkColor
            datamodeller_querymodeller_background.color = datamodeller_querymodeller.hovered ? Constants.leftDarkColor : Constants.themeColor
            queryModellerTab_text.color = Constants.blackColor

            // Prompt dialog to warn user of data deletion
            // If accepted, the clear data
            // and push to another stackview screen
            // MessageDialog defined at the bottom
            dataRemovalWarningQueryModel.open()
        }

    }

    function showInMemoryPopup(){
        inMemory.visible = true
    }

    function onRefreshBtnClicked(){
        showInMemoryPopup()
    }

    function onInMemorySelected(){

        // Also set the C++ class
        // extract == in memory
        DSParamsModel.setDsType("extract")
    }

    function openDataFilters(){
        datafilters.visible = true
    }

    function onLiveSelected(){

        // Also set the C++ class
        DSParamsModel.setDsType("live")
    }

    function onCreateDashboardClicked(){

        Datasources.setDsName(ds_name.text)
        Datasources.setSourceType("live")

        stacklayout_home.currentIndex = 6
    }


    function onPublishDataSourceClicked(){
        publishDatasource.visible = true

        QueryStatsModel.setProfiling(false)
        QueryStatsModel.setProfileStatus(false)
    }

    function searchTable(text){
        TableListModel.callQuery(text)
    }

    function collapseTables(){

        if(collapsed === true){
            drop_icon.source = "../../../Images/icons/Up_20.png"
            collapsed = false
            tableslist.visible = true
        }
        else{
            drop_icon.source = "../../../Images/icons/Down_20.png"
            collapsed = true
            tableslist.visible = false
        }
    }


    function setDataSourceName(){
        DSParamsModel.setDsName(ds_name.text)
    }

    function focusDataSourceNameField(){
        ds_name.readOnly= false
        ds_name.focus = true;
        console.log('Focussed')
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/






    /***********************************************************************************************************************/
    // SubComponents Starts

    DataFilters{
        id: datafilters
    }

    PublishDatasource{
        id: publishDatasource
    }

    InMemory{
        id: inMemory
    }


    Component{
        id:tablelistDelegate

        Rectangle {
            id: dragRect
            width: 200
            height: 30
            property bool caught: false

            Image {
                id: tableImg
                height: 22
                width: 22
                source: "../../Images/icons/table_32.png"
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: contactInfo
                text: tableName
                anchors.left: tableImg.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                drag.target: dragRect
                drag.minimumX: -(  page.width - parent.width - leftMenuBar.width)
                drag.maximumX: 0


                drag.onActiveChanged: {
                    if (mouseArea.drag.active) {
                        tableslist.dragItemIndex = index;
                        tableslist.tableName = tableName
                    }
                    dragRect.Drag.drop();
                }
            }

            states: [
                State {
                    when: dragRect.Drag.active
                    ParentChange {
                        target: dragRect
                        parent: tableslist
                    }

                    AnchorChanges {
                        target: dragRect
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                    }
                }
            ]

            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: dragRect.width / 2
            Drag.hotSpot.y: dragRect.height / 2
        }
    }

    MessageDialog{
        id: dataRemovalWarningDataModel
        title: "Warning"
        text: "Your query will be lost. Are you sure you want to proceed?"
        icon: StandardIcon.Critical

        onAccepted: {
            dataQueryModellerStackview.pop()
            dataQueryModellerStackview.push("./SubComponents/DataModeller.qml")
        }
    }

    MessageDialog{
        id: dataRemovalWarningQueryModel
        title: "Warning"
        text: "Your diagram will be lost. Are you sure you want to proceed?"
        icon: StandardIcon.Critical

        onAccepted: {
            QueryModel.setTmpSql("")

            dataQueryModellerStackview.pop()
            dataQueryModellerStackview.push("./SubComponents/QueryModeller.qml")
        }

    }

    ButtonGroup{
        id: memoryType
    }

    // SubComponents ends
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Page Design Starts

    // Left menubar starts

    LeftMenuBar{
        id: left_menubar
    }

    // Left menubar ends


    // Top toolbar starts - Sub menu -> Data modeller and Query Modeller Tabs + Filter Btns

    Rectangle{
        id: submenu
        height: 22.5
        width: parent.width - menu_width - column_querymodeller.width
        x: menu_width - 11

        TabBar{

            id: tabbutton_querymodeller


            // Data Modeller Button starts

            TabButton{
                id: datamodeller_querymodeller
                text: "Data Modeler"
                width:100

                onClicked: onDataModellerClicked()
                onHoveredChanged: onDataModellerHovered()

                background: Rectangle {
                    id: datamodeller_querymodeller_background
                    color: {
                        datamodeller_querymodeller.hovered ? Constants.grafieksGreenColor : Constants.themeColor
                    }
                }

                contentItem: Text{
                    id: datamodeller_querymodeller_text
                    text: datamodeller_querymodeller.text
                    color:  datamodeller_querymodeller.hovered ? Constants.whiteColor : Constants.blackColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Component.onCompleted: {
                    datamodeller_querymodeller_background.color = Constants.leftDarkColor
                    datamodeller_querymodeller_text.color = Constants.blackColor
                }

            }

            // Data Modeller Button ends



            // Query Modeller Button starts

            TabButton{
                id: queryModellerTab
                text: "Query Modeler"
                width:100

                onClicked: onQueryModellerClicked()
                onHoveredChanged: onQueryModellerHovered()

                background: Rectangle {
                    id: queryModellerTab_background
                    color:  queryModellerTab.hovered ? Constants.grafieksGreenColor : Constants.themeColor

                }

                contentItem: Text{
                    id: queryModellerTab_text
                    text: queryModellerTab.text
                    color:  queryModellerTab.hovered ? Constants.whiteColor : Constants.blackColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }

            // Query Modeller button ends



        }

        Row{
            id: toptool_querymodeller
            anchors.right: submenu.right
            anchors.rightMargin: 10

            // Refresh button starts

            Button{
                id:refresh_querymodeller
                height: 28
                width: 30

                Image{

                    source: "../../Images/icons/Refresh_30.png"
                    anchors.topMargin: 4
                    anchors.left: refresh_querymodeller.left
                    anchors.top: refresh_querymodeller.top
                    anchors.leftMargin: 5
                    height: 20
                    width: 20

                }


                background: Rectangle{
                    color: refresh_querymodeller.hovered ? Constants.darkThemeColor : "white"
                }

                onClicked: onRefreshBtnClicked()

            }

            // Refresh button ends




            // Filter button starts

            Button{
                id: filter_btn
                width: 100
                height: 28
                anchors.leftMargin: 10

                Image{
                    id: filter_querymodeller
                    source: "../../Images/icons/Plus_32.png"
                    anchors.topMargin: 4
                    anchors.leftMargin: 10
                    anchors.left: filter_btn.left
                    anchors.top: filter_btn.top
                    height: 20
                    width: 20

                }

                Text{
                    id: filterText
                    text: "Filter"
                    anchors.top: filter_btn.top
                    anchors.left: filter_querymodeller.right
                    anchors.topMargin: 6
                    anchors.leftMargin: 5
                }

                Text {
                    id: filterLeftSquareBracket
                    anchors.left: filterText.right
                    anchors.top: filter_btn.top
                    anchors.topMargin: 6
                    anchors.leftMargin: 2
                    text: qsTr("[")
                    color: Constants.grafieksGreen
                }
                Text {
                    id: filterNumber
                    anchors.left: filterLeftSquareBracket.right
                    anchors.top: filter_btn.top
                    anchors.topMargin: 6
                    text: qsTr("0")
                }
                Text {
                    id: filterRightSquareBracket
                    anchors.left: filterNumber.right
                    anchors.top: filter_btn.top
                    anchors.topMargin: 6
                    text: qsTr("]")
                    color: Constants.grafieksGreen
                }

                background: Rectangle{
                    color: filter_btn.hovered ? Constants.darkThemeColor : "white"
                }

                onClicked: openDataFilters()
            }

            // Filter button ends



            // Live radio button starts


            CustomRadioButton{
                id: radio_live
                radio_text: qsTr("Live")
                radio_checked: true
                parent_dimension: 16
                ButtonGroup.group: memoryType
                onCheckedChanged: onLiveSelected()
            }

            // Live radio button ends



            // In memory radio button starts

            CustomRadioButton{
                id: radio_memory
                radio_text: qsTr("In Memory")
                radio_checked: false
                parent_dimension: 16

                ButtonGroup.group: memoryType
                onCheckedChanged: onInMemorySelected()
            }

            // In memory radio button ends
        }

    }

    /***********************************************************************************************************************/


    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width - menu_width - 100
        anchors.top: submenu.bottom
        leftPadding: left_menubar.width
        anchors.horizontalCenter: submenu.horizontalCenter

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }

    }

    // Top toolbar ends





    /***********************************************************************************************************************/
    // Center Panel starts

    StackView{
        id: dataQueryModellerStackview

        anchors.top: toolsep1.bottom
        anchors.left:left_menubar.right
        height:queryModellerPage.height - 300
        width: queryModellerPage.width - menu_width - column_querymodeller.width
        rightPadding: 10
        leftPadding: 10

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 1
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 1
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 1
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 1
            }
        }

        initialItem: DataModeller{}
    }


    // Center Panel Ends
    /***********************************************************************************************************************/



    // Data table and other info at bottom Starts

    InfoTable{

        id: infodata_table
        anchors.top: dataQueryModellerStackview.bottom
        anchors.left: left_menubar.right
        width: parent.width
        visible: true

    }

    // Info table Ends


    ToolSeparator{
        id: toolsep2
        height:parent.height
        anchors.right:parent.right
        anchors.top: parent.top
        anchors.rightMargin: 194
        anchors.topMargin: -5
    }



    // Righthand Panel starts


    Column{
        id: column_querymodeller

        height:parent.height
        width: 200
        anchors.right:parent.right
        spacing: 50


        Rectangle{
            id: rectangle_querymodeller_right_col
            color:Constants.themeColor
            width:column_querymodeller.width
            height:column_querymodeller.height
            border.color: Constants.darkThemeColor

            // Tab button starts

            TabBar{
                id: tabbar_querymodeller

                width:rectangle_querymodeller_right_col.width

                background: Rectangle {
                    color: "transparent"
                }
                // Next button starts

                TabButton{
                    id: tabPublishDashboard
                    width:rectangle_querymodeller_right_col.width / 2
                    height: parent.height

                    Image {
                        id: publishIcon
                        source: "../../Images/icons/publish_20.png"
                        height: 20
                        width: 20
                        anchors.centerIn: parent
                    }

                    onClicked: onPublishDataSourceClicked()

                    background: Rectangle{
                        color: Constants.grafieksLightGreenColor
                        opacity: tabPublishDashboard.hovered ? 0.42 : 1
                    }

                }


                TabButton{
                    id: tabCreateDashboard
                    width:rectangle_querymodeller_right_col.width / 2
                    height: parent.height

                    Image {
                        id: dashboardIcon
                        source: "../../Images/icons/create_dashboard_20.png"
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

                    onClicked: onCreateDashboardClicked()

                }

                // Next button ends
            }

            // Tab button ends



            // Right item 1 starts

            Rectangle{
                id: rectangle_querymodeller_right_col1

                anchors.top: tabbar_querymodeller.bottom
                anchors.topMargin: 2

                height:50
                width: rectangle_querymodeller_right_col.width

                TextEdit{
                    id: ds_name
                    text: "Data Source Name"
                    anchors.verticalCenter: rectangle_querymodeller_right_col1.verticalCenter
                    anchors.left: rectangle_querymodeller_right_col1.left
                    anchors.leftMargin: 10
                    readOnly: true

                    // Set the text
                    onTextChanged: setDataSourceName()

                }

                Image {
                    id: dataSourceNameEditIcon
                    source: "../../Images/icons/edit-32.png"
                    height: 20
                    width: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea{
                        anchors.fill: parent
                        onClicked: focusDataSourceNameField()
                    }
                }
            }

            // Right item 1 ends

            // Right item 2 starts

            Rectangle{
                id: rectangle_querymodeller_right_col2

                anchors.top: rectangle_querymodeller_right_col1.bottom
                anchors.topMargin: 2
                height:50
                width: rectangle_querymodeller_right_col.width
                color:Constants.themeColor

                Text{
                    id: connected_to
                    text: "Connected To: " + ConnectorsLoginModel.currentDbName
                    // text: "Connected To: grafieks_my"
                    anchors.verticalCenter: rectangle_querymodeller_right_col2.verticalCenter
                    anchors.left: rectangle_querymodeller_right_col2.left
                    anchors.leftMargin: 10

                }
            }

            // Right item 2 ends

            // Right item 3 starts

            Rectangle{
                id: rectangle_querymodeller_right_col3

                anchors.top: rectangle_querymodeller_right_col2.bottom
                anchors.topMargin: 2
                height:50
                width: rectangle_querymodeller_right_col.width

                Row{

                    id: row_querymodeller_right_col

                    TextField{
                        id:searchTextBox
                        placeholderText: "Search"
                        width:rectangle_querymodeller_right_col3.width - search_icon.width
                        height:30
                        cursorVisible: true
                        anchors.top: row_querymodeller_right_col.top
                        anchors.topMargin: 5

                        background: Rectangle{
                            border.width: 0
                        }

                    }

                    Image{
                        id:search_icon
                        source:"../../Images/icons/Search.png"
                        height:25
                        width:25
                        anchors.rightMargin: 10
                        anchors.top: row_querymodeller_right_col.top
                        anchors.topMargin: 7.5

                        MouseArea{
                            anchors.fill: parent

                            onClicked: searchTable(searchTextBox.text)
                        }
                    }
                }

                ToolSeparator{
                    id: toolsep3
                    orientation: Qt.Horizontal
                    width: rectangle_querymodeller_right_col3.width - 10
                    anchors.top: row_querymodeller_right_col.bottom
                    anchors.horizontalCenter: row_querymodeller_right_col.horizontalCenter
                    anchors.topMargin: 5
                }
            }

            // Right item 3 ends

            // Right item 4 starts

            Item{
                id: item_querymodeller
                width: rectangle_querymodeller_right_col3.width - 10
                anchors.top: rectangle_querymodeller_right_col3.bottom
                anchors.topMargin: 2

                Rectangle {
                    id: categoryItem
                    height: 50
                    width: 200

                    Image {
                        id: database
                        height: 28
                        width: 22
                        source: "../../Images/icons/database_32x36.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        anchors.left: database.right
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Constants.fontCategoryHeaderSmall
                        text: "Database Name 1"
                    }


                    Image {
                        id: drop_icon
                        source: "../../Images/icons/Up_20.png"
                        width: 10
                        height: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        visible: true

                        MouseArea {
                            anchors.fill: parent

                            onClicked: collapseTables()
                        }
                    }
                }

                ListView {
                    id: tableslist
                    spacing: 2
                    anchors.top: categoryItem.bottom
                    height : contentHeight
                    delegate: tablelistDelegate
                    visible: true

                    property int dragItemIndex: -1
                    property string tableName : ""
                }

            }

        }
    }

    // Righthand Panel ends

    //Page Design Ends
    /***********************************************************************************************************************/


}
