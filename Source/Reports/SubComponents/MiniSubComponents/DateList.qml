import QtQuick 2.0
import QtQuick.Controls 2.15
import com.grafieks.singleton.constants 1.0

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
            listmodel.clear()
            listmodel.append({"key" : Constants.tempGrafieksValue, "value": ""})
            for(const [key, value] of Object.entries(allDatesMap)){
                console.log("FIELD NAME AND ALIAS", key, value)
                listmodel.append({"key" : key, "value": value, "calculated": false})
            }

            dateList.model =  listmodel
        }
    }

    Connections{
        target: CalculatedFields

        function onSignalCalculatedFields(calculatedFields){
            for(let [key, value] of Object.entries(calculatedFields)){
                if(value[2] === Constants.dateItemType) {
                    listmodel.append({"key" : key, "value": key, "calculated": true})
                }
            }
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
        visible: key === Constants.tempGrafieksValue ? false : true
        height: key === Constants.tempGrafieksValue ? 0 : 24
    }
}
