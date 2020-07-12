import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

TextArea{
    id: textArea

    property alias boxWidth: textArea.width
    property alias boxHeight: textArea.height

    anchors.verticalCenter: parent.verticalCenter

    background: Rectangle {
        border.color: Constants.borderBlueColor
        radius: 6
        width: parent.width
        border.width: 2
    }
}
