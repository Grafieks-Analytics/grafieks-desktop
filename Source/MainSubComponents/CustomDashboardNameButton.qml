import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Button{
    id: customButton

    property alias textValue: contentItem.text
    property alias fontPointSize: contentItem.font.pointSize
    property alias fontPixelSize: contentItem.font.pixelSize
    property alias backgroundColor: btnBackground.color
    property color bgColor;

    background: Rectangle{
        id: btnBackground
        color: customButton.hovered ? Constants.grafieksGreen : bgColor
    }

    contentItem: Text {
        id: contentItem
        color: customButton.hovered ? Constants.blackColor : Constants.blackColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    ToolSeparator{
        anchors.right: customButton.right
        height: parent.height
        width: 2
        background: Rectangle{
            color: Constants.darkThemeColor
        }
    }

}
