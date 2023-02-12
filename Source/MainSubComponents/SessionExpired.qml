import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

Popup {
    id: sessionExpiredPopup
    x: parent.width/2 - 300
    y: parent.height/2 - 200
    width: 600
    height: 300
    modal: true
    visible: false
    padding: 0

    closePolicy: Popup.NoAutoClose


    function closePopup(){
        User.logout()
        sessionExpiredPopup.visible = false
        errorMsg.text = ""
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
            text: Messages.msc_sed_header
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            anchors.leftMargin: 10
        }
        Image {
            id: close_icn
            source: "/Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: closePopup()
            }
        }
    }

    // Popup Header ends

    // Row : Session starts

    Row{

        id: datasourceErrorMsg
        anchors.top: header_popup.bottom
        anchors.topMargin: 30
        // anchors.left: parent.left
        // anchors.leftMargin: 30
        // anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{

            id: label1
            width:sessionExpiredPopup.width
            height: 40
            // anchors.leftMargin: 30
            anchors.horizontalCenter: sessionExpiredPopup.horizontalCenter


            Text{
                id : dsNameLabel
                text: Messages.msc_sed_mainText
                // anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }

    // Row : Sesison ends

    // Row : Buttons starts

    Row{

        id: sessionErrorHandlingButtons
        anchors.top: datasourceErrorMsg.bottom
        anchors.topMargin: 30
        // anchors.left: parent.left
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.leftMargin: 30

        Button{
            id: confirm
            text: "OK"
            onClicked: closePopup()
        }

    }

    // Row :Buttons ends

    // Row 2: Error message starts
    Row{

        id: errorRow
        anchors.top: sessionErrorHandlingButtons.bottom
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
