import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

// This is the Image Widget dynamically called from MainContainer
// when a column is dropped from right side customize


Item{

    visible: true
    anchors{
        top: mainContainer.top
        left: mainContainer.left
        right: mainContainer.right
        bottom: mainContainer.bottom

    }

    Rectangle {

        color: "white"
        border.width: 1
        border.color: "grey"

        width: parent.width
        height: parent.height

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Text{
            text: 'Choose Image'
            anchors.centerIn: parent
        }

    }

}

