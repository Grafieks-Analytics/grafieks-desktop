/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Tab Background Component
**
****************************************************************************/

import QtQuick 2.15

Item {

    id : tabRectangleComponent
    property alias colorOuter : outerRect.color


    Rectangle{
        id: outerRect
        color: "red"
        height: tabRectangleComponent.height
        width: tabRectangleComponent.width

        Rectangle{
            id: innerRect
            anchors.fill: parent
            anchors.bottomMargin: 2
        }
    }

}
