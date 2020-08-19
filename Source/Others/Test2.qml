import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

Page{
    id:dragRect

    property var firstRectCoordinateBack : Qt.point(0, 0)
    property var secondRectCoordinateFront : Qt.point(0, 0)


    Rectangle{
        height: parent.height
        width: parent.width

        MouseArea{
            anchors.fill: parent

            DropArea{
                anchors.fill: parent
            }
        }
    }

    Rectangle{
        id: rect1
        color: "gold"
        height: 30
        width: 50
        x: 100
        y:100

        MouseArea{
            anchors.fill: parent
            drag.target: rect1

            onPositionChanged: {
                firstRectCoordinateBack.x = rect1.x + rect1.width
                firstRectCoordinateBack.y = rect1.y + (rect1.height / 2)

                shapePath.startX = firstRectCoordinateBack.x
                shapePath.startY = firstRectCoordinateBack.y
            }

        }
    }

    Rectangle{
        id: rect2
        color: "silver"
        height: 30
        width: 50
        x: 200
        y:200

        MouseArea{
            anchors.fill: parent
            drag.target: rect2

            onPositionChanged: {
                secondRectCoordinateFront.x = rect2.x
                secondRectCoordinateFront.y = rect2.y + (rect2.height / 2)

                secondRectCoord.x = secondRectCoordinateFront.x
                secondRectCoord.y = secondRectCoordinateFront.y
            }
        }
    }


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

                    console.log(shapePath.startX, shapePath.startY, secondRectCoord.x, secondRectCoord.y, invisibleCircle.x, invisibleCircle.y)

                }
            }

            onStartXChanged: {
                invisibleCircle.x = shapePath.startX <= secondRectCoord.x ? shapePath.startX + Math.abs(shapePath.startX - secondRectCoord.x) / 2 : secondRectCoord.x + Math.abs(shapePath.startX - secondRectCoord.x) / 2
                invisibleCircle.y = shapePath.startY <= secondRectCoord.y ? shapePath.startY + Math.abs(shapePath.startY - secondRectCoord.y) / 2 : secondRectCoord.y + Math.abs(shapePath.startY - secondRectCoord.y) / 2

                console.log(shapePath.startX, shapePath.startY, secondRectCoord.x, secondRectCoord.y)
            }

        }


        TapHandler{
            onTapped: console.log("tapped")
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
