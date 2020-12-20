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
    Connections{
        target : ReportModelList


        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            dateModel.clear()
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

    model: dateModel
    anchors.top: dateHeading.bottom
    anchors.topMargin: 5
    height: parent.height - dateHeading.height - 5
    width: parent.width
    interactive: false
    delegate: DataPaneElement{
        id: dataPaneListElement
    }
}
