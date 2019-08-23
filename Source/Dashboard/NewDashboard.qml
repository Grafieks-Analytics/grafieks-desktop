/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Dashboard & Customizations
**
****************************************************************************/


import QtQuick 2.11
import QtQuick.Controls 2.4
import QtWebEngine 1.7

import "../MainSubComponents"
import "./SubComponents"
import "../../Constants.js" as Constants

Page {

    id: new_dashboard_page
    property int menu_width: 60

    LeftMenuBar{
        id: left_menubar
    }

    Rectangle{
        id: submenu
        height: 23
        width: parent.width - menu_width
        x: menu_width


        TabBar{

            id: tabbutton_newdashboard

            TabButton{
                id: datamodeller_newdashboard
                text: "Dashboard 1"
                width:100

                onClicked: {

                }

                background: Rectangle {
                    id: datamodeller_newdashboard_background
                    color:  datamodeller_newdashboard.pressed? Constants.darkThemeColor: Constants.themeColor

                }
                contentItem: Text{
                    id: datamodeller_newdashboard_text
                    text: datamodeller_newdashboard.text
                    color:  "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }

        }



        Button{
            id: new_dashboard_btn
            anchors.left: tabbutton_newdashboard.right
            width: 50

            Image{
                id: new_dashboard_icon
                source: "../../Images/icons/Plus_32.png"
                height: 25
                width: 25
                anchors.top: new_dashboard_btn.top
                anchors.topMargin: 3
                anchors.left: new_dashboard_btn.left
                anchors.leftMargin: 13
            }


            onClicked: {

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
        }



        Row{
            id: toptool_newdashboard
            anchors.right: submenu.right



            Button{
                id: report_btn
                width: 100
                height: 30

                Image{
                    id: report_btn_icon
                    source: "../../Images/icons/Plus_32.png"
                    anchors.top: report_btn.top
                    anchors.left: report_btn.left
                    anchors.leftMargin: 10
                    anchors.topMargin: 2
                    width: 25
                    height: 25

                }

                Text{
                    text: "Report"
                    anchors.top: report_btn.top
                    anchors.left: report_btn_icon.right
                    anchors.topMargin: 8
                    anchors.leftMargin: 5

                }

                onClicked: {

                }

                background: Rectangle {
                    id: report_btn_background
                    color: report_btn.pressed? Constants.darkThemeColor: Constants.themeColor

                }

            }

            Button{
                id: filter_btn
                width: 100
                height: 30

                Image{
                    id: filter_newdashboard
                    source: "../../Images/icons/Plus_32.png"
                    anchors.top: filter_btn.top
                    anchors.left: filter_btn.left
                    anchors.leftMargin: 10
                    anchors.topMargin: 2
                    height:25
                    width: 25
                }

                Text{
                    text: "Filter [0]"
                    anchors.top: filter_btn.top
                    anchors.left: filter_newdashboard.right
                    anchors.topMargin: 8
                    anchors.leftMargin: 5

                }

                onClicked: {

                    if(column_filter_newdashboard.visible === true){
                        column_filter_newdashboard.visible = false

                        // hide other panels
                        column_newdashboard.visible = false
                    }
                    else{
                        column_filter_newdashboard.visible = true

                        // hide other panels
                        column_newdashboard.visible = false
                    }

                }

                background: Rectangle {
                    id: filter_btn_background
                    color: filter_btn.pressed? Constants.darkThemeColor: Constants.themeColor

                }
            }


            Button{
                id: customize_btn
                height: 30
                width: 100

                Text{
                    text: "Customize"
                    anchors.top: customize_btn.top
                    anchors.topMargin: 8
                    anchors.left: customize_btn.left
                    anchors.leftMargin: 20
                }

                onClicked: {
                    if(column_newdashboard.visible === true){
                        column_newdashboard.visible = false

                        // hide other panels
                        column_filter_newdashboard.visible = false
                    }
                    else{
                        column_newdashboard.visible = true

                        // hide other panels
                        column_filter_newdashboard.visible = false
                    }
                }
                background: Rectangle {
                    id: customize_btn_background
                    color: customize_btn.pressed? Constants.darkThemeColor: Constants.themeColor

                }
            }



        }

    }

    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width - menu_width
        anchors.top: submenu.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: submenu.horizontalCenter
        padding: 0

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }
    }

    // Center Panel Starts

    DashboardSummary{
        id: dashboard_summary
        anchors.left: left_menubar.right
        anchors.top: toolsep1.bottom
    }

    WebEngineView {
        id:primary_chart

        url: "../Charts/sunburst.html"
        height:parent.height
        anchors.left: dashboard_summary.right
        anchors.top:toolsep1.bottom
        width: parent.width - dashboard_summary.width - left_menubar.width - column_newdashboard.width
    }

    // Center Panel Ends



    // Right Dashboard Customize Starts

    ToolSeparator{
        id: tool_sep_chartFilters
        anchors.left: column_newdashboard.left
        anchors.leftMargin: -8
        height:parent.height

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.themeColor
        }


    }

    Column{
        id: column_newdashboard

        height:parent.height - submenu.height
        width: 200
        anchors.right:parent.right
        anchors.top: submenu.bottom
        anchors.topMargin: 10
        spacing: 50

        Rectangle{
            id: rectangle_newdashboard_right_col
            color:Constants.themeColor
            width:column_newdashboard.width
            height:column_newdashboard.height





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
                id: dashboard_customize_newdashboard
                anchors.top: rectangle_newdashboard_right_col1.bottom
                anchors.left: parent.left
            }

            // Widget Drawer ends





        }

    }

    // Right Dashboard Customize Ends


    // Right Filter Starts

    Column{
        id: column_filter_newdashboard

        height:parent.height - submenu.height
        width: 200
        anchors.right:parent.right
        anchors.top: submenu.bottom
        anchors.topMargin: 10
        spacing: 50
        visible: false

        DashboardFilters{}
    }

    // Right Filter Ends

}
