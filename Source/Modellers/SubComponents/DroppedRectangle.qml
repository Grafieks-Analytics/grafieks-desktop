import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

// This is the rectangle dynamically called in DataModeller
// when a column is dropped from right side listview


Item{

    id: newItem
    visible: true
    width: droppedRectangle.width
    height: droppedRectangle.height
    property string name: nameID.text
    property var objectName

    objectName: objectName

    signal dragged(double x, double y);
    signal dropped(double x, double y);
    signal destroyComponents(int counter)
    signal refObjectCount(int counter, int objectWidth)


    Component.onCompleted: {
        nameID.text = name
        droppedRectangle.width = nameID.text.length * 10 + 30
    }

    function onRectangleToggle(){
        droppedRectangle.height = droppedRectangle.height === 30 ? 60 : 30
    }

    function destroyRectangle(counter){
        newItem.destroy()
        destroyComponents(counter)
    }


    Rectangle {

        id: droppedRectangle
        color: "white"
        border.width: 1
        border.color: "grey"
        height: 30


        Text{
            id: nameID
            text: text
            anchors.centerIn: parent

        }

        Image{
            id: removeIcon
            source : "../../../Images/icons/remove.png"
            anchors.right: droppedRectangle.right
            anchors.rightMargin: 10
            anchors.verticalCenter: droppedRectangle.verticalCenter
            z: 5

            MouseArea{
                anchors.fill: parent
                onClicked: destroyRectangle(parseInt(newItem.objectName))
            }

        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: newItem

            onDoubleClicked: onRectangleToggle()
            onReleased: newItem.dropped(newItem.x, newItem.y)
            onPositionChanged: newItem.dragged(newItem.x, newItem.y)
            onPressed: newItem.refObjectCount(parseInt(newItem.objectName), newItem.width, newItem.height)
        }


    }

}

