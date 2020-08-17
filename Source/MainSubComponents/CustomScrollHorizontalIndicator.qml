import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

ScrollIndicator {
    active: true
    height: 10
    contentItem: Rectangle {
        color: Constants.scrollBarColor
        radius: Constants.defaultRadius
    }
}
