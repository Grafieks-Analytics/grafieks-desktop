import QtQuick 2.0


ListView{
    id: numericalList

    property string itemType: "Numerical"

    ListModel{
        id: numericalModel
        ListElement{
            categoricalName: "Numerical "
        }
        ListElement{
            categoricalName: "Numerical 2"
        }
        ListElement{
            categoricalName: "Numerical 3 23 23 23 232"
        }
        ListElement{
            categoricalName: "Numerical 4"
        }
    }

    Connections{
        target : ReportModelList


        function onSendFilteredColumn(allCategorical, allNumerical, allDates){
            numericalModel.clear()
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

    model: numericalModel
    anchors.top: numericalHeading.bottom
    anchors.topMargin: 5
    height: parent.height - numericalHeading.height - 5
    width: parent.width
    interactive: false

    delegate: DataPaneElement{
        id: dataPaneListElement
    }

}


