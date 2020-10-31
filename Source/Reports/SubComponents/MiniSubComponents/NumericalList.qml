import QtQuick 2.0


ListView{
    id: numericalList

    property string itemType: "Numerical"

    ListModel{
        id: numericalModel
        ListElement{
            categoricalName: "Numerical "
        }
        ListElement{
            categoricalName: "Numerical 2"
        }
        ListElement{
            categoricalName: "Numerical 3 23 23 23 232"
        }
        ListElement{
            categoricalName: "Numerical 4"
        }
    }

    function appendToList(name){
          numericalModel.append({categoricalName: name});
    }

    function isDropEligible(itemType){
        if(dataType == ""){
            return true;
        }
        if(dataType && dataType !== itemType){
            return false;
        }
        if(itemType.toLowerCase() === "numerical"){
            return true;
        }
        return false;
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
            source: "/Images/icons/fx.png"
            height: 16
            width: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: categoricalName
            width: parent.width - numericalImage.width - menuButton.width - 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: numericalImage.right
            anchors.leftMargin: 10
            elide: Text.ElideRight
        }

        Image {
            id:menuButton
            source: "/Images/icons/menu-button.png"
            height: 20
            width: 20
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            z:100
            MouseArea{
                anchors.fill: parent
                onClicked: openMenu()
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: numericalListElement
            drag.onActiveChanged: {
                if (mouseArea.drag.active) {
                    ReportParamsModel.itemName = categoricalName;
                    ReportParamsModel.itemType = itemType;
                    ReportParamsModel.setXAxisActive(true);
                    ReportParamsModel.setYAxisActive(true);
                    if(isDropEligible(itemType)){
                        ReportParamsModel.setColorByActive(true);
                    }else{
                        ReportParamsModel.setColorByActive(false);
                    }

                }else{
                    ReportParamsModel.setXAxisActive(false);
                    ReportParamsModel.setYAxisActive(false);
                    ReportParamsModel.setColorByActive(false);
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


