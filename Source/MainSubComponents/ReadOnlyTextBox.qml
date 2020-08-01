import QtQuick 2.15


import com.grafieks.singleton.constants 1.0

Rectangle {

    property alias boxWidth: box.width
    property alias text: textValue.text

    id: box
    height: 30
    border.color: Constants.borderBlueColor
    border.width: Constants.borderWidth

    Text {
        id: textValue
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }


}
