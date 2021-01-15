import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: win
    width: 860
    height: 560
    visible: true

    ListModel {
        id: libraryModel
        ListElement {
            title: "A Masterpiece"
            author: "Gabriel"
        }
        ListElement {
            title: "Brilliance"
            author: "Jens"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
        ListElement {
            title: "Outstanding"
            author: "Frederik"
        }
    }

    TableView {

        width: parent.width
        height: parent.height

        alternatingRowColors: false


        TableViewColumn {
            role: "title"
            title: "Title"
            width: parent.width/2
        }
        TableViewColumn {
            role: "author"
            title: "Author"
            width: parent.width/2


        }
        model: libraryModel

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
                    //                    anchors.right: parent.right
                    //                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //                    anchors.bottomMargin: 1
                    //                    anchors.topMargin: 1
                    width: parent.width
                    height: 1

                    color: "black"
                    border.color: "black"
                }
            }

            itemDelegate: Rectangle {
                height: textItem.implicitHeight * 1.2
                width: textItem.implicitWidth
                color: "white"
                //                border.color: "black"
                Text {
                    id: textItem1
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
                    //                    anchors.bottomMargin: 1
                    //                    anchors.topMargin: 1
                    width: 1
                    color: "black"
                    border.color: "black"
                }
                Rectangle {
                    //                    anchors.right: parent.right
                    //                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //                    anchors.bottomMargin: 1
                    //                    anchors.topMargin: 1
                    width: parent.width
                    height: 1

                    color: "black"
                    border.color: "black"
                }
            }

            //            rowDelegate: Rectangle {
            //                height: textItem.implicitHeight * 1.2
            //                width: textItem.implicitWidth
            ////                color: "green"
            //                border.color: "black"
            ////                Text {
            ////                    id: textItem1
            ////                    anchors.fill: parent
            ////                    verticalAlignment: Text.AlignVCenter
            ////                    horizontalAlignment: styleData.textAlignment
            ////                    anchors.leftMargin: 12
            ////                    text: "ravi"
            ////                    elide: Text.ElideRight
            ////                    color: textColor
            ////                    renderType: Text.NativeRendering

            ////                }
            //                Rectangle {
            //                    anchors.right: parent.right
            //                    anchors.top: parent.top
            //                    anchors.bottom: parent.bottom
            //                    anchors.bottomMargin: 1
            //                    anchors.topMargin: 1
            //                    width: 1
            //                    color: "green"
            //                    border.color: "green"
            //                }


            //            }

        }
    }
}
