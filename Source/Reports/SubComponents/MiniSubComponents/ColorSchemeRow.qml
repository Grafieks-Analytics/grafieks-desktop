import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

Item {

    property alias list: listView.model

    Rectangle{
        height: 30
        width: parent.width

        ListView{

            id: listView
            height: parent.height
            width: parent.width

            orientation: ListView.Horizontal
            model: allColors
            delegate: Rectangle{

                height: 30
                width: 30
                color: colorName

            }
        }
    }
}
