import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Rectangle{

    id: fileUploadBtn

    property alias btnHeight:  fileUploadBtn.height
    property alias btnWidth:  fileUploadBtn.width
    property alias textValue: textfield.text

    border.color: Constants.borderBlueColor
    border.width: 2

    Text{
        id: textfield
        anchors.centerIn: parent
    }
}
