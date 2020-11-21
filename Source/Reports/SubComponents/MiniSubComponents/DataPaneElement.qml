import QtQuick 2.15
import QtQuick.Controls 2.15


Rectangle{
    height: 24
    width: parent.width


    function isDropEligible(itemType){
        var lastDropped = ReportParamsModel.lastDropped;
        if(!lastDropped){
            return true;
        }
        if(lastDropped !== itemType){
            return false;
        }
        if(itemType.toLowerCase() === "numerical"){
            return true;
        }
        return false;
    }

    function openMenu(){
        dataPaneMenu.visible = true
    }

    DataPaneMenu{
        id: dataPaneMenu
    }

    Image {
        id: categoricalImage
        source: "/Images/icons/AB.png"
        height: 16
        width: 20
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: categoricalName
        width: parent.width - categoricalImage.width - menuButton.width - 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: categoricalImage.right
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
        drag.target: categoricalListElement
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
