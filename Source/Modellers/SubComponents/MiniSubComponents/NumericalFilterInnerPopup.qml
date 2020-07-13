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

import "../../../MainSubComponents"


Rectangle{
    property bool listOpened: false

    property string selectOption: "Select numerical"

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:60
    anchors.top:  fullExtactRadioBtn.bottom
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    Row{
        id: numericalHeading

        height: 40
        width: parent.width

        Column{

            id: addnumerical
            anchors.top: parent.top

            anchors.left: parent.left
            leftPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            CheckBox {
                checked: true
                text: qsTr("Include Null")
                indicator.width: 15
                indicator.height: 15
            }


        }

        Column{
            id: singleSelectRadioColumn

            anchors.right: parent.right
            rightPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            CheckBox {
                checked: true
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15
            }


        }
    }

    Row{
        id: conditionRow

        height: 30

        width: parent.width

        anchors.top: numericalHeading.bottom
        anchors.topMargin: 5

        Text {
            id: name
            text: qsTr("Condition")
            leftPadding: 20
        }



    }

    Column{
        anchors.top: conditionRow.bottom
        width: parent.width
        height: 30


        Row{
            id: numericalOptionRow
//            anchors.top: numericalHeading.bottom
//            anchors.topMargin: 8
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width / 3
            height: 30

            ListModel{
                id: listModel
                ListElement{
                    menuItem:"Equal"
                }
                ListElement{
                    menuItem:"Not Equal To"
                }
                ListElement{
                    menuItem:"Smaller Than"
                }
                ListElement{
                    menuItem:"Greater Than"
                }
                ListElement{
                    menuItem:"Equal or Smaller Than"
                }
                ListElement{
                    menuItem:"Equal or Greater Than"
                }
                ListElement{
                    menuItem:"Between"
                }
            }

            SelectDropdown{
                id: selectOption
                textValue:"Equal"
                list: listModel
                height: listModel.count * 30
                anchors.left: parent.left
                anchors.leftMargin: 20
            }


        }

        Row{
            id: numericalTextRow
//            anchors.top: numericalHeading.bottom
//            anchors.right: numericalHeading.right
            anchors.top: parent.top
            anchors.right: parent.right

            width: parent.width / 3
            height: 30
            anchors.rightMargin: 20

            Rectangle{
                id: numericalTextBox
                height: 30
                width: parent.width
                anchors.left: parent.left
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

            Rectangle{
                id: numericalTextBoxes
                height: 30
                width: parent.width
                anchors.left: parent.left
                anchors.rightMargin: 20
                visible: false

                Row{
                    height: parent.height
                    width: parent.width/2
                    anchors.left: parent.left

                    rightPadding: 20

                    TextField {
                        placeholderText: "Enter Text"
                        anchors.centerIn: parent
                        width: parent.width - 10
                        height: 30
                    }
                }


                Row{
                    height: parent.height
                    width: parent.width/2
                    anchors.right: parent.right

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
}

