import QtQuick 2.12
import QtQuick.Controls 2.4


TableView {
    id: testQueryResult
    model: QueryStatsModel
    columnWidthProvider: function (column) { return 100; }
    rowHeightProvider: function (column) { return 30; }
    width: parent.width
    visible: false
    columnSpacing: 1
    rowSpacing: 1
    height:parent.height
    boundsBehavior : Flickable.StopAtBounds
    clip:true
    ScrollBar.horizontal: ScrollBar{}
    ScrollBar.vertical: ScrollBar{}
    topMargin: columnsHeader.implicitHeight

    delegate: Rectangle {
        Text {
            text: display
            anchors.fill: parent
            anchors.margins: 10
            color: 'black'
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter

        }
    }
    Rectangle { // mask the headers
        z: 3
        color: "#222222"
        y: dataPreviewResult.contentY
        x: dataPreviewResult.contentX
        width: dataPreviewResult.leftMargin
        height: dataPreviewResult.topMargin
    }

    // Table Header Starts

    Row {
        id: columnsHeader
        y: testQueryResult.contentY
        z: 3
        width: parent.width


        Label {
            id: numberCoulmn
            width: parent.width/5 // 20% of width
            height: 30
            text: "#"
            color: 'black'
            padding: 10
            leftPadding: 20
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: 'white'
            }

        }
        Label {
            id: actionCoulmn
            width: parent.width/2.5 // 40% of width
            height: 30
            text: "Duration"
            color: 'black'
            padding: 10
            leftPadding: 20
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: 'white'
            }

        }
        Label {

            id: messageColumn
            width: parent.width /2.5 // 40% of width
            height: 30
            text: "Query"
            color: 'black'
            padding: 10
            leftPadding: 20
            verticalAlignment: Text.AlignVCenter
            background: Rectangle{
                color: 'white'
            }

        }
        //            Label {
        //                id: durationColumn
        //                width: parent.width  - ( statusColumn.width + numberCoulmn.width + actionCoulmn.width + messageColumn.width)
        //                height: 30
        //                text: "Duration"
        //                color: 'black'
        //                padding: 10
        //                leftPadding: 20
        //                verticalAlignment: Text.AlignVCenter
        //                background: Rectangle{
        //                    color: 'white'
        //                }

        //            }

    }
    // Table Header Ends

    // Table Header Ends

    ScrollIndicator.horizontal: ScrollIndicator { }
    ScrollIndicator.vertical: ScrollIndicator { }

}

