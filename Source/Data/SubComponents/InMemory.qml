/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** InMemory
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Popup {
    id: popupMain
    width: 600
    height: 400
    x: parent.width / 2 - 380
    y: 100
    modal: true
    visible: false
    padding: 0

    background: Rectangle{
        color: Constants.whiteColor
    }

    // Popup Header starts

    Rectangle{
        id: headerPopup
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
            text: "Data Extract"
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
                    popupMain.visible = false
                }
            }
        }

    }
    // Popup Header ends

    Rectangle{
        id: content
        anchors.top: headerPopup.bottom
        height: 100
        width: parent.width
        color: Constants.whiteColor


        Row{
            id: fullExtactRadioBtn
            height: 40
            padding: 30
            RadioButtonTpl{
                id: radio_memory
                radio_text: qsTr("Full Extract")
                radio_checked: false
                parent_dimension: 16
            }
        }
        Row{
            id: incrementatlExtactRadioBtn
            anchors.top: fullExtactRadioBtn.bottom
            height:40
            padding: 30
            RadioButtonTpl{
                id: radio_memory2
                radio_text: qsTr("Incremental Extract")
                radio_checked: false
                parent_dimension: 16
            }
        }


        Column{
            id: selectColumn
            anchors.top: incrementatlExtactRadioBtn.bottom
            anchors.topMargin: 30
            height: 40
            padding: 30

            Text {
                id: incrementatlExtactSelectbtnText
                anchors.top: selectColumn.top
                text: qsTr("Select the column for incremental extract")
                anchors.margins: 10
                leftPadding: 30
            }

            Row{
                id: incrementatlExtactSelectbtn
                anchors.top: incrementatlExtactSelectbtnText.bottom
                height: 40
                leftPadding: 30
                anchors.margins: 10
                Rectangle{
                    height: 40
                    width: 520
                    border.color: Constants.borderBlueColor
                    radius: 4
                }
            }

            Text {
                id: dataExtractSelectBtnText
                text: qsTr("Select Schedule for data extract")
                anchors.top: incrementatlExtactSelectbtn.bottom
                anchors.margins: 6
                leftPadding: 30
            }

            Row{
                id:dataExtractSelectBtn
                anchors.top: dataExtractSelectBtnText.bottom
                height: 40
                leftPadding: 30
                anchors.topMargin: 10

                Rectangle{
                    height: 40
                    width: 520
                    border.color: Constants.borderBlueColor
                    radius: 4
                }
            }

            Text {
                id: noteText
                anchors.top: dataExtractSelectBtn.bottom
                leftPadding: 30
                anchors.topMargin: 4
                text: qsTr("Above field will show all data extract schedule that is set up in GRS")
            }

            Button{
                 id: addBtn
                 anchors.top: noteText.bottom
                 x: popupMain.width - 150
                 anchors.rightMargin: 100
                 anchors.topMargin: 20

                 Text {
                     id: name
                     text: qsTr("Add")
                     anchors.top: parent
                     anchors.centerIn: parent
                 }
            }


        }

    }

}
