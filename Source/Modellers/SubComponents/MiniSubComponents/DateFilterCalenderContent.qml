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
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"


Rectangle{
    property bool listOpened: false

    property var locale: Qt.locale()

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
        id: dateRangeText

        height: 40
        width: parent.width

        Column{

            padding: 12
            leftPadding: 20

            anchors.verticalCenter: parent.verticalAlignment

            Text {
                text: qsTr("Date Range")
            }

        }
    }

    Row{
        id: dateOptionRow
        anchors.top: dateRangeText.bottom
        anchors.topMargin: 8
        width: parent.width
        height: 30

        Column{
            id: fromDate
            anchors.top: parent.top
            width: parent.width/2
            anchors.left: parent.left
            anchors.leftMargin: 20

            anchors.verticalCenter: parent.verticalAlignment

            Text {
                id: fromDateText
                text: qsTr("From")
            }

            Row{
                width: parent.width
                anchors.top: fromDateText.bottom
                anchors.left: parent.left
                anchors.topMargin: 10
                height: 30

                TextField {
                    id:fromDateInput
                    placeholderText: "dd/mm/yyyy"
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                }

                Image{
                    id: fromDatePicker
                    source: '../../../Images/icons/clipart268070@2x.png'
                    anchors.top: parent.top
                    anchors.left: fromDateInput.right
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 10
                    width: parent.height - 10

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            fromDateCalendar.visible = true
                        }
                    }
                }

                Calendar{
                    id: fromDateCalendar
                    visible: false
                    onClicked: {
                        fromDateCalendar.visible = false
                        let date = fromDateCalendar.selectedDate.toLocaleDateString(locale,"dd/MM/yyyy")
                        fromDateInput.text = date
                    }

                }

            }

        }

        Column{
            anchors.top: parent.top
            width: parent.width/2
            anchors.left: fromDate.right
            anchors.leftMargin: 20

            anchors.verticalCenter: parent.verticalAlignment

            Text {
                id: toDateText
                text: qsTr("To")
            }

            Row{
                width: parent.width
                anchors.top: toDateText.bottom
                anchors.left: parent.left
                anchors.topMargin: 10
                height: 30

                TextField {
                    id: toDateInput
                    placeholderText: "dd/mm/yyyy"
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                }


                Image{
                    id: toDatePicker
                    source: '../../../Images/icons/clipart268070@2x.png'
                    anchors.top: parent.top
                    anchors.left: toDateInput.right
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 10
                    width: parent.height - 10

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            toDateCalendar.visible = true
                        }
                    }
                }

                Calendar{
                    id: toDateCalendar
                    visible: false
                    onClicked: {
                        toDateCalendar.visible = false
                        let date = toDateCalendar.selectedDate.toLocaleDateString(locale,"dd/MM/yyyy")
                        toDateInput.text = date
                    }

                }


            }

        }



    }

    Row{
        height: 30
        anchors.bottom: parent.bottom;

        anchors.left: parent.left
        anchors.leftMargin: 20

        CheckBox {
            checked: true
            text: qsTr("Include Null")

        }
    }

    Row{
        height: 30
        anchors.bottom: parent.bottom;

        anchors.right: parent.right
        anchors.rightMargin: 20

        CheckBox {
            checked: true
            text: qsTr("Exclude")

        }
    }

}
