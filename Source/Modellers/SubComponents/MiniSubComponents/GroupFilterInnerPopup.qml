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

    property string selectOption: "Select group"

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:60
    color: Constants.whiteColor
    border.color: Constants.darkThemeColor


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

    Rectangle{
        id: conditionRow

        height: 30

        width: parent.width

        anchors.top: parent.top
        anchors.topMargin: 10

        anchors.left: parent.left
        anchors.leftMargin: 20

        color: "transparent"

        CustomButton {
            id: name
            textValue: qsTr("Add Character")
        }



    }

    Rectangle{
        anchors.top: conditionRow.bottom
        anchors.topMargin: 10
        width: parent.width
        height: 30

        color: "transparent"


        Rectangle{
            id: groupOptionRow
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width / 3
            height: 30

            color:"transparent"

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
            id: groupSelectRow
            anchors.top: parent.top
            anchors.right: parent.right
            color:"transparent"

            width: parent.width / 3
            height: 30
            anchors.rightMargin: 20


            ListModel{
                id: listModel2
                ListElement{
                    menuItem:"Value 1"
                }
                ListElement{
                    menuItem:"Value 2"
                }
                ListElement{
                    menuItem:"Value 3"
                }
                ListElement{
                    menuItem:"Value 4"
                }
                ListElement{
                    menuItem:"Value 5"
                }
                ListElement{
                    menuItem:"Value 6"
                }

            }

            SelectDropdown{
                id: selectOptio2
                textValue:"Equal"
                list: listModel2
                height: listModel2.count * 30
                anchors.left: parent.left
            }

        }

    }
}

