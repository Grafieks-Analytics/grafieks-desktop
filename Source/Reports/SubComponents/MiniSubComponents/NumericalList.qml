import QtQuick 2.0


ListView{
    id: numericalList
    property string itemName: "";

    ListModel{
        id: numericalModel
        ListElement{
            categoricalName: "Numerical "
        }
        ListElement{
            categoricalName: "Numerical 2"
        }
        ListElement{
            categoricalName: "Numerical 3"
        }
        ListElement{
            categoricalName: "Numerical 4"
        }
    }

    model: numericalModel
    anchors.top: numericalHeading.bottom
    anchors.topMargin: 5
    height: parent.height - numericalHeading.height - 5
    width: parent.width
    interactive: false
    delegate: Rectangle{
        id: numericalListElement
        height: 24
        width: parent.width
        Image {
            id: numericalImage
            source: "/Images/icons/AB.png"
            height: 16
            width: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: categoricalName
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: numericalImage.right
            anchors.leftMargin: 10
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: numericalListElement
            drag.onActiveChanged: {
                if (mouseArea.drag.active) {
                    numericalList.itemName = categoricalName;
                }
                numericalListElement.Drag.drop();
            }
        }

        states: [
            State {
                when: numericalListElement.Drag.active
                ParentChange {
                    target: numericalListElement
                    parent: numericalList
                }

                AnchorChanges {
                    target: numericalListElement
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


