import QtQuick 2.0


ListView{
    id: numericalList

    property string itemType: "Numerical"


    Connections{
        target : ChartsModel


        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            numericalList.model =  allNumerical

        }
    }
    function appendToList(name){
          numericalModel.append({categoricalName: name});
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

    anchors.top: numericalHeading.bottom
    anchors.topMargin: 5
    height: parent.height - numericalHeading.height - 5
    width: parent.width
    interactive: false

    delegate: DataPaneElement{
        id: dataPaneListElement
    }

}


