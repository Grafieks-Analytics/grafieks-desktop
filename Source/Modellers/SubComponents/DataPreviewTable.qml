import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3


TableView {
    id: dataPreviewResult

    columnWidthProvider: function (column) { return 100; }
    rowHeightProvider: function (column) { return 30; }
    anchors.fill: parent
    topMargin: columnsHeader1.implicitHeight
    width: parent.width
    model: QtTest2
    ScrollBar.horizontal: ScrollBar{}
    ScrollBar.vertical: ScrollBar{}
    clip: true
    boundsBehavior : Flickable.StopAtBounds

    delegate: Rectangle {
        Text {
            text: 'text'
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

    Row {
        id: columnsHeader1
        y: dataPreviewResult.contentY
        z: 2
        Repeater {
            model: dataPreviewResult.columns > 0 ? dataPreviewResult.columns : 1
            Label {
                width: dataPreviewResult.columnWidthProvider(modelData)
                height: 35
                text: QtTest2.headerData(modelData, Qt.Horizontal)
                //                            text: "s"
                color: 'black'
                font.pixelSize: 15
                padding: 10
                verticalAlignment: Text.AlignVCenter

                background: Rectangle { color: "white" }
            }
        }
    }


    ScrollIndicator.horizontal: ScrollIndicator { }
    ScrollIndicator.vertical: ScrollIndicator { }
}
