/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Range Slider Template
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import com.grafieks.singleton.constants 1.0

Item {

    id: rangeslider_item
    width: control.implicitWidth
    height: control.implicitHeight

    property alias slider_width: slider_exluded_line.implicitWidth
    property alias slider_height: slider_exluded_line.implicitHeight
    property alias knob_size:first_knob.implicitWidth


    RangeSlider {
        id: control

        from: 1
        to: 100

        first.value: 1
        second.value: 100

        background: Rectangle {

            id: slider_exluded_line
            x: control.leftPadding
            y: control.topPadding + control.availableHeight / 2 - height / 2
            width: control.availableWidth
            height: implicitHeight
            radius: 2
            color: Constants.themeColor

            Rectangle {
                id: slider_included_line
                x: control.first.visualPosition * parent.width
                width: control.second.visualPosition * parent.width - x
                height: parent.height
                color: Constants.darkThemeColor
                radius: 2
            }
        }

        first.handle: Rectangle {
            id: first_knob
            x: control.leftPadding + first.visualPosition * (control.availableWidth - width)
            y: control.topPadding + control.availableHeight / 2 - height / 2
            height: knob_size
            radius: knob_size/2
            color: first.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }

        second.handle: Rectangle {
            id: second_knob
            x: control.leftPadding + second.visualPosition * (control.availableWidth - width)
            y: control.topPadding + control.availableHeight / 2 - height / 2
            width: knob_size
            height: knob_size
            radius: knob_size/2
            color: second.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }
    }


}
