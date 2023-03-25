/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Sources
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
//import QtQuick.Controls 1.4 as OldControls

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../MainSubComponents"
import "./SubComponents"


Page {

    id: datasourcelist_page
    property int menu_width: 60
    property var clickedItemConnectionType: ""
    property bool connectAllowed: true
    background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }

    Component.onCompleted: {
        DatasourceDS.fetchDatsources(0, false, true)

        // Connect signal and slot
        data_source_grid.updateDSName.connect(datasourcelist_page.updateDSNameTitle)
        data_source_list.updateDSName.connect(datasourcelist_page.updateDSNameTitle)

    }

    // Slots
    function updateDSNameTitle(signalDSName, updateDSName, connectAllowed){
        ds_name_header.text = signalDSName
        datasourcelist_page.clickedItemConnectionType = updateDSName
        datasourcelist_page.connectAllowed = connectAllowed

        console.log(datasourcelist_page.connectAllowed, connectAllowed)
    }


    function processDS(){

        if(datasourcelist_page.connectAllowed === true){
            GeneralParamsModel.setAPISwitch(true)
            if(datasourcelist_page.clickedItemConnectionType === "live"){
                GeneralParamsModel.setForAPI(ds_name_header.text, Constants.sqlType)
            } else {
                GeneralParamsModel.setForAPI(ds_name_header.text, Constants.duckType)
            }

            ReportsDataModel.generateColumnsForExtract()
            TableColumnsModel.generateColumnsFromAPI() // Statics::currentDBClassification, Statics::currentDSFile
            stacklayout_home.currentIndex = 6
            DSParamsModel.setDsName(ds_name_header.text)
        } else {
            connectionError.open()
        }
    }



    LeftMenuBar{
        id: left_menubar
    }

    ConnectionError{
        id: connectionError
    }


    Rectangle{
        id: submenu
        height: 20
        width: parent.width - menu_width
        x: menu_width
        z: 5


        Button{
            id: next_btn
            anchors.right: parent.right
            anchors.top: submenu.top
            anchors.topMargin: 0
            height: 30
            width:70

            onClicked: processDS()
            Image {
                id: dashboardIcon
                source: "/Images/icons/create_dashboard_20.png"
                height: 20
                width: 20
                anchors.centerIn: parent
            }

            background: Rectangle{
                id: next_btn_background
                color: Constants.grafieksLightGreenColor
                opacity: tabCreateDashboard.hovered ? 0.42 : 1
            }

            ToolTip.delay:Constants.tooltipShowTime
            ToolTip.timeout: Constants.tooltipHideTime
            ToolTip.visible: hovered
            ToolTip.text: Messages.ds_ds_create


        }

        TabBar{
            id: tabbar_ds
            anchors.right: next_btn.left
            anchors.rightMargin: 1
            anchors.top: submenu.top
            anchors.topMargin: 0
            currentIndex: stacklayout_ds.currentIndex
            z: 5

            Component.onCompleted: {
                grid_btn_background.color = Constants.darkThemeColor
                list_btn_background.color = Constants.themeColor
            }

            TabButton{
                id: grid_btn
                icon.source: "/Images/icons/Grid.png"
                icon.color: "black"
                height: 30
                

                background: Rectangle {
                    id: grid_btn_background
                    color:"white"
                    implicitHeight: 30
                    implicitWidth: 30
                }

                onClicked: {
                    grid_btn_background.color = Constants.darkThemeColor
                    list_btn_background.color = Constants.themeColor
                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipShowTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.ds_ds_grid


            }

            TabButton{
                id: list_btn
                icon.source: "/Images/icons/List.png"
                icon.color: "black"
                height: 30

                background: Rectangle {
                    id: list_btn_background
                    color:"white"
                    implicitHeight: 30
                    implicitWidth: 30
                }


                onClicked: {
                    grid_btn_background.color = Constants.themeColor
                    list_btn_background.color = Constants.darkThemeColor
                }

                ToolTip.delay: Constants.tooltipShowTime
                ToolTip.timeout: Constants.tooltipShowTime
                ToolTip.visible: hovered
                ToolTip.text: Messages.ds_ds_list

            }
        }

    }



    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width - menu_width
        anchors.top: submenu.bottom
        anchors.horizontalCenter: submenu.horizontalCenter
        z: 5

        padding: vertical ? 10 : 2
        topPadding: vertical ? 2 : 10
        bottomPadding: vertical ? 2 : 10

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }

    }

    Rectangle{
        id: info_rectangle
        height: 70
        width: parent.width - menu_width
        anchors.top: toolsep1.bottom
        anchors.horizontalCenter: toolsep1.horizontalCenter
        x: menu_width
        z: 5

        Row{

            anchors.left: parent.left
            anchors.leftMargin: 20
            width: info_rectangle.width
            anchors.horizontalCenter: parent.horizontalCenter

            Grid{
                id: grid1
                columns: 2
                spacing: 20

                Text{
                    id: ds_server_label_header
                    text: Messages.ds_ds_server
                }
                Text{
                    id: ds_server_header
                    text: settings.value("general/sitelookup").includes("http:") || settings.value("general/sitelookup").includes("https:") ? settings.value("general/sitelookup") : "https://" + settings.value("general/sitelookup")
                }
                Text{
                    id: ds_name_label_header
                    text: Messages.ds_ds_name
                }
                Text{
                    id: ds_name_header
                    text: Messages.ds_ds_notSelected
                }
            }


            // Search box

            Rectangle{
                id:search_rect
                anchors.right:parent.right
                anchors.verticalCenter: grid1.verticalCenter
                anchors.rightMargin: 50
                border.color: Constants.darkThemeColor
                width: 250
                height: 35
                radius:5

                TextField {
                    id: search_text
                    placeholderText: Messages.search
                    width:250
                    height: 30
                    anchors.left: search_rect.left
                    verticalAlignment:TextEdit.AlignVCenter
                    background:Rectangle{
                        width:250
                        height: 35
                        radius:5
                        border.color: Constants.darkThemeColor
                    }

                    onTextChanged: DatasourceDS.fetchDatsources(0, false, true, search_text.text)
                }


            }
        }
    }


    ToolSeparator{
        id: toolsep2
        orientation: Qt.Horizontal
        width: parent.width - menu_width
        anchors.top: info_rectangle.bottom
        anchors.horizontalCenter: info_rectangle.horizontalCenter
        z: 5

        padding: vertical ? 10 : 2
        topPadding: vertical ? 2 : 10
        bottomPadding: vertical ? 2 : 10

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }
    }


    Rectangle{

        id: toolsep11
        width: parent.width - menu_width
        height: parent.height
        anchors.top: toolsep2.bottom
        anchors.left: left_menubar.right

        StackLayout{
            id: stacklayout_ds
            currentIndex: tabbar_ds.currentIndex
            width: toolsep11.width
            height: toolsep11.height

            DataSourcesGrid{
                id: data_source_grid

            }

            DataSourcesList{
                id: data_source_list
            }

        }
    }
}

