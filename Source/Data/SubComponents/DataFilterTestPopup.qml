import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../../MainSubComponents"

Popup {
    id: popup2Main
    width: 600
    height: 500
    x: parent.width / 2 - 380
    y: 100
    modal: true
    visible: false
    padding: 0

    background: Rectangle{
        color: Constants.themeColor
    }

}
