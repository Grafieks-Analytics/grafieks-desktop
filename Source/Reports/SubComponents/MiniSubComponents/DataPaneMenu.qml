import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    property int elementHeight: 20

    width: parent.width - 20
    x: 10
    height: 100
    modal: false
    visible: false

    background: Rectangle{
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }

    function openSubMenu(type){
        switch(type){
        case "convertTo": dataPaneSubMenu.convertToSelected = true
            break;
        case "create": dataPaneSubMenu.convertToSelected = false
            break;
        }

        dataPaneSubMenu.visible = true
    }


    DataPaneSubMenu{
        id: dataPaneSubMenu
        y: elementHeight
    }

    Rectangle{
        anchors.fill: parent
        color: Constants.themeColor

        Column{
            anchors.fill: parent
            spacing: 8

            Rectangle{
                height: elementHeight
                width: parent.width
                color: Constants.themeColor

                Text {
                    text: qsTr("Rename")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }

                HorizontalLineTpl{
                    line_color: Constants.darkThemeColor
                    line_width: parent.width + 20
                    x: -10
                    anchors.top: parent.bottom
                }
            }

            Rectangle{
                height: elementHeight
                width: parent.width

                color: Constants.themeColor

                Text {
                    text: qsTr("Create")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }
                Image {
                    source: "/Images/icons/arrow_right.png"
                    height: 20
                    width: 20
                    anchors.right: parent.right
                    MouseArea{
                        anchors.fill: parent
                        onClicked: openSubMenu('create')
                    }
                }

                HorizontalLineTpl{
                    line_color: Constants.darkThemeColor
                    line_width: parent.width + 20
                    x: -10
                    anchors.top: parent.bottom
                }
            }

            Rectangle{
                height: elementHeight
                width: parent.width
                color: Constants.themeColor

                Text {
                    text: qsTr("Convert To")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    source: "/Images/icons/arrow_right.png"
                    height: 20
                    width: 20
                    anchors.right: parent.right
                    MouseArea{
                        anchors.fill: parent
                        onClicked: openSubMenu('convertTo')
                    }
                }

            }


        }
    }
}
