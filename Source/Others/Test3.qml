import QtQuick 2.15

Item{

    id: x1
    width: rect1.width
    height: rect1.height

    Rectangle{
        id: rect1
        width: 100
        height: 50
        z: 20
        color: x1.color

        Drag.active: mouseArea1.drag.active
        //    Drag.hotSpot.x: 100
        //    Drag.hotSpot.y: 50


        MouseArea{
            id: mouseArea1
            anchors.fill: parent

            drag.target: rect1
            drag.onActiveChanged: {
                rect1.Drag.drop();

            }
        }

        DropArea{
            id: dropArea1
            anchors.fill: parent
        }
    }
}
