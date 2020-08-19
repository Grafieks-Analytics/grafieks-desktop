import QtQuick 2.15
import QtQuick.Shapes 1.15

import com.grafieks.singleton.constants 1.0

// This is the dynamically generated line connecting two rectangles
// when a relation is to be shown between two tables

Item{
    id: lineItem
    property string lineColor: shapePath.strokeColor
    property var incomingRectangleFrontX
    property var incomingRectangleFrontY
    property var refRectangleFrontX
    property var refRectangleFrontY

    Shape {
        containsMode: Shape.FillContains

        ShapePath {
            id:shapePath
            strokeColor: "black"
            strokeWidth: 1
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: firstRectCoordinateBack.x
            startY: firstRectCoordinateBack.y

            PathLine {
                id: secondRectCoord;
                x: secondRectCoordinateFront.x ;
                y: secondRectCoordinateFront.y;
                onXChanged: {
                    invisibleCircle.x = shapePath.startX <= secondRectCoord.x ? shapePath.startX + Math.abs(shapePath.startX - secondRectCoord.x) / 2 : secondRectCoord.x + Math.abs(shapePath.startX - secondRectCoord.x) / 2
                    invisibleCircle.y = shapePath.startY <= secondRectCoord.y ? shapePath.startY + Math.abs(shapePath.startY - secondRectCoord.y) / 2 : secondRectCoord.y + Math.abs(shapePath.startY - secondRectCoord.y) / 2

    //                    console.log(shapePath.startX, shapePath.startY, secondRectCoord.x, secondRectCoord.y, invisibleCircle.x, invisibleCircle.y)
                }
            }

            onStartXChanged: {
                invisibleCircle.x = shapePath.startX <= secondRectCoord.x ? shapePath.startX + Math.abs(shapePath.startX - secondRectCoord.x) / 2 : secondRectCoord.x + Math.abs(shapePath.startX - secondRectCoord.x) / 2
                invisibleCircle.y = shapePath.startY <= secondRectCoord.y ? shapePath.startY + Math.abs(shapePath.startY - secondRectCoord.y) / 2 : secondRectCoord.y + Math.abs(shapePath.startY - secondRectCoord.y) / 2

    //                console.log(shapePath.startX, shapePath.startY, secondRectCoord.x, secondRectCoord.y)
            }
        }
    }

    Rectangle{
        id: invisibleCircle
        width:20
        height:20
        color: "red"
        radius: 10

        MouseArea{
            anchors.fill: parent
            onClicked: {
                console.log("join")
            }
        }
    }
}
