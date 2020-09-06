import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.15

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"



Rectangle {
    width: parent.width / 2
    height: parent.height
    anchors.right: parent.right
    color: "#aaff0011"

    DropArea {
        id: dropArea
        anchors.fill: parent
        onDropped: {
            listView.model.remove(listView.dragItemIndex);
            listView.dragItemIndex = -1;
        }
    }
}

