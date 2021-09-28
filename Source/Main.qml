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


import "./Modellers"
import "./Modellers/SubComponents"
import "./Modellers/SubComponents/MiniSubComponents"
import "./Dashboards"
import "./Connectors"
import "./Datasources"
import "./Reports"
import "./Others"
import "./MainSubComponents"

import "./Dashboards/SubComponents"


ApplicationWindow {

    id: mainwindow
    visible: true
    width: 1800
    height: 900
    minimumWidth: 1300
    minimumHeight: 700

    title: Constants.applicationName

    // Handle Splash screen here
    onVisibilityChanged: {
        GeneralParamsModel.loadingComplete()
    }



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

    Connections{
        target: ExtractProcessor

        function onExtractReaderProcessed(){
            stacklayout_home.currentIndex = 6
        }
    }

    Connections{
        target: DashboardParamsModel

        function onMoveToDashboardScreen(){
            stacklayout_home.currentIndex = 6
        }
    }

    Connections{
        target: WorkbookProcessor

        function onExtractMissing(){
            readerDialog.title = "Extract missing. Select a file"
            readerDialog.open()
        }
    }

    // Connections Ends
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {

        // Get Reader file
        // We call a function to check because signals and slots between Qml and C++ dont Work
        // Before the components are completely loaded in the UI
        // Hence after completion we check if the arguments are received and then process the extract

        if(ExtractProcessor.receivedArgumentStatus() === true){
            ExtractProcessor.processExtract()
        }

        if(WorkbookProcessor.receivedArgumentStatus() === true){
            WorkbookProcessor.processExtract()
        }

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

    function openNewApplication(){
        GeneralParamsModel.openNewGrafieksInstance();
    }

    function disconnectDS(){
        DSParamsModel.disconnectDS()
    }

    function saveDatasource(){

        dsSaveDialog.visible = true
    }

    function saveWorkbook(){
        saveWorkbookPrompt.open()
    }

    function openDatasource(){

        dsOpenDialog.visible = true
    }

    function openReaderDialog(){
        readerDialog.visible = true
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
        nameFilters: ["Extract (*."+Constants.extractFileExt+")", "Live (*."+Constants.liveFileExt+")"]

        onAccepted: {
            var x = DSParamsModel.readDatasource(file)

        }
    }

    FileDialog {
        id: readerDialog
        title: "Select File"
        folder: shortcuts.documents
        fileMode: FileDialog.OpenFile
        nameFilters: ["Extract (*."+Constants.extractFileExt+")", "Live (*."+Constants.liveFileExt+")", "Workbook (*."+Constants.workbookFileExt+")"]

        onAccepted: {
            var readerFile = GeneralParamsModel.urlToFilePath(readerDialog.file)
            console.log(readerFile)
            if(readerFile.includes(Constants.extractFileExt)){
                ExtractProcessor.setArgumentsFromMenu(readerFile)
            } else if(readerFile.includes(Constants.workbookFileExt)){
                WorkbookProcessor.setArgumentsFromMenu(readerFile)
            }

        }
    }

    About{
        id: aboutPopup
    }


    // SubComponents Starts

    // This is a component because it uses Qt.labs.Platform
    // and this conflicts with the current file
    SaveWorkbook{
        id: saveWorkbookPrompt
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
                onTriggered: openNewApplication()
            }

            MenuItem{
                id: action_open
                text: qsTr("Open")

                onTriggered: openReaderDialog()
            }

            MenuSeparator{}

            MenuItem{
                id: action_save_ds
                text: qsTr("Save Datasource")

                onTriggered: saveDatasource()
            }

            MenuSeparator{}

            MenuItem{
                id: action_save_workbook
                text: qsTr("Save Workbook")
                enabled: true

                onTriggered: saveWorkbook()
            }

            MenuSeparator{}

            MenuItem{
                id: action_sampledata
                text: qsTr("SampleData")
                enabled: false
            }


        }

//        Menu{
//            id: editMenu
//            title: qsTr("&Edit")


//            MenuItem{
//                id: action_undo
//                text: qsTr("Undo")
//            }

//            MenuItem{
//                id: action_redo
//                text: qsTr("Redo")
//            }

//            MenuSeparator{}

//            MenuItem{
//                id: action_cut
//                text: qsTr("Cut")
//            }

//            MenuItem{
//                id: action_copy
//                text: qsTr("Copy")
//            }

//            MenuItem{
//                id: action_paste
//                text: qsTr("Paste")
//            }

//            MenuItem{
//                id: action_delete
//                text: qsTr("Delete")
//            }


//        }

        Menu {
            id: dataMenu
            title: qsTr("&Data")


                MenuItem{
                    id: disconnect_ds
                    text: qsTr("Disconnect")

                    onTriggered: disconnectDS()
                }

//            MenuItem{
//                id: action_new_ds
//                text: qsTr("Add New Datasource")

//                onTriggered: openDatasource()
//            }

//            MenuSeparator{}

//            MenuItem{
//                id: action_save_ds
//                text: qsTr("Save Datasource")

//                onTriggered: saveDatasource()
//            }
//            MenuItem{
//                id: action_refresh_ds
//                text: qsTr("Refresh Datasource")
//            }

//            MenuSeparator{}

//            MenuItem{
//                id: action_export_ds_csv
//                text: qsTr("Export Datasource to CSV")
//            }
//            MenuItem{
//                id: action_export_ds_excel
//                text: qsTr("Export Datasource to Excel")
//            }
        }



        Menu {
            id: serverMenu
            title: qsTr("&Server")


            MenuItem{
                id: action_signin
                text: Constants.signInText
                enabled: false

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
                enabled: false

                onTriggered: {
                    Datasources.setSourceType(Constants.liveDS)
                    publishGrafieks1.visible = true
                }
            }

            MenuSeparator{}

            MenuItem{
                id: action_publish_workbook
                text: qsTr("Publish Workbook")
                enabled: false
            }
        }

        Menu {
            id: helpMenu
            title: qsTr("&Help")


            MenuItem{
                text: qsTr("Open Help")
                onTriggered: {
                    // stacklayout_home.currentIndex = 2
                    Qt.openUrlExternally("https://docs.grafieks.com/");
                }

            }
            MenuItem{
                text: qsTr("Support")
            }
            MenuItem{
                text: qsTr("Grafieks Community")
            }

            MenuSeparator{}
            MenuItem{
                text: qsTr("Manage License")
                enabled: false
            }

            MenuItem{
                text: qsTr("Check for updates")
                enabled: false

            }

            MenuSeparator{}

            MenuItem{
                text: qsTr("About")
                onTriggered: {
                    console.log("About clicked")
                    aboutPopup.open()
                }
            }

//            MenuItem{
//                text: qsTr("Test")
//                onTriggered: {
//                    stacklayout_home.currentIndex = 0
//                }
//            }

        }

    }


    // Menu Bar Ends
    /***********************************************************************************************************************/

    header: Rectangle {
        implicitWidth: parent.vertical ? 1 : 24
        implicitHeight: parent.vertical ? 24 : 1
        color: "red"
    }



    /***********************************************************************************************************************/
    // Stack Layout Starts

    StackLayout{
        id: stacklayout_home
        width: mainwindow.width
        height: mainwindow.height
        currentIndex:Constants.initialIndex

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

        // 8
        TableTest{
            id: table_test
        }



    }

    // Stack Layout Ends
    /***********************************************************************************************************************/


    // Page Design Ends
    /***********************************************************************************************************************/


}
