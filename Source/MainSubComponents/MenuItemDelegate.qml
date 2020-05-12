/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Menu Item Delegate
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import com.grafieks.singleton.constants 1.0

Component{
     id : menuItemComponent

    MenuItem{
        id: menuItem

        background: Rectangle {

            Rectangle{
                anchors.fill: parent
                anchors.margins: 3
                color: menuItem.highlighted ? "#A5BAFA" : "transparent"

                Rectangle{
                    anchors.fill: parent
                    anchors.margins: 2
                    color: menuItem.highlighted? "#C5D2FC" : "transparent"
                }
            }

            implicitWidth: 200
            implicitHeight: 25
            opacity: enabled ? 1 : 0.3
            color:  "#E3E5EA"

        }

        contentItem: Text {
            leftPadding: 30
            text: menuItem.text
            font: menuItem.font
            opacity: enabled ? 1.0 : 0.3
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
