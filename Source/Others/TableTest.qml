import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: win
    width: 860
    height: 560
    visible: true


    TableView {

        width: parent.width
        height: parent.height

        alternatingRowColors: false
        model: QueryStatsModel


        TableViewColumn {
            role: "no"
            title: "#"
            width: parent.width/4
        }
        TableViewColumn {
            role: "duration"
            title: "Duration"
            width: parent.width/4
        }
        TableViewColumn {
            role: "action"
            title: "Action"
            width: parent.width/4
        }
        TableViewColumn {
            role: "message"
            title: "Message"
            width: parent.width/4


        }



        //        style: TableViewStyle {
        //            headerDelegate: Rectangle {
        //                height: textItem.implicitHeight * 1.2
        //                width: textItem.implicitWidth
        //                color: "lightgrey"
        //                Text {
        //                    id: textItem
        //                    anchors.fill: parent
        //                    verticalAlignment: Text.AlignVCenter
        //                    horizontalAlignment: styleData.textAlignment
        //                    anchors.leftMargin: 12
        //                    text: styleData.value
        //                    elide: Text.ElideRight
        //                    color: textColor
        //                    renderType: Text.NativeRendering

        //                }
        //                Rectangle {
        //                    anchors.right: parent.right
        //                    anchors.top: parent.top
        //                    anchors.bottom: parent.bottom
        //                    anchors.bottomMargin: 1
        //                    anchors.topMargin: 1
        //                    width: 1
        //                    color: "black"
        //                    border.color: "black"
        //                }
        //                Rectangle {
        //                    anchors.bottom: parent.bottom
        //                    width: parent.width
        //                    height: 1

        //                    color: "black"
        //                    border.color: "black"
        //                }
        //            }

        itemDelegate: Rectangle {
            height: textItem.implicitHeight * 1.2
            width: textItem.implicitWidth
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

