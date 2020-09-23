import QtQuick 2.15
import QtQuick.Controls 2.15

import "../MainSubComponents"

Page{
    width: parent.width
    height: parent.height

    property int counter : 3

    Rectangle{
        id: mainRect
        width: parent.width
        height: parent.height
        color: "lightgrey"
        z: 1

        DropArea{
            id: mainDropAre
            anchors.fill: parent
            onDropped: {

                drop.accept(Qt.IgnoreAction)
                console.log("Dropped")
            }
        }
    }

    // Rectangle 1
    Rectangle{
        id: rect1
        width: 100
        height: 50
        color: "beige"
        z: 2

        Drag.active: mouseArea1.drag.active

        MouseArea{
            id: mouseArea1
            anchors.fill: parent

            drag.target: rect1
            drag.onActiveChanged: {
                rect1.Drag.drop();
                if(drag.active === true){
                    counter++
                    rect1.z = counter
                    dropArea1.anchors.fill = hideRect1
                    dropArea2.anchors.fill = rect2
                }
            }

        }

        Rectangle{
            id: hideRect1
            width: 1
            height: 1
            anchors.centerIn: parent
        }

        DropArea{
            id: dropArea1
            anchors.fill: parent
            onDropped: console.log("Dropped on Rect1")
        }


    }

    // Rectangle 2
    Rectangle{
        id: rect2
        width: 100
        height: 50
        color: "gold"
        z: 3

        Drag.active: mouseArea2.drag.active

        MouseArea{
            id: mouseArea2
            anchors.fill: parent

            drag.target: rect2
            drag.onActiveChanged: {
                rect2.Drag.drop();
                if(drag.active === true){
                    counter++
                    rect2.z = counter
                    dropArea2.anchors.fill = hideRect2
                    dropArea1.anchors.fill = rect1
                }
            }
        }

        Rectangle{
            id: hideRect2
            width: 1
            height: 1
            anchors.centerIn: parent
        }

        DropArea{
            id: dropArea2
            anchors.fill: parent
            onDropped: console.log("Dropped on Rect2")
        }
    }
}
