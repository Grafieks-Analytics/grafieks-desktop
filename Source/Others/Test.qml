import QtQuick 2.15

//Rectangle {

//    function onTextChanging(){
//        console.log(GeneralParamsModel.returnPlainTextFromHtml(xText.text))
//    }

//    Component.onCompleted: {
//         console.log(GeneralParamsModel.returnPlainTextFromHtml(xText.text))
//    }


//    TextEdit{
//        id: xText
//        text:  qsTr("<!DOCTYPE html><html><body><h1 style='font-size:300%;'>This is a heading</h1><p style='font-size:160%;'>This is a paragraph.</p></body>
//</html>
//")
//        height:300
//        width: 500
//        textFormat:TextEdit.RichText
//        onTextChanged: onTextChanging()
//    }
//}

//Rectangle {
//    visible: true
//    width: 640
//    height: 480
//    color: "red"


//    Rectangle{
//        id:rectangle
//        anchors.fill: parent
//        color: "red"
//        TextEdit {
//            id: textEdit
//            text: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
//            font.pointSize: 24
//            height: contentHeight
//            width: parent.width
//            y: 0
//            wrapMode: TextEdit.Wrap

//            MouseArea {
//                anchors.fill: parent
//                drag.target: textEdit
//                drag.axis: Drag.YAxis
//                drag.minimumY: -(parent.height-480)
//                drag.maximumY: 0
//            }
//        }
//    }

//}

import QtQuick 2.12
import QtQuick.Controls 2.12

//ApplicationWindow {
//    visible: true
//    width: 640
//    height: 480
//    title: qsTr("Scroll")

    ScrollView {
        anchors.fill: parent

        ScrollBar.vertical: ScrollBar {
            id: verticalBar
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            hoverEnabled: true
            active: hovered || pressed

            property bool showIt: hovered || pressed

            background: Rectangle {
                implicitWidth: 25
                implicitHeight: 40
                radius: 5
                color: verticalBar.showIt ? "grey" : "transparent"
            }

            contentItem: Item {
                implicitWidth: 25
                implicitHeight: 40
                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 6
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    anchors.bottomMargin: 6
                    radius: 10
                    color: verticalBar.showIt ? "#424246" : "transparent"
                }
            }
        }

        TextEdit {
            width: parent.width

            textFormat: Text.AutoText
            focus: true
            selectByMouse: true

            text: "asdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdfasdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdfasdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdf"
        }
    }
//}

//Flickable {
//              id: flickArea
//              x: 0
//              y: 0
//              width: parent.width; height: parent.height
//              anchors.rightMargin: 0
//              anchors.bottomMargin: 0
//              anchors.leftMargin: 0
//              anchors.topMargin: 0
//              anchors.fill:parent

//              boundsBehavior: Flickable.StopAtBounds
//              flickableDirection: Flickable.HorizontalFlick

//              interactive: true
//                            function ensureVisible(r) {
//                  if (contentX >= r.x)
//                  contentX = r.x;
//                  else if (contentX+width <= r.x+r.width)
//                  contentX = r.x+r.width-width;
//                  if (contentY >= r.y)
//                  contentY = r.y;
//                  else if (contentY+height <= r.y+r.height)
//                  contentY = r.y+r.height-height;
//              }

//              TextEdit {
//                  id: textEdit
//                  x: 0
//                  y: 0

//                  anchors.fill:parent
//                  width:parent.width; height:parent.height
//                  color:fontColor
//                  anchors.rightMargin: 0
//                  anchors.bottomMargin: 0
//                  anchors.leftMargin: 0
//                  anchors.topMargin: 0
//                  focus: true
//                  wrapMode: TextEdit.Wrap
//                  font.pointSize:10
//                  onCursorRectangleChanged: flickArea.ensureVisible(cursorRectangle)

//                  selectByMouse: true
//              }
//          }
