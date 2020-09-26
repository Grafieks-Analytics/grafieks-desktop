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

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"
import "./SubComponents"

Page {

    id: new_dashboard_page
    property int menu_width: 60


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



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS



    function openDashboardFilters(){

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

    function onCustomizeBtnClicked(){
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

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



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


        TabBar{

            id: tabbutton_newdashboard

            TabButton{
                id: datamodeller_newdashboard
                text: "Dashboard 1"
                width:100

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
                source: "/Images/icons/Plus_32.png"
                height: 25
                width: 25
                anchors.top: new_dashboard_btn.top
                anchors.topMargin: 3
                anchors.left: new_dashboard_btn.left
                anchors.leftMargin: 13
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
                height: 28

                Image{
                    id: report_btn_icon
                    source: "/Images/icons/Plus_32.png"
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
                    anchors.verticalCenter: Text.AlignVCenter
                    anchors.topMargin: 6
                    anchors.leftMargin: 5
                }


                background: Rectangle {
                    id: report_btn_background
                    color: report_btn.hovered? Constants.darkThemeColor: Constants.whiteColor
                }

            }


            // Filter button starts

            Button{
                id: filter_btn
                width: 100
                height: 28
                anchors.leftMargin: 10

                Image{
                    id: filter_querymodeller
                    source: "/Images/icons/Plus_32.png"
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
                    anchors.top: parent.top
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

                onClicked: openDashboardFilters()
            }


            Button{
                id: customize_btn
                height: 28
                width: 100

                Text{
                    id: customizeText
                    text: "Customize"
                    anchors.top: parent.top
                    anchors.topMargin: 6
                    anchors.left: customizeIcon.left
                    anchors.leftMargin: 10
                }

                onClicked: {
                    onCustomizeBtnClicked()
                }

                background: Rectangle{
                    color: customize_btn.hovered ? Constants.darkThemeColor : "white"
                }

            }



        }

    }


    ToolSeparator{
        id: toolsep1
        orientation: Qt.Horizontal
        width: parent.width - left_menubar.width
        anchors.top: submenu.bottom
        anchors.left: left_menubar.right
        anchors.horizontalCenter: submenu.horizontalCenter

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
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

    Column{
        id: column_newdashboard

        height:parent.height - submenu.height
        width: 200
        anchors.right:parent.right
        anchors.top: submenu.bottom
        anchors.topMargin: 4
        spacing: 50

        visible: false


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
            anchors.topMargin: 10

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

        ToolSeparator{
            anchors.top: parent.top
            anchors.left: column_newdashboard.left
//            anchors.leftMargin: 20

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


    // Page Design Ends
    /***********************************************************************************************************************/

}
