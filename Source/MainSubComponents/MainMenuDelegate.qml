/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Main Menu Delegate
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Component{

    id : mainMenuComponent

    MenuBarItem{
        id: menuBarItem

        contentItem: Text{
            text : menuBarItem.text
            font : menuBarItem.font
            opacity: enabled ? 1.0 : 0.3
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        background:
            Rectangle{
            implicitWidth: 30
            implicitHeight: 30
            opacity: enabled ? 1 : 0.3
            color: "transparent"

            Rectangle {
                id: inner_rect
                anchors.fill: parent
                anchors.margins: 2

                Rectangle{
                    anchors.fill: parent
                    id: inner_rect2
                    anchors.margins: 2

                    color: {
                        if(menuBarItem.autoExclusive)
                            "#E1E3E7"
                        else if(menuBarItem.highlighted)
                            "#C5D2FC"
                        else
                            "transparent"
                    }
                }

                color:{
                    menuBarItem.highlighted ?  "#A5BAFA" : "transparent"
                }

            }
        }
    }
}
