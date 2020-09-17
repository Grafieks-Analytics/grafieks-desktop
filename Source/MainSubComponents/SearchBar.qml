/****************************************************************************
**
** Copyright (C) 2019 Grafieks.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Search Template
**
****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Item {

    property alias searchtext: search_text.text

    Rectangle{
        id:search_rect
        border.color: Constants.darkThemeColor
        width: 300
        height: 40
        radius: 10

        TextEdit {
            id: search_text
            text: "Search"
            cursorVisible: true
            width:250
            height: 40
            anchors.left: search_rect.left
            anchors.leftMargin: 10
            verticalAlignment:TextEdit.AlignVCenter
        }

        Image{
            id:search_btn
            source: "/Images/icons/Search.png"
            anchors.left: search_text.right
            height:30
            width: height
            anchors.verticalCenter: search_rect.verticalCenter

        }
    }

}
