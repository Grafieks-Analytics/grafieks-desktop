import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    id : somepageid


    TableView {
            id: tableView

            columnWidthProvider: function (column) { return 100; }
            rowHeightProvider: function (column) { return 60; }
            anchors.fill: parent
            leftMargin: rowsHeader.implicitWidth
            topMargin: columnsHeader.implicitHeight
            model: QtTest2
            ScrollBar.horizontal: ScrollBar{}
            ScrollBar.vertical: ScrollBar{}
            clip: true
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
                y: tableView.contentY
                x: tableView.contentX
                width: tableView.leftMargin
                height: tableView.topMargin
            }

            Row {
                id: columnsHeader
                y: tableView.contentY
                z: 2
                Repeater {
                    model: tableView.columns > 0 ? tableView.columns : 1
                    Label {
                        width: tableView.columnWidthProvider(modelData)
                        height: 35
                        text: QtTest2.headerData(modelData, Qt.Horizontal)
                        color: '#aaaaaa'
                        font.pixelSize: 15
                        padding: 10
                        verticalAlignment: Text.AlignVCenter

                        background: Rectangle { color: "#333333" }
                    }
                }
            }
            Column {
                id: rowsHeader
                x: tableView.contentX
                z: 2
                Repeater {
                    model: tableView.rows > 0 ? tableView.rows : 1
                    Label {
                        width: 60
                        height: tableView.rowHeightProvider(modelData)
                        text: QtTest2.headerData(modelData, Qt.Vertical)
                        color: '#aaaaaa'
                        font.pixelSize: 15
                        padding: 10
                        verticalAlignment: Text.AlignVCenter

                        background: Rectangle { color: "#333333" }
                    }
                }
            }

            ScrollIndicator.horizontal: ScrollIndicator { }
            ScrollIndicator.vertical: ScrollIndicator { }
        }

}
