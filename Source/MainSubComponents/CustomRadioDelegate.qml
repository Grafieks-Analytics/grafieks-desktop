import QtQuick 2.0
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

RadioDelegate {
    id: control

    background: Rectangle {
        visible: control.down || control.highlighted
        color: "transparent"
    }

    indicator: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        x: control.width/2
        radius: 16
        color: "transparent"
        border.color: control.down ? Constants.darkThemeColor : "black"

        Rectangle {
            width: 10
            height: 10
            x: 3
            y: 3
            radius: 8
            color: control.down ? Constants.darkThemeColor : "black"
            visible: control.checked
        }
    }


}
