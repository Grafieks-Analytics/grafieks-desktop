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


    LeftMenuBar{
        id: left_menubar
    }

    Text{
        id: mainLabel

        text: qsTr("Connect To")
        font.pointSize: 20
        color:"gray"
        anchors.top:parent.top
        anchors.topMargin: 100
        x: selectconn_page.width/2 - 70
    }

    Row{
        id: options_row

        height:300
        spacing: 150
        anchors.horizontalCenter:mainLabel.horizontalCenter
        anchors.top: mainLabel.bottom
        anchors.topMargin: 60
        Layout.fillWidth: true


        Column{
            id:excel_col
            spacing:10

            Image{
                source:"../../Images/icons/Excel.png"
                height:60
                fillMode: Image.Stretch
                width:height
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        fileDialog1.open()
                    }
                }
            }
            Text{
                text:"Microsoft Excel"
                font.pointSize: 14
                color:"gray"
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        fileDialog1.open()
                    }
                }
            }
        }


        Column{
            id:odbc_col
            spacing:10

            Image{
                source:"../../Images/icons/Db.png"
                height:60
                width:height
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                    }
                }
            }
            Text{
                text:"ODBC"
                font.pointSize: 14
                color:"gray"
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                    }
                }
            }
        }


        Column{
            id:jdbc_col
            spacing:10

            Image{
                source:"../../Images/icons/Db.png"
                height:60
                width:height
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                    }
                }
            }
            Text{
                text:"JDBC"
                font.pointSize: 14
                color:"gray"
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectDatabase.visible = true
                    }
                }
            }
        }


        Column{
            id:server_col
            spacing:10

            Image{
                source:"../../Images/icons/server.png"
                height:60
                width:height
                verticalAlignment: Image.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectGrafieks1.visible = true
                    }
                }
            }
            Text{
                text:"Server"
                font.pointSize: 14
                color:"gray"
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        connectGrafieks1.visible = true
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
