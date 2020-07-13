/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Dashboard/Subcomponents
** Dashboard Summary
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import com.grafieks.singleton.constants 1.0

Item {

    width: 250

    Rectangle {
        id: rectangle
        x: 8
        y: 8
        width: 235
        height: 50
        color: "white"
        border.color: Constants.themeColor

        Image {
            id: image
            x: 8
            y: 10
            source: "../../../Images/icons/charts/Map2_30.png"
        }

        Text {
            id: text1
            x: 45
            y: 10
            color: "#3d31e9"
            text: qsTr("$1,000")
            font.weight: Font.Bold
            font.pixelSize: 12
        }

        Text {
            id: text2
            x: 45
            y: 25
            height: 15
            text: qsTr("Total Revenue")
            lineHeight: 1
            font.pixelSize: 12
        }
    }

    Rectangle {
        id: rectangle1
        x: 8
        y: 64
        width: 235
        height: 50
        color: "white"
        border.color: Constants.themeColor
        Image {
            id: image1
            x: 8
            y: 10
            source: "../../../Images/icons/charts/Map2_30.png"
        }

        Text {
            id: text3
            x: 45
            y: 10
            color: "#3d31e9"
            text: qsTr("$1,000")
            font.pixelSize: 12
            font.weight: Font.Bold
        }

        Text {
            id: text4
            x: 45
            y: 25
            height: 15
            text: qsTr("Growth")
            lineHeight: 1
            font.pixelSize: 12
        }
    }

    Rectangle {
        id: rectangle2
        x: 8
        y: 120
        width: 235
        height: 50
        color: "white"
        border.color: Constants.themeColor
        Image {
            id: image2
            x: 8
            y: 10
            source: "../../../Images/icons/charts/Map2_30.png"
        }

        Text {
            id: text5
            x: 45
            y: 10
            color: "#3d31e9"
            text: qsTr("$1,000")
            font.pixelSize: 12
            font.weight: Font.Bold
        }

        Text {
            id: text6
            x: 45
            y: 25
            height: 15
            text: qsTr("Revenue")
            lineHeight: 1
            font.pixelSize: 12
        }
    }

}
