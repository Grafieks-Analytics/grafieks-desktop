/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Data Filters screen
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "../../MainSubComponents"
import "../../../Constants.js" as Constants


Popup {
    id: popup_main
    width: 600
    height: 390
    x: parent.width / 2 - 200
    y: 100
    modal: true
    visible: false
    padding: 0



    // Header starts

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
            text: "Add Data Filter"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Header ends

    // Top header buttons starts

    TabBar{
        id: tabbar1
        anchors.top: header_popup.bottom
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1

        Component.onCompleted: {
            character_btn_background.color =  Constants.darkThemeColor
        }


        // Characters Tab button starts

        TabButton{
            id: character_btn
            text: "Character"
            width:popup_main.width/4 - 1

            background: Rectangle {
                id: character_btn_background
                border.color: Constants.darkThemeColor
                color: character_btn.pressed? Constants.darkThemeColor: Constants.themeColor
            }

            contentItem: Text{
                id:character_btn_text
                text: character_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                character_btn_background.color =  Constants.darkThemeColor
                date_btn_background.color =  Constants.themeColor
                numbers_btn_background.color = Constants.themeColor
                users_btn_background.color = Constants.themeColor
            }
        }

        // Characters Tab button ends

        // Date Tab button starts

        TabButton{
            id: date_btn
            text: "Date"
            width:popup_main.width/4 - 1

            background: Rectangle {
                id: date_btn_background
                border.color: Constants.darkThemeColor
                color: date_btn.pressed? Constants.darkThemeColor: Constants.themeColor
            }

            contentItem: Text{
                id:date_btn_text
                text: date_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                character_btn_background.color =  Constants.themeColor
                date_btn_background.color =  Constants.darkThemeColor
                numbers_btn_background.color = Constants.themeColor
                users_btn_background.color = Constants.themeColor
            }
        }

        // Date Tab button ends

        // Numbers Tab button starts

        TabButton{
            id: numbers_btn
            text: "Numbers"
            width:popup_main.width/4 - 1

            background: Rectangle {
                id: numbers_btn_background
                border.color: Constants.darkThemeColor
                color: character_btn.pressed? Constants.darkThemeColor: Constants.themeColor
            }

            contentItem: Text{
                id:numbers_btn_text
                text: numbers_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                character_btn_background.color =  Constants.themeColor
                date_btn_background.color =  Constants.themeColor
                numbers_btn_background.color = Constants.darkThemeColor
                users_btn_background.color = Constants.themeColor
            }
        }

        // Numbers Tab button ends

        // Users Tab button starts

        TabButton{
            id: users_btn
            text: "User"
            width:popup_main.width/4 - 2


            background: Rectangle {
                id: users_btn_background
                border.color: Constants.darkThemeColor
                color: users_btn.pressed? Constants.darkThemeColor: Constants.themeColor

            }

            contentItem: Text{
                id:users_btn_text
                text: users_btn.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                character_btn_background.color =  Constants.themeColor
                date_btn_background.color =  Constants.themeColor
                numbers_btn_background.color = Constants.themeColor
                users_btn_background.color = Constants.darkThemeColor
            }
        }

        // Users Tab button ends
    }

    // Top header buttons ends

    // Add button starts

    Button{
        id: add_btn_1
        anchors.top: tabbar1.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 20

        text:"Add"
        onClicked: {
            optionsMenu1.open()
        }

        background: Rectangle {
            id: add_btn_1_background
            color: users_btn.pressed? Constants.darkThemeColor: Constants.themeColor

        }

        contentItem: Text{
            id:add_btn_1_text
            text: add_btn_1.text
            color:"black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // Add button ends

    // Menu options on clicking 'Add button' starts

    Menu {
        id: optionsMenu1
        x: 50
        y: 10


        MenuItem {
            text: "Customer ID"
            onTriggered: {}
        }
        MenuItem {
            text: "Customer Name"
            onTriggered: {
            }
        }
        MenuItem {
            text: "Sales Order No"
            onTriggered: {}
        }
        MenuItem {
            text: "Sales Order Line No"
            onTriggered: {}
        }
        MenuItem {
            text: "PO Number"
            onTriggered: {}
        }
        MenuItem {
            text: "PO Line Number"
            onTriggered: {}
        }
    }

    // Menu options on clicking 'Add button' ends

    // Center Panel Starts

    Rectangle{
        id: rect1
        width: popup_main.width - 40
        height:230
        border.color: "black"
        anchors.top:add_btn_1.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 20
    }

    // Center Panel Ends

    // Action button starts

    Row{
        anchors.top:rect1.bottom
        anchors.right: parent.right
        anchors.topMargin: 5
        anchors.rightMargin: 20
        spacing: 5


        Button{
            id: cancel_btn1
            text: "Cancel"
            onClicked: {
                popup_main.visible = false
            }

            background: Rectangle {
                id: cancel_btn1_background
                color: cancel_btn1.pressed? Constants.darkThemeColor: Constants.themeColor

            }

            contentItem: Text{
                id:cancel_btn1_text
                text: cancel_btn1.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }


        }


        Button{
            id: apply_btn1
            text: "Apply"

            background: Rectangle {
                id: apply_btn1_background
                color: apply_btn1.pressed? Constants.darkThemeColor: Constants.themeColor

            }

            contentItem: Text{
                id:apply_btn1_text
                text: apply_btn1.text
                color:"black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                popup_main.visible = false
            }
        }
    }

    // Action button ends
}

