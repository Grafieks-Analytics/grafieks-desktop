import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Item {

    id: joinBoxItem
    property var objectName

    objectName: objectName

    signal joinChanged(int joinId);

    Component.onCompleted: {
        DSParamsModel.setJoinIcon("../../../../Images/icons/inner_join_32.png")
    }


    Rectangle{
        id: joinBoxRectangle
        width:35
        height:35
        color: "transparent"

        Image{
            id: iconId
            source: DSParamsModel.joinIcon

            onSourceChanged: joinChanged(parseInt(objectName))
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                joinPopup.visible = true
            }
        }
    }

}
