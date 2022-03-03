import QtQuick 2.0
import QtQuick.Controls 2.15

ListView{
    id: dateList
    property string itemName: "";
    property string itemType: "Date";
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    interactive: true
    clip: false
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AlwaysOn
        anchors.right: parent.right
        anchors.rightMargin: -6
    }



    /***********************************************************************************************************************/
    // LIST MODEL STARTS

    ListModel{
        id: listmodel
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
        target : ReportsDataModel

        function onSendFilteredColumn(allCategoricalMap, allNumericalMap, allDatesMap){
            for(const [key, value] of Object.entries(allDatesMap)){
                console.log("FIELD NAME AND ALIAS", key, value)
                listmodel.append({"key" : key, "value": value})
            }

            dateList.model =  listmodel
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



    anchors.top: dateHeading.bottom
    anchors.topMargin: 5
    height: parent.height - dateHeading.height - 5
    width: parent.width
    delegate: DataPaneElement{
        id: dataPaneListElement
        visible: key === false ? false : true
        height: key === false ? 0 : 24
    }
}
