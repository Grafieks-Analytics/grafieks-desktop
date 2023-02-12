import QtQuick 2.15
import QtQuick.Controls 2.15

import com.grafieks.singleton.constants 1.0

import "../../dataPanesDropHandlers.js" as DataPanesDropHandler


Rectangle{
    id:rightDataDrag
    height: 24
    width: parent.width
    anchors.leftMargin: 5

    z: 200000



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

        if(report_desiner_page.chartTitle==Constants.groupBarChartTitle || report_desiner_page.chartTitle==Constants.horizontalBarGroupedChartTitle){
            var xAxisValidNames = getAxisColumnNames(Constants.xAxisName);
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

    function openMenuCalc(colName, colType){
        CalculatedFields.setCalculatedFieldName(colName)
        CalculatedFields.setCalculatedFieldType(colType)


        console.log("HERE AGAIN", colName)
        console.log("HERE AGAIN2", colType)

        popupcalc.open()
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
        text: key
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
            // onClicked: openMenu()
            onClicked: menuOptionscalc.open()
        }
    }
        Row{

                anchors.right: tableImg.right
                anchors.top: toggleMenuIcon.bottom
                anchors.rightMargin: -70
                width: parent.width-30
                height: 80

                Item {
                    id: name

                    anchors.right:parent.right

                    x: -menuOptions.width

                    Menu{
                        id: menuOptionscalc
                        background: Rectangle{
                            implicitWidth: 200
                            border.color: Constants.darkThemeColor
                        }


                        // Menu{
                        //     id: menuOptionsdsd
                        //     title: qsTr("Rename")

                        //     background: Rectangle{
                        //         implicitWidth: 180

                        //         border.color: Constants.darkThemeColor
                        //     }
                        //      MouseArea{
                        // anchors.fill: parent
                        // // onClicked: openMenu()
                        // onClicked:openMenuCalc()
                        // }  

                        // }
                        Menu{
                            id: menuOptionsdsdl
                            title: qsTr("Create")
                            
                            background: Rectangle{
                                implicitWidth: 180

                                border.color: Constants.darkThemeColor
                            }
                              MenuItem {
                                id:menuItemcreate1
                                implicitHeight: 30
                                leftPadding: 15
                                text: "custom field"

                                onClicked: openMenuCalc(key, itemType.toLowerCase())

                            }
                        // MouseArea{
                        // anchors.fill: parent
                        // // onClicked: openMenu()
                        // onClicked:openMenuCalc()
                        // }  
                        }
                        // Menu{
                        //     id: menuOptionsdsdu
                        //     title: qsTr("Convert To")

                        //     background: Rectangle{
                        //         implicitWidth: 180

                        //         border.color: Constants.darkThemeColor
                        //     }
                        //     MenuItem {
                        //         id:menuItem13
                        //         implicitHeight: 30
                        //         leftPadding: 15
                        //         text: Messages.filterCategorical

                        //         onClicked: changeDataType(colName, colType, tableName, Constants.categoricalTab)

                        //     }
                        //     MenuSeparator{}
                        //     MenuItem {
                        //         id:menuItem23
                        //         implicitHeight: 30
                        //         leftPadding: 15
                        //         text: Messages.filterNumerical

                        //         onClicked: changeDataType(colName, colType, tableName, Constants.numericalTab)
                        //     }

                        // }
                    }
                }


            }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: dataPaneListElement
        drag.onActiveChanged: {
            if (mouseArea.drag.active) {
                if(itemType == "Numerical"){
                    rightDataDrag.color= Constants.defaultNumericalColor
                    rightDataDrag.radius=15
//                    rightDataDrag.width=parent.width+5

                }
                else if(itemType == "Categorical"){
                    rightDataDrag.color= Constants.defaultCategoricalColor
                    rightDataDrag.radius=15
//                    rightDataDrag.width=parent.width+5

                }
                else if(itemType == "Date"){
                    rightDataDrag.color= "yellow"
                    rightDataDrag.radius=15
//                    rightDataDrag.width=parent.width+5

                }



                report_desiner_page.lastPickedDataPaneElementProperties = { itemName: key, tableValue: value , itemType: itemType, dateFormat: Constants.yearFormat };

                ReportParamsModel.itemName = key;
                ReportParamsModel.itemType = itemType;
                
                report_desiner_page.xaxisActive = DataPanesDropHandler.xAxisDropEligible(itemType);
                report_desiner_page.yaxisActive = DataPanesDropHandler.yAxisDropEligible(itemType);

                report_desiner_page.row3Active = DataPanesDropHandler.row3AxisDropEligible(itemType);
                report_desiner_page.row4Active = DataPanesDropHandler.row4AxisDropEligible(itemType);

                if(isDropEligible(itemType, key)){
                    ReportParamsModel.setColorByActive(true);
                }else{
                    ReportParamsModel.setColorByActive(false);
                }
            }else{
                rightDataDrag.color= "white"
                rightDataDrag.radius=0

                report_desiner_page.xaxisActive = false;
                report_desiner_page.yaxisActive = false;

                ReportParamsModel.setColorByActive(false);
                report_desiner_page.row3Active = false;
                report_desiner_page.row4Active = false;
                
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
