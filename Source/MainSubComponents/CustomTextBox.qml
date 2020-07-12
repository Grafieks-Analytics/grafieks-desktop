import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

TextField{
    id: textField
    property alias maxLength: textField.maximumLength
    property alias boxWidth: textField.width
    property alias boxHeight: textField.height

//    anchors.verticalCenter: parent.verticalCenter

    background: Rectangle {
        border.color: Constants.borderBlueColor
        radius: 6
        width: parent.width
        border.width: 2
    }
}
