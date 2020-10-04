import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents"

Rectangle{

    function onOpacityValueChanged(){
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

        Rectangle{

            width: parent.width
            height: 20
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15

            Text {
                id: backgroundColor
                text: qsTr("Background Color")
            }

            Image {
                anchors.right: parent.right
                source: "/Images/icons/Edit.png"
                height: 20
                width: 20
            }

        }

        Rectangle{

            width: parent.width
            height: 20
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15

            Text {
                id: lineColor
                text: qsTr("Line Color")
            }

            Image {
                anchors.right: parent.right
                source: "/Images/icons/Edit.png"
                height: 20
                width: 20
            }

        }

        Rectangle{

            width: parent.width
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15

            Text {
                id: opacity
                text: qsTr("Opacity")
                anchors.verticalCenter: parent.verticalCenter
            }

            CustomSpinBox {
                id: fontSizeSpinBox
                value: 0
                anchors.right: parent.right
                onValueChanged: onOpacityValueChanged()
//                maximumValue: 100
            }

        }

        Rectangle{

            width: parent.width
            height: 20
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15

            Text {
                text: qsTr("Grid")
            }

            Image {
                anchors.right: parent.right
                source: "/Images/icons/Edit.png"
                height: 20
                width: 20
            }

        }



    }

}
