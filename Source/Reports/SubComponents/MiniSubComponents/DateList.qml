import QtQuick 2.0
import QtQuick.Controls 2.15

ListView{

    property string itemName: "";
    property string itemType: "Date";
    flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            interactive: true
             clip: false
             ScrollBar.vertical: ScrollBar {}



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
    Connections{
        target : ChartsModel


        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            dateList.model =  allDates

        }
    }


    // Connections Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // JAVASCRIPT FUNCTION STARTS


    function openMenu(){
        console.log('Open Menu')
    }


//    function isDropEligible(itemType){
//        var lastDropped = ReportParamsModel.lastDropped;
//        if(!lastDropped){
//            return true;
//        }
//        if(lastDropped !== itemType){
//            return false;
//        }
//        if(itemType.toLowerCase() === "numerical"){
//            return true;
//        }
//        return false;
//    }


    // JAVASCRIPT FUNCTION ENDS
    /***********************************************************************************************************************/




    /***********************************************************************************************************************/
    // SubComponents Starts



    // SubComponents Ends
    /***********************************************************************************************************************/





    /***********************************************************************************************************************/
    // Page Design Starts

    id: dateList

    anchors.top: dateHeading.bottom
    anchors.topMargin: 5
    height: parent.height - dateHeading.height - 5
    width: parent.width
    delegate: DataPaneElement{
        id: dataPaneListElement
    }
}
