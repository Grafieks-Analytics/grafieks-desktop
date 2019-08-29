/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Popup code to connect to database server
** Prompts all the details
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import "../../../Constants.js" as Constants



Popup {
    id: popup
    width: 600
    height: 360
    modal: true
    visible: false
    x: parent.width / 2 - 200
    y: 100
    padding: 0

    property int label_col : 150

    // Popup Header starts

    Rectangle{
        id: header_popup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            text: "Signin to Database"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            anchors.leftMargin: 10
        }
    }

    // Popup Header ends

    // Row1: Enter Server address starts

    Row{

        id: row1
        anchors.top: header_popup.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label1
            width:label_col
            height: 40

            Text{
                text: "Server"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: field1
            maximumLength: 45
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Row1: Enter server address ends

    // Row2: Enter database name starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label2
            width:label_col
            height: 40

            Text{
                text: "Database"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: field2
            maximumLength: 45
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Row2: Enter database name ends

    // Row3: Enter database name starts

    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label3
            width:label_col
            height: 40

            Text{
                text: "Port"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: field3
            maximumLength: 45
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Row3: Enter database name ends

    // Row 4: Enter user name starts

    Row{

        id: row4
        anchors.top: row3.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label4
            width:label_col
            height: 40

            Text{
                text: "Username"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: field4
            maximumLength: 45
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Row 4: Enter user name ends

    // Row 5: Enter password starts

    Row{

        id: row5
        anchors.top: row4.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label5
            width:label_col
            height: 40

            Text{
                text: "Password"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: field5
            maximumLength: 45
            echoMode: "Password"
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Row 5: Enter password ends

    // Row 6: Action Button starts

    Row{

        id: row6
        anchors.top: row5.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: label_col
        spacing: 10

        Button{
            id: btn_test_con
            height: back_rec_1.height
            width: back_rec_1.width

            background: Rectangle{
                id: back_rec_1
                radius: 10
                color: Constants.greenThemeColor
                width: 130
                height: 30

                Text{
                    text:"Test Connection"
                    anchors.centerIn: parent
                }
            }
        }

        Button{
            id: btn_connect
            height: back_rec_2.height
            width: back_rec_2.width

            background: Rectangle{
                id: back_rec_2
                radius: 10
                color: Constants.greenThemeColor
                width: 100
                height: 30

                Text{
                    text:"Connect"
                    anchors.centerIn: parent
                }
            }

            onClicked: {
                popup.visible = false
                stacklayout_home.currentIndex = 4
            }
        }

        Button{
            id: btn_cancel
            height: back_rec_3.height
            width: back_rec_3.width

            background: Rectangle{
                id: back_rec_3
                radius: 10
                color: Constants.redThemeColor
                width: 100
                height: 30

                Text{
                    text:"Cancel"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                popup.visible = false
            }
        }
    }
    // Row 6: Action Button ends
}
