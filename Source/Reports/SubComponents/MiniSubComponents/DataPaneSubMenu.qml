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

    width: parent.width
    x: 10
    height: 60
    modal: false
    visible: false

    background: Rectangle{
//        color: Constants.whiteColor
        color: Constants.themeColor
        border.color: Constants.darkThemeColor
    }

    function openCalculatedFieldMenu(){
        calculatedFieldPopup.visible = true
    }

    Rectangle{
        anchors.fill: parent
        color: Constants.themeColor
        Column{
            anchors.fill: parent
            spacing: 4

            Rectangle{
                height: elementHeight
                width: parent.width
                visible: !convertToSelected
                color: Constants.themeColor

                Text {
                    text: qsTr("Calculated Field")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: openCalculatedFieldMenu()
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
                visible: !convertToSelected
                color: Constants.themeColor

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
                color: Constants.themeColor

                Text {
                    text: qsTr("Date")
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
                visible: convertToSelected
                color: Constants.themeColor

                Text {
                    text: qsTr("Number")
                    font.pixelSize: Constants.fontCategoryHeaderMedium
                    anchors.verticalCenter: parent.verticalCenter
                }

            }

        }
    }
}
