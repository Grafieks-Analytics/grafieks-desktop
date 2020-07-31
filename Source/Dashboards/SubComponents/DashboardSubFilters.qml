/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Sub Filters
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Item {

    id: dashboard_subfilter
    width: 350
    property alias button1: button1

    Rectangle {
        id: rectangle
        x: 6
        y: 5
        width: 342
        height: 464
        color: "white"
        border.color: Constants.themeColor

        ToolSeparator {
            id: toolSeparator
            x: 121
            y: 46
            width: 14
            height: 400

            StackView {
                id: stackView
                x: 15
                y: 0
                width: 200
                height: 400
            }
        }

        Button {
            id: button
            x: 15
            y: 63
            text: qsTr("Property")
        }

        Button {
            id: button1
            x: 15
            y: 109
            text: qsTr("Filter Type")
        }

        Button {
            id: button2
            x: 16
            y: 155
            text: qsTr("Value")
        }

        Button {
            id: button3
            x: 15
            y: 201
            text: qsTr("Apply")
        }

        Rectangle {
            id: rectangle1
            x: 2
            y: 2
            width: 338
            height: 40
            color: Constants.themeColor

            Text {
                id: text1
                x: 13
                y: 12
                text: qsTr("Filters")
                font.pixelSize: 12
            }

            Image {
                id: image
                x: 310
                y: 8
                width: 20
                height: 20
                source: "qrc:/qtquickplugin/images/template_image.png"
            }
        }
    }

}
