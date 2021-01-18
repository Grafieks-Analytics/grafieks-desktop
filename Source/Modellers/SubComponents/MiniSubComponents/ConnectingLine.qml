import QtQuick 2.15
import QtQuick.Shapes 1.15

import com.grafieks.singleton.constants 1.0

// This is the dynamically generated line connecting two rectangles
// when a relation is to be shown between two tables

Item{
    id: lineItem
    property string lineColor
    property var incomingRectangleFrontX
    property var incomingRectangleFrontY
    property var refRectangleRearX
    property var refRectangleRearY
    property var objectName

    objectName: objectName
    smooth: true
    antialiasing: true
    Shape {
        containsMode: Shape.FillContains




        ShapePath {
            id:shapePath
            strokeStyle: ShapePath.SolidLine
            strokeColor: Constants.buttonBorderColor
            strokeWidth: 1

//            dashPattern: [5,5]
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: refRectangleRearX
            startY: refRectangleRearY

            PathLine {

                id: secondRectCoord;
                x: incomingRectangleFrontX
                y: incomingRectangleFrontY
            }
        }
    }
}
