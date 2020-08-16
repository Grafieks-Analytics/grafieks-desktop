/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Master Template File
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.1

import com.grafieks.singleton.constants 1.0


import "./Source/Modellers"
import "./Source/Modellers/SubComponents"
import "./Source/Modellers/SubComponents/MiniSubComponents"
import "./Source/Dashboards"
import "./Source/Connectors"
import "./Source/Datasources"
import "./Source/Reports"
import "./Source/Others"
import "./Source/MainSubComponents"


ApplicationWindow {

    id: mainwindow
    visible: true
    width: 1800
    height: 900
    minimumWidth: 1300
    minimumHeight: 700

    title: Constants.applicationName


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
        if(settings.value("user/profileId") > 0){
            var firstname = settings.value("user/firstname")
            var lastname = settings.value("user/lastname")
            var capitalizeFirstName = firstname.charAt(0).toUpperCase() + firstname.slice(1)
            var capitalizeLastName = lastname.charAt(0).toUpperCase() + lastname.slice(1)
            var name = capitalizeFirstName + " "+ capitalizeLastName

            action_signin.text  = Constants.signOutText
            menu_signIn.title = qsTr(name)

        }
    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    // Global Modals
    PublishDatasource{
        id: datasourceDescription
    }
    LoginServer{
        id: connectGrafieks1
    }
    LoginCredentials{
        id: connectGrafieks2
    }
    Logout{
        id: logout
    }

    // Settings
    // Fetch and Set Settings
    Settings{
        id: settings
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    /***********************************************************************************************************************/
    // Menu Bar Starts

    menuBar : MenuBar{
        id:menubar

        // Menu File

        Menu{
            id: menu_file
            x: 0
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

            MenuSeparatorComponent{}

            Action{
                id: action_quit
                text: qsTr("Exit")
                onTriggered: {
                    Qt.quit()
                }
            }

            delegate: MenuItemDelegate{}

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
            MenuSeparatorComponent{}
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


            delegate: MenuItemDelegate{}

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

            delegate: MenuItemDelegate{}
        }

        // Menu Server

        Menu{
            id: menu_server
            title: qsTr("Server")

            Action{
                id: action_signin
                text: Constants.signInText

                onTriggered: {
                    if(typeof settings.value("user/sessionToken") !== "undefined"){

                        // Call logout
                        logout.visible = true
                    } else{

                        // Call login
                        connectGrafieks1.visible = true
                    }
                }
            }
            Action{
                id: action_publish_datasource
                text: qsTr("Publish Datasource")

                onTriggered: {
                    Datasources.setSourceType("live")

                    publishGrafieks1.visible = true
                }
            }
            delegate: MenuItemDelegate{}

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
            MenuSeparatorComponent{}
            Action{
                text: qsTr("Manage License")
            }

            Action{
                text: qsTr("Check for updates")

            }
            MenuSeparatorComponent{}

            Action{
                text: qsTr("Report Issue")

            }
            Action{
                text: qsTr("Locate Log Files")

            }
            MenuSeparatorComponent{}
            Action{
                text: qsTr("Function List")

            }
            MenuSeparatorComponent{}


            Action{
                text: qsTr("Grafieks Community")
            }
            Action{
                text: qsTr("About Grafieks")
            }
            Action{
                text: qsTr("Test")
                onTriggered: {
                    stacklayout_home.currentIndex = 1
                }
            }

            delegate: MenuItemDelegate{}
        }

        Menu{
            id: menu_signIn
            title: Constants.signInText
            height: 0
            onOpened: {

                if(typeof settings.value("user/sessionToken") !== "undefined"){

                    // Call logout
                    logout.visible = true

                } else{

                    // Call login
                    connectGrafieks1.visible = true
                }
            }
        }
        delegate: MainMenuDelegate{}

        background: Rectangle {
            color: Constants.themeColor
        }

    }

    // Menu Bar Ends
    /***********************************************************************************************************************/

    header: Rectangle {
        implicitWidth: parent.vertical ? 1 : 24
        implicitHeight: parent.vertical ? 24 : 1
        color: Constants.darkThemeColor
    }



    /***********************************************************************************************************************/
    // Stack Layout Starts

    StackLayout{
        id: stacklayout_home
        width: mainwindow.width
        height: mainwindow.height
        currentIndex:5

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

    // Stack Layout Ends
    /***********************************************************************************************************************/


    // Page Design Ends
    /***********************************************************************************************************************/


}

