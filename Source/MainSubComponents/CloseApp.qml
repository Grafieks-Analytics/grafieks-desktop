import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

Popup {
    id: closePopupId
    x: parent.width/2 - 300
    y: parent.height/2 - 200
    width: 600
    height: 300
    modal: true
    visible: false
    padding: 0

    closePolicy: Popup.NoAutoClose

    signal closeSignal()

    Component.onCompleted: {
        closePopupId.closeSignal.connect(mainwindow.closeApp)
    }

    function closePopup(){
        closePopupId.visible = false
    }

    function closeApp(){
        closeSignal()
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
            text: Messages.msc_cap_header
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

    // Row : Close Header starts

    Row{

        id: datasourceCloseMsg
        anchors.top: header_popup.bottom
        anchors.topMargin: 50
         anchors.right: parent.right
        // anchors.left: parent.left
        // anchors.leftMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{

            id: label1
            width:parent.width
            height: 40
            // anchors.leftMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter


            Text{
                id : dsNameLabel
                text: Messages.msc_cap_mainText
                // anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }

    // Row : Close header ends

    // Row : Buttons starts

    Row{

        id: closePopupHandlingButtons
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.rightMargin: 10
        spacing:10

        Button{
            id: confirm
            text: Messages.closeBtnTxt
            onClicked: closeApp()
            anchors.rightMargin:20
        }

        Button{
            id: cancel
            text: Messages.cancelBtnTxt
            onClicked: closePopup()
        }

    }

    // Row :Buttons ends


}
