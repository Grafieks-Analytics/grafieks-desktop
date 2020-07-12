import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Button{
    id: customButton

    property alias textValue: contentItem.text

    background: Rectangle{
        id: btnBackground
        color: customButton.hovered ? Constants.grafieksGreen : Constants.leftDarkColor
    }

    contentItem: Text {
        id: contentItem
        color: customButton.hovered ? Constants.whiteColor : Constants.blackColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }


}
