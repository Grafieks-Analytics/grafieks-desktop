import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtWebEngine 1.10
import QtQuick.Shapes 1.15

Rectangle{
    id:dragRect

    height: 40
    width: 60
    color: "blue"


    signal clicked(double x, double y);

    MouseArea{
        id: mArea
        anchors.fill: parent
        drag.target: dragRect

        onReleased: {
            console.log("Child", dragRect.x, dragRect.y)
            dragRect.clicked(dragRect.x, dragRect.y)
        }

    }
}
