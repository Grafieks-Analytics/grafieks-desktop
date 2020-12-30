import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Rectangle{
    height: 24
    width: parent.width

    function alreadyExists(elementsList,element){
        if(elementsList.includes(element)){
            return true;
        }
        return false;
    }

    function xAxisDropEligible(itemName){
        var xAxisColumns  = ReportParamsModel.xAxisColumns;
        const multiChart = true;
        if(multiChart && !alreadyExists(xAxisColumns,itemName)){
            return true;
        }
        return false;
    }

    function yAxisDropEligible(itemName){
        var yAxisColumns  = ReportParamsModel.yAxisColumns;
        const multiChart = true;
        if(multiChart && !alreadyExists(yAxisColumns,itemName)){
            return true;
        }
        return false;
    }


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

    function getSourceImage(itemType){
        switch(itemType && itemType.toLowerCase()){
            case "categorical": return "/Images/icons/AB.png"
            case "numerical": return "/Images/icons/fx.png"
            case "date": return "/Images/icons/date_field.png"
        }
        return "";
    }

    DataPaneMenu{
        id: dataPaneMenu
        y: parent.height
    }

    Image {
        id: categoricalImage
        source: getSourceImage(itemType)
        height: 16
        width: itemType && itemType.toLowerCase() === Constants.categoricalItemType ? 20 : 16
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: modelData
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
        drag.target: dataPaneListElement
        drag.onActiveChanged: {
            if (mouseArea.drag.active) {
                ReportParamsModel.itemName = modelData;
                ReportParamsModel.itemType = itemType;
                ReportParamsModel.setXAxisActive(xAxisDropEligible(modelData));
                ReportParamsModel.setYAxisActive(yAxisDropEligible(modelData));

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

            dataPaneListElement.Drag.drop();
        }
    }

    states: [
        State {
            when: dataPaneListElement.Drag.active
            ParentChange {
                target: dataPaneListElement
                parent: categoricalList
            }

            AnchorChanges {
                target: dataPaneListElement
                anchors.horizontalCenter: undefined
                anchors.verticalCenter: undefined
            }
        }
    ]

    Drag.active: mouseArea.drag.active
    Drag.hotSpot.x: 2
    Drag.hotSpot.y: 2
}
