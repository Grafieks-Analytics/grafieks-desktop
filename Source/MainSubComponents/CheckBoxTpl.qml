/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Checkbox Template
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

//Item {

//    id: check_item
//    height: control.implicitHeight
//    width: control.implicitWidth



    CheckBox {
        id: control
        property alias checkbox_text: control.text
        property alias checkbox_checked: control.checked
        property alias parent_dimension: parent_border.implicitWidth

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

//}
