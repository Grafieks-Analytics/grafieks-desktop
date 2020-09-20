import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

// This is the rectangle dynamically called in DataModeller
// when a column is dropped from right side listview


Item{

    id: newItem
    visible: true
//    width: parent.width
//    height: parent.height
    property string name: nameID.text
    property bool alreadyJoined: true
    property var objectName

    objectName: objectName

    signal dragged(double x, double y);
    signal dropped(double x, double y);
    signal destroyComponents(int counter)
    signal refObjectCount(int counter, int objectWidth)

    Component.onCompleted: {
//        nameID.text = name
        droppedRectangle.width = nameID.text.length * 10 + 100
    }

    function onRectangleToggle(){
        textEditor.visible = true
//        droppedRectangle.height = droppedRectangle.height === 30 ? 60 : 30
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

        // Call signal
        parent.dropped(newItem.x, newItem.y)
        console.log(newItem.x)
    }


    Rectangle {

        id: droppedRectangle
        color: "white"
        border.width: 1
        height: parent.height
        width: parent.width

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: newItem

            onDoubleClicked: onRectangleToggle()
            onReleased: onReleasedRectangle(newItem)
            onPositionChanged: newItem.dragged(newItem.x, newItem.y)
            onPressed: newItem.refObjectCount(parseInt(newItem.objectName), newItem.width, newItem.height)
        }


    }

    WidgetTextEditor{
        id: textEditor
    }

    DropArea{

        id: dropAreaRectangle
        anchors.fill: parent
        onEntered:  console.log("entered on rect") //onDropAreaRectangleEntered()
        onDropped: console.log("dropped on rect") //onDropAreaRectangleEntered()

    }
}

