import QtQuick 2.11
import QtQuick.Controls 2.4

Page{

    Component.onCompleted: {
        console.log(QtTest2)
    }

    Rectangle {
        width: 500
        height: 500
        MouseArea {
            anchors.fill: parent
            Text {
                id: text1
                anchors.verticalCenterOffset: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Testing")
                font.pixelSize: 12
                }
            ListView {
                id: list_view1
                x: 125
                y: 100
                width: 110
                height: 160
                delegate: delegate
                model: QtTest2
            }
        }
    }

    Item {
        id: delegate
        width: delegate.ListView.view.width;
        height: 30
        clip: true
        anchors.margins: 4
        Row {
            anchors.margins: 4
            anchors.fill: parent
            spacing: 4;
            Text {
                text: username
                width: 150
            }
            Text {
                text: password
                width: 300;
            }
            Text {
                text: email
                width: 50;
            }
        }
    }

}
