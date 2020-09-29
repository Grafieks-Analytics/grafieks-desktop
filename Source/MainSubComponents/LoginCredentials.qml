/****************************************************************************
**
** Copyright (C) 2019 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Login Credentials
** Popup code to connect to Grafieks server
** Prompts Username and Password
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

import com.grafieks.singleton.constants 1.0



Popup {
    id: popupLoginCredentials
    width: 600
    height: 400
    modal: true
    visible: false
    x: parent.width / 2 - 300
    y: parent.width / 2 - 700
    padding: 0

    property int label_col : 150

    Connections{
        target: User
        function onLoginStatus(status){

            if(status.code === 200){
                popupLoginCredentials.visible = false
                stacklayout_home.currentIndex = 4

                var firstname = settings.value("user/firstname")
                var lastname = settings.value("user/lastname")
                var capitalizeFirstName = firstname.charAt(0).toUpperCase() + firstname.slice(1)
                var capitalizeLastName = lastname.charAt(0).toUpperCase() + lastname.slice(1)
                var name = capitalizeFirstName + " "+ capitalizeLastName

                action_signin.text  = Constants.signOutText
                menu_signIn.title = qsTr(name)
            }
            else{
                error_connection_text.text = status.msg
            }


        }

    }



    // Popup Header starts

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
            text: "Signin to Grafieks server"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
            anchors.leftMargin: 10
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
                    popupLoginCredentials.visible = false
                }
            }
        }
    }

    // Popup Header ends

    // Row1: Enter username starts

    Row{

        id: row1
        anchors.top: headerPopup.bottom
        anchors.topMargin: 70
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
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: username_field
            maximumLength: 45
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

    // Row1: Enter username ends

    // Row2: Enter password starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 30
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
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: password_field
            maximumLength: 45
            echoMode: "Password"
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

    // Row2: Enter password ends

    // Row 3: Action Button starts

    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        spacing: 10

        Button{

            id: btn_signin
            height: back_rec_1.height
            width: back_rec_1.width

            background: Rectangle{
                id: back_rec_1
                color: btn_signin.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
                width: 100
                height: 40

                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 1
                    color: btn_signin.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

                }

                Text{
                    text:Constants.signInText
                    font.pixelSize: Constants.fontCategoryHeader
                    color: btn_signin.hovered ? "white" : "black"
                    anchors.centerIn: parent
                }
            }
            onClicked: {

                error_connection_text.text = "Signing in. Please wait.."
                User.setUsername(username_field.text);
                User.setPassword(password_field.text);

                User.login()

            }
        }

        Button{
            id: btn_cancel
            height: back_rec_2.height
            width: back_rec_2.width

            background: Rectangle{
                id: back_rec_2
                color: btn_cancel.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
                width: 100
                height: 40
                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 1
                    color: btn_cancel.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

                }

                Text{
                    text:"Cancel"
                    font.pixelSize: Constants.fontCategoryHeader
                    color: btn_cancel.hovered ? "white" : "black"
                    anchors.centerIn: parent
                }
            }

            onClicked: {
                popupLoginCredentials.visible = false
            }
        }


    }
    // Row 3: Action Button ends


    // Row 3: Error message starts
    Row{

        id: row4
        anchors.top: row3.bottom
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        spacing: 10

        Text{
            id: error_connection_text
            color: "red"
            text: ""
        }
    }

    // Row 3: Error message ends


    Settings{
        id: settings

    }

}
