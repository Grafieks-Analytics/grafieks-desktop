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

import "../../MainSubComponents"

Popup {
    id: popup
    width: 600
    height: 520
    modal: true
    visible: false
    x: parent.width / 2 - 200
    y: 100
    padding: 0

    closePolicy: Popup.NoAutoClose

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
            text: "Publish Data Source"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left : parent.left
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

    // Row : Enter Data Source name

    Row{

        id: datasourceName
        anchors.top: header_popup.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label1
            width:label_col
            height: 40
            anchors.leftMargin: 30

            Text{
                id : dsNameLabel
                text: "Data Source Name"
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        CustomTextBox{
            id: datasource_name_field
            anchors.verticalCenter: parent.verticalCenter
            maxLength: 150
            boxWidth: 370
            boxHeight: 40
        }

    }


    // Row1: Enter Description starts

    Row{

        id: row1
        anchors.top: datasourceName.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label2
            width:label_col
            height: 40

            Text{
                text: "Description"
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        CustomTextArea{
            id: description_field
            boxWidth: 370
            boxHeight: 200

        }

    }

    // Row1: Enter Description ends

    // Row2: Enter FileDialog starts

    Row{

        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        Rectangle{

            id: label3
            width:label_col
            height: 40

            Text{
                text: "Upload Image"
                anchors.left: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        FileUploadBtn{
            id: file
            btnHeight: 40
            btnWidth: 370
            textValue: "Click to upload image (*.jpg *.jpeg *.png  only)"

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    fileDialog1.open();
                }
            }
        }

    }


    // Row2: Enter FileDialog ends

    // Row 3: Action Button starts

    Row{

        id: row3
        anchors.top: row2.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 50
        spacing: 10

        CustomButton{

            id: btn_signin
            textValue: "Publish"
            onClicked: {


                // Call Cpp function to process &
                // Upload data to API

                var dsName = datasource_name_field.text
                var description = description_field.text
                var uploadImage = fileDialog1.fileUrl
                var sourceType = DSParamsModel.dsType

                PublishDatasourceModel.publishDatasource(dsName, description, uploadImage, sourceType)

                popup.visible = false
                stacklayout_home.currentIndex = 6
            }
        }

        CustomButton{
            id: btn_cancel
            textValue: "Cancel"
            onClicked: {
                popup.visible = false
            }
        }
    }
    // Row 3: Action Button ends

    Row{
        id: note
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 30

        Text {
            text: qsTr("For Data Source access permission, contact Project Admin ")
        }

    }

    FileDialog{
        id: fileDialog1
        title: "Select a file (*.jpg *.jpeg *.png  only)"
        selectMultiple: false
        nameFilters: [ "Image files (*.jpg *.jpeg *.png )"]

        onAccepted: {
            console.log("You chose: " + fileDialog1.fileUrls)
        }
        onRejected: {
            console.log("file rejected")
        }
    }
}
