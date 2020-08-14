import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtWebEngine 1.10
import QtQuick.Shapes 1.15



Page {
    id : somepageid

    Rectangle {
        color: "lightGray"

        Shape {
            id: circ1
            anchors.fill: parent
            containsMode: Shape.BoundingRectContains
            z:3

            ShapePath {
                strokeColor: "black"
                strokeWidth: 10
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                property int joinStyleIndex: 2

                property variant styles: [
                    ShapePath.BevelJoin,
                    ShapePath.MiterJoin,
                    ShapePath.RoundJoin
                ]

                joinStyle: styles[joinStyleIndex]

                startX: 30
                startY: 30
                PathLine { x: 100; y: 100 }
                PathLine { x: 30; y: 100 }


            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("hello")
                }
            }
        }


    }
}
