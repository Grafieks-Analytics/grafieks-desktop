/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Popup code to connect to Grafieks server
** Prompts Server URL
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import "../../../Constants.js" as Constants

Popup {
    id: popup
    width: 600
    height: 180
    modal: true
    visible: false
    x: parent.width / 2 - 200
    y: 100
    padding: 0

    property int label_col : 150

    // Header starts

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
            text: "Signin to Grafieks server"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            anchors.leftMargin: 10
        }
    }

    // Header ends

    // Signin to server starts

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
                text: "Server URL"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: field1
            placeholderText: "http://"
            maximumLength: 45
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Signin to server ends

    // Row 2: Action Button starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: label_col
        spacing: 10

        Button{
            id: btn_con
            height: back_rec_1.height
            width: back_rec_1.width

            background: Rectangle{
                id: back_rec_1
                radius: 10
                color: Constants.greenThemeColor
                width: 100
                height: 30

                Text{
                    text: "Connect"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                popup.visible = false
                connectGrafieks2.visible = true
            }
        }

        Button{
            id: btn_cancel
            height: back_rec_2.height
            width: back_rec_2.width

            background: Rectangle{
                id: back_rec_2
                radius: 10
                color: Constants.redThemeColor
                width: 100
                height:30

                Text{
                    text: "Cancel"
                    anchors.centerIn: parent
                }
            }

            onClicked: {
                popup.visible = false
            }
        }
    }
    // Row 2: Action Button ends
}
