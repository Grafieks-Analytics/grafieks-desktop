import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

// Data Preview - Table View From Query Results

TableView {
    id: dataPreviewResult

    columnWidthProvider: function (column) { return 100; }
    rowHeightProvider: function (column) { if(column < DSParamsModel.displayRowsCount) {return 30;} else {return 0;} }
    anchors.fill: parent
    topMargin: columnsHeader1.implicitHeight
    width: parent.width
    model: QueryModel
    ScrollBar.horizontal: ScrollBar{}
    ScrollBar.vertical: ScrollBar{}
    clip: true
    boundsBehavior : Flickable.StopAtBounds



    delegate: Rectangle {
        Text {
            text: display
            anchors.fill: parent
            anchors.margins: 10
            color: 'black'
            font.pixelSize: 15
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
        id: columnsHeader1
        y: dataPreviewResult.contentY
        z: 2
        Repeater {
            model: dataPreviewResult.columns > 0 ? dataPreviewResult.columns : 1
            Label {
                id : label
                width: dataPreviewResult.columnWidthProvider(modelData)
                height: 35
                text: QueryModel.headerData(modelData, Qt.Horizontal)
                color: 'black'
                font.pixelSize: 15
                padding: 10
                verticalAlignment: Text.AlignVCenter

                background: Rectangle { color: "white" }
            }

        }
    }

    // Table Header Ends

    ScrollIndicator.horizontal: ScrollIndicator { }
    ScrollIndicator.vertical: ScrollIndicator { }
}
