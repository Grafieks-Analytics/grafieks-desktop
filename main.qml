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
import Qt.labs.platform 1.1


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

    function saveDatasource(){

        dsSaveDialog.visible = true
    }

    function openDatasource(){

        dsOpenDialog.visible = true
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


    FileDialog {
        id: dsSaveDialog
        title: "Save as"
        folder: shortcuts.documents
        fileMode: FileDialog.SaveFile
        defaultSuffix: DSParamsModel.fileExtension
        onAccepted: {
            DSParamsModel.saveDatasource(file)

        }
    }

    FileDialog {
        id: dsOpenDialog
        title: "Add New Datasource"
        folder: shortcuts.documents
        fileMode: FileDialog.OpenFile
        nameFilters: ["Extract (*.gadse)", "Live (*.gads)"]

        onAccepted: {
            console.log(file)
            var x = DSParamsModel.readDatasource(file)
            console.log(x[0], x[1])

        }
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    /***********************************************************************************************************************/
    // Menu Bar Starts

    MenuBar {
        id: menuBar

        Menu {
            id: fileMenu
            title: qsTr("&File")


            MenuItem{
                id: action_new
                text: qsTr("New")
            }

            MenuItem{
                id: action_open
                text: qsTr("Open")
            }

            MenuSeparator{}

            MenuItem{
                id: action_sampledata
                text: qsTr("SampleData")
            }


        }

        Menu{
            id: editMenu
            title: qsTr("&Edit")


            MenuItem{
                id: action_undo
                text: qsTr("Undo")
            }

            MenuItem{
                id: action_redo
                text: qsTr("Redo")
            }

            MenuSeparator{}

            MenuItem{
                id: action_cut
                text: qsTr("Cut")
            }

            MenuItem{
                id: action_copy
                text: qsTr("Copy")
            }

            MenuItem{
                id: action_paste
                text: qsTr("Paste")
            }

            MenuItem{
                id: action_delete
                text: qsTr("Delete")
            }


        }

        Menu {
            id: dataMenu
            title: qsTr("&Data")


            MenuItem{
                id: action_new_ds
                text: qsTr("Add New Datasource")

                onTriggered: openDatasource()
            }

            MenuSeparator{}

            MenuItem{
                id: action_save_ds
                text: qsTr("Save Datasource")

                onTriggered: saveDatasource()
            }
            MenuItem{
                id: action_refresh_ds
                text: qsTr("Refresh Datasource")
            }

            MenuSeparator{}

            MenuItem{
                id: action_export_ds_csv
                text: qsTr("Export Datasource to CSV")
            }
            MenuItem{
                id: action_export_ds_excel
                text: qsTr("Export Datasource to Excel")
            }
        }

        Menu {
            id: serverMenu
            title: qsTr("&Server")


            MenuItem{
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

            MenuSeparator{}

            MenuItem{
                id: action_publish_datasource
                text: qsTr("Publish Datasource")

                onTriggered: {
                    Datasources.setSourceType(Constants.liveDS)

                    publishGrafieks1.visible = true
                }
            }
        }

        Menu {
            id: helpMenu
            title: qsTr("&Help")


            MenuItem{
                text: qsTr("Open Help")
                onTriggered: {
                    stacklayout_home.currentIndex = 2
                }

            }
            MenuSeparator{}
            MenuItem{
                text: qsTr("Manage License")
            }

            MenuItem{
                text: qsTr("Check for updates")

            }
            MenuSeparator{}

            MenuItem{
                text: qsTr("Report Issue")

            }
            MenuItem{
                text: qsTr("Locate Log Files")

            }
            MenuSeparator{}
            MenuItem{
                text: qsTr("Function List")

            }
            MenuSeparator{}


            MenuItem{
                text: qsTr("Grafieks Community")
            }

            MenuItem{
                text: qsTr("Test")
                onTriggered: {
                    stacklayout_home.currentIndex = 1
                }
            }

        }

        //        Menu{
        //            id: menu_signIn
        //            title: Constants.signInText
        //            height: 0
        //            onOpened: {

        //                if(typeof settings.value("user/sessionToken") !== "undefined"){

        //                    // Call logout
        //                    logout.visible = true

        //                } else{

        //                    // Call login
        //                    connectGrafieks1.visible = true
        //                }
        //            }
        //        }
        //    }
    }


    // Menu Bar Ends
    /***********************************************************************************************************************/

    header: Rectangle {
        implicitWidth: parent.vertical ? 1 : 24
        implicitHeight: parent.vertical ? 24 : 1
//        color: Constants.darkThemeColor
        color: "red"
//        border.color: "green"
    }



    /***********************************************************************************************************************/
    // Stack Layout Starts

    StackLayout{
        id: stacklayout_home
        width: mainwindow.width
        height: mainwindow.height
        currentIndex:3

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
        NewDashboard{
            id: new_dashboard_main
        }

        // 7
        NewReport{
            id: new_report_main
        }



    }

    // Stack Layout Ends
    /***********************************************************************************************************************/


    // Page Design Ends
    /***********************************************************************************************************************/


}
