import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{

    function onWidthValueChanged(){
        console.log('Opacity')
    }
    function onHeightValueChanged(){
        console.log('Opacity')
    }

    Column{
        spacing: 10
        width: parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 10

        Row{

            width: parent.width
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 5

            Column{
                height: parent.height * 2
                width: parent.width/2
                spacing: 10
                Text {
                    text: qsTr("Width")
                }
                CustomSpinBox {
                    value: 0
                    onValueChanged: onWidthValueChanged()
                    maximumValue: 100
                }
            }

            Column{
                height: parent.height * 2
                width: parent.width/2
                spacing: 10
                Text {
                    text: qsTr("Height")
                }
                CustomSpinBox {
                    value: 0
                    onValueChanged: onHeightValueChanged()
                    maximumValue: 100
                }
            }

        }

    }

}
