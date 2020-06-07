/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Query Modeller
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0


import "../MainSubComponents"
import "./SubComponents"

Page {

    id: query_modeller_page
    property int menu_width: 60
    property bool data_modeller_selected: true
    property int statusIndex: 1
    property bool collapsed: false

    ListModel{
        id : testQueryModel
        ListElement{
            status: "tick"
            queryNumber:"1"
            action:"SELECT * from  accounts LIMIT 0, 1000"
            message:"1 row(s) returned"
            duration:"01.000 sec"
        }
        ListElement{
            status: "cross"
            queryNumber:"2"
            action:"SELECT * from  accountssad LIMIT 0, 1000"
            message:"Error Code: 1146. Table 'grafieks_my.accountsasd' doesn't exist"
            duration:""
        }
        ListElement{
            status: "tick"
            queryNumber:"3"
            action:"SELECT * from  accountsasda LIMIT 0, 1000"
            message:"2 row(s) returned"
            duration:"01.000 sec"
        }
    }

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
                console.log("HEre i am",TableListModel)
            }
        }
    }

    // Left menubar starts

    LeftMenuBar{
        id: left_menubar
    }

    // Left menubar ends

    // Top toolbar starts

    Rectangle{
        id: submenu
        height: 22
        width: parent.width - menu_width - column_querymodeller.width
        x: menu_width - 11

        TabBar{

            id: tabbutton_querymodeller

            // Data Modeller Button starts

            TabButton{
                id: datamodeller_querymodeller
                text: "Data Modeller"
                width:100

                onClicked: {


                    if(!data_modeller_selected){
                        data_modeller_selected = !data_modeller_selected
                        datamodeller_querymodeller_background.color = Constants.darkThemeColor;
                        query_querymodeller_background.color = query_querymodeller_background.hovered ? Constants.darkThemeColor : Constants.themeColor

                        data_query_modeller_stackview.pop()
                        data_query_modeller_stackview.push("./SubComponents/DataModeller.qml")
                    }

                }

                onHoveredChanged: {
                    if(!data_modeller_selected){
                        datamodeller_querymodeller_background.color = datamodeller_querymodeller.hovered ? Constants.darkThemeColor : Constants.themeColor
                    }
                }

                background: Rectangle {
                    id: datamodeller_querymodeller_background
                    color: datamodeller_querymodeller.hovered ? Constants.darkThemeColor : Constants.themeColor

                }
                contentItem: Text{
                    id: datamodeller_querymodeller_text
                    text: datamodeller_querymodeller.text
                    color:  "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Component.onCompleted: {
                    datamodeller_querymodeller_background.color = Constants.darkThemeColor
                }

            }

            // Data Modeller Button ends

            // Query Modeller Button starts

            TabButton{
                id: query_querymodeller
                text: "Query"
                width:100

                onClicked: {

                    if(data_modeller_selected){
                        data_modeller_selected = !data_modeller_selected

                        query_querymodeller_background.color = Constants.darkThemeColor
                        datamodeller_querymodeller_background.color = datamodeller_querymodeller.hovered ? Constants.darkThemeColor : Constants.themeColor

                        data_query_modeller_stackview.pop()
                        data_query_modeller_stackview.push("./SubComponents/QueryModeller.qml")
                    }

                }

                onHoveredChanged: {
                    if(data_modeller_selected){
                        query_querymodeller_background.color = query_querymodeller.hovered ? Constants.darkThemeColor : Constants.themeColor
                    }
                }

                background: Rectangle {
                    id: query_querymodeller_background
                    color:  query_querymodeller.hovered ? Constants.darkThemeColor : Constants.themeColor

                }

                contentItem: Text{
                    id: query_querymodeller_text
                    text: query_querymodeller.text
                    color:  "black"
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
                height: 30
                width: 30


                Image{

                    source: "../../Images/icons/Refresh_30.png"
                    anchors.topMargin: 5
                    anchors.left: refresh_querymodeller.left
                    anchors.top: refresh_querymodeller.top
                    anchors.leftMargin: 5
                    height: 20
                    width: 20


                }


                background: Rectangle{
                    color: refresh_querymodeller.hovered ? Constants.darkThemeColor : "white"
                }

                onClicked: {
                    inMemory.visible = true
                }


            }


            // Refresh button ends

            // Filter button starts

            Button{
                id: filter_btn
                width: 100
                height: 30
                anchors.leftMargin: 10

                Image{
                    id: filter_querymodeller
                    source: "../../Images/icons/Plus_32.png"
                    anchors.topMargin: 5
                    anchors.leftMargin: 10
                    anchors.left: filter_btn.left
                    anchors.top: filter_btn.top
                    height: 20
                    width: 20

                }

                Text{
                    text: "Filter [0]"
                    anchors.top: filter_btn.top
                    anchors.left: filter_querymodeller.right
                    anchors.topMargin: 7
                    anchors.leftMargin: 5

                }

                background: Rectangle{
                    color: filter_btn.hovered ? Constants.darkThemeColor : "white"
                }

                onClicked: {
                    datafilters.visible = true
                }
            }

            // Filter button ends

            // Live radio button starts


            RadioButtonTpl{
                id: radio_live
                radio_text: qsTr("Live")
                radio_checked: true
                parent_dimension: 16
            }

            // Live radio button ends

            // In memory radio button starts

            RadioButtonTpl{
                id: radio_memory
                radio_text: qsTr("In Memory")
                radio_checked: false
                parent_dimension: 16
            }

            // In memory radio button ends
        }

    }


    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width - menu_width
        anchors.top: submenu.bottom
        anchors.horizontalCenter: submenu.horizontalCenter


        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }

    }

    // Top toolbar ends

    // Center Panel starts

    StackView{
        id: data_query_modeller_stackview

        anchors.top: toolsep1.bottom
        anchors.left:left_menubar.right
        height:query_modeller_page.height - 300
        width: query_modeller_page.width - menu_width - column_querymodeller.width
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

    // Data table and other info at bottom
    // Starts



    Item{

        id: infodata_table
        anchors.top: data_query_modeller_stackview.bottom
        anchors.left: left_menubar.right
        width: parent.width
        visible: true

        HorizontalLineTpl{
            id: linebar1
            line_color: Constants.themeColor
            line_width: parent.width
            anchors.top: infodata_table.top
        }

        Rectangle{
            id: toolbar_querymodeller

            width: 100
            anchors.top: linebar1.bottom
            anchors.left: parent.left
            height: 22

            Button{
                id: testQueryBtn
                height: 27
                width: 100
                leftPadding: 10
                topPadding: 8

                Text{
                    text: "Test Query"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    id: testQueryBtnBackground
                    color: testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked: {


                    testQueryBtnBackground.color = Constants.themeColor
                    displayLimitBtnBackground.color = displayLimitBtn.hovered ? Constants.themeColor : Constants.whiteColor
                    dataPreviewBtnBackground.color = dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor


                    testQueryResult.visible = true
                    dataPreviewResult.visible = false
                    displayResult.visible = false

                    QueryModel.callQuery()

                }
            }


        }

        ToolSeparator{
            id: seperator1
            height:30
            anchors.left:toolbar_querymodeller.right
            anchors.top: linebar1.top
            padding: 0
        }

        Rectangle{

            id: data_preview_btn
            width: 100
            anchors.top: linebar1.bottom
            anchors.left: seperator1.right
            height: 22

            Button{
                id: dataPreviewBtn
                height: 27
                width: 100
                leftPadding: 10
                topPadding: 8

                Text{
                    text: "Data Preview"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    id: dataPreviewBtnBackground
                    color: dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked: {

                    testQueryBtnBackground.color = testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor
                    dataPreviewBtnBackground.color = Constants.themeColor
                    displayLimitBtnBackground.color = displayLimitBtn.hovered ? Constants.themeColor : Constants.whiteColor

                    testQueryResult.visible = false
                    dataPreviewResult.visible = true
                    displayResult.visible = false

                }


            }


        }

        ToolSeparator{
            id: seperator2
            height:30
            anchors.left:data_preview_btn.right
            anchors.top: linebar1.top
            padding: 0
        }

        Rectangle{

            id: display_limited_btn
            width: 160
            anchors.top: linebar1.bottom
            anchors.left: seperator2.right
            height: 22

            Button{
                id: displayLimitBtn
                height: 27
                width: 160
                leftPadding: 10
                topPadding: 8

                Text{
                    text: "Display limited to top 100"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    id: displayLimitBtnBackground
                    color: displayLimitBtn.hovered ? Constants.themeColor : Constants.whiteColor
                }

                onClicked: {

                    testQueryBtnBackground.color = testQueryBtn.hovered ? Constants.themeColor : Constants.whiteColor
                    dataPreviewBtnBackground.color = dataPreviewBtn.hovered ? Constants.themeColor : Constants.whiteColor
                    displayLimitBtnBackground.color = Constants.themeColor

                    testQueryResult.visible = false
                    dataPreviewResult.visible = false
                    displayResult.visible = true

                }

            }

        }

        ToolSeparator{
            id: seperator3
            height:30
            anchors.left:display_limited_btn.right
            anchors.top: linebar1.top
            padding: 0
        }

        Rectangle{

            id: play_btn_rect
            width: 160
            anchors.top: linebar1.bottom
            anchors.left: seperator3.right
            height: 22

            Button{
                id: playBtn
                height: 27
                width: 27
                leftPadding: 10
                topPadding: 8

                Image {
                    id: playBtnImage
                    height: 24
                    width: 24
                    source: "../../Images/icons/play.png"
                    anchors.centerIn: parent
                }

                background: Rectangle{
                    color: playBtn.hovered ? "#009B8F" : "#0dd1c2"
                    opacity: 0.42
                }

            }

        }

        HorizontalLineTpl{
            id: linebar2
            line_color: Constants.themeColor
            line_width: parent.width
            anchors.topMargin: 28
            anchors.top: parent.bottom
        }

        // Result starts

        Rectangle{
            id:testQueryResult
            visible: false
            height: testQueryList.height
            width: parent.width
            anchors.top: linebar2.bottom

            ListView{
                id: testQueryList
                model:testQueryModel

                header: Row{
                    width: parent.width

                    Column{
                        width: 40
                        Rectangle {
                            height: 30
                            width: 40
                            Text{
                                text: ""
                            }
                        }
                    }

                    Column{
                        width: 40
                        Rectangle {
                            height: 30
                            width: 40
                            Text{
                                text: "#"
                                anchors.centerIn: parent
                            }
                        }
                    }

                    Column{
                        width: 200
                        Rectangle {
                            height: 30
                            width: 200
                            Text{
                                text: "Action"
                                anchors.centerIn: parent
                            }
                        }
                    }


                    Column{
                        width: 400
                        Rectangle {
                            height: 30
                            width: 400
                            Text{
                                text: "Message"
                                anchors.centerIn: parent
                            }
                        }
                    }


                    Column{
                        width: 120
                        Rectangle {
                            height: 30
                            width: 120
                            Text{
                                text: "Duration"
                                anchors.centerIn: parent
                            }
                        }
                    }
                }


            }



        }


        Row{
            id:dataPreviewResult
            anchors.topMargin: 30
            topPadding: 30
            leftPadding: 10
            visible: false
            Text {
                id: dataPreviewResultText
                anchors.top: linebar2.bottom
                text: qsTr("Data preview result")
            }
        }


        Row{
            id:displayResult
            anchors.topMargin: 30
            topPadding: 30
            leftPadding: 10
            visible: false
            Text {
                id: displayResultText
                anchors.top: linebar2.bottom
                text: qsTr("Table Result")
            }
        }

        // Result starts

    }
    // Data table and other info at bottom
    // Ends

    // Center Panel ends

    // Righthand Panel starts

    ToolSeparator{
        id: toolsep2
        height:parent.height
        anchors.right:parent.right
        anchors.top: parent.top
        anchors.rightMargin: 194
        anchors.topMargin: -5
    }


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

            // Tab button starts

            TabBar{
                id: tabbar_querymodeller

                width:rectangle_querymodeller_right_col.width

                background: Rectangle {
                    color: Constants.darkThemeColor
                }

                // Next button starts

                TabButton{
                    id: tabCreateDashboard
                    text:"Create Dashboard"
                    width:rectangle_querymodeller_right_col.width

                    onClicked: {

                        Datasources.setDsName(ds_name.text)
                        Datasources.setSourceType("live")

                        stacklayout_home.currentIndex = 6
                    }

                    background: Rectangle {
                        color: tabCreateDashboard.hovered? Constants.darkThemeColor: Constants.themeColor
                    }

                    contentItem: Text{
                        id:tabCreateDashboard_text
                        text: tabCreateDashboard.text
                        color:"black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

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

                            onClicked: {
                                TableListModel.callQuery(searchTextBox.text)
                            }
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

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 15
                        font.pixelSize: 12
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

                            onClicked: {

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
                }

            }

            // Right item 4 ends

            Button {
                id: publish_button
                text: qsTr("Publish Data Source")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
                width: parent.width

                onClicked: {
                    Datasources.setDsName(ds_name.text)
                    Datasources.setSourceType("live")
                    datasourceDescription.visible = true

                }
            }
        }
    }

    // Righthand Panel ends
    DataFilters{
        id: datafilters
    }

    DataSourceDescription{
        id: datasourceDescription
    }

    InMemory{
        id: inMemory
    }


    Component{
        id:tablelistDelegate

        Rectangle {
            id: wrapper
            width: 200
            height: 30

            Text {
                id: contactInfo
                text: tableName
                x: 20
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

}
