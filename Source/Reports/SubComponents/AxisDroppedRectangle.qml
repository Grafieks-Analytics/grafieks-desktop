import QtQuick 2.0

import com.grafieks.singleton.constants 1.0

Rectangle{

    property alias textValue: textbox.text

    height: parent.height - 10
    width: 200
    border.width: 1
    border.color: this.color
    radius: this.width/2

    Text {
        id: textbox
        anchors.verticalCenter: parent.verticalCenter
        x: 15
        width: parent.width - functionRectangle.width - this.x - 5
        elide: Text.ElideRight
        font.pixelSize: Constants.fontCategoryHeaderSmall
    }
    Rectangle{
        id: functionRectangle
        anchors.right: parent.right
        anchors.rightMargin: 5
        height: parent.height - 10
        anchors.top: parent.top
        anchors.topMargin: 5
        width: 80
        color: "#ffffff"
        radius: 10

        Text {
            text: qsTr("text")
            anchors.centerIn: parent
        }
    }
}
