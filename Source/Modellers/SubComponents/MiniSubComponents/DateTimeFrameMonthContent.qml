import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Column{
    width: parent.width
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 80
    anchors.topMargin: 30


    Rectangle{
        id:thisTimeFrameRow
        height: 30
        width: parent.width
        anchors.left: parent.left


        RadioButtonTpl{
            id:thisRadio

            radio_text: qsTr("This Month")
            radio_checked: false
            parent_dimension: 16

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    thisRadio.radio_checked = true
                    lastRadio.radio_checked = false
                    nextRadio.radio_checked = false
                    nextXRadio.radio_checked = false
                    lastXRadio.radio_checked = false

                    nextXRadioTextField.focus = false
                    lastXRadioTextField.focus = false

                }
            }
        }

    }

    Rectangle{
        id:lastTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: thisTimeFrameRow.bottom
        anchors.topMargin: 10
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2

        RadioButtonTpl{
            id:lastRadio
            radio_text: qsTr("Last Month")
            radio_checked: false
            parent_dimension: 16

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    thisRadio.radio_checked = false
                    lastRadio.radio_checked = true
                    nextRadio.radio_checked = false
                    nextXRadio.radio_checked = false
                    lastXRadio.radio_checked = false

                    nextXRadioTextField.focus = false
                    lastXRadioTextField.focus = false
                }
            }
        }

    }

    Rectangle{
        id:nextTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: lastTimeFrameRow.bottom
        anchors.topMargin: 10
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2

        RadioButtonTpl{
            id:nextRadio
            radio_text: qsTr("Next Month")
            radio_checked: false
            parent_dimension: 16

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    thisRadio.radio_checked = false
                    lastRadio.radio_checked = false
                    nextRadio.radio_checked = true
                    nextXRadio.radio_checked = false
                    lastXRadio.radio_checked = false

                    nextXRadioTextField.focus = false
                    lastXRadioTextField.focus = false
                }
            }
        }

    }


    Rectangle{
        id:lastXTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: nextTimeFrameRow.bottom
        anchors.leftMargin: parent.width * 0.2
        anchors.topMargin: 10
        anchors.rightMargin: parent.width * 0.2

        RadioButtonTpl{
            id:lastXRadio
            radio_text: qsTr("Last")
            radio_checked: false
            parent_dimension: 16
            width: 200

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    thisRadio.radio_checked = false
                    lastRadio.radio_checked = false
                    nextRadio.radio_checked = false
                    nextXRadio.radio_checked = false
                    lastXRadio.radio_checked = true


                    nextXRadioTextField.focus = false
                    lastXRadioTextField.focus = true
                }
            }
        }

        TextField{
            height: 30
            width: 80
            id:lastXRadioTextField
            anchors.left: lastXRadio.right
            placeholderText: "Month"
        }

    }

    Rectangle{
        id:nextXTimeFrameRow
        height: 30
        width: parent.width

        anchors.left: parent.left
        anchors.top: lastXTimeFrameRow.bottom
        anchors.leftMargin: parent.width * 0.2
        anchors.rightMargin: parent.width * 0.2
        anchors.topMargin: 10

        RadioButtonTpl{
            id:nextXRadio
            radio_text: qsTr("Next")
            radio_checked: false
            parent_dimension: 16
            width: 200

            MouseArea{
                anchors.fill:parent

                onClicked: {
                    thisRadio.radio_checked = false
                    lastRadio.radio_checked = false
                    nextRadio.radio_checked = false
                    nextXRadio.radio_checked = true
                    lastXRadio.radio_checked = false


                    nextXRadioTextField.focus = true
                    lastXRadioTextField.focus = false
                }
            }
        }

        TextField{
            id: nextXRadioTextField
            height: 30
            width: 80
            anchors.left: nextXRadio.right

            placeholderText: "Month"
        }

    }
}
