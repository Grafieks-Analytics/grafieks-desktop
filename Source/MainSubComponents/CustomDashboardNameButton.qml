import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts

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
// Button {
//     id: control
//     text: "First"
//     Layout.fillWidth: true
//     hoverEnabled: true
//     highlighted :true
//     flat:true

//     background: Rectangle {
//         implicitWidth: 100
//         implicitHeight: 40
//         opacity: enabled ? 1 : 1
//         color: control.down ? "#ff0000" : (control.hovered ? "#0000ff" : "#00ff00")
//         border.width: 1
//         radius: 2
        
//      }
// }