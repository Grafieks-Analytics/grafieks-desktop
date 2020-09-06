import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

Page{
    id:dragRect

    Rectangle {
        id: root
        width: 400
        height: 400

        ListView {
            id: listView
            width: parent.width / 2
            height: parent.height

            property int dragItemIndex: -1

            model: ListModel {
                Component.onCompleted: {
                    for (var i = 0; i < 10; ++i) {
                        append({value: i});
                    }
                }
            }

            delegate: Item {
                id: delegateItem
                width: listView.width
                height: 50

                Rectangle {
                    id: dragRect2
                    width: listView.width
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: "salmon"
                    border.color: Qt.darker(color)

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        drag.target: dragRect2

                        drag.onActiveChanged: {
                            if (mouseArea.drag.active) {
                                listView.dragItemIndex = index;
                            }
                            dragRect2.Drag.drop();
                        }
                    }

                    states: [
                        State {
                            when: dragRect2.Drag.active
                            ParentChange {
                                target: dragRect2
                                parent: root
                            }

                            AnchorChanges {
                                target: dragRect2
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]

                    Drag.active: mouseArea.drag.active
                    Drag.hotSpot.x: dragRect2.width / 2
                    Drag.hotSpot.y: dragRect2.height / 2
                }
            }
        }

        Rectangle {
            width: parent.width / 2
            height: parent.height
            anchors.right: parent.right
            color: "#aaff0011"

            DropArea {
                id: dropArea
                anchors.fill: parent
                onDropped: {
                    listView.model.remove(listView.dragItemIndex);
                    listView.dragItemIndex = -1;
                }
            }
        }
    }

}
