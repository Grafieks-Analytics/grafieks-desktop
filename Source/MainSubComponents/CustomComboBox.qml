import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

ComboBox{
    id:control
    height: 30
    width: 200

    background: Rectangle{
        color: Constants.whiteColor
        radius: Constants.radiusNumber
        border.color: Constants.borderBlueColor
        border.width: Constants.borderWidth
    }
}
