import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

Popup {
    id: updateApplication
    width: parent.width-1
    height: 41
    // modal: true
    visible: false
    x: 0
    y: 0
    padding: 0


    Connections{
        target: UpdateApplicationModel

        function onUpdateAppVersion(currentAppVersion, latestAppVersion){
            updateApplication.visible = true
        }
    }


    function confirmUpdate(){
        error_connection_text.text = Messages.msc_uan_pleaseWait
        UpdateApplicationModel.promptUpdater()
        GeneralParamsModel.quitApplication()
        closePrompt()
    }

    function closePrompt(){
        updateApplication.visible = false
    }

    // Popup Header starts

    Rectangle{
        id: headerPopup
        color: "#F4CE6A"
        border.color: "#F4CE6A"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        // Text{
        //     id:textUpdate
        //     text: Messages.msc_uan_header
        //     anchors.verticalCenter: parent.verticalCenter
        //     anchors.left : parent.left
        //     font.pixelSize: Constants.fontCategoryHeader
        //     anchors.leftMargin: 10
        // }
         Text{
            id:textUpdate2
            anchors.left : parent.left
            anchors.leftMargin:20
            text: Messages.msc_uan_appUpdateMsg
            anchors.verticalCenter: parent.verticalCenter
            // wrapMode: Text.WordWrap
        }
         Button{

            id: btn_download
            height: back_rec_1.height
            width: back_rec_1.width
             anchors.right : btn_cancel.left
             anchors.rightMargin:20

            background: Rectangle{
                id: back_rec_1
                color: btn_download.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
                width: 100
                height: 40
                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 1
                    color: btn_signin.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

                }


                Text{
                    text: Messages.updateBtnTxt
                    font.pixelSize: Constants.fontCategoryHeader
                    color: btn_download.hovered ? "white" : "black"
                    anchors.centerIn: parent
                }
            }
            onClicked: confirmUpdate()
        }

        Button{
            id: btn_cancel
            height: back_rec_2.height
            width: back_rec_2.width
            anchors.right : close_icn.left
            anchors.rightMargin:20

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

            onClicked: closePrompt()
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
                onClicked: closePrompt()
            }
        }
    }

    // Popup Header ends


    // Row{
    //     id: row1
    //     anchors.right: parent.right
    //     spacing: 10

    //     Text{
    //         text: Messages.msc_uan_appUpdateMsg
    //         wrapMode: Text.WordWrap
    //     }
    // }


    // Row 1: Action Button starts

    // Row{

    //     id: row2
    //     anchors.bottom: parent.bottom
    //     anchors.bottomMargin:  30
    //     anchors.right: parent.right
    //     anchors.rightMargin: label_col - 70
    //     spacing: 10

    //     Button{

    //         id: btn_download
    //         height: back_rec_1.height
    //         width: back_rec_1.width

    //         background: Rectangle{
    //             id: back_rec_1
    //             color: btn_download.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
    //             width: 100
    //             height: 40
    //             Rectangle{
    //                 anchors.fill: parent
    //                 anchors.margins: 1
    //                 color: btn_signin.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

    //             }


    //             Text{
    //                 text: Messages.updateBtnTxt
    //                 font.pixelSize: Constants.fontCategoryHeader
    //                 color: btn_download.hovered ? "white" : "black"
    //                 anchors.centerIn: parent
    //             }
    //         }
    //         onClicked: confirmUpdate()
    //     }

    //     Button{
    //         id: btn_cancel
    //         height: back_rec_2.height
    //         width: back_rec_2.width

    //         background: Rectangle{
    //             id: back_rec_2
    //             color: btn_cancel.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor
    //             width: 100
    //             height: 40
    //             Rectangle{
    //                 anchors.fill: parent
    //                 anchors.margins: 1
    //                 color: btn_cancel.hovered ? Constants.buttonBorderColor : Constants.lightThemeColor

    //             }

    //             Text{
    //                 text: Messages.cancelBtnTxt
    //                 font.pixelSize: Constants.fontCategoryHeader
    //                 color: btn_cancel.hovered ? "white" : "black"
    //                 anchors.centerIn: parent
    //             }
    //         }

    //         onClicked: closePrompt()
    //     }


    // }
    // Row 1: Action Button ends


    // Row 2: Error message starts
    Row{

        id: row3
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

    // Row 2: Error message ends
}
