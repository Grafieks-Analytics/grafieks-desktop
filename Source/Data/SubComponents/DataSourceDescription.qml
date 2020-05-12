/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Data Sources Description
** Popup code to publish datasource to Grafieks server
** Prompts Description and Image upload for Datasource
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0



Popup {
    id: popup
    width: 600
    height: 230
    modal: true
    visible: false
    x: parent.width / 2 - 200
    y: 100
    padding: 0

    property int label_col : 150
    property string host_final : ""
    property string database_final : ""
    property string port_final : ""
    property string username_final : ""
    property string password_final : ""
    property string mode_final : ""
    property string datasource_name_final : ""


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
            text: "Signin to Grafieks server"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
            anchors.leftMargin: 10
        }
    }

    // Popup Header ends

    // Row1: Enter Description starts

    Row{

        id: row1
        anchors.top: header_popup.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 1

        Rectangle{

            id: label1
            width:label_col
            height: 40

            Text{
                text: "Description"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TextField{
            id: description_field
            anchors.verticalCenter: parent.verticalCenter
            maximumLength: 45
            width: 370
            background: Rectangle {
                border.color: Constants.darkThemeColor
                radius: 10
                width: 370
            }
        }

    }

    // Row1: Enter Description ends

    // Row2: Enter FileDialog starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 1

        Button{
            text: "Choose a file"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                fileDialog1.open();
            }
        }

    }

    // Row2: Enter FileDialog ends

    // Row 3: Action Button starts

    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: label_col
        spacing: 10

        Button{

            id: btn_signin
            height: back_rec_1.height
            width: back_rec_1.width

            background: Rectangle{
                id: back_rec_1
                radius: 10
                color: Constants.greenThemeColor
                width: 100
                height: 30

                Text{
                    text:"Publish"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                Datasources.setDsDescription(description_field.text);
                Datasources.setDsImage("");
                Datasources.setDsOwner(User.firstName + " "+ User.lastName);

                Datasources.saveDataSources(1, Datasources.sourceType, Datasources.dsName, Datasources.dsDescription, Datasources.dsImage, Datasources.dsOwner)

                popup.visible = false
                stacklayout_home.currentIndex = 6
            }
        }

        Button{
            id: btn_cancel
            height: back_rec_2.height
            width: back_rec_2.width

            background: Rectangle{
                id: back_rec_2
                radius: 10
                color: Constants.redThemeColor
                width: 100
                height: 30

                Text{
                    text:"Cancel"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                popup.visible = false
            }
        }
    }
    // Row 3: Action Button ends


    FileDialog{
        id: fileDialog1
        title: "Select a file"

        onAccepted: {
            messageDialog1.open()
        }
        onRejected: {
            console.log("file rejected")
        }
    }
}
