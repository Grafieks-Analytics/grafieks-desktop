/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Slider Template
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Item {

    id: slider_item
    height: control.implicitHeight
    width: control.implicitWidth


    property alias slider_height:excluded_range.implicitHeight
    property alias slider_width: excluded_range.implicitWidth
    property alias knob_size: knob.implicitWidth

    Slider {
        id: control
        value: 0.5

        background: Rectangle {
            id: excluded_range
            x: control.leftPadding
            y: control.topPadding + control.availableHeight / 2 - height / 2
            width: control.availableWidth
            height: implicitHeight
            radius: 2
            color: Constants.themeColor

            Rectangle {
                id: included_range
                width: control.visualPosition * parent.width
                height: parent.height
                color: Constants.darkThemeColor
                radius: 2
            }
        }

        handle: Rectangle {
            id: knob
            x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
            y: control.topPadding + control.availableHeight / 2 - height / 2
            implicitHeight: knob_size
            radius: knob_size/2
            color: control.pressed ? Constants.darkThemeColor: Constants.themeColor
            border.color: "black"
        }
    }
}
