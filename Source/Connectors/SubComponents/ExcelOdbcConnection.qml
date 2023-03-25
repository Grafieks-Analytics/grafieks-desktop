/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Mysql Connection
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
    height: 300
    modal: true
    visible: false
    x: parent.width/2 - 300
    y: parent.height/2 - 150
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


    /***********************************************************************************************************************/
    // Connection  Starts

    // LIVE CONNECTION not possible

    Connections{
        target: ConnectorsLoginModel

        function onExcelLoginOdbcStatus(status, directLogin){

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
        }

        function onLogout(){
            excelFileName.text = ""
            selectedFile = ""
        }
    }

    Connections{
        target: ODBCDriversModel

        function onAvailableDrivers(driversList, database){
            if(database === Constants.excelOdbc){
                if(driversList.length > 0 && typeof driversList !== "undefined"){
                    excelOdbcModalError.visible = false

                    control.model = driversList
                } else{
                    popup.visible = false
                    excelOdbcModalError.visible = true

                    control.model = ["No Drivers"]
                }
            }
        }
    }

    // Connection  Ends
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        promptExcel.nameFilters = Messages.cn_sub_excodbc_namedFilter
        file_btn.text = Messages.cn_sub_excodbc_header
    }

    function hidePopup(){
        popup.visible = false
    }


    function handleExcel(excelFileName){

        if(true){
            startTime = new Date().getTime().toString()
//            busyindicator.running = true
            mainTimer.running = true
            mainTimer.start()
            displayTime.text = ""

            ConnectorsLoginModel.excelOdbcLogin(control.currentText, excelFileName)
        } else {
            msg_dialog.text = Messages.noSelectedFile
            msg_dialog.visible = true
        }
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // SubComponents Starts


    MessageDialog{
        id: msg_dialog
        title: Messages.cn_sub_excodbc_subHeader
        text: ""
//        icon: StandardIcon.Critical
    }


    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


    // Popup Header starts

    Rectangle{
        id: headerPopup
        color: Constants.themeColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        // anchors.topMargin: 10
        anchors.leftMargin: 1

        Text{
            id : text1
            text: Messages.cn_sub_excodbc_header
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
                onClicked: hidePopup()
            }
        }

    }

    // Popup Header ends

    // Row1: Enter Server address starts

    Row{

        id: row1
        anchors.top: headerPopup.bottom
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.rightMargin: 40

        Rectangle{

            id: label1
            width:label_col
            height: 40

            Text{
                text: Messages.cn_sub_common_driver
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader

                anchors.verticalCenter: parent.verticalCenter
            }
        }


        ComboBox {
            id: control
            model: ["First", "Second", "Third","fourth"]

            delegate: ItemDelegate {
                width: control.width
                contentItem: Text {
                    text: modelData
                    color: "black"
                    font: control.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: control.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control
                    onPressedChanged: canvas.requestPaint()
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control.pressed ? "#black" : "#gray";
                    context.fill();
                }
            }

            contentItem: Text {
                leftPadding: 10
                rightPadding: control.indicator.width + control.spacing

                text: control.displayText
                font: control.font
                color: control.pressed ? "black" : "black"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 400
                implicitHeight: 40
                border.color: Constants.borderBlueColor
                border.width: control.visualFocus ? 2 : 1
                radius: 5
            }

            popup: Popup {
                y: control.height - 1
                width: control.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: control.popup.visible ? control.delegateModel : null
                    currentIndex: control.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    border.color: Constants.borderBlueColor
                    radius: 10
                }
            }
        }

    }

    // Row1: Enter server address ends

    // Row2: Select excel starts


    Column{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 55
        anchors.left: parent.left
        anchors.leftMargin: 130

        Rectangle{

            id: label3
            width:label_col
            height: 40
            y:40

            Button{
                id : file_btn

                anchors.left: parent.left
                anchors.leftMargin:  10
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


    // Row2: Select excel ends

    // Row 3: Action Button starts

    Row{

        id: row3
        // anchors.top: row2.bottom
        // anchors.topMargin: 15
        anchors.bottom:parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 65
        //        anchors.rightMargin: label_col*2 + 47
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

        CustomButton{

            id: btn_signin
            textValue: Messages.openFileText
            fontPixelSize: Constants.fontCategoryHeader
            onClicked: handleExcel(selectedFile)
        }

    }
    // Row 3: Action Button ends


    // Page Design Ends
    /***********************************************************************************************************************/

    MessageDialog {
        id: excelOdbcModalError
        visible: false
        title: Messages.cn_sub_excodbc_missingDriver
        text: Messages.cn_sub_excodbc_driverDownload

    }

    // Select Excel file
    FileDialog{
        id: promptExcel
        title: Messages.selectFile


        onAccepted: {
//            selectedFile = GeneralParamsModel.urlToFilePath(selectedFile)
            console.log("selectedFile",selectedFile)
            excelFileName.text = "file:///C:/Users/Ravi Prakash/Desktop/SampleSuperstore.xlsx".replace(/^.*[\\\/]/, '')
        }
        onRejected: {
            console.log("file rejected")
        }

    }

}
