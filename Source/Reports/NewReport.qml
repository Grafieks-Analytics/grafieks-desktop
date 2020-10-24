/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard
** New Report
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtWebEngine 1.7

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"
import "./SubComponents"

Page {

    id: report_desiner_page
    width: parent.width
    property int menu_width: 60


    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: categoricalModel
        ListElement{
            categoricalName: "Customer Name"
        }
        ListElement{
            categoricalName: "Customer Name 1"
        }
        ListElement{
            categoricalName: "Customer Name 2"
        }
        ListElement{
            categoricalName: "Customer Name 3"
        }
    }

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

    Component.onCompleted: {

        // Connect signal and slots

    }

    // Slot Function
    // For changing the chart on clicking chart icons

    function changeChart(chartname){
        primary_chart.url = chartname
    }

    function addReport(){
        // Add report to dashboard
        stacklayout_home.currentIndex = 6
    }

    function cancelReport(){
        // Back to dashboard
        stacklayout_home.currentIndex = 6
    }

    function focusReportTitle(){
        report_title_text.readOnly= false
        report_title_text.focus = true;
        console.log('Focus Title')
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    Row{
        id: title_menu
        anchors.top: parent.top
        height: implicitHeight
        width: implicitWidth

        Rectangle{
            id: customize_title
            width: left_menubar_reports.width + chartFilters1.width
            height: 30
            color: Constants.themeColor

            Text{
                text: "Customize"
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
            }
        }

        Rectangle{
            id: report_title
            width: report_desiner_page.width - left_menubar_reports.width - chartFilters1.width - column_querymodeller.width

            height: 30

            TextEdit {
                id: report_title_text
                text: "Report Title"
                readOnly: true
                cursorVisible: false
                width:250
                height: 40
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
                verticalAlignment:TextEdit.AlignVCenter
                Keys.onReturnPressed: {
                    report_title_text.focus = false
                }
            }

            Image {
                source: "/Images/icons/Edit.png"
                height: 20
                width: 20
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: focusReportTitle()
                }
            }
        }


    }

    // Seperator lines
    Row{
        id: seperator_title_bar
        anchors.top:title_menu.bottom
        width: parent.width

        // Seperator for Left Menu
        Rectangle {
            id: customize_title_bar
            width: customize_title.width
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }

        // Seperator for Center Panel and Title
        Rectangle {
            id: report_title_bar
            width: report_title.width
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }
    }

    // Left Menu Chart Icons Starts
    LeftMenuBarReports{
        id: left_menubar_reports
        anchors.top: seperator_title_bar.bottom
        Component.onCompleted: {
            loadchart.connect(report_desiner_page.changeChart)
        }

    }
    // Left Menu Chart Icons Ends

    ToolSeparator{
        id: tool_sep_leftmenubarreports
        anchors.left: left_menubar_reports.right
        anchors.top: seperator_title_bar.bottom
        anchors.leftMargin: 0
        height:parent.height
        padding: 0

        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }
    }


    // Left Menu Customization Items
    ReportCustomizations{
        id: chartFilters1
        anchors.left: tool_sep_leftmenubarreports.right
        anchors.top: seperator_title_bar.bottom
        anchors.leftMargin: 0
    }

    ToolSeparator{
        id: tool_sep_chartFilters
        anchors.left: chartFilters1.right
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.topMargin: -3
        height:parent.height
        padding: 0
        contentItem: Rectangle {
            implicitWidth: parent.vertical ? 1 : 24
            implicitHeight: parent.vertical ? 24 : 1
            color: Constants.darkThemeColor
        }
    }


    // Center Panel

    WebEngineView {
        id:primary_chart
        height:parent.height
        width: parent.width - chartFilters1.width - left_menubar_reports.width - column_querymodeller.width
        url: "../Charts/horizontal-bar.html"
        anchors.left: tool_sep_chartFilters.right
        anchors.top: seperator_title_bar.bottom
    }


    ToolSeparator{
        id: toolsep2
        height:parent.height + 6
        anchors.right:parent.right
        anchors.top: parent.top
        anchors.rightMargin: 194
        anchors.topMargin: -5
    }

   // Right Panel Starts

    Column{
        id: column_querymodeller

        height:parent.height
        width: 200
        anchors.right:parent.right
        spacing: 50


        Rectangle{
            id: rectangle_querymodeller_right_col
            color:Constants.themeColor
            width: parent.width
            height: parent.height

            // Cancel and Add report Buttons Starts
            Rectangle{
                id: tabbarQuerymodeller
                width:parent.width
                height: 31
                Button{
                    anchors.left: parent.left
                    width: parent.width/2-0.5
                    text:"Cancel"
                    height: parent.height
                    background: Rectangle{
                        color: Constants.grafieksLightGreenColor
                        opacity: parent.hovered ? 0.42 : 1
                    }
                    contentItem: Text{
                        text: parent.text
                        color:  Constants.blackColor
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: cancelReport()
                }

                Button{
                    text:"Add"
                    height: parent.height
                    anchors.right: parent.right
                    width: parent.width/2-0.5
                    onClicked: addReport()
                    background: Rectangle {
                        color: Constants.grafieksLightGreenColor
                        opacity: parent.hovered ? 0.42 : 1
                    }
                    contentItem: Text{
                        text: parent.text
                        color:  Constants.blackColor
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            // Cancel and Add report Buttons Ends

            // Dashboard Name Starts

            Rectangle{
                id: dashboardNameRectangle

                anchors.top: tabbarQuerymodeller.bottom
                anchors.topMargin: 2

                height:50
                width: parent.width

                Text{
                    text: "Data Source Name"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
            }

            // Dashboard Name Ends

            // Search starts

            Rectangle{
                id: searchRectangle

                anchors.top: dashboardNameRectangle.bottom
                anchors.topMargin: 2
                height:50
                width: parent.width

                Row{

                    id: searchBarRow
                    TextField{
                        width: parent.parent.width - search_icon.width - 5
                        height:30
                        cursorVisible: true
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        placeholderText: "Search"
                        background: Rectangle{
                            border.width: 0
                        }
                    }

                    Image{
                        id:search_icon
                        source:"/Images/icons/Search.png"
                        height:30
                        width:30
                        anchors.top: parent.top
                        anchors.topMargin: 5
                    }
                }

                ToolSeparator{
                    orientation: Qt.Horizontal
                    width: parent.width - 10
                    anchors.top: searchBarRow.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 5
                }

            }

            // Search Ends

            // Data Column Starts
            Rectangle{
                anchors.top: searchRectangle.bottom
                height: parent.height - (searchRectangle.height + dashboardNameRectangle.height + tabbarQuerymodeller.height)
                width: parent.width

                Column{
                    anchors.fill: parent
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    spacing: 15

                    Rectangle{
                        height: parent.height/3 - 5
                        width: parent.width

                        Text {
                            id: categoricalHeading
                            text: qsTr("Categorical")
                            font.pixelSize: Constants.fontCategoryHeader
                        }

                        ListView{
                            model: categoricalModel
                            anchors.top: categoricalHeading.bottom
                            anchors.topMargin: 5
                            height: parent.height - categoricalHeading.height - 5
                            width: parent.width
                            delegate: Rectangle{
                                height: 24
                                width: parent.width
                                Image {
                                    id: categoricalImage
                                    source: "/Images/icons/AB.png"
                                    height: 16
                                    width: 16
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: categoricalName
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: categoricalImage.right
                                    anchors.leftMargin: 10
                                }
                            }

                        }

                    }

                    Rectangle{
                        height: parent.height/3 - 5
                        width: parent.width

                        Text {
                            id: dateHeading
                            text: qsTr("Date")
                            font.pixelSize: Constants.fontCategoryHeader
                        }

                        ListView{
                            model: categoricalModel
                            anchors.top: dateHeading.bottom
                            anchors.topMargin: 5
                            height: parent.height - dateHeading.height - 5
                            width: parent.width
                            delegate: Rectangle{
                                height: 24
                                width: parent.width
                                Image {
                                    id: dateImage
                                    source: "/Images/icons/AB.png"
                                    height: 16
                                    width: 16
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: categoricalName
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: dateImage.right
                                    anchors.leftMargin: 10
                                }
                            }

                        }


                    }

                    Rectangle{
                        height: parent.height/3 - 5
                        width: parent.width


                        Text {
                            id: numericalHeading
                            text: qsTr("Date")
                            font.pixelSize: Constants.fontCategoryHeader
                        }

                        ListView{
                            model: categoricalModel
                            anchors.top: numericalHeading.bottom
                            anchors.topMargin: 5
                            height: parent.height - numericalHeading.height - 5
                            width: parent.width
                            delegate: Rectangle{
                                height: 24
                                width: parent.width
                                Image {
                                    id: numericalImage
                                    source: "/Images/icons/AB.png"
                                    height: 16
                                    width: 16
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: categoricalName
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: numericalImage.right
                                    anchors.leftMargin: 10
                                }
                            }

                        }



                    }
                }

            }
            // Data Column Ends



        }



    }


    // Right Panel Ends
}
