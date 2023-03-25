/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Json Connection
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

import com.grafieks.singleton.constants 1.0
import com.grafieks.singleton.messages 1.0

import "../../MainSubComponents"

Popup {
    id: popup
    width: 600
    height: 500
    modal: true
    visible: false
    x: parent.width/2 - 300
    y: parent.height/2 - 300
    padding: 0
    background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }
    property int label_col : 135

    property var selectedFile: ""
    property var startTime: 0

    onClosed: {
        mainTimer.stop()
        mainTimer.running = false
        busyindicator.running = false

        displayTime.text = ""
    }

    // LIVE CONNECTION not possible

    Connections{
        target: ConnectorsLoginModel

        function onLogout(){
            selectedFile = ""
            jsonFileName.text = ""
        }

        function onJsonLoginStatus(status, directLogin){

            if(directLogin === true){
                if(status.status === true){

                    popup.visible = false
                    GeneralParamsModel.setCurrentScreen(Constants.modelerScreen)
                    stacklayout_home.currentIndex = 5
                }
                else{
                    popup.visible = true
                    msg_dialog.open()
                    msg_dialog.text = status.msg
                }
            }

            mainTimer.stop()
            mainTimer.running = false
            busyindicator.running = false
            displayTime.text = ""
        }
    }


    Component.onCompleted: {
        promptJson.nameFilters = Messages.cn_sub_json_namedFilter
        file_btn.text = Messages.selectFile
    }

    function handleJson(jsonFileName){

        if(jsonFileName !== ""){
            startTime = new Date().getTime().toString()
            busyindicator.running = true
            mainTimer.running = true
            mainTimer.start()
            displayTime.text = ""

            ConnectorsLoginModel.jsonLogin(selectedFile, true)
        } else {
            msg_dialog.text = Messages.noSelectedFile
            msg_dialog.visible = true
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
            text: Messages.cn_sub_json_header
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            font.pixelSize: Constants.fontCategoryHeader
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
                onClicked: {
                    popup.visible = false
                }
            }
        }

    }

    // Popup Header ends




    // Row3: Enter port number starts


    Column{

        id: row3
        anchors.top: header_popup.bottom
        anchors.topMargin: 55
        anchors.left: parent.left
        anchors.leftMargin: 100



        //        Rectangle{

        //            id: name1
        //            width:label_col
        //            height: 40

        //            Text{
        //                text: "Json"
        //                anchors.left: parent.left
        //                anchors.leftMargin: 10
        //                font.pixelSize: Constants.fontCategoryHeader
        //                anchors.verticalCenter: parent.verticalCenter
        //            }
        //        }
        Rectangle{

            id: name2
            width:label_col
            height: 40

            Button{
                id : file_btn
                anchors.left: parent.left
                anchors.leftMargin:  10
                onClicked: promptJson.open();
            }
        }

        Rectangle{

            id: name3
            width:label_col
            height: 40
            Text{
                id: jsonFileName
                anchors.left: parent.left
                anchors.leftMargin:  10
                anchors.verticalCenter: parent.verticalCenter
                text:""
            }
        }

    }


    // Row3: Enter port number ends



    // Row 6: Action Button starts

    Row{

        id: row6
        //        anchors.top: row3.bottom
        //        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: label_col
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
        spacing: 10

        Text{
            id: displayTime
            anchors.right: busyindicator.left
            anchors.rightMargin: 10

            Timer {
                id: mainTimer
                interval: 1000;
                running: false;
                repeat: true
                onTriggered: displayTime.text = Math.round((new Date().getTime() - startTime) / 1000) + " s"
            }
        }

        BusyIndicatorTpl {
            id: busyindicator
            running: false
            anchors.right: btn_cancel.left
            anchors.rightMargin: 10
        }

        Button{
            id: btn_cancel
            height: back_rec_3.height
            width: back_rec_3.width

            background: Rectangle{
                id: back_rec_3
                color: btn_cancel.hovered ? Constants.buttonBorderColor : "#E6E7EA"
                width: 100
                height: 40

                Text{
                    text: Messages.openFileText
                    anchors.centerIn: parent
                    font.pixelSize: Constants.fontCategoryHeader
                    color: btn_cancel.hovered ? "white" : "black"
                }
            }
            onClicked: handleJson(selectedFile)

        }
    }
    // Row 6: Action Button ends


    MessageDialog{
        id: msg_dialog
        title: Messages.cn_sub_json_subHeader
        text: ""
//        icon: StandardIcon.Critical
    }

    MessageDialog{
        id: error_dialog
        title: Messages.cn_sub_json_importErr
        text: ""
//        icon: StandardIcon.Critical
    }

    // Select JSON file
    FileDialog{
        id: promptJson
        title: Messages.selectFile


        onAccepted: {
            console.log(fileUrl)
            selectedFile = GeneralParamsModel.urlToFilePath(fileUrl)
            jsonFileName.text = selectedFile.replace(/^.*[\\\/]/, '')
        }
        onRejected: {
            console.log("file rejected")
        }
    }


}
