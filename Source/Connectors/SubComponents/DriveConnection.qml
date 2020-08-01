/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Sqlite Connection
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../SubComponents"
import "../../MainSubComponents"

Popup {
    id: drivePopup
    width: 800
    height: 500
    modal: true
    visible: false
    x: parent.width/2 - 300
    y: parent.height/2 - 300
    padding: 0
    property int label_col : 135


    Connections{
        target: ConnectorsLoginModel

        onSqliteLoginStatus:{

            if(status.status === true){

                popup.visible = false
                stacklayout_home.currentIndex = 5
            }
            else{
                popup.visible = true
                msg_dialog.open()
                msg_dialog.text = status.msg
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
            id : text1
            text: "Connect to drive"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: 15
            anchors.leftMargin: 10
        }
        Image {
            id: close_icn
            source: "../../../Images/icons/outline_close_black_18dp2x.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            height: 25
            width: 25
            anchors.rightMargin: 5
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    popup.visible = false
                }
            }
        }

    }

    // Popup Header ends

    // Row : To allow user to login to drive

    Row{
        id: driveConnectionModal
        anchors.top: header_popup.bottom
        anchors.topMargin: 70
        width: parent.width

        Rectangle{

            id:driveConnectionAllow
            width: parent.width

            Text {
                id: allowMsg
                anchors.top: parent.top
                anchors.rightMargin: 10

                text: qsTr("Allow Grafieks desktop to access to your drive account...")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: Constants.fontCategoryHeaderSmall
            }





            CustomButton{

                id: allowBtn
                textValue: "Allow"
                anchors.top: allowMsg.bottom
                anchors.topMargin: 60
                width: 100
                height:50
                fontPointSize: Constants.fontCategoryHeaderSmall

                anchors.horizontalCenter: parent.horizontalCenter


                onClicked: {
                    driveListPopup.visible = true;
                    drivePopup.visible = false;
                    DriveDS.fetchDatasources();
                    //driveds.cpp for more info
                }

            }


            Text {
                id: infoMsg
                anchors.top: allowBtn.bottom

                anchors.topMargin: 80

                text: qsTr("Click the allow button above to open the drive authorization page on a separate window.");
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

            Text {
                id: infoMsg2
                anchors.top: infoMsg.bottom

                text: qsTr("Once you authorize this connection you will be returned to this page.")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Constants.fontCategoryHeaderSmall
            }

        }

    }






}

