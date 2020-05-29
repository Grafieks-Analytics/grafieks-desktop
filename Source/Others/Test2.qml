import QtQuick 2.11
import QtQuick.Controls 2.4

Item{
    id: x1

    Component.onCompleted: {

        DBListModel.callQuery()
        list_view1.model = DBListModel
    }

    ListView {
        id: list_view1
        x: 10
        y: 100
        width: parent.width
        height: 160
        delegate: x
    }

//    ListView {
//        id: tableslist
//        anchors.top: categoryItem.bottom

//        delegate: x
//    }

    Component{
        id: x

        Item {
            id: delegate
            width: parent.width;
            height: 30
            clip: true
            anchors.margins: 4
            Row {
                anchors.margins: 4
                anchors.fill: parent
                spacing: 4;
                Text {
                    text: dbName
                    width: delegate.width/3
                }
            }
        }
    }
}
