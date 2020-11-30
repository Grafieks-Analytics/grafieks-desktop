import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

import "../../../MainSubComponents";
import "../MiniSubComponents";

Popup {

    width: parent.width - 20
    x: 10
    height: 50
    modal: false

    background: Rectangle{
        color: Constants.whiteColor
        border.color: Constants.themeColor
    }

    CustomSlider {
        from: 8
        value: 12
        to: 100
        width: parent.width
    }

}