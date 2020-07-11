import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"
import "../MiniSubComponents"

Popup {
    id: dataFilterPopup
    width: parent.width
    height: parent.height
    x: 0
    y: 0
    modal: true
    visible: false
    padding: 0
    closePolicy: Popup.NoAutoClose
    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }

    ListModel{
        id: checkListModel

        ListElement{
            textValue:"All"
        }

        ListElement{
            textValue:"All 1"
        }

        ListElement{
            textValue:"All 2"
        }

        ListElement{
            textValue:"All 3"
        }
    }


    // Popup Header starts

    Rectangle{
        id: headerPopup
        color: Constants.whiteColor
        border.color: "transparent"
        height: 40
        width: parent.width - 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 1
        anchors.leftMargin: 1


        Text{
            id : text1
            text: "Numerical Data Filter"
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
                    dataFilterPopup.visible = false
                }
            }
        }

    }

    // Popup Header ends

    //    Top Menu Contents

    NumericalFilterInnerPopup{
        id: topContent
    }

    // Footer starts

    Row{
        id: footerContent
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.rightMargin: 20
        spacing: 5
        height: 30
        width: parent.width


        CustomButton{
            id: resetBtn
            textValue:  "Reset"

            anchors.left: parent.left
            anchors.leftMargin: 20

            onClicked: {
                dataFilterPopup.visible = false
            }
        }



        CustomButton{
            id: apply_btn1
            textValue:  "Apply"

            anchors.right: parent.right
            anchors.rightMargin: 20


            onClicked: {
                dataFilterPopup.visible = false
            }
        }


        CustomButton{
            id: cancel_btn1

            anchors.right: apply_btn1.left
            anchors.rightMargin: 20

            textValue: "Cancel"
            onClicked: {
                dataFilterPopup.visible = false
            }


        }


    }

    // Footer ends
}
