import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {

    id : somepageid

    Component.onCompleted: {
        QueryStatsModel.callQuery()
    }

    ListModel{
        id: x
        ListElement{
            name: "a"
            surname: "b"
        }
    }

    TableView{
        model: QueryStatsModel
        height: 500
        width: 400
        delegate:
            Text {
            text: display

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
                    text: QueryStatsModel.headerData(modelData, Qt.Horizontal)
                    color: 'black'
                    font.pixelSize: 15
                    padding: 10
                    verticalAlignment: Text.AlignVCenter

                    background: Rectangle { color: "white" }
                }
            }
        }
    }

}
