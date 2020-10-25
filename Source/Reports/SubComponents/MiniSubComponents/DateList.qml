import QtQuick 2.0

ListView{

    property string itemName: "";
    property string itemType: "Date";
    ListModel{
        id: dateModel
        ListElement{
            categoricalName: "Date 1"
        }
        ListElement{
            categoricalName: "Date "
        }
        ListElement{
            categoricalName: "Date 2"
        }
        ListElement{
            categoricalName: "date 3"
        }
    }

    id: dateList

    model: dateModel
    anchors.top: dateHeading.bottom
    anchors.topMargin: 5
    height: parent.height - dateHeading.height - 5
    width: parent.width
    interactive: false

    delegate: Rectangle{
        id: dateListElement
        height: 24
        width: parent.width
        Image {
            id: dateImage
            source: "/Images/icons/AB.png"
            height: 16
            width: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: categoricalName
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: dateImage.right
            anchors.leftMargin: 10
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: dateListElement
            drag.onActiveChanged: {
                if (mouseArea.drag.active) {
                    ReportParamsModel.itemName = categoricalName;
                    ReportParamsModel.itemType = itemType;
                }
                dateListElement.Drag.drop();
            }
        }

        states: [
            State {
                when: dateListElement.Drag.active
                ParentChange {
                    target: dateListElement
                    parent: dateList
                }

                AnchorChanges {
                    target: dateListElement
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
