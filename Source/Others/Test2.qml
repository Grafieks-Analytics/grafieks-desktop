import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item{
    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.topMargin: 15
        Layout.bottomMargin: 20
        height: 0.2 * window.height
        spacing: 5

        contentWidth: headerItem.width
        flickableDirection: Flickable.HorizontalAndVerticalFlick

        header: Row {
            spacing: 1
            function itemAt(index) { return repeater.itemAt(index) }
            Repeater {
                id: repeater
                model: [qsTr("date/time:"), qsTr("result:")]
                Label {
                    text: modelData
                    font.bold: true
                    padding: 10
                    //background: Rectangle { color: "silver" }
                }
            }
        }

        function columnWidth(index) { return listView.headerItem.itemAt(index).width }

        model: boardModel.list

        delegate: GridLayout {
            id: grid
            columns: 2
            rows: 1
            width: contentWidth
            flow: GridLayout.LeftToRight

            Text {
                Layout.alignment: Qt.AlignVCenter
                text: time
                width: contentWidth - columnWidth(1)
            }

            Text {
                Layout.alignment: Qt.AlignRight
                text: score
                font.pixelSize: 16
                width: columnWidth(1)
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
