import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import "../MainSubComponents"
import "./SubComponents"
import "../../Constants.js" as Constants

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
        font.pointSize: 28
        color:"gray"
        anchors.top:parent.top
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        x: selectconn_page.width/2 - 70
    }

    Rectangle{
        id:search_rect
        border.color: "#BCE0FD"
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
            font.pointSize: 12
            opacity: 0.6
        }

        Image{
            id:search_btn
            source: "../../Images/icons/Search.png"
            //anchors.left: search_text.right
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
        x : selectconn_page.width/2 - 450

        TabButton{
            id: tab_all
            text: qsTr("All")
            width: 50
            font.pixelSize: 15
            contentItem: Text {

                text: tab_all.text
                font: tab_all.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }
            background: Rectangle{
                color : tab_all.activeFocus ? Constants.buttonBorderColor : "transparent"

                Rectangle{
                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    color: tab_all.activeFocus ? "white" : "transparent"
                }
            }
        }
        TabButton{
            id: tab_file
            text: qsTr("File")
            width: 50
            font.pixelSize: 15
            contentItem: Text {

                text: tab_file.text
                font: tab_file.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }
            background: Rectangle{
                color : tab_file.activeFocus ? Constants.buttonBorderColor : "transparent"

                Rectangle{
                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    color: tab_file.activeFocus ? "white" : "transparent"
                }
            }
        }
        TabButton{
            id: tab_grs
            text: qsTr("Grafieks Reporting Server")
            width: 200
            font.pixelSize: 15
            contentItem: Text {

                text: tab_grs.text
                font: tab_grs.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }
            background: Rectangle{
                color : tab_grs.activeFocus ? Constants.buttonBorderColor : "transparent"

                Rectangle{
                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    color: tab_grs.activeFocus ? "white" : "transparent"
                }
            }
        }
        TabButton{
            id:tab_rd
            text: qsTr("Relational Database")
            width: 150
            font.pixelSize: 15
            contentItem: Text {

                text: tab_rd.text
                font: tab_rd.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }
            background: Rectangle{
                color : tab_rd.activeFocus ? Constants.buttonBorderColor : "transparent"

                Rectangle{
                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    color: tab_rd.activeFocus ? "white" : "transparent"
                }
            }
        }
        TabButton{
            id: tab_nd
            text: qsTr("NoSQL Database")
            width: 150
            font.pixelSize: 15
            contentItem: Text {

                text: tab_nd.text
                font: tab_nd.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }
            background: Rectangle{
                color : tab_nd.activeFocus ? Constants.buttonBorderColor : "transparent"

                Rectangle{
                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    color: tab_nd.activeFocus ? "white" : "transparent"
                }
            }
        }
        TabButton{
            id: tab_cs
            text: qsTr("Cloud Storage")
            width: 150
            font.pixelSize: 15
            contentItem: Text {

                text: tab_cs.text
                font: tab_cs.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }
            background: Rectangle{
                color : tab_cs.activeFocus ? Constants.buttonBorderColor : "transparent"

                Rectangle{
                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    color: tab_cs.activeFocus ? "white" : "transparent"
                }
            }
        }
        TabButton{
            id:tab_os
            text: qsTr("Online Services")
            width: 150
            font.pixelSize: 15
            contentItem: Text {

                text: tab_os.text
                font: tab_os.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "black"
            }
            background: Rectangle{
                color : tab_os.activeFocus ? Constants.buttonBorderColor : "transparent"

                Rectangle{
                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    color: tab_os.activeFocus ? "white" : "transparent"
                }
            }
        }

    }

    GridLayout{
        id: grid1
        columns: 6
        columnSpacing: 130
        rowSpacing: 30
        //        height:200
        anchors.horizontalCenter: mainLabel.horizontalCenter
        anchors.top: mainLabel.bottom
        anchors.verticalCenter: mainLabel.verticalCenter
        anchors.topMargin: 170


        Column{
            id:amz_rs_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }

            //  Layout.leftMargin: 300
            Image{
                id: i1
                source:"../../Images/icons/aws-redshift-logo.png"
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Amazon Redshift"
                font.pointSize: 20
                color:"gray"
                anchors.top: i1.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: i1.horizontalCenter


                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id:apache_hv_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100

            Rectangle{
                width: parent.height
                height: parent.height
            }


            //            Layout.leftMargin: 15
            Image{
                id: i2
                source:"../../Images/icons/hadoop.png"
                height:60
                width:height

                anchors.centerIn:  parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Apache Hadoop"
                font.pointSize: 20
                color:"gray"
                anchors.top: i2.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: i2.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }




        Column{
            id:box_logo_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100


            Rectangle{
                width: parent.height
                height: parent.height
            }
            //Layout.leftMargin: 45
            Image{
                id: i3
                source:"../../Images/icons/box.png"
                height:60
                width:height
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.centerIn:  parent


                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Box"
                font.pointSize: 20
                color:"gray"
                anchors.top: i3.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: i3.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }
        Column{
            id:drpbx_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }


            //Layout.leftMargin: 25
            Image{
                id: i4
                source:"../../Images/icons/dropbox-2.png"
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"DropBox"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i4.horizontalCenter
                anchors.topMargin: 10
                anchors.top : i4.bottom

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id:gthb_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }


            // Layout.leftMargin: 45
            Image{
                id: i5
                source:"../../Images/icons/github-1.png"
                height:60
                width:height
                anchors.centerIn: parent
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Github"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i5.horizontalCenter
                anchors.topMargin: 10
                anchors.top : i5.bottom
                //anchors.verticalCenter: parent.verticalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id:ggl_ana_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }

            //  Layout.rightMargin: 350
            Image{
                id: i6
                source:"../../Images/icons/google-analytics-4.png"
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Google Analytics"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i6.horizontalCenter
                anchors.topMargin: 10
                anchors.top : i6.bottom

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id:gog_sheet_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100

            Rectangle{
                width: parent.height
                height: parent.height
            }

            //   Layout.leftMargin: 330
            Image{
                id: i7
                source:"../../Images/icons/16_google-sheets_1b1915a4b0.png"
                height:60
                width:height
                anchors.centerIn:  parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Google Sheet"
                font.pointSize: 20
                color:"gray"
                anchors.top: i7.bottom
                anchors.horizontalCenter: i7.horizontalCenter
                anchors.topMargin: 10

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id: grs_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }

            //            Layout.leftMargin: 85
            Image{
                id: i8
                source:"../../Images/icons/GRS.png"
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"GRS"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i8.horizontalCenter
                anchors.topMargin: 10
                anchors.top : i8.bottom

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }
        Column{
            id:jdbc_col
            spacing:10
            scale : 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }


            //            Layout.leftMargin: 40
            Image{
                id: i9
                source:"../../Images/icons/Db - 60.png"
                height:60
                width:height
                anchors.centerIn:  parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"JDBC"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i9.horizontalCenter
                anchors.topMargin: 10
                anchors.top : i9.bottom

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
        }
        Column{
            id:json_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 50
            Image{
                id: i10
                source:"../../Images/icons/json-icon.png"
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"JSON"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i10.horizontalCenter
                anchors.top : i10.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id: ms_acc_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: -25
            Image{
                id: i11
                source:"../../Images/icons/microsoft-access-1.png"
                height:60
                width:height
                anchors.centerIn:  parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Microsoft Access"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i11.horizontalCenter
                anchors.top : i11.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id:excel_col
            spacing:10
            scale : 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.rightMargin: 300
            Image{
                id: i12
                //id: excel_icon
                source:"../../Images/icons/microsoft-excel-2013.png"
                height:60
                //fillMode: Image.Stretch
                width:height
                anchors.centerIn:  parent

                MouseArea{
                    id: btn1
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        fileDialog1.open()
                    }

                }
            }
            Text{
                id: excel_text
                text:"Microsoft Excel"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i12.horizontalCenter
                anchors.top : i12.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        fileDialog1.open()
                    }
                }
            }
        }

        Column{
            id:mysql_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 380
            Image{
                id: i13
                source:"../../Images/icons/mysql-6.png"
                height:60
                width:height
                anchors.centerIn:  parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"MySQL"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i13.horizontalCenter
                anchors.top : i13.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id: oracle_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 70
            Image{
                id: i14
                source:"../../Images/icons/oracle-icon.png"
                height:60
                width:height
                anchors.centerIn:  parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Oracle"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i14.horizontalCenter
                anchors.top: i14.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        //                        connectDatabase.visible = true
                        //                        update_data_sources_list();
                    }
                }
            }
        }


        Column{
            id:odbc_col
            spacing:10
            scale: 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 35
            Image{
                id: i15
                source:"../../Images/icons/Db - 60.png"
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"ODBC"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i15.horizontalCenter
                anchors.top : i15.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id:snowflake_col
            spacing:10
            scale : 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 15
            Image{
                id: i16
                source:"../../Images/icons/20_snowflake-icon_a4ed1ae266.png"
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Snowflake"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i16.horizontalCenter
                anchors.top : i16.bottom
                anchors.topMargin: 10

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
        }




        Column{
            id:sqlite_col
            spacing:10
            scale : 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 50
            Image{
                id: i17
                source:"../../Images/icons/74_sqlite-icon_a6ac860586.png"
                height:60
                width:height
                verticalAlignment: Image.AlignVCenter
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectGrafieks1.visible = true
                    }
                }
            }
            Text{
                text:"SQLite"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i17.horizontalCenter
                anchors.top : i17.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectGrafieks1.visible = true
                    }
                }
            }
        }

        Column{
            id:sql_srvr_col
            spacing:10
            scale : 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 40
            Image{
                id: i18
                source:"../../Images/icons/microsoft-sql-server.png"
                height:60
                width:height
                anchors.centerIn:  parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectGrafieks1.visible = true
                    }
                }
            }
            Text{
                text:"SQL Server"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i18.horizontalCenter
                anchors.top : i18.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectGrafieks1.visible = true
                    }
                }
            }
        }

        Column{
            id:teradata_col
            spacing:10
            scale : 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 370
            Image{
                id: i19
                source:"../../Images/icons/Db - 60.png"
                height:60
                width:height
                anchors.centerIn:  parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Teradata"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i19.horizontalCenter
                anchors.top: i19.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
        }

        Column{
            id:text_csv_col
            spacing:10
            scale : 0.7
            height: 100
            width: 100
            Rectangle{
                width: parent.height
                height: parent.height
            }
            //            Layout.leftMargin: 50
            Image{
                id: i20
                source:"../../Images/icons/16_csv.png"
                height:60
                width:height
                anchors.centerIn: parent

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
            Text{
                text:"Text/CSV"
                font.pointSize: 20
                color:"gray"
                anchors.horizontalCenter: i20.horizontalCenter
                anchors.top: i20.bottom
                anchors.topMargin: 10
                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                        update_data_sources_list();
                    }
                }
            }
        }

        //        Column{
        //            id:server_col1
        //            spacing:10
        //            scale : 0.7
        //          height: 100
        //          width: 100
        //            Image{
        //                source:"../../Images/icons/Server.png"
        //                height:60
        //                width:height
        //                verticalAlignment: Image.AlignVCenter
        //                anchors.horizontalCenter: parent.horizontalCenter

        //                MouseArea{
        //                    anchors.fill: parent

        //                    onClicked: {
        //                        connectGrafieks1.visible = true
        //                    }
        //                }
        //            }
        //            Text{
        //                text:"Server"
        //                font.pointSize: 20
        //                color:"gray"
        //                anchors.horizontalCenter: parent.horizontalCenter

        //                MouseArea{
        //                    anchors.fill: parent

        //                    onClicked: {
        //                        connectGrafieks1.visible = true
        //                    }
        //                }
        //            }
        //        }



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

    ConnectGrafieks1{
        id: connectGrafieks1
    }

    ConnectGrafieks2{
        id: connectGrafieks2

    }

    ConnectDatabase{
        id: connectDatabase

    }







}
