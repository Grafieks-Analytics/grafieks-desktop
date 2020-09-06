import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Dialogs 1.2

import com.grafieks.singleton.constants 1.0

// This is the rectangle dynamically called in DataModeller
// when a column is dropped from right side listview


Item{

    id: newItem
    visible: true
    width: droppedRectangle.width
    height: droppedRectangle.height
    property string name: nameID.text
    property bool alreadyJoined: true
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


    function onDropAreaRectangleEntered(){
        console.log("detected")
        var keys = dropAreaRectangle.keys;
        console.log('keys',keys)
    }

    function onReleasedRectangle(parent){

        // Released rectangle
//        parent.Drag.drop();

        // Call signal
        parent.dropped(newItem.x, newItem.y)
        console.log(newItem.x)
    }

    FileDialog{
        id: fileDialog
        title: "Select a file (*.jpg *.jpeg *.png  only)"
        selectMultiple: false
        nameFilters: [ "Image files (*.jpg *.jpeg *.png )"]
    }


    Rectangle {

        id: droppedRectangle
        color: "white"
        border.width: 1
        border.color: "grey"
        height: 100
        width: 100

        Text{
            id: nameID
            text: 'Choose Image'
            anchors.centerIn: parent
        }

        Image{
            id: removeIcon
            source : "../../../../Images/icons/remove.png"
            height: 10
            width: 10
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
            onClicked: fileDialog.open()
            onReleased: onReleasedRectangle(newItem)
            onPositionChanged: newItem.dragged(newItem.x, newItem.y)
            onPressed: newItem.refObjectCount(parseInt(newItem.objectName), newItem.width, newItem.height)
        }



    }
    DropArea{

        id: dropAreaRectangle
        anchors.fill: parent
        onEntered:  console.log("entered on rect") //onDropAreaRectangleEntered()
        onDropped: console.log("dropped on rect") //onDropAreaRectangleEntered()

    }
}

