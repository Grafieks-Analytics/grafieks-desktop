import QtQuick 2.0

ListView{

    property string itemName: "";
    property string itemType: "Date";



    /***********************************************************************************************************************/
    // LIST MODEL STARTS


    ListModel{
        id: dateModel
        ListElement{
            categoricalName: "Date 1"
        }
        ListElement{
            categoricalName: "Dateas dsa dsa sasad as "
        }
        ListElement{
            categoricalName: "Date 2"
        }
        ListElement{
            categoricalName: "date 3"
        }
    }


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


    function openMenu(){
        console.log('Open Menu')
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


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts

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
            source: "/Images/icons/date_field.png"
            height: 16
            width: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: categoricalName
            width: parent.width - dateImage.width - menuButton.width - 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: dateImage.right
            anchors.leftMargin: 10
            elide: Text.ElideRight
        }

        Image {
            id: menuButton
            source: "/Images/icons/menu-button.png"
            height: 18
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
            drag.target: dateListElement
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
