import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"

Page{

    id: root


    function buttonClicked(a,b){
        console.debug("not here", a,b);
    }

    // On Dropped
    function onDropAreaDropped(drag){
        console.log(JSON.stringify(drag))
    }

    // On Entered
    function onDropAreaEntered(drag){
        console.log(JSON.stringify(drag))
    }

    // This is the Drop area code
    Rectangle{
        id: dropRectangle
        color: "beige"
        width: parent.width
        height: parent.height

        DropArea {
            id: dropArea
            anchors.fill: parent
            onEntered: onDropAreaEntered(drag)
            onDropped: onDropAreaDropped(drag)
        }

        // This creates the new rectangle component
        Component.onCompleted: {
            var dynamicRectangle2 = Qt.createComponent("Test2.qml");
            var newRect =  dynamicRectangle2.createObject(root, {x:100, y: 100})
            newRect.clicked.connect(buttonClicked)
        }
    }

}
