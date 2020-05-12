/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Select Connection
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"
import "./SubComponents"


Page {

    id: selectconn_page
    width: parent.width - left_menubar.width


    // Signals
    signal update_host_query_modeller(string new_host);
    signal update_data_sources_list();

    // Slots

    function tmp_update_host(new_host){
        update_host_query_modeller(new_host)
    }


    LeftMenuBar{
        id: left_menubar
    }



    Text{
        id: mainLabel
        scale : 0.8
        text: qsTr("Data Connectors")
        font.pointSize: Constants.fontHeader
        color:"gray"
        anchors.top:parent.top
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        x: selectconn_page.width/2 - 70
    }

    Rectangle{
        id:search_rect
        border.color: Constants.borderBlueColor
        width: 400
        height: 35
        radius: 5
        x: selectconn_page.width/2 - 195
        anchors.verticalCenter: selectconn_page.verticalCenter
        anchors.top : mainLabel.bottom
        anchors.topMargin: 20


        TextEdit {
            id: search_text
            text: "Search"
            cursorVisible: true
            width:250
            height: 50
            anchors.left: search_rect.left
            anchors.leftMargin: 30
            anchors.top: search_rect.top
            anchors.bottom:search_rect.bottom
            verticalAlignment:TextEdit.AlignVCenter
            font.italic: true
            font.weight: font.Thin
            font.pointSize: Constants.fontReading
            opacity: 0.6
        }

        Image{
            id:search_btn
            source: "../../Images/icons/Search.png"
            anchors.right: search_rect.right
            anchors.rightMargin: 10
            height:30
            width: height
            anchors.verticalCenter: search_rect.verticalCenter

        }

    }

    TabBar{
        id: tabbar
        anchors.top: search_rect.bottom
        anchors.verticalCenter: selectconn_page.verticalCenter
        height: 40
        anchors.topMargin: 40
        x : selectconn_page.width/2 - 440



        TabButton{
            id: tab_all
            width: 50
            height: parent.height
            contentItem: TabTextComponent{
                name: qsTr("All")

            }

            background: TabBackgroundComponent{
                colorOuter : tab_all.activeFocus ? Constants.buttonBorderColor : "transparent"
            }

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
        }

    }

    ListModel {
        id: listConnectors
        Component.onCompleted: {
            [
            {
                imageLink: "../../Images/icons/aws-redshift-logo.png",
                name: qsTr("Amazon Redshift")
            },
            {
                imageLink: "../../Images/icons/hadoop.png",
                name: qsTr("Apache Hadoop")
            },
            {
                imageLink: "../../Images/icons/box.png",
                name: qsTr("Box")
            },
            {
                imageLink: "../../Images/icons/dropbox-2.png",
                name: qsTr("Dropbox")
            },
            {
                imageLink: "../../Images/icons/github-1.png",
                name: qsTr("Github")
            },
            {
                imageLink: "../../Images/icons/google-analytics-4.png",
                name: qsTr("Google Analytics")
            },
            {
                imageLink: "../../Images/icons/16_google-sheets_1b1915a4b0.png",
                name: qsTr("Google Sheets")
            },
            {
                imageLink: "../../Images/icons/GRS.png",
                name: qsTr("GRS"),
                modalId: connectGrafieks1,
                func: "dummyFunc"
            },
            {
                imageLink: "../../Images/icons/json-icon.png",
                name: qsTr("JSON"),
                modalId: "dummyId",
                func: "dummyFunc"
            },
            {
                imageLink: "../../Images/icons/microsoft-access-1.png",
                name: qsTr("Microsoft Access")
            },
            {
                imageLink: "../../Images/icons/microsoft-excel-2013.png",
                name: qsTr("Microsoft Excel")
            },
            {
                imageLink: "../../Images/icons/mysql-6.png",
                name: qsTr("Mysql")
            },
            {
                imageLink: "../../Images/icons/oracle-icon.png",
                name: qsTr("Oracle")
            },
            {
                imageLink: "../../Images/icons/Db - 60.png",
                name: qsTr("ODBC"),
                modalId: connectDatabase,
                func: "dummyFunc"
            },
            {
                imageLink: "../../Images/icons/20_snowflake-icon_a4ed1ae266.png",
                name: qsTr("Snowflake")
            },
            {
                imageLink: "../../Images/icons/74_sqlite-icon_a6ac860586.png",
                name: qsTr("Sqlite")
            },
            {
                imageLink: "../../Images/icons/microsoft-sql-server.png",
                name: qsTr("SQL Server")
            },
            {
                imageLink: "../../Images/icons/Db - 60.png",
                name: qsTr("Tera Data")
            },
            {
                imageLink: "../../Images/icons/16_csv.png",
                name: qsTr("CSV")
            }

            ].forEach(function(e) { append(e); });
        }
    }

    GridView{
        id: grid1

        anchors.top: tabbar.bottom
        anchors.topMargin: 60
        anchors.left: left_menubar.right
        width: selectconn_page.width
        height: parent.height
        model: listConnectors
        cellWidth: grid1.width / 6
        cellHeight: 130



        delegate : Column{
            scale: 0.8
            width: 230

            Image{
                id: imageId
                source:imageLink
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        modalId.visible = true
//                        update_data_sources_list();
                    }
                }
            }

            Text{
                text:name
                font.pointSize: Constants.fontSubHeader
                color:"gray"
                anchors.top: imageId.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: imageId.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        modalId.visible = true
//                        update_data_sources_list();
                    }
                }
            }
        }
    }




    // Connect to Microsoft Excel
    FileDialog{
        id: fileDialog1

        title: "Select a file"

        onAccepted: {
            console.log("file chosen")
            messageDialog1.open()
        }
        onRejected: {
            console.log("file rejected")
        }
    }

    MessageDialog{
        id: messageDialog1

        modality: Qt.ApplicationModal
        title: "Processing file"
        text: "Please wait. We are processing your input file. Hit Ok to continue"
        standardButtons: StandardButton.Ok | StandardButton.Close

        onAccepted: {

        }
        onRejected: {

        }
    }

    LoginServer{
        id: connectGrafieks1
    }

    LoginCredentials{
        id: connectGrafieks2

    }

    ConnectDatabase{
        id: connectDatabase

    }

}
