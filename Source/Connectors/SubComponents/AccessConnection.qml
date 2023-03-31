/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Microsoft Access Connection
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
    height: 360
    modal: true
    visible: false
    x: parent.width/2 - 300
    y: parent.height/2 - 180
    padding: 0
     background:Rectangle{
        height:parent.height
        width:parent.width
        color:"white"
    }
    property int label_col : 135
    property var fileName: ""


    /***********************************************************************************************************************/
    // Connection  Starts

    // LIVE CONNECTION not possible

    Connections{
        target: ConnectorsLoginModel

        function onAccessLoginStatus(status){

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

        function onLogout(){
            fileName = ""
            username.text = ""
            password.text = ""
        }
    }

    Connections{
        target: ODBCDriversModel

        function onAvailableDrivers(driversList, database){
            if(database === Constants.accessOdbc){
                if(driversList.length > 0 && typeof driversList !== "undefined"){
                    accessOdbcModalError.visible = false

                    control.model = driversList
                    database.readOnly = false
                    username.readOnly = false
                    password.readOnly = false
                } else{
                    popup.visible = false
                    accessOdbcModalError.visible = true

                    control.model = ["No Drivers"]
                    database.readOnly = true
                    username.readOnly = true
                    password.readOnly = true
                }
            }
        }
    }

    // Connection  Ends
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    Component.onCompleted: {
        promptAccess.nameFilters = Messages.cn_sub_access_namedFilter
    }

    function hidePopup(){
        popup.visible = false
    }

    function connectToAccess(){
        ConnectorsLoginModel.accessOdbcLogin(control.currentText, fileName, username.text, password.text)
    }

    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // SubComponents Starts


    MessageDialog{
        id: msg_dialog
        title: Messages.cn_sub_access_subHeader
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
        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left
        Text{
            id : text1
            text: Messages.cn_sub_access_header
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


    // Row3: Enter port number starts


    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label2
            width:label_col
            height: 40

            Text{
                text: Messages.cn_sub_common_db
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Button{
            text: Messages.selectFile
            onClicked: promptAccess.open();
        }

        Text{
            id: accessFileName
        }


    }


    // Row2: Enter port number ends

    // Row 3: Enter user name starts

    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label4
            width:label_col
            height: 40

            Text{
                text: Messages.cn_sub_common_username
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: username
            maximumLength: 250
            selectByMouse: true
            anchors.verticalCenter: parent.verticalCenter
            width: 370
            height: 40

            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 400

            }
        }

    }

    // Row 3: Enter user name ends

    // Row 4: Enter password starts

    Row{

        id: row4
        anchors.top: row3.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label5
            width:label_col
            height: 40

            Text{
                text: Messages.cn_sub_common_password
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: Constants.fontCategoryHeader
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: password
            maximumLength: 45
            selectByMouse: true
            echoMode: "Password"
            anchors.verticalCenter: parent.verticalCenter
            width: 370
            height: 40

            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 400

            }
        }

    }

    // Row 4: Enter password ends

    // Row 5: Action Button starts

    Row{

        id: row5
        // anchors.top: row4.bottom
        // anchors.topMargin: 15
        anchors.bottom:parent.bottom
        anchors.bottomMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        //        anchors.rightMargin: label_col*2 + 47
        spacing: 10

        CustomButton{

            id: btn_signin
            textValue: Messages.signInText
            fontPixelSize: Constants.fontCategoryHeader
            onClicked: connectToAccess()
        }

    }
    // Row 5: Action Button ends



    // Page Design Ends
    /***********************************************************************************************************************/

    MessageDialog {
        id: accessOdbcModalError
        visible: false
        title: Messages.cn_sub_access_missingDriver
        text: Messages.cn_sub_access_driverDownload

    }

    // Select Access file
    FileDialog{
        id: promptAccess
        title: Messages.cn_sub_access_selFile

        onAccepted: {

            popup.fileName = GeneralParamsModel.urlToFilePath(promptAccess.selectedFile)
            accessFileName.text = popup.fileName.replace(/^.*[\\\/]/, '')
        }
        onRejected: {
            console.log("file rejected")
        }
    }

}
