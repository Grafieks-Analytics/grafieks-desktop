/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** CSV Connection
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"


Popup {
    id: popup
    width: 600
    height: 300
    modal: true
    visible: false
    x: parent.width/2 - 300
    y: parent.height/2 - 150
    padding: 0
    property int label_col : 135

    property var selectedFile: ""
    property var startTime: 0
    property var separator: ","

    onClosed: {
        mainTimer.stop()
        mainTimer.running = false
        busyindicator.running = false

        displayTime.text = ""
    }

    Connections{
        target: ConnectorsLoginModel

        function onLogout(){
            selectedFile = ""
            separator.text = ","
            csvFileName.text = ""
            idSeparatorText.text = ""
        }

        function onCsvLoginStatus(status, directLogin){
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

    function handleCsv(csvFileName, separatorText){

        if(csvFileName !== ""){
            startTime = new Date().getTime().toString()
            busyindicator.running = true
            mainTimer.running = true
            mainTimer.start()
            displayTime.text = ""

            ConnectorsLoginModel.csvLogin(csvFileName, true, separatorText)
        } else {
            msg_dialog.text = "No file selected"
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
            text: "Signin to CSV"
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



    Row{

        id: row3
        anchors.top: header_popup.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1



        Rectangle{

            id: label2
            width:label_col
            height: 40

            Text{
                text: "Database"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Button{
            id : file_btn
            text: "Select CSV file"
            onClicked: promptCSV.open();
        }

        Text{
            id: csvFileName
            text:""
        }

    }

    Row{

        id: row4
        anchors.top: row3.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label4
            width:label_col
            height: 40

            Text{
                text: "Separator"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter

            }
        }

        TextField{
            id: idSeparatorText
            maximumLength: 250
            selectByMouse: true
            anchors.verticalCenter: parent.verticalCenter
            width: 200
            height: 40

            onTextChanged: separator = idSeparatorText.text

            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 400

            }
        }

    }

    // Row 6: Action Button starts

    Row{

        id: row6
        // anchors.top: row4.bottom
        // anchors.topMargin: 15
        anchors.bottom:parent.bottom
        anchors.bottomMargin: 65

        anchors.right: parent.right
        anchors.rightMargin: label_col+30
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
                    text: Constants.openFileText
                    anchors.centerIn: parent
                    font.pixelSize: Constants.fontCategoryHeader
                    color: btn_cancel.hovered ? "white" : "black"
                }
            }
            onClicked: handleCsv(selectedFile, separator)

        }
    }
    // Row 6: Action Button ends


    MessageDialog{
        id: msg_dialog
        title: "CSV Connection"
        text: ""
        icon: StandardIcon.Critical
    }

    MessageDialog{
        id: error_dialog
        title: "CSV Import Error"
        text: ""
        icon: StandardIcon.Critical
    }

    // Select SQLITE file
    FileDialog{
        id: promptCSV
        title: "Select a CSV file"
        nameFilters: ["CSV files (*.csv)"];

        onAccepted: {

            selectedFile = GeneralParamsModel.urlToFilePath(promptCSV.fileUrl)
            csvFileName.text = selectedFile.replace(/^.*[\\\/]/, '')
        }
        onRejected: {
            console.log("file rejected")
        }
    }


}
