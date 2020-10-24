import QtQuick 2.0

ListView{

    id:categoricalList

    ListModel{
        id: categoricalModel
        ListElement{
            categoricalName: "Customer Name"
        }
        ListElement{
            categoricalName: "Customer Name 1"
        }
        ListElement{
            categoricalName: "Customer Name 2"
        }
        ListElement{
            categoricalName: "Customer Name 3"
        }
    }


    model: categoricalModel
    anchors.top: categoricalHeading.bottom
    anchors.topMargin: 5
    height: parent.height - categoricalHeading.height - 5
    width: parent.width
    interactive: false
    delegate: Rectangle{
        id: categoricalListElement
        height: 24
        width: parent.width
        Image {
            id: categoricalImage
            source: "/Images/icons/AB.png"
            height: 16
            width: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: categoricalName
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: categoricalImage.right
            anchors.leftMargin: 10
        }


        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: categoricalListElement
            drag.onActiveChanged: {
                if (mouseArea.drag.active) {
                    categoricalList.itemName = categoricalName;
                }
                categoricalListElement.Drag.drop();
            }
        }

        states: [
            State {
                when: categoricalListElement.Drag.active
                ParentChange {
                    target: categoricalListElement
                    parent: categoricalList
                }

                AnchorChanges {
                    target: categoricalListElement
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            }
        ]

        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: 2
        Drag.hotSpot.y: 2
    }

}
