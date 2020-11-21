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
        color: Constants.whiteColor
        border.color: Constants.themeColor
    }

    Rectangle{
        anchors.fill: parent
        Column{
            anchors.fill: parent
            spacing: 8
            Rectangle{
                height: elementHeight
                width: parent.width

                Text {
                    text: qsTr("Rename")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle{
                height: elementHeight
                width: parent.width

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
                }
            }

            Rectangle{
                height: elementHeight
                width: parent.width

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
                }
            }


        }
    }
}
