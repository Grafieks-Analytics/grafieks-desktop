/****************************************************************************
**
** Copyright (C) 2019 - 2020 Grafieks v1.0.
** Contact: https://grafieks.com/
**
** Data/SubComponents
** Tab Text Component
**
****************************************************************************/

import QtQuick 2.11
import com.grafieks.singleton.constants 1.0

Item {

    id : tabTextComponent
    property alias name : textcomponent.text

    Text {
        id : textcomponent
        font.pointSize: 10
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "black"
        anchors.centerIn: parent

    }
}
