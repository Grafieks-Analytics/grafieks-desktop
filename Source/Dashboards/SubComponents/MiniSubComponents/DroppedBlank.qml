import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

// This is the Text Widget dynamically called from MainContainer
// when a column is dropped from right side customize

Item{

    id: newItem
    visible: true

    anchors{
        top: mainContainer.top
        left: mainContainer.left
        right: mainContainer.right
        bottom: mainContainer.bottom
    }

    Component.onCompleted: {
        var globalCordinates = this.mapToGlobal(0,0)
        console.log(globalCordinates.x)
        console.log(globalCordinates.y)
    }

    Rectangle {

        id: droppedRectangle
        color: "white"
        border.width: 1
        height: parent.height
        width: parent.width

    }

}

