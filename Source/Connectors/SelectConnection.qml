/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Select Connection
**
****************************************************************************/

import QtQuick
import QtQuick.Controls 
import QtQuick.Layouts
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../MainSubComponents"
import "./SubComponents"
import "./SubComponents/MiniSubComponents"


Page {

    id: selectconn_page
    width: parent.width - left_menubar.width
    background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }

    // For search, filter, sort
    property var categoriesList : ["all", "file", "grs", "rdbms", "nosql", "cloud", "online"]
    property var selectedCategory : categoriesList[0]


    /***********************************************************************************************************************/
    // SIGNALS STARTS

    signal update_host_query_modeller(string new_host);
    signal update_data_sources_list();

    Connections{
        target: LiveProcessor

        function onOpenConnection(dbType){
            selectAuthorization(dbType)
        }
    }


    // SIGNALS ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // Status Changed Functions Starts

    onSelectedCategoryChanged: {
        if(selectedCategory !== categoriesList[0]){
            ConnectorFilter.setFilterString(selectedCategory);
        } else{
            ConnectorFilter.setFilterString("");
        }
    }

    // Status Changed Function ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connection  Starts


    // Connection  Ends
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTIONS STARTS

    function tmp_update_host(new_host){
        update_host_query_modeller(new_host)
    }

    // General Functions

    // Set modal popup
    function selectAuthorization(param){

        switch(param.toLowerCase()){

        case "grs":

            // If already logged in, dont prompt
            if (typeof settings.value("user/sessionToken") == "undefined"){
                connectGrafieks1.visible = true
            } else{
                GeneralParamsModel.setCurrentScreen(Constants.grsScreen)
                stacklayout_home.currentIndex = 4
            }

            break;

        case "mysql":
            mysqlModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.mysqlOdbc)
            break;

        case "sqlite":
            sqliteModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.sqliteOdbc)
            break;

        case "sql server":
            mssqlModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.mssqlOdbc)
            break;

        case "postgres":
            postgresModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.postgresOdbc)
            break;

        case "microsoft excel":
            excelModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.excelOdbc)
            break;

        case "mongodb":
            mongoModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.mongoOdbc)
            break;

        case "amazon redshift":
            redshiftModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.redshiftOdbc)
            break;

        case "apache hive":
            hiveModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.hiveOdbc)
            break;

        case "csv":
            csvModal.visible = true
            break;

        case "github":
            githubModal.visible = true
            break;

        case "impala":
            impalaModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.impalaOdbc)
            break;

        case "json":
            jsonModal.visible = true
            break;

        case "microsoft access":
            accessModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.accessOdbc)
            break;

        case "oracle":
            oracleModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.oracleOdbc)
            break;

        case "snowflake":
            snowflakeModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.snowflakeOdbc)
            break;

        case "teradata":
            teradataModal.visible = true
            ODBCDriversModel.fetchOdbcDrivers(Constants.teradataOdbc)
            break;

        case "dropbox":
            if(GeneralParamsModel.getOnlineStorageType() !== Constants.dropBoxType){
                dropboxModal.visible = true
            } else {
                fileListPopup.visible = true
            }

            break;

        case "google drive":
            if(GeneralParamsModel.getOnlineStorageType() !== Constants.driveType){
                driveModal.visible = true
            } else {
                driveListPopup.visible = true
            }
            break;

        case "box":
            if(GeneralParamsModel.getOnlineStorageType() !== Constants.boxType){
                boxModal.visible = true
            } else {
                boxListPopup.visible = true
            }
            break;

        case "google sheets":
            if(GeneralParamsModel.getOnlineStorageType() !== Constants.sheetType){
                sheetModal.visible = true
            } else {
                sheetListPopup.visible = true
            }
            break;

        default:
            break;
        }
    }

    //Search Data Connector
    function  searchDataConnector(text){
        ConnectorFilter.setSearchString(text)
    }



    // JAVASCRIPT FUNCTIONS ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts

    LoginServer{
        id: connectGrafieks1
    }

    LoginCredentials{
        id: connectGrafieks2
    }

    MysqlConnection{
        id: mysqlModal
    }

    SqliteConnection{
        id: sqliteModal
    }

    MSSqlConnection{
        id: mssqlModal
    }

    PostgresConnection{
        id: postgresModal
    }

    //    ExcelConnection{
    //        id: excelModal
    //    }

    ExcelOdbcConnection{
        id: excelModal
    }

    MongoConnection{
        id: mongoModal
    }

    RedshiftConnection{
        id: redshiftModal
    }

    HiveConnection{
        id: hiveModal
    }

    ImpalaConnection{
        id: impalaModal
    }

    JsonConnection{
        id: jsonModal
    }

    AccessConnection{
        id: accessModal
    }

    OracleConnection{
        id: oracleModal
    }

    SnowflakeConnection{
        id: snowflakeModal
    }

    TeradataConnection{
        id: teradataModal
    }

    DropboxConnection{
        id: dropboxModal
    }

    DropboxConnectionFiles{
        id: fileListPopup
    }

    DriveConnection{
        id: driveModal
    }

    DriveConnectionFiles{
        id: driveListPopup
    }

    BoxConnection{
        id: boxModal
    }

    BoxConnectionFiles{
        id: boxListPopup
    }

    SheetConnection{
        id: sheetModal
    }

    SheetConnectionFiles{
        id: sheetListPopup
    }

    GithubConnection{
        id: githubModal
    }

    GithubConnectionFiles{
        id: githubListPopup
    }

    CSVConnection{
        id: csvModal
    }

    // Connect to Microsoft Excel
    FileDialog{
        id: fileDialog1

        title: Messages.selectFile

        onAccepted: {
            messageDialog1.open()
        }
        onRejected: console.log("file rejected")
    }

    MessageDialog{
        id: messageDialog1

        modality: Qt.ApplicationModal
        title: Messages.cn_sel_processFile
        text: Messages.cn_sel_pleaseWait
//        standardButtons: StandardButton.Ok | StandardButton.Close
        buttons: MessageDialog.Ok | MessageDialog.Close

        onAccepted: {

        }
        onRejected: {

        }
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts



    // Left menubar starts

    LeftMenuBar{
        id: left_menubar
    }

    // Left menubar ends


    Text{
        id: mainLabel
        scale : 0.8
        text: Messages.cn_sel_headers
        font.pointSize: Constants.fontHeader
        color:"gray"
        anchors.top:parent.top
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        x: selectconn_page.width/2 - 70
    }


    // Search Bar
    Rectangle{
        id:searchRectangle
        border.color: Constants.borderBlueColor
        width: 300
        height: 40
        radius: 5
        x: selectconn_page.width/2 - 150

        anchors.top : mainLabel.bottom
        anchors.topMargin: 20
        z: 5

        TextField {
            id: search_text
            width: parent.width
            height: 40
            placeholderText: Messages.search
            cursorVisible: true
            anchors.left: searchRectangle.left
            leftPadding: 15
            rightPadding: 45
            anchors.top: searchRectangle.top
            anchors.bottom:searchRectangle.bottom
            verticalAlignment:TextField.AlignVCenter
            font.italic: true
            font.pointSize: Constants.fontReading
            opacity: 0.6

            onTextChanged: searchDataConnector(search_text.text);


        }

    }

    TabBar{
        id: tabbar
        anchors.top: searchRectangle.bottom
        height: 40
        anchors.topMargin: 40
        width: parent.width
        x : selectconn_page.width/2 - 440
        z: 6
         background: TabBackgroundComponent{
                colorOuter : "transparent"
            }

        TabButton{
            id: tab_all
            width: 50
            height: parent.height
            focus : true
            contentItem: TabTextComponent{
                name: qsTr("All")

            }

            background: TabBackgroundComponent{
                colorOuter : tab_all.activeFocus ? Constants.buttonBorderColor : "transparent"
            }

            onClicked: selectedCategory = categoriesList[0]

        }

        TabButton{
            id: tab_file
            width: 50
            height: parent.height

            contentItem: TabTextComponent{
                name: qsTr("File")
            }

            background: TabBackgroundComponent{
                colorOuter : tab_file.activeFocus ? Constants.buttonBorderColor : "transparent"
            }

            onClicked: selectedCategory = categoriesList[1]
        }

        TabButton{
            id: tab_grs
            width: 220
            height: parent.height


            contentItem: TabTextComponent{
                name: qsTr("Grafieks Reporting Server")
            }

            background: TabBackgroundComponent{
                colorOuter : tab_grs.activeFocus ? Constants.buttonBorderColor : "transparent"

            }

            onClicked: selectedCategory = categoriesList[2]
        }

        TabButton{
            id:tab_rd
            width: 170
            height: parent.height


            contentItem: TabTextComponent{
                name: qsTr("Relational Database")
            }


            background: TabBackgroundComponent{
                colorOuter : tab_rd.activeFocus ? Constants.buttonBorderColor : "transparent"
            }

            onClicked: selectedCategory = categoriesList[3]
        }

        TabButton{
            id: tab_nd
            width: 150
            height: parent.height


            contentItem: TabTextComponent{
                name: qsTr("NoSQL Database")
            }


            background: TabBackgroundComponent{
                colorOuter : tab_nd.activeFocus ? Constants.buttonBorderColor : "transparent"
            }

            onClicked: selectedCategory = categoriesList[4]
        }

        TabButton{
            id: tab_cs
            width: 150
            height: parent.height


            contentItem: TabTextComponent{
                name: qsTr("Cloud Storage")
            }


            background: TabBackgroundComponent{
                colorOuter : tab_cs.activeFocus ? Constants.buttonBorderColor : "transparent"
            }

            onClicked: selectedCategory = categoriesList[5]
        }
        TabButton{
            id:tab_os
            width: 150
            height: parent.height


            contentItem: TabTextComponent{
                name: qsTr("Online Services")
            }

            background: TabBackgroundComponent{
                colorOuter : tab_os.activeFocus ? Constants.buttonBorderColor : "transparent"
            }

            onClicked: selectedCategory = categoriesList[6]
        }

    }

    // Display Connectors
    GridView{
        id: grid1

        anchors.top: tabbar.bottom
        anchors.left: left_menubar.right
        width: selectconn_page.width-50
        height: parent.height-300
        model: ConnectorFilter
        cellWidth: grid1.width / 6
        cellHeight: 130
        clip: true
        interactive: true
        ScrollBar.vertical: ScrollBar{}


        delegate : Rectangle{
            scale: 1
            width: 230
            height: 80

            Image{
                id: imageId
                source:imageLink
                height:50
                width:height
                anchors.centerIn: parent
                enabled: isEnabled

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        GeneralParamsModel.setFromLiveFile(false)
                        selectAuthorization(name)
                    }
                    enabled: isEnabled

                }
            }

            Text{
                text:(name == "Postgres"?"PostgresSQL":(name == "Sql Server"?"Microsoft Sql Server":name))
                font.pointSize: Constants.fontReading
                color:"gray"
                anchors.top: imageId.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: imageId.horizontalCenter
                enabled: isEnabled

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        GeneralParamsModel.setFromLiveFile(false)
                        selectAuthorization(name)
                    }
                    enabled: isEnabled
                }
            }
        }
    }



    // Page Design Ends
    /***********************************************************************************************************************/

}
