/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Mysql Connection
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
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

        onMysqlLoginStatus:{

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
            text: "Signin to Mysql"
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

    // Row1: Enter Server address starts

    Row{

        id: row1
        anchors.top: header_popup.bottom
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 45
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.rightMargin: 40

        Rectangle{

            id: label1
            width:label_col
            height: 40

            Text{
                text: "Driver"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: 15

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


    // Action button starts

    Row{

        id: row_btn
        anchors.top: row1.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        //        anchors.rightMargin: label_col + 55
        spacing: 10

        Button{
            id: btn_test_con
            height: back_rec_1.height
            width: back_rec_1.width

            background: Rectangle{
                id: back_rec_1
                //radius: 10
                color: btn_test_con.hovered? Constants.buttonBorderColor : "#E6E7EA"
                width: 130
                height: 40

                Text{
                    text: "Test Connection"
                    anchors.centerIn: parent
                    font.pixelSize: 15
                    color: btn_test_con.hovered ? "white" : "black"
                }
            }
        }

        Button{
            id: btn_connect
            height: back_rec_2.height
            width: back_rec_2.width

            background: Rectangle{
                id: back_rec_2
                //radius: 10
                color: btn_connect.hovered ? Constants.buttonBorderColor : "#E6E7EA"
                width: 100
                height: 40

                Text{
                    text: "Connect"
                    anchors.centerIn: parent
                    font.pixelSize: 15
                    color: btn_connect.hovered ? "white" : "black"
                }
            }

            onClicked: {

                // Move forward without any checks
                // Only for UI checks
                popup.visible = false
                stacklayout_home.currentIndex = 5
            }
        }


    }

    // Action button ends

    // Row2: Enter database name starts

    Row{

        id: row2
        anchors.top: row_btn.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label3
            width:label_col
            height: 40
            Text{
                text: "Server"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: server
            maximumLength: 45
            anchors.verticalCenter: parent.verticalCenter
            height: 40
            width: 200

            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 200
            }
        }
        Rectangle{

            id: label_port
            width: 40
            height: 40


            Text{
                text: "Port"
                leftPadding: 10
                anchors.left: server.right
                //anchors.leftMargin: 20
                anchors.rightMargin: 20
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        TextField{
            id: port
            maximumLength: 45
            anchors.verticalCenter: parent.verticalCenter
            //width: 130
            height: 40
            background: Rectangle {
                border.color: Constants.borderBlueColor
                radius: 5
                width: 160

            }
        }

    }

    // Row2: Enter database name ends

    // Row3: Enter port number starts


    Row{

        id: row3
        anchors.top: row2.bottom
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
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: database
            maximumLength: 45
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


    // Row3: Enter port number ends

    // Row 4: Enter user name starts

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
                text: "Username"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: username
            maximumLength: 45
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

    // Row 4: Enter user name ends

    // Row 5: Enter password starts

    Row{

        id: row5
        anchors.top: row4.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label5
            width:label_col
            height: 40

            Text{
                text: "Password"
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pixelSize: 15
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: password
            maximumLength: 45
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

    // Row 5: Enter password ends

    // Row 6: Action Button starts

    Row{

        id: row6
        anchors.top: row5.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: label_col - 70
        //        anchors.rightMargin: label_col*2 + 47
        spacing: 10

        Button{
            id: btn_cancel
            height: back_rec_3.height
            width: back_rec_3.width

            background: Rectangle{
                id: back_rec_3
                //radius: 10
                color: btn_cancel.hovered ? Constants.buttonBorderColor : "#E6E7EA"
                width: 100
                height: 40

                Text{
                    text: Constants.signInText
                    anchors.centerIn: parent
                    font.pixelSize: 15
                    color: btn_cancel.hovered ? "white" : "black"
                }
            }
            onClicked: {

                // Call mysql connector model
//                ConnectorsLoginModel.mysqlLogin(server.text, database.text, port.text, username.text, password.text)
//                ConnectorsLoginModel.mysqlLogin("localhost", "grafieks_my", 3306, "root", "123@312QQl")
                ConnectorsLoginModel.mysqlLogin("localhost", "information_schema", 3306, "root", "")

            }
        }
    }
    // Row 6: Action Button ends


    MessageDialog{
        id: msg_dialog
        title: "Mysql Connection"
        text: ""
        icon: StandardIcon.Critical
    }

}
