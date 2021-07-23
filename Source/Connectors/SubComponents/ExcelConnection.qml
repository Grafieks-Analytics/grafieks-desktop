/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Excel Connection
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
    height: 500
    modal: true
    visible: false
    x: parent.width/2 - 300
    y: parent.height/2 - 300
    padding: 0
    property int label_col : 135

    property var selectedFile: ""
    property var startTime: 0

    onClosed: {
        mainTimer.stop()
        mainTimer.running = false
        busyindicator.running = false

        displayTime.text = ""
    }

    Connections{
        target: DuckCon

        function onExcelLoginStatus(status, directLogin){

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

        function onImportError(errorString, fileType){
            if(errorString.length > 0 && fileType === "excel"){
                // Show on import csv error
                error_dialog.open();
                error_dialog.text = errorString
            }
        }
    }

    Connections{
        target: ConnectorsLoginModel

        function onExcelLoginStatus(status, directLogin){

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

        function onLogout(){
            selectedFile = ""
            excelFileName.text = ""
        }
    }


    Component.onCompleted: {
        busyindicator.running = false
        mainTimer.running = false
        displayTime.text = ""
    }


    function handleExcel(excelFileName){

        if(excelFileName !== ""){
            startTime = new Date().getTime().toString()
            busyindicator.running = true
            mainTimer.running = true
            mainTimer.start()
            displayTime.text = ""

            ConnectorsLoginModel.excelLogin(excelFileName, true)
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
            text: "Choose an Excel file"
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




    // Row1: Select excel starts


    Column{

        id: row1
        anchors.top: header_popup.bottom
        anchors.topMargin: 55
        anchors.left: parent.left
        anchors.leftMargin: 100



        //        Rectangle{

        //            id: label2
        //            width:label_col
        //            height: 40

        //            Text{
        //                text: "Excel"
        //                anchors.left: parent.left
        //                anchors.leftMargin:  10
        //                font.pixelSize: Constants.fontCategoryHeader
        //                anchors.verticalCenter: parent.verticalCenter
        //            }
        //        }

        Rectangle{

            id: label3
            width:label_col
            height: 40
            y:40

            Button{
                id : file_btn

                anchors.left: parent.left
                anchors.leftMargin:  10
                text: "Select Excel file"
                onClicked: promptExcel.open();
            }
        }


        Rectangle{

            id: label4
            width:label_col
            height: 40
            Text{
                id: excelFileName
                anchors.left: parent.left
                anchors.leftMargin:  10
                anchors.verticalCenter: parent.verticalCenter
                text:""
            }
        }

    }


    // Row1: Select excel ends



    // Row 2: Action Button starts

    Row{

        id: row2
        //        anchors.top: row1.bottom
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
                onTriggered: displayTime.text = Math.ceil((new Date().getTime() - startTime) / 1000) + " s"
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
            onClicked: handleExcel(selectedFile)

        }
    }
    // Row 2: Action Button ends


    MessageDialog{
        id: msg_dialog
        title: "Excel Connection"
        text: ""
        icon: StandardIcon.Critical
    }

    MessageDialog{
        id: error_dialog
        title: "Excel Import Error"
        text: ""
        icon: StandardIcon.Critical
    }

    // Select Excel file
    FileDialog{
        id: promptExcel
        title: "Select a file"
        nameFilters: ["Excel files (*.xls *.xlsx)"];


        onAccepted: {
            console.log(fileUrl)
            selectedFile = ConnectorsLoginModel.urlToFilePath(fileUrl)
            excelFileName.text = selectedFile.replace(/^.*[\\\/]/, '')
        }
        onRejected: {
            console.log("file rejected")
        }

    }



}
