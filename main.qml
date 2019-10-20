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
            x: 2
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

            MenuSeparator{}

            Action{
                id: action_quit
                text: qsTr("&Quit")
                onTriggered: {
                    Qt.quit()
                }
            }
        }

        // Menu Data

        Menu{
            id: menu_data
            title: qsTr("Data")

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
            Action{
                text: qsTr("Check for updates")

            }
            Action{
                text: qsTr("Sample dashboards")

            }
            Action{
                text: qsTr("Watch videos")

            }
            Action{
                text: qsTr("Grafieks community")

            }
            Action{
                text: qsTr("Get support")

            }
            Action{
                text: qsTr("Manage product keys")

            }
            Action{
                text: qsTr("About Grafieks")

            }

            Action{
                text: qsTr("&Test")
                onTriggered: {
                    stacklayout_home.currentIndex = 1
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

