import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Master Template File
**
****************************************************************************/

import "./Source/Data"
import "./Source/Dashboard"
import "./Source/Others"
import "./Source/Data/SubComponents"

import "Constants.js" as Constants

ApplicationWindow {
    id: mainwindow
    visible: true
    width: 1600
    height: 800
    minimumWidth: 1300
    minimumHeight: 700

    title: Constants.applicationName

    Component.onCompleted: {
        var loginSession = User.checkSession();
        if(loginSession){
            action_signin.text  = qsTr("Sign Out")
        }
    }


    menuBar : MenuBar{
        id:menubar

        // Menu File

        Menu{
            id: menu_file
            x: 0
            //height: implicitHeight
            width: 200
            title: qsTr("File")


            Action{
                id: action_new
                text: qsTr("New")
            }

            Action{
                id: action_open
                text: qsTr("Open")
            }

            Action{
                id: action_sampledata
                text: qsTr("SampleData")
            }

            MenuSeparator{
//                width: 150
//                x: 40
                topPadding: 0
                bottomPadding: 0
                background: Rectangle{
                    color: "#D7D9DF"
                }
            }

            Action{
                id: action_quit
                text: qsTr("Exit")
                onTriggered: {
                    Qt.quit()
                }
            }


            delegate: MenuItem{
             id: menuItem
             background: Rectangle {

                 Rectangle{
                     anchors.fill: parent
                     anchors.margins: 3
                     color: menuItem.highlighted ? "#A5BAFA" : "transparent"
                 Rectangle{
                    anchors.fill: parent
                    anchors.margins: 2
                    color: menuItem.highlighted? "#C5D2FC" : "transparent"
                 }
                 }
                     implicitWidth: 200
                     implicitHeight: 25
                     opacity: enabled ? 1 : 0.3
                     color:  "#E3E5EA"

                 }
             contentItem: Text {
                         leftPadding: 30
                         text: menuItem.text
                         font: menuItem.font
                         opacity: enabled ? 1.0 : 0.3
                         //color: menuItem.highlighted ? "#ffffff" : "#000"
                         horizontalAlignment: Text.AlignLeft
                         verticalAlignment: Text.AlignVCenter
                         elide: Text.ElideRight
                     }

            }

        }

        //Menu Edit

        Menu{
            id: menu_edit
            x: 0
            //height: implicitHeight
            width: 160
            title: qsTr("Edit")


            Action{
                id: action_undo
                text: qsTr("Undo")
            }

            Action{
                id: action_redo
                text: qsTr("Redo")
            }
            MenuSeparator{
//                width: 150
//                x: 40
                topPadding: 0
                bottomPadding: 0
                background: Rectangle{
                    color: "#D7D9DF"
                }
            }
            Action{
                id: action_cut
                text: qsTr("Cut")
            }

            Action{
                id: action_copy
                text: qsTr("Copy")
            }
            Action{
                id: action_paste
                text: qsTr("Paste")
            }
            Action{
                id: action_delete
                text: qsTr("Delete")
            }


            delegate: MenuItem{
             id: menuItem5
             background: Rectangle {

                 Rectangle{
                     anchors.fill: parent
                     anchors.margins: 3
                     color: menuItem5.highlighted ? "#A5BAFA" : "transparent"
                 Rectangle{
                    anchors.fill: parent
                    anchors.margins: 2
                    color: menuItem5.highlighted? "#C5D2FC" : "transparent"
                 }
                 }
                     implicitWidth: 200
                     implicitHeight: 25
                     opacity: enabled ? 1 : 0.3
                     color:  "#E3E5EA"

                 }
             contentItem: Text {
                         leftPadding: 30
                         text: menuItem5.text
                         font: menuItem5.font
                         opacity: enabled ? 1.0 : 0.3
                         //color: menuItem.highlighted ? "#ffffff" : "#000"
                         horizontalAlignment: Text.AlignLeft
                         verticalAlignment: Text.AlignVCenter
                         elide: Text.ElideRight
                     }

            }

        }

        // Menu Data

        Menu{
            id: menu_data
            title: qsTr("Data")
            width:250

            Action{
                id: action_new_ds
                text: qsTr("Add New Datasource")
            }
            Action{
                id: action_refresh_ds
                text: qsTr("Refresh Datasource")
            }
            Action{
                id: action_export_ds_csv
                text: qsTr("Export Datasource to CSV")
            }
            Action{
                id: action_export_ds_excel
                text: qsTr("Export Datasource to Excel")
            }

            delegate: MenuItem{
             id: menuItem2
             background: Rectangle {
                 Rectangle{
                     anchors.fill: parent
                     anchors.margins: 3
                     color: menuItem2.highlighted ? "#A5BAFA" : "transparent"
                 Rectangle{
                    anchors.fill: parent
                    anchors.margins: 2
                    color: menuItem2.highlighted? "#C5D2FC" : "transparent"
                 }
                 }
                     implicitWidth: 200
                     implicitHeight: 25
                     opacity: enabled ? 1 : 0.3
                     color: "#E3E5EA"

                 }
             contentItem: Text {
                         leftPadding: 30
                         text: menuItem2.text
                         font: menuItem2.font
                         opacity: enabled ? 1.0 : 0.3
                         //color: menuItem2.highlighted ? "#ffffff" : "#000"
                         horizontalAlignment: Text.AlignLeft
                         verticalAlignment: Text.AlignVCenter
                         elide: Text.ElideRight
                     }

            }
        }

        // Menu Server

        Menu{
            id: menu_server
            title: qsTr("Server")

            Action{
                id: action_signin
                text: qsTr("Sign In")
            }
            Action{
                id: action_publish_datasource
                text: qsTr("Publish Datasource")

                onTriggered: {
                    Datasources.setSourceType("live")

                    publishGrafieks1.visible = true
                }
            }
            delegate: MenuItem{
             id: menuItem3
             background: Rectangle {
                 Rectangle{
                     anchors.fill: parent
                     anchors.margins: 3
                     color: menuItem3.highlighted ? "#A5BAFA" : "transparent"
                 Rectangle{
                    anchors.fill: parent
                    anchors.margins: 2
                    color: menuItem3.highlighted? "#C5D2FC" : "transparent"
                 }
                 }
                     implicitWidth: 200
                     implicitHeight: 25
                     opacity: enabled ? 1 : 0.3
                     color:  "#E3E5EA"


                 }
             contentItem: Text {
                         leftPadding: 30
                         text: menuItem3.text
                         font: menuItem3.font
                         opacity: enabled ? 1.0 : 0.3
                        // color: menuItem3.highlighted ? "#ffffff" : "#000"
                         horizontalAlignment: Text.AlignLeft
                         verticalAlignment: Text.AlignVCenter
                         elide: Text.ElideRight
                     }

            }
        }


        // Menu Help

        Menu{
            id: menu_help
            title: qsTr("Help")

            Action{
                text: qsTr("Open Help")
                onTriggered: {
                    stacklayout_home.currentIndex = 2
                }

            }
            MenuSeparator{
//                width: 150
//                x: 40
                topPadding: 0
                bottomPadding: 0
                background: Rectangle{
                    color: "#D7D9DF"
                }
            }
            Action{
                text: qsTr("Manage License")
            }

            Action{
                text: qsTr("Check for updates")

            }
            MenuSeparator{
//                width: 150
//                x: 40
                topPadding: 0
                bottomPadding: 0
                background: Rectangle{
                    color: "#D7D9DF"
                }
            }
            Action{
                text: qsTr("Report Issue")

            }
            Action{
                text: qsTr("Locate Log Files")

            }
            MenuSeparator{
//                width: 150
//                x: 40
                topPadding: 0
                bottomPadding: 0
                background: Rectangle{
                    color: "#D7D9DF"
                }
            }
            Action{
                text: qsTr("Function List")

            }
            MenuSeparator{
//                width: 160
//                id:msep
//                x: 40
                topPadding: 0
                bottomPadding: 0

                background: Rectangle{
                    color: "#D7D9DF"
                }
            }


            Action{
                text: qsTr("Grafieks Community")

            }
            Action{
                text: qsTr("About Grafieks")

            }


            delegate: MenuItem{
             id: menuItem4
             background: Rectangle {
                 Rectangle{
                     anchors.fill: parent
                     anchors.margins: 3
                     color: menuItem4.highlighted ? "#A5BAFA" : "transparent"
                 Rectangle{
                    anchors.fill: parent
                    anchors.margins: 2
                    color: menuItem4.highlighted? "#C5D2FC" : "transparent"
                 }
                 }
                     implicitWidth: 200
                     implicitHeight: 25
                     opacity: enabled ? 1 : 0.3
                     color:  "#E3E5EA"


                     //border.color: "#CAC9C9"

                 }

             contentItem: Text {
                         leftPadding: 30
                         text: menuItem4.text
                         font: menuItem4.font
                         opacity: enabled ? 1.0 : 0.3
                         //color: menuItem4.highlighted ? "#ffffff" : "#000"
                         horizontalAlignment: Text.AlignLeft
                         verticalAlignment: Text.AlignVCenter
                         elide: Text.ElideRight
                     }

            }
        }
        delegate: MenuBarItem{
            id: menuBarItem
            contentItem: Text{
                text : menuBarItem.text
                font : menuBarItem.font
                opacity: enabled ? 1.0 : 0.3
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                //elide: Text.ElideRight
            }
            background:
                Rectangle{
                implicitWidth: 30
                implicitHeight: 30
                opacity: enabled ? 1 : 0.3
                color: "transparent"
                Rectangle {
                    id: inner_rect
                anchors.fill: parent
                anchors.margins: 2
                Rectangle{
                   anchors.fill: parent
                   id: inner_rect2
                   anchors.margins: 2

                   color: {
                       if(menuBarItem.autoExclusive)
                       "#E1E3E7"
                       else if(menuBarItem.highlighted)
                        "#C5D2FC"
                       else
                       "transparent"
                   }
//

                }


                        color:{
                            menuBarItem.highlighted ?  "#A5BAFA" : "transparent"
                 }

                }


        }
        }

        background: Rectangle {

            color: Constants.themeColor

        }

    }

    header: Rectangle {
        implicitWidth: parent.vertical ? 1 : 24
        implicitHeight: parent.vertical ? 24 : 1
        color: Constants.darkThemeColor
    }



    StackLayout{
        id: stacklayout_home
        width: mainwindow.width
        height: mainwindow.height
        currentIndex: 2

        // 0
        Test{
            id: test_main
        }

        // 1
        Test2{
            id: test2_main
        }

        // 2
        Home{
            id: home_main
        }

        // 3
        SelectConnection{
            id: select_connecton_main
        }

        // 4
        DataSources{
            id: datasources_grid_main
        }

        // 5
        DataQueryModeller{
            id: data_query_modeller_main
        }

        // 6
        NewReport{
            id: new_report_main
        }

        // 7
        NewDashboard{
            id: new_dashboard_main
        }

    }

    PublishGrafieks1{
        id: publishGrafieks1
    }

    PublishGrafieks2{
        id: publishGrafieks2
    }

    DataSourceDescription{
        id: datasourceDescription
    }
}

