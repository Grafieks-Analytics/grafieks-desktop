import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

Rectangle{
    id:rightDataDrag
    height: 24
    width: parent.width
    anchors.leftMargin: 5

    //    z: 999



    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    // LIST MODEL ENDS
    /***********************************************************************************************************************/


    /***********************************************************************************************************************/
    // SIGNALS STARTS



    // SIGNALS ENDS
    /***********************************************************************************************************************/



    /***********************************************************************************************************************/
    // Connections Starts



    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS

    function isDropEligible(itemType, itemName){

        if(report_desiner_page.chartTitle==Constants.groupBarChartTitle){
            var xAxisValidNames = getAxisColumnNames(Constants.xAxisName);
            console.log(xAxisValidNames);
            if(xAxisValidNames.includes(itemName)){
                return true;
            }
            return false;
        }

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


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts


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
        //        z:100
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
                console.log("dragdrag")
                if(itemType == "Numerical"){
                    console.log("itemtypecolor"+itemType)
                    rightDataDrag.color= Constants.defaultNumericalColor
                    rightDataDrag.radius=15
                    rightDataDrag.width=parent.width+5

                }
                else if(itemType == "Categorical"){
                    console.log("itemtypecolor"+itemType)
                    rightDataDrag.color= Constants.defaultCategoricalColor
                    rightDataDrag.radius=15
                    rightDataDrag.width=parent.width+5

                }
                else if(itemType == "Date"){
                    console.log("itemtypecolor"+itemType)
                    rightDataDrag.color= "yellow"
                    rightDataDrag.radius=15
                    rightDataDrag.width=parent.width+5

                }



                report_desiner_page.lastPickedDataPaneElementProperties = { itemName: modelData, itemType: itemType };
                console.log(modelData);

                ReportParamsModel.itemName = modelData;
                ReportParamsModel.itemType = itemType;
                ReportParamsModel.setXAxisActive(xAxisDropEligible(modelData));
                ReportParamsModel.setYAxisActive(yAxisDropEligible(modelData));

                if(isDropEligible(itemType, modelData)){
                    ReportParamsModel.setColorByActive(true);
                }else{
                    ReportParamsModel.setColorByActive(false);
                }
            }else{
                rightDataDrag.color= "white"
                rightDataDrag.radius=0
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
