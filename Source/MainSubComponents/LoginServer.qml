/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Login Server
** Popup code to connect to Grafieks server
** Prompts Server URL
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Popup {
    id: popupLoginServer
    width: 600
    height: 200
    modal: true
    visible: false
    x: parent.width / 2 - 300
    y: parent.width /2 - 600
    padding: 0

    property int label_col : 150

    Connections{
        target: User

        function onSitelookupStatus(status){
            console.log(JSON.stringify(status))

            if(status.code === 200){
                popupLoginServer.visible = false
                connectGrafieks2.visible = true

                errorMsg.text = ""
                server_address.text = ""

            } else {
                errorMsg.text = status.msg + " Host not found"
            }
        }
    }

    // Header starts

    Rectangle{
        id: headerPopup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Text{
            id: text2
            text: "Sign in to Grafieks Reporting Server"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            anchors.leftMargin: 10
            font.pixelSize: Constants.fontCategoryHeader
        }
        Image {
            id: close_icn
            source: "/Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    popupLoginServer.visible = false
                }
            }
        }
    }

    // Header ends

    // Signin to server starts

    Row{

        id: row1
        anchors.top: headerPopup.bottom
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
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: server_address
            placeholderText: "http://"
            selectByMouse: true
            maximumLength: 250
            font.pixelSize: Constants.fontCategoryHeader
            anchors.verticalCenter: parent.verticalCenter
            width: 370
            height: 40
            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 370
            }
        }

    }

    // Signin to server ends

    // Row 2: Action Button starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        spacing: 10

        Button{
            id: btn_con
            height: back_rec_1.height
            width: back_rec_1.width

            background: Rectangle{
                id: back_rec_1
                //radius: 10
                color: btn_con.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
                width: 100
                height: 40
                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 1
                    //radius: 10
                    color: btn_con.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

                }
                Text{
                    text: "Connect"
                    anchors.centerIn: parent
                    color: btn_con.hovered ? "white" : "black"
                    font.pixelSize: Constants.fontCategoryHeader
                }
            }
            onClicked: User.siteLookup(server_address.text)
        }

        Button{
            id: btn_cancel
            height: back_rec_2.height
            width: back_rec_2.width

            background: Rectangle{
                id: back_rec_2
                //radius: 10
                color: btn_cancel.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
                width: 100
                height: 40
                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 1
                    //radius: 10
                    color: btn_cancel.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

                }

                Text{
                    text: "Cancel"
                    anchors.centerIn: parent
                    color: btn_cancel.hovered ? "white" : "black"
                    font.pixelSize: Constants.fontCategoryHeader
                }
            }

            onClicked: {
                popupLoginServer.visible = false
            }
        }
    }
    // Row 2: Action Button ends


    // Row 3: Error Msg
    Row{
        anchors.top: row2.bottom
        anchors.leftMargin: 10

        Text{
            id: errorMsg
            color: Constants.redColor
            font.pointSize:  Constants.fontReading

        }
    }

}
