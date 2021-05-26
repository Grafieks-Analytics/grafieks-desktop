import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import com.grafieks.singleton.constants 1.0
//import QtQuick 2.15

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

//import QtQuick 2.12
//import QtQuick.Controls 2.12

//ApplicationWindow {
//    visible: true
//    width: 640
//    height: 480
//    title: qsTr("Scroll")



//    Flickable {
//         id: flick

//         width: 300;
//         height: 200;
//         contentWidth: edit.paintedWidth
//         contentHeight: edit.paintedHeight
//         clip: true
//         ScrollBar.vertical: ScrollBar {
//                    active: flick.moving || !flick.moving
//                }

//         function ensureVisible(r)
//         {
//             if (contentX >= r.x)
//                 contentX = r.x;
//             else if (contentX+width <= r.x+r.width)
//                 contentX = r.x+r.width-width;
//             if (contentY >= r.y)
//                 contentY = r.y;
//             else if (contentY+height <= r.y+r.height)
//                 contentY = r.y+r.height-height;
//         }

//         TextEdit {
//             id: edit
//             width: flick.width
//             focus: true
//             wrapMode: TextEdit.Wrap
//             onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
//         }
//     }



//ScrollView {
////    anchors.fill: parent
//    anchors.top: a.bottom
//    height: 500
//    width: parent.width


//    ScrollBar.vertical: ScrollBar {
//        id: verticalBar
//        anchors.top: parent.top
//        anchors.bottom: parent.bottom
//        anchors.right: parent.right
//        hoverEnabled: true
//        active: hovered || pressed

//        property bool showIt: hovered || pressed

//        background: Rectangle {
//            implicitWidth: 25
//            implicitHeight: 40
//            radius: 5
//            color: verticalBar.showIt ? "grey" : "transparent"
//        }

//        contentItem: Item {
//            implicitWidth: 25
//            implicitHeight: 40
//            Rectangle {
//                anchors.fill: parent
//                anchors.topMargin: 6
//                anchors.leftMargin: 4
//                anchors.rightMargin: 4
//                anchors.bottomMargin: 6
//                radius: 10
//                color: verticalBar.showIt ? "#424246" : "transparent"
//            }
//        }
//    }

//    TextEdit {
//        width: parent.width
// wrapMode: TextEdit.WordWrap
//textMargin : 50
//        textFormat: Text.AutoText
//        focus: true
//        selectByMouse: true
//z:-5
//        text: "asdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdfasdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdfasdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdfasdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdfasdf\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nasdf"
//    }
//}
//}
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

//                            clip: true
//                               // ...
//                               ScrollBar.vertical: ScrollBar {
//                                   parent: flickable.parent
//                                   anchors.top: flickable.top
//                                   anchors.left: flickable.right
//                                   anchors.bottom: flickable.bottom
//                               }

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




Rectangle {
    id: win
    width: 860
    height: 560
    visible: true

    property var roleNames:["a", "b", "c"]
    property var newObject: []

    Connections{
        target: QueryModel

        // This one is for table data
        function onSqlHasData(hasData){
            view.model = hasData === true? QueryModel: ""

        }

        // This slot is for updating headers
        // This is also returning an array of strings
        function onHeaderDataChanged(tableHeaders){
            if(tableHeaders.length > 0){
                roleNames = []
                roleNames = tableHeaders

                for(var i=0; i<roleNames.length; i++){
                    var role  = roleNames[i]
                    var columnString = 'import QtQuick 2.3; import QtQuick.Controls 1.2; TableViewColumn {role: "' + role + '"; title: "' + role + '"; }';
                    newObject[i] = Qt.createQmlObject(columnString, view)
                    view.addColumn(newObject[i])
                }
            }
        }

    }

    // This one is to clear the table
    function clearTable(){
        for(var i=0; i<roleNames.length; i++){
            view.removeColumn(newObject[i])
            delete newObject[i]

        }
    }


    Button{
        id: clearBtn
        text: "Clear"
        height: 30
        onClicked: clearTable()
    }

    TableView {
        id:view
        width: parent.width
        height: parent.height - clearBtn.height
        anchors.top: clearBtn.bottom
        alternatingRowColors: false
        style: TableViewStyle {
            headerDelegate: Rectangle {
                height: textItem.implicitHeight * 1.2
                width: textItem.implicitWidth
                color: "lightgrey"
                Text {
                    id: textItem
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    text: styleData.value
                    elide: Text.ElideRight
                    color: textColor
                    renderType: Text.NativeRendering

                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    anchors.topMargin: 1
                    width: 1
                    color: "black"
                    border.color: "black"
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: "black"
                    border.color: "black"
                }
            }

            itemDelegate: Rectangle {
                color: "white"
                Text {
                    id: textItem1
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: styleData.textAlignment
                    anchors.leftMargin: 12
                    text: modelData
                    elide: Text.ElideRight
                    color: textColor
                    renderType: Text.NativeRendering
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 1
                    color: "black"
                    border.color: "black"
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: "black"
                    border.color: "black"
                }
            }
        }
    }
}



