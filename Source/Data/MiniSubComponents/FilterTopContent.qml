/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Query Modeller
**
****************************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"


Rectangle{
    property bool listOpened: false

    property string selectOption: "Select top"

    id: topHead

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:30
    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    visible: false


    Row{
        id: topOptionRow
        anchors.top: topHead.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        width: parent.width / 3
        height: 30

        ListModel{
            id: listModel
            ListElement{
                menuItem:"Top"
            }
            ListElement{
                menuItem:"Bottom"
            }
        }

        SelectDropdown{
            id: selectOption
            textValue:"Top"
            list: listModel
        }

    }

    Row{
        id: topOption2Row
        anchors.top: topHead.top
        anchors.right: topHead.right
        anchors.topMargin: 20

        width: parent.width / 3
        height: 30
        anchors.rightMargin: 20

        Rectangle{
            id: topTextBox
            height: 30
            width: parent.width
            anchors.left: topOptionRow.left
            anchors.rightMargin: 20

            Row{
                height: parent.height
                width: parent.width
                rightPadding: 20

                TextField {
                    placeholderText: "Enter Text"
                    anchors.centerIn: parent
                    width: parent.width - 10
                    height: 30
                }
            }

        }

    }

//    By Select Box Start

    Row{
        id: topByTextField
        anchors.top: topOptionRow.top
        anchors.right: parent.right
        anchors.topMargin: 50

        width: parent.width / 3
        height: 30

        Rectangle{
            id: topByTextBox
            height: 30
            width: parent.width
            anchors.right: parent.right
            anchors.rightMargin: 20

            Row{
                height: parent.height
                width: parent.width
                rightPadding: 20

                Text {
                    id: topByText
                    text: qsTr("By")
                    y:5
                    x: -30
                }

                ListModel{
                    id: bySelectModel
                    ListElement{
                        menuItem:"Order unit"
                    }
                    ListElement{
                        menuItem:"Profit"
                    }
                    ListElement{
                        menuItem:"Sales value"
                    }
                }

                SelectDropdown{
                    id: bySelectDropdown
                    textValue:""
                    list: bySelectModel
                }

            }

        }

    }


    //    By Select Box Ends

}
