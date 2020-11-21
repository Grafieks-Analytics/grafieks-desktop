import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    property int elementHeight: 20
    property bool convertToSelected: false

    width: parent.width - 20
    x: 10
    height: 60
    modal: false
    visible: false

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.themeColor
    }

    function openCalculatedFieldMenu(){
        console.log('openCalculatedFieldPopup');
    }

    Rectangle{
        anchors.fill: parent
        Column{
            anchors.fill: parent
            spacing: 8

            Rectangle{
                height: elementHeight
                width: parent.width
                visible: !convertToSelected

                Text {
                    text: qsTr("Calculated Field")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: openCalculatedFieldMenu()
                }
            }

            Rectangle{
                height: elementHeight
                width: parent.width
                visible: !convertToSelected

                Text {
                    text: qsTr("Group")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }
            }


            Rectangle{
                height: elementHeight
                width: parent.width
                visible: convertToSelected

                Text {
                    text: qsTr("Date")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle{
                height: elementHeight
                width: parent.width
                visible: convertToSelected

                Text {
                    text: qsTr("Number")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

        }
    }
}
