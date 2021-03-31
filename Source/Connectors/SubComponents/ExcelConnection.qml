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


    Connections{
        target: ConnectorsLoginModel

        function onExcelLoginStatus(status, directLogin){

            if(directLogin === true){
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
            text: "Choose a Excel file"
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
                text: "Excel"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Button{
            id : file_btn
            text: "Select Excel file"
            onClicked: promptExcel.open();
        }

        Text{
            id: excelFileName
            text:""
        }

    }


    // Row3: Enter port number ends



    // Row 6: Action Button starts

    Row{

        id: row6
        anchors.top: row3.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        spacing: 10

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
            onClicked: {ConnectorsLoginModel.excelLogin(excelFileName.text, true)}

        }
    }
    // Row 6: Action Button ends


    MessageDialog{
        id: msg_dialog
        title: "Excel Connection"
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
            excelFileName.text = ConnectorsLoginModel.urlToFilePath(promptExcel.fileUrl)
        }
        onRejected: {
            console.log("file rejected")
        }
    }


}
