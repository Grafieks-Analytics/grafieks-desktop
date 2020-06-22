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

    property string selectOption: "Select Wildcard"

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:10
    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor
    visible: false

    Row{
        id: wildcardHead

        height: 40
        width: parent.width

        Column{

            id: addWildcard
            anchors.top: wildcardHead.top

            padding: 12
            leftPadding: 30

            anchors.verticalCenter: parent.verticalAlignment

            Text {
                text: qsTr("Add Wildcard")
            }

        }

        Column{
            id: singleSelectRadioColumn

            anchors.right: wildcardHead.right
            rightPadding: 30

            CheckBox {
                checked: true
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15
            }


        }
    }

    Row{
        id: wildcardOptionRow
        anchors.top: wildcardHead.bottom
        anchors.topMargin: 8
        width: parent.width / 3
        height: 30

        Rectangle{
            id: selectBox
            height: 30
            width: parent.width
            anchors.left: wildcardOptionRow.left
            border.color: Constants.borderBlueColor
            anchors.leftMargin: 20

            Row{
                height: parent.height
                width: parent.width
                leftPadding: 20

                Text {
                    id: selectBoxValue
                    text: qsTr("Select Wildcard")
                    color: Constants.grayColor
                    anchors.centerIn: parent
                    width: parent.width - 10
                }

                Image{
                    id: showBtn
                    source:"../../../Images/icons/Down_20.png"

                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.topMargin: 5
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        selectListViewOptions.open()
                    }
                }

            }

        }

        Menu {
            id: selectListViewOptions
            x: 20
            y: selectBox.height
            width: 150

            MenuItem {
                text: "Containing"
                height: 30
                onTriggered: {}
                onClicked: {
                    selectBoxValue.text = this.text
                }
            }
            MenuItem {
                text: "Ends with"
                height: 30
                onTriggered: {
                }
                onClicked: {
                    selectBoxValue.text = this.text
                }
            }
            MenuItem {
                text: "Equals to"
                height: 30
                onTriggered: {}
                onClicked: {
                    selectBoxValue.text = this.text
                }
            }
            MenuItem {
                text: "Doesn't Start With"
                height: 30
                onTriggered: {}
                onClicked: {
                    selectBoxValue.text = this.text
                }
            }
            MenuItem {
                text: "Doesn't End With"
                height: 30
                onTriggered: {}
                onClicked: {
                    selectBoxValue.text = this.text
                }
            }
            MenuItem {
                text: "Not Equal to"
                height: 30
                onTriggered: {}
                onClicked: {
                    selectBoxValue.text = this.text
                }
            }
        }

    }

    Row{
        id: wildcardOption2Row
        anchors.top: wildcardHead.bottom
        anchors.right: wildcardHead.right
        anchors.topMargin: 8

        width: parent.width / 3
        height: 30
        anchors.rightMargin: 20

        Rectangle{
            id: wildcardTextBox
            height: 30
            width: parent.width
            anchors.left: wildcardOptionRow.left
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

}
