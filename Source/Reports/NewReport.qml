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
        height:parent.height
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

            Rectangle{
                id: tabbar_querymodeller
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

            Rectangle{
                id: rectangle_querymodeller_right_col1

                anchors.top: tabbar_querymodeller.bottom
                anchors.topMargin: 2

                height:50
                width: rectangle_querymodeller_right_col.width

                Text{
                    text: "Data Source Name"
                    anchors.verticalCenter: rectangle_querymodeller_right_col1.verticalCenter
                    anchors.left: rectangle_querymodeller_right_col1.left
                    anchors.leftMargin: 10
                }
            }


            Rectangle{
                id: rectangle_querymodeller_right_col3

                anchors.top: rectangle_querymodeller_right_col1.bottom
                anchors.topMargin: 2
                height:50
                width: rectangle_querymodeller_right_col.width

                Row{

                    id: row_querymodeller_right_col

                    TextField{
                        text: "Search"
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
                        source:"/Images/icons/Search.png"
                        height:30
                        width:30
                        anchors.top: row_querymodeller_right_col.top
                        anchors.topMargin: 5
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



//            Item{
//                id: item_querymodeller
//                width: rectangle_querymodeller_right_col3.width - 10
//                anchors.top: rectangle_querymodeller_right_col3.bottom
//                anchors.topMargin: 2

//                ListView {
//                    anchors.fill: parent
//                    model: nestedModel
//                    delegate: categoryDelegate
//                }


//                ListModel {
//                    id: nestedModel


//                    ListElement {
//                        categoryName: "Database 1"
//                        collapsed: true

//                        subItems: [
//                            ListElement { itemName: "Table 1" },
//                            ListElement { itemName: "Table 2" },
//                            ListElement { itemName: "Table 3" },
//                            ListElement { itemName: "Table 4" }
//                        ]
//                    }


//                }

//                Component {
//                    id: categoryDelegate
//                    Column {
//                        width: 200

//                        Rectangle {
//                            id: categoryItem
//                            height: 50
//                            width: 200

//                            Text {
//                                anchors.verticalCenter: parent.verticalCenter
//                                x: 15
//                                font.pixelSize: 12
//                                text: categoryName
//                            }

//                            Image {
//                                id: drop_icon
//                                source: "/Images/icons/Down_20.png"
//                                width: 10
//                                height: 10
//                                anchors.right: parent.right
//                                anchors.rightMargin: 15
//                                anchors.verticalCenter: parent.verticalCenter
//                                visible: true

//                                MouseArea {
//                                    anchors.fill: parent

//                                    onClicked: {
//                                        nestedModel.setProperty(index, "collapsed", !collapsed)

//                                        if(collapsed === true){
//                                            drop_icon.source = "/Images/icons/Down_20.png"
//                                        }
//                                        else{
//                                            drop_icon.source = "/Images/icons/Up_20.png"
//                                        }
//                                    }
//                                }
//                            }
//                        }

//                        Loader {
//                            id: subItemLoader

//                            visible: !collapsed
//                            property variant subItemModel : subItems
//                            sourceComponent: collapsed ? null : subItemColumnDelegate
//                            onStatusChanged: if (status == Loader.Ready) item.model = subItemModel
//                        }
//                    }

//                }

//                Component {
//                    id: subItemColumnDelegate
//                    Column {
//                        property alias model : subItemRepeater.model
//                        width: 200
//                        Repeater {
//                            id: subItemRepeater
//                            delegate: Rectangle {
//                                height: 40
//                                width: 200

//                                Text {
//                                    anchors.verticalCenter: parent.verticalCenter
//                                    x: 30
//                                    font.pixelSize: 12
//                                    text: itemName
//                                }
//                            }
//                        }
//                    }

//                }

//            }


        }

    }


    // Right Panel Ends
}
