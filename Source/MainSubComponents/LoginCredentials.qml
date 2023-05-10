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
import QtQuick.Dialogs
import Qt.labs.settings 1.0

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0



Popup {
    id: popupLoginCredentials
    width: 600
    height: 400
    modal: true
    visible: false
     background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }
    x: parent.width / 2 - 300
    y: parent.height / 2 - 200
    padding: 0

    property int label_col : 150

    Connections{
        target: User
        function onLoginStatus(status){

            if(status.code === 200){
                popupLoginCredentials.visible = false
//                stacklayout_home.currentIndex = 4

                var firstname = settings.value("user/firstname")
                var lastname = settings.value("user/lastname")
                var capitalizeFirstName = firstname.charAt(0).toUpperCase() + firstname.slice(1)
                var capitalizeLastName = lastname.charAt(0).toUpperCase() + lastname.slice(1)
                var name = capitalizeFirstName + " "+ capitalizeLastName

                action_signin.text  = Messages.signOutText

                // Load datasources in GRS for first time
                DatasourceDS.fetchDatsources(0,false, false)

                error_connection_text.text = ""
                password_field.text = ""
                username_field.text = ""

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
        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left

        Text{
            text: Messages.msc_lcr_header
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
                text: Messages.msc_lcr_username
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: username_field
            maximumLength: 250
            selectByMouse: true
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment:TextField.AlignVCenter
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
                text: Messages.msc_lcr_password
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: password_field
            maximumLength: 250
            selectByMouse: true
            echoMode: "Password"
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment:TextField.AlignVCenter
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

        // Button{

        //     id: btn_signin
        //     height: back_rec_1.height
        //     width: back_rec_1.width

        //     background: Rectangle{
        //         id: back_rec_1
        //         color: btn_signin.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
        //         width: 100
        //         height: 40

        //         Rectangle{
        //             anchors.fill: parent
        //             anchors.margins: 1
        //             color: btn_signin.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

        //         }

        //         Text{
        //             text:Messages.signInText
        //             font.pixelSize: Constants.fontCategoryHeader
        //             color: btn_signin.hovered ? "white" : "black"
        //             anchors.centerIn: parent
        //         }
        //     }
        //     onClicked: {

        //         error_connection_text.text = Messages.msc_lcr_pleaseWait
        //         User.setUsername(username_field.text);
        //         User.setPassword(password_field.text);

        //         User.login()

        //     }
        // }
        CustomButton{
            id: btn_signin
            width: 100
            anchors.right:btn_cancel.left
            anchors.rightMargin:30
            textValue: Messages.signInText
            fontPixelSize: Constants.fontCategoryHeader
            onClicked: {

                error_connection_text.text = Messages.msc_lcr_pleaseWait
                User.setUsername(username_field.text);
                User.setPassword(password_field.text);

                User.login()

            }
        }
        CustomButton{
            id: btn_cancel
            width: 100
            anchors.right:parent.right
            textValue: "Cancel"
            fontPixelSize: Constants.fontCategoryHeader
            onClicked: {
                popupLoginCredentials.visible = false
            }
        }

        // Button{
        //     id: btn_cancel
        //     height: back_rec_2.height
        //     width: back_rec_2.width

        //     background: Rectangle{
        //         id: back_rec_2
        //         color: btn_cancel.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
        //         width: 100
        //         height: 40
        //         Rectangle{
        //             anchors.fill: parent
        //             anchors.margins: 1
        //             color: btn_cancel.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

        //         }

        //         Text{
        //             text:"Cancel"
        //             font.pixelSize: Constants.fontCategoryHeader
        //             color: btn_cancel.hovered ? "white" : "black"
        //             anchors.centerIn: parent
        //         }
        //     }

        //     onClicked: {
        //         popupLoginCredentials.visible = false
        //     }
        // }


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
