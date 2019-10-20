/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Popup code to connect to Grafieks server
** Prompts Username and Password
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2

import "../../../Constants.js" as Constants



Popup {
    id: popup2
    width: 600
    height: 230
    modal: true
    visible: false
    x: parent.width / 2 - 200
    y: 100
    padding: 0

    property int label_col : 150

    Connections{
        target: User
        onLoginStatus:{

            if(showPublish === true){

                if(loginStatusVar === true){
                    popup2.visible = false
                    datasourceDescription.visible = true
                    action_signin.text = qsTr("Sign Out")

                }
                else{
                    popup2.visible = true
                    msg_dialog_publish_grafieks.open()
                    msg_dialog_publish_grafieks.text = "Invalid Username or Password"
                }
            }
        }
    }

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
            text: "Signin to Grafieks server"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            anchors.leftMargin: 10
        }
    }

    // Popup Header ends

    // Row1: Enter username starts

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
                text: "Username"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: username_field
            maximumLength: 45
            anchors.verticalCenter: parent.verticalCenter
            width: 370

            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Row1: Enter username ends

    // Row2: Enter password starts

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
                text: "Password"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: password_field
            maximumLength: 45
            echoMode: "Password"
            anchors.verticalCenter: parent.verticalCenter
            width: 370

            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Row2: Enter password ends

    // Row 3: Action Button starts

    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: label_col
        spacing: 10

        Button{

            id: btn_signin
            height: back_rec_1.height
            width: back_rec_1.width

            background: Rectangle{
                id: back_rec_1
                radius: 10
                color: Constants.greenThemeColor
                width: 100
                height: 30

                Text{
                    text:"Sign In"
                    anchors.centerIn: parent
                }
            }
            onClicked: {

                User.setLoginUsername(username_field.text);
                User.setLoginPassword(password_field.text);

                User.checkLogin(true)
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
                height: 30

                Text{
                    text:"Cancel"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                popup2.visible = false
            }
        }
    }
    // Row 3: Action Button ends

    MessageDialog{
        id: msg_dialog_publish_grafieks
        title: "Hostname"
        text: ""
        icon: StandardIcon.Critical
    }
}
