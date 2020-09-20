import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.15

import com.grafieks.singleton.constants 1.0

import "../MainSubComponents"



//Rectangle {
//    width: parent.width / 2
//    height: parent.height
//    anchors.right: parent.right
//    color: "#aaff0011"



//    DropArea {
//        id: dropArea
//        anchors.fill: parent
//        onDropped: {
//            listView.model.remove(listView.dragItemIndex);
//            listView.dragItemIndex = -1;
//        }
//    }
//}

Page{
    id: page
    width: parent.width
    height: parent.height


    function onResizeRectangle(mouse){
           console.log(mouse.x)
           console.log(mouse.y)
    }


    Rectangle{

        id: rect

        width: 100
        height: 200
        color: "red"

        x:100
        y:100

    }

    ToolSeparator{
        id: leftWall
        anchors.left: rect.left
        height: rect.height
        width: 10

        x:100
        y:100

        background: Rectangle{
            color: "black"
        }
    }

}

