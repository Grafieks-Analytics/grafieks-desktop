/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Radio Button Template
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0


RadioButton {
    id: control

    height: control.implicitHeight
    width: control.implicitWidth

    property alias radio_text: control.text
    property alias radio_checked: control.checked
    property alias parent_dimension: parent_border.implicitWidth


    indicator: Rectangle {
        id: parent_border
        implicitHeight: parent_dimension
        radius: parent_dimension/2
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        border.color: control.down ? Constants.darkThemeColor : "black"

        Rectangle {
            id: child_border
            width: parent_dimension/2
            height: width
            radius: width/2
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: control.down ? Constants.darkThemeColor : "black"
            visible: control.checked
        }
    }

    contentItem: Text {
        text: control.text
        opacity: enabled ? 1.0 : 0.3
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}

