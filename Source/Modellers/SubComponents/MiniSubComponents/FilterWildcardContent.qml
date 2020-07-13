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

    property string selectOption: "Select Wildcard"

    height: parent.height - 80 - 40
    width: parent.width - 40
    x:20
    y:10
    anchors.top:  fullExtactRadioBtn.bottom

    color: Constants.whiteColor
    border.color: Constants.darkThemeColor
    visible: false

    Rectangle{
        id: wildcardHead
        anchors.top: parent.top
        anchors.topMargin: 5

        height: 40
        width: parent.width - 10

        anchors.horizontalCenter: parent.horizontalCenter


        Column{

            id: addWildcard
            anchors.top: wildcardHead.top

            padding: 12
            leftPadding: 30

            anchors.verticalCenter: parent.verticalAlignment

            CustomButton {
                textValue: qsTr("Add Wildcard")
            }

        }

        Column{
            id: singleSelectRadioColumn

            anchors.right: parent.right
            rightPadding: 30

            CheckBox {

                checked: true
                text: qsTr("Exclude")
                indicator.width: 15
                indicator.height: 15
            }


        }
    }

    property int numModels: 2

    ListView{
        model: numModels
        anchors.top: wildcardHead.bottom
        anchors.topMargin: 20
        anchors.left: parent.left

        anchors.leftMargin: 30
        width: parent.width
        height: numModels * 40
        spacing: 5

        delegate: Row{
            width: parent.width
            height: 40

            Column{

                width: parent.width/2

                ListModel{
                    id: selectDropdown

                    ListElement{
                        menuItem:"Containing"
                    }
                    ListElement{
                        menuItem:"Ends With"
                    }
                    ListElement{
                        menuItem:"Equal To"
                    }
                    ListElement{
                        menuItem:"Doesn't Start with"
                    }
                    ListElement{
                        menuItem:"Doesn't End with"
                    }
                    ListElement{
                        menuItem:"Not Equal to"
                    }
                }

                SelectDropdown{
                    id: wildcardDropdown
                    width: parent.width*2/3
                    textValue:"Containing"
                    list: selectDropdown
                }


            }

            Column{
                width: parent.width/2

                anchors{
                    top: parent.top
                }

                CustomTextBox{
                    placeholderText: "Enter Text"
                    boxWidth: parent.width * 2 / 3

                    anchors{
                        right: parent.right
                        rightMargin: 50
                    }

                    boxHeight: 30
                }
            }

        }

    }
}
