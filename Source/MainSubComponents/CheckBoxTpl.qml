/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** Checkbox Template
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

Item {

    id: check_item
    height: control.implicitHeight
    width: control.implicitWidth

    property alias checkbox_text: control.text
    property alias checkbox_checked: control.checked
    property alias parent_dimension: parent_border.implicitWidth

    CheckBox {
        id: control

        indicator: Rectangle {
            id: parent_border
            implicitHeight: parent_dimension
            x: control.leftPadding
            y: parent.height / 2 - height / 2
            border.color: control.down ? Constants.darkThemeColor : "black"

            Rectangle {
                id: child_border
                width: parent_dimension/2
                height: width
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: control.down ?  Constants.darkThemeColor : "black"
                visible: control.checked
            }
        }

        contentItem: Text {
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing
        }
    }

}
