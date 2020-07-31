/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data
** Data Query Modeller
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"


Rectangle{
    property bool listOpened: false

    property string selectOption: "Select numerical"

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

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:60
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor

    Rectangle{
        id: numericalHeading

        height: 40
        width: parent.width

        color: "transparent"

        Column{

            id: addnumerical
            anchors.top: parent.top

            anchors.left: parent.left
            leftPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            CheckBox {
                checked: DSParamsModel.includeNull
                text: qsTr("Include Null")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {
                    DSParamsModel.setIncludeNull(checked)
                }
            }


        }

        Column{
            id: singleSelectRadioColumn

            anchors.right: parent.right
            rightPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            CheckBox {
                checked: DSParamsModel.exclude
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15

                onCheckStateChanged: {
                    DSParamsModel.setExclude(checked)
                }
            }


        }
    }

    Rectangle{
        id: conditionRow

        height: 30
        width: parent.width
        color: "transparent"

        anchors.top: numericalHeading.bottom
        anchors.topMargin: 5

        Text {
            id: name
            text: qsTr("Condition")
            leftPadding: 20
        }



    }

    Rectangle{
        anchors.top: conditionRow.bottom
        width: parent.width
        height: 30
        color: "transparent"

        Rectangle{
            id: numericalOptionRow
            anchors.left: parent.left
            width: parent.width / 3
            height: 30
            color: "transparent"


            SelectDropdown{
                id: selectOption
                textValue:"Equal"
                list: listModel
                height: listModel.count * 30
                anchors.left: parent.left
                anchors.leftMargin: 20
            }


        }

        Rectangle{
            id: numericalTextRow
            anchors.top: parent.top
            anchors.right: parent.right

            width: parent.width / 3
            height: 30
            anchors.rightMargin: 20


            color: "transparent"

            Rectangle{
                id: numericalTextBox
                height: 30
                width: parent.width
                anchors.left: parent.left
                anchors.rightMargin: 20

                Rectangle{
                    height: parent.height
                    width: parent.width
                    color: "transparent"

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

                Rectangle{
                    height: parent.height
                    width: parent.width/2
                    anchors.left: parent.left
                    color: "transparent"

                    TextField {
                        placeholderText: "Enter Text"
                        anchors.centerIn: parent
                        width: parent.width - 10
                        height: 30
                    }
                }


                Rectangle{
                    height: parent.height
                    width: parent.width/2
                    anchors.right: parent.right

                    color: "transparent"

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

