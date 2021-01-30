/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** MainSubComponents
** Horizontal Line Tpl
**
****************************************************************************/

import QtQuick 2.15

import com.grafieks.singleton.constants 1.0

Item{

    id: verticle_line
    width: control.implicitWidth
    height: control.implicitHeight

    property alias line_color: control.color
    property alias line_width: control.width

    Rectangle {
        id: control
        implicitWidth: parent.vertical ? 1 : 24
        implicitHeight: parent.vertical ? 24 : 1

        color: "red"
    }

}
