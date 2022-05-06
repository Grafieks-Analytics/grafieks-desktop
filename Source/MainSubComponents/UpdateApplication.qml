import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

Popup {
    id: updateApplication
    width: 600
    height: 300
    modal: true
    visible: false
    x: parent.width / 2 - 300
    y: parent.height / 2 - 200
    padding: 0

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
            text: Messages.msc_uan_header
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
                    updateApplication.visible = false
                }
            }
        }
    }

    // Popup Header ends



    // Row 1: Action Button starts

    Row{

        id: row1
        anchors.bottom: parent.bottom
        anchors.bottomMargin:  60
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
                    text: Messages.signOutText
                    font.pixelSize: Constants.fontCategoryHeader
                    color: btn_signin.hovered ? "white" : "black"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                error_connection_text.text = Messages.msc_uan_pleaseWait
                User.logout()
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
                    text: Messages.cancelBtnTxt
                    font.pixelSize: Constants.fontCategoryHeader
                    color: btn_cancel.hovered ? "white" : "black"
                    anchors.centerIn: parent
                }
            }

            onClicked: {
                popupLogout.visible = false
            }
        }


    }
    // Row 1: Action Button ends


    // Row 2: Error message starts
    Row{

        id: row2
        anchors.top: row1.bottom
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

    // Row 2: Error message ends
}
